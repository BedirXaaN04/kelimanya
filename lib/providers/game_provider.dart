import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../services/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider extends ChangeNotifier {
  int totalCoins = 200;
  int currentLevelIndex = 0;
  List<String> foundWords = [];
  List<String> currentSelectedLetters = [];
  
  LevelModel get currentLevel => gameLevels[currentLevelIndex % gameLevels.length];

  GameProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    totalCoins = prefs.getInt('coins') ?? 200;
    currentLevelIndex = prefs.getInt('level') ?? 0;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', totalCoins);
    await prefs.setInt('level', currentLevelIndex);
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
