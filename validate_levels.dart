import 'dart:io';

void main() {
  var file = File('lib/models/level_model.dart');
  var lines = file.readAsLinesSync();
  
  int currentLevelId = -1;
  List<String> currentLetters = [];
  List<String> currentWords = [];
  List<String> currentExtras = [];
  
  final levelIdRegex = RegExp(r'id:\s*(\d+)');
  final lettersRegex = RegExp(r'letters:\s*\[(.*?)\]');
  final wordRegex = RegExp(r'word:\s*"([^"]+)"');
  final extrasRegex = RegExp(r'extras:\s*\[(.*?)\]');
  
  for (int i = 0; i < lines.length; i++) {
    var line = lines[i];
    
    var idMatch = levelIdRegex.firstMatch(line);
    if (idMatch != null) {
      currentLevelId = int.parse(idMatch.group(1)!);
      currentLetters = [];
      currentWords = [];
      currentExtras = [];
    }
    
    var lettersMatch = lettersRegex.firstMatch(line);
    if (lettersMatch != null) {
      var matchStr = lettersMatch.group(1)!;
      currentLetters = matchStr.split(',').map((e) => e.replaceAll('"', '').trim()).where((e) => e.isNotEmpty).toList();
    }
    
    var wordMatches = wordRegex.allMatches(line);
    for (var match in wordMatches) {
      currentWords.add(match.group(1)!);
    }
    
    var extrasMatch = extrasRegex.firstMatch(line);
    if (extrasMatch != null && currentLevelId != -1) {
      var matchStr = extrasMatch.group(1)!;
      currentExtras = matchStr.split(',').map((e) => e.replaceAll('"', '').trim()).where((e) => e.isNotEmpty).toList();
      
      // Now validate
      var allWords = [...currentWords, ...currentExtras];
      for (var word in allWords) {
        if (word.isEmpty) continue;
        
        var letterCounts = <String, int>{};
        for (var letter in currentLetters) {
          letterCounts[letter] = (letterCounts[letter] ?? 0) + 1;
        }
        
        bool canForm = true;
        var wordLetterCounts = <String, int>{};
        for (int j = 0; j < word.length; j++) {
          var char = word[j];
          wordLetterCounts[char] = (wordLetterCounts[char] ?? 0) + 1;
        }
        
        for (var entry in wordLetterCounts.entries) {
          if ((letterCounts[entry.key] ?? 0) < entry.value) {
            canForm = false;
            break;
          }
        }
        
        if (!canForm) {
          print('Level $currentLevelId: Cannot form "$word" from $currentLetters (Missing ${wordLetterCounts} vs $letterCounts)');
        }
      }
    }
  }
}
