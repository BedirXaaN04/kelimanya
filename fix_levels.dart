import 'dart:io';

void main() {
  var file = File('lib/models/level_model.dart');
  var content = file.readAsStringSync();

  var blocks = content.split('LevelModel(');
  var outContent = blocks[0];

  final lettersRegex = RegExp(r'letters:\s*\[(.*?)\]');
  final wordRegex = RegExp(r'word:\s*"([^"]+)"');
  final extrasRegex = RegExp(r'extras:\s*\[(.*?)\]');

  for (int i = 1; i < blocks.length; i++) {
    var body = blocks[i];

    var lettersMatch = lettersRegex.firstMatch(body);
    if (lettersMatch == null) {
      outContent += 'LevelModel(' + body;
      continue;
    }

    List<String> currentLetters = [];
    var lettersStr = lettersMatch.group(1)!;
    if (lettersStr.isNotEmpty) {
      currentLetters = lettersStr.split(',').map((e) => e.replaceAll('"', '').replaceAll("'", "").trim()).where((e) => e.isNotEmpty).toList();
    }

    var wordsMatches = wordRegex.allMatches(body);
    List<String> allWords = [];
    for (var match in wordsMatches) {
      allWords.add(match.group(1)!);
    }

    var extrasMatch = extrasRegex.firstMatch(body);
    if (extrasMatch != null) {
      var extStr = extrasMatch.group(1)!;
      if (extStr.isNotEmpty) {
        var extras = extStr.split(',').map((e) => e.replaceAll('"', '').replaceAll("'", "").trim()).where((e) => e.isNotEmpty).toList();
        allWords.addAll(extras);
      }
    }

    Map<String, int> requiredCounts = {};
    for (var word in allWords) {
      Map<String, int> wordCounts = {};
      for (int j = 0; j < word.length; j++) {
        var char = word[j];
        wordCounts[char] = (wordCounts[char] ?? 0) + 1;
      }
      for (var entry in wordCounts.entries) {
        if ((requiredCounts[entry.key] ?? 0) < entry.value) {
          requiredCounts[entry.key] = entry.value;
        }
      }
    }

    List<String> finalLetters = [];
    Map<String, int> tempReq = Map.from(requiredCounts);
    
    // Fill with requested letters first to preserve some original design
    for (var char in currentLetters) {
      if ((tempReq[char] ?? 0) > 0) {
        finalLetters.add(char);
        tempReq[char] = tempReq[char]! - 1;
      }
    }
    
    // Add missing letters
    for (var entry in tempReq.entries) {
      for (int k = 0; k < entry.value; k++) {
        finalLetters.add(entry.key);
      }
    }

    var newLettersStr = finalLetters.map((c) => '"$c"').join(', ');
    var newBody = body.replaceRange(lettersMatch.start, lettersMatch.end, 'letters: [$newLettersStr]');
    outContent += 'LevelModel(' + newBody;
  }

  file.writeAsStringSync(outContent);
  print('Levels updated successfully.');
}
