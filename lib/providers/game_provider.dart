import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/theme_model.dart';
import '../services/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameProvider extends ChangeNotifier {
  int totalCoins = 200;
  int currentLevelIndex = 0;
  List<String> foundWords = [];
  List<String> currentSelectedLetters = [];
  List<String> currentShuffledLetters = [];
  Set<String> hintedCoordinates = {};
  
  // Streak system (from HTML)
  int streak = 0;
  
  // Confetti flag
  bool showConfetti = false;
  
  // Toast message
  String? toastMessage;
  
  // Surprise Tile
  String? surpriseTileCoordinate; // e.g. "2_1"
  bool isSurpriseFound = false;
  
  int tasksCompletedLimit = 5;
  bool isGiftClaimedToday = false;
  int lastClaimedCycle = -1;
  
  // Sound
  bool soundOn = true;

  // Owl Reactions
  bool isOwlHappy = false;
  bool isOwlAngry = false;
  
  String activeThemeId = "default";
  List<String> unlockedThemes = ["default"];

  ThemeModel get currentTheme => StoreThemes.getTheme(activeThemeId);
  
  LevelModel get currentLevel => gameLevels[currentLevelIndex % gameLevels.length];

  GameProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    totalCoins = prefs.getInt('coins') ?? 200;
    currentLevelIndex = prefs.getInt('level') ?? 0;
    lastClaimedCycle = prefs.getInt('lastClaimedCycle') ?? -1;
    activeThemeId = prefs.getString('activeThemeId') ?? "default";
    unlockedThemes = prefs.getStringList('unlockedThemes') ?? ["default"];
    streak = prefs.getInt('streak') ?? 0;
    soundOn = prefs.getBool('soundOn') ?? true;
    
    String? lastGiftDate = prefs.getString('lastGiftDate');
    String today = DateTime.now().toIso8601String().split('T')[0];
    if (lastGiftDate == today) {
      isGiftClaimedToday = true;
    }
    
    currentShuffledLetters = List.from(currentLevel.letters);
    
    // Remote Sync if Authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          totalCoins = doc.data()?['coins'] ?? totalCoins;
          currentLevelIndex = doc.data()?['level'] ?? currentLevelIndex;
          lastClaimedCycle = doc.data()?['lastClaimedCycle'] ?? lastClaimedCycle;
          activeThemeId = doc.data()?['activeThemeId'] ?? activeThemeId;
          unlockedThemes = List<String>.from(doc.data()?['unlockedThemes'] ?? unlockedThemes);
          streak = doc.data()?['streak'] ?? streak;
        }
      } catch (e) {
        debugPrint("Error loading from Firestore: $e");
      }
    }
    
    _generateSurpriseTile();
    notifyListeners();
  }

  void _generateSurpriseTile() {
    surpriseTileCoordinate = null;
    isSurpriseFound = false;
    
    // 30% chance to have a surprise tile
    if (DateTime.now().millisecond % 100 < 30) {
      // Find all coordinates
      List<String> allCoords = [];
      for (var w in currentLevel.words) {
        for (int i = 0; i < w.word.length; i++) {
          int cx = w.x + (w.direction == 'H' ? i : 0);
          int cy = w.y + (w.direction == 'V' ? i : 0);
          String c = "${cx}_${cy}";
          if (!allCoords.contains(c)) {
            allCoords.add(c);
          }
        }
      }
      if (allCoords.isNotEmpty) {
        allCoords.shuffle();
        surpriseTileCoordinate = allCoords.first;
      }
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', totalCoins);
    await prefs.setInt('level', currentLevelIndex);
    await prefs.setInt('lastClaimedCycle', lastClaimedCycle);
    await prefs.setString('activeThemeId', activeThemeId);
    await prefs.setStringList('unlockedThemes', unlockedThemes);
    await prefs.setInt('streak', streak);
    await prefs.setBool('soundOn', soundOn);
    
    // Remote Sync if Authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'coins': totalCoins,
          'level': currentLevelIndex,
          'lastClaimedCycle': lastClaimedCycle,
          'activeThemeId': activeThemeId,
          'unlockedThemes': unlockedThemes,
          'streak': streak,
          'email': user.email,
          'displayName': user.displayName,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error saving to Firestore: $e");
      }
    }
  }

  void shuffleLetters() {
    currentShuffledLetters.shuffle();
    notifyListeners();
  }
  
  void toggleSound() {
    soundOn = !soundOn;
    _saveData();
    notifyListeners();
  }
  
  void claimDailyGift() async {
    if (!isGiftClaimedToday) {
      totalCoins += 50;
      isGiftClaimedToday = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastGiftDate', DateTime.now().toIso8601String().split('T')[0]);
      _saveData();
      notifyListeners();
    }
  }

  int get currentCycle => currentLevelIndex ~/ tasksCompletedLimit;

  int get completedTasksProgress => currentLevelIndex % tasksCompletedLimit;
  
  bool canClaimTaskReward() {
      return completedTasksProgress == 0 && currentLevelIndex > 0 && lastClaimedCycle < currentCycle;
  }
  
  void claimTaskReward() {
    if (canClaimTaskReward()) {
      totalCoins += 100;
      lastClaimedCycle = currentCycle;
      _saveData();
      notifyListeners();
    }
  }

  void addSelectedLetter(String letter) {
    currentSelectedLetters.add(letter);
    notifyListeners();
  }

  void clearSelectedLetters() {
    currentSelectedLetters.clear();
    notifyListeners();
  }

  /// Show toast message
  void showToast(String msg) {
    toastMessage = msg;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 2200), () {
      toastMessage = null;
      notifyListeners();
    });
  }

  bool checkWordSelection(String wordStr) {
    bool isTarget = false;
    for (var target in currentLevel.words) {
      if (target.word == wordStr) {
        if (!foundWords.contains(wordStr)) {
          foundWords.add(wordStr);
          isTarget = true;
          // Streak system from HTML
          streak++;
          if (streak >= 3) {
            totalCoins += 5;
            showToast('🔥 $streak Seri! +5 🪙');
          }
          
          // Check for surprise tile
          if (surpriseTileCoordinate != null && !isSurpriseFound) {
            for (int i = 0; i < target.word.length; i++) {
              int cx = target.x + (target.direction == 'H' ? i : 0);
              int cy = target.y + (target.direction == 'V' ? i : 0);
              if ("${cx}_${cy}" == surpriseTileCoordinate) {
                isSurpriseFound = true;
                totalCoins += 10;
                showToast('💎 Sürpriz Bulundu! +10 🪙');
                break;
              }
            }
          }
          
          triggerHappyOwl();
          _saveData();
          notifyListeners();
          
          // Check level completion
          if (isLevelCompleted()) {
            showConfetti = true;
            notifyListeners();
          }
        }
        break;
      }
    }

    if (!isTarget && currentLevel.extras.map((w) => w.toUpperCase()).contains(wordStr.toUpperCase())) {
      if (!foundWords.contains('_x$wordStr')) {
        foundWords.add('_x$wordStr');
        totalCoins += 2;
        showToast('+2 🪙 BONUS: $wordStr!');
        triggerHappyOwl();
        _saveData();
        notifyListeners();
        return true; // Found an extra
      }
    }
    
    if (!isTarget) {
      // Wrong word — reset streak (from HTML)
      streak = 0;
      triggerAngryOwl();
      _saveData();
      notifyListeners();
    }
    
    return isTarget;
  }

  void triggerHappyOwl() {
    isOwlHappy = true;
    isOwlAngry = false;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1500), () {
      isOwlHappy = false;
      notifyListeners();
    });
  }

  void triggerAngryOwl() {
    isOwlAngry = true;
    isOwlHappy = false;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1000), () {
      isOwlAngry = false;
      notifyListeners();
    });
  }

  bool isLevelCompleted() {
    int mainFound = foundWords.where((f) => !f.startsWith('_x')).length;
    return mainFound == currentLevel.words.length;
  }

  void nextLevel() {
    currentLevelIndex++;
    totalCoins += 50;
    foundWords.clear();
    currentSelectedLetters.clear();
    hintedCoordinates.clear();
    showConfetti = false;
    
    if (currentLevelIndex >= gameLevels.length) {
      showToast('🏆 Tüm seviyeleri bitirdin!');
      currentLevelIndex = 0;
    }
    
    currentShuffledLetters = List.from(currentLevel.letters);
    _generateSurpriseTile();
    
    _saveData();
    notifyListeners();
    
    // Show interstitial every 3 levels completed
    if (currentLevelIndex % 3 == 0) {
      AdService().showInterstitialAd();
    }
  }

  void useHint(String type) {
    int cost = type == 'rocket' ? 100 : 25;
    if (totalCoins >= cost) {
      if (type == 'single') {
         bool revealedOne = false;
         for (var wordObj in currentLevel.words) {
            if (foundWords.contains(wordObj.word)) continue;
            for (int i = 0; i < wordObj.word.length; i++) {
                int cx = wordObj.x + (wordObj.direction == 'H' ? i : 0);
                int cy = wordObj.y + (wordObj.direction == 'V' ? i : 0);
                String coord = "$cx,$cy";
                if (!hintedCoordinates.contains(coord)) {
                    hintedCoordinates.add(coord);
                    revealedOne = true;
                    break;
                }
            }
            if (revealedOne) break;
         }
         if (!revealedOne) return;
      } else if (type == 'rocket') {
         bool revealedAny = false;
         for (var wordObj in currentLevel.words) {
            if (foundWords.contains(wordObj.word)) continue;
            for (int i = 0; i < wordObj.word.length; i++) {
                int cx = wordObj.x + (wordObj.direction == 'H' ? i : 0);
                int cy = wordObj.y + (wordObj.direction == 'V' ? i : 0);
                String coord = "$cx,$cy";
                if (!hintedCoordinates.contains(coord)) {
                    hintedCoordinates.add(coord);
                    revealedAny = true;
                }
            }
            if (revealedAny) break;
         }
         if (!revealedAny) return;
      }

      totalCoins -= cost;
      _saveData();
      notifyListeners();
    }
  }

  // Market: Mega İpucu (100 Altın)
  // Rastgele bulunmamış bir kelimenin tamamını açar
  bool useMegaHint() {
    int cost = 100;
    if (totalCoins >= cost) {
      for (var wordObj in currentLevel.words) {
         if (!foundWords.contains(wordObj.word)) {
            // Found an uncompleted word, reveal all its letters
            for (int i = 0; i < wordObj.word.length; i++) {
                int cx = wordObj.x + (wordObj.direction == 'H' ? i : 0);
                int cy = wordObj.y + (wordObj.direction == 'V' ? i : 0);
                String coord = "$cx,$cy";
                hintedCoordinates.add(coord);
            }
            totalCoins -= cost;
            showToast('🪄 Mega İpucu Kullanıldı!');
            _saveData();
            notifyListeners();
            return true;
         }
      }
      showToast('Tüm kelimeler bulundu!');
      return false;
    }
    showToast('Yetersiz Altın!');
    return false;
  }

  // Market: Sesli Harf Taraması (75 Altın)
  // Tablodaki tüm A, E, I, İ, O, Ö, U, Ü harflerini ipucu olarak açar
  bool useVowelScanner() {
    int cost = 75;
    if (totalCoins >= cost) {
      bool revealedAny = false;
      List<String> vowels = ['A', 'E', 'I', 'İ', 'O', 'Ö', 'U', 'Ü'];
      
      for (var wordObj in currentLevel.words) {
         if (foundWords.contains(wordObj.word)) continue;
         for (int i = 0; i < wordObj.word.length; i++) {
            if (vowels.contains(wordObj.word[i])) {
                int cx = wordObj.x + (wordObj.direction == 'H' ? i : 0);
                int cy = wordObj.y + (wordObj.direction == 'V' ? i : 0);
                String coord = "$cx,$cy";
                if (!hintedCoordinates.contains(coord)) {
                    hintedCoordinates.add(coord);
                    revealedAny = true;
                }
            }
         }
      }
      
      if (revealedAny) {
        totalCoins -= cost;
        showToast('🅰️ Sesli Harfler Tarandı!');
        _saveData();
        notifyListeners();
        return true;
      } else {
        showToast('Açılacak sesli harf kalmadı!');
        return false;
      }
    }
    showToast('Yetersiz Altın!');
    return false;
  }

  void claimReward(int amount) {
    totalCoins += amount;
    _saveData();
    notifyListeners();
  }

  void equipTheme(String themeId) {
    if (unlockedThemes.contains(themeId)) {
      activeThemeId = themeId;
      _saveData();
      notifyListeners();
    }
  }

  bool purchaseTheme(ThemeModel theme) {
    if (!unlockedThemes.contains(theme.id) && totalCoins >= theme.cost) {
      totalCoins -= theme.cost;
      unlockedThemes.add(theme.id);
      equipTheme(theme.id);
      return true;
    }
    return false;
  }
}
