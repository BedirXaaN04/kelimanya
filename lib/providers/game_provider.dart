import 'package:flutter/material.dart';
import '../models/level_model.dart';
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
  
  // Tasks and Gifts
  int tasksCompletedLimit = 5;
  bool isGiftClaimedToday = false;
  
  LevelModel get currentLevel => gameLevels[currentLevelIndex % gameLevels.length];

  GameProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    totalCoins = prefs.getInt('coins') ?? 200;
    currentLevelIndex = prefs.getInt('level') ?? 0;
    
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
        }
      } catch (e) {
        debugPrint("Error loading from Firestore: $e");
      }
    }
    
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', totalCoins);
    await prefs.setInt('level', currentLevelIndex);
    
    // Remote Sync if Authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'coins': totalCoins,
          'level': currentLevelIndex,
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

  int get completedTasksProgress => currentLevelIndex % tasksCompletedLimit;
  
  void claimTaskReward() {
    if (completedTasksProgress == 0 && currentLevelIndex > 0) {
      // Reward logic can be handled here if tasks were more complex
      totalCoins += 100;
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

  bool checkWordSelection(String wordStr) {
    bool isTarget = false;
    for (var target in currentLevel.words) {
      if (target.word == wordStr) {
        if (!foundWords.contains(wordStr)) {
          foundWords.add(wordStr);
          isTarget = true;
          notifyListeners();
        }
        break;
      }
    }

    if (!isTarget && currentLevel.extras.contains(wordStr)) {
      totalCoins += 2;
      _saveData();
      notifyListeners();
      return true; // Found an extra
    }
    return isTarget;
  }

  bool isLevelCompleted() {
    return foundWords.length == currentLevel.words.length;
  }

  void nextLevel() {
    currentLevelIndex++;
    totalCoins += 50;
    foundWords.clear();
    currentSelectedLetters.clear();
    currentShuffledLetters = List.from(currentLevel.letters);
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
      totalCoins -= cost;
      _saveData();
      notifyListeners();
      // logic to set hinted state would go in widgets or be tracked here
    }
  }

  void claimReward(int amount) {
    totalCoins += amount;
    _saveData();
    notifyListeners();
  }
}
