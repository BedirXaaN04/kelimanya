import 'dart:io';

class CrosswordGenerator {
  List<String> words;
  Map<String, String> grid = {};
  List<Map<String, dynamic>> wordPositions = [];
  List<String> placedWords = [];

  CrosswordGenerator(this.words) {
    words.sort((a, b) => b.length.compareTo(a.length));
  }

  void placeFirstWord(String word) {
    wordPositions.add({'word': word, 'x': 0, 'y': 0, 'direction': 'H'});
    placedWords.add(word);
    for (int i = 0; i < word.length; i++) {
      grid['$i\_0'] = word[i];
    }
  }

  bool canPlace(String word, int x, int y, String direction) {
    if (direction == 'H') {
      if (grid.containsKey('${x - 1}\_$y') || grid.containsKey('${x + word.length}\_$y')) return false;
      for (int i = 0; i < word.length; i++) {
        int cx = x + i;
        int cy = y;
        if (grid.containsKey('${cx}\_${cy}')) {
          if (grid['${cx}\_${cy}'] != word[i]) return false;
        } else {
          if (grid.containsKey('${cx}\_${cy - 1}') || grid.containsKey('${cx}\_${cy + 1}')) return false;
        }
      }
      return true;
    } else {
      if (grid.containsKey('${x}\_${y - 1}') || grid.containsKey('${x}\_${y + word.length}')) return false;
      for (int i = 0; i < word.length; i++) {
        int cx = x;
        int cy = y + i;
        if (grid.containsKey('${cx}\_${cy}')) {
          if (grid['${cx}\_${cy}'] != word[i]) return false;
        } else {
          if (grid.containsKey('${cx - 1}\_${cy}') || grid.containsKey('${cx + 1}\_${cy}')) return false;
        }
      }
      return true;
    }
  }

  void placeWord(String word, int x, int y, String direction) {
    wordPositions.add({'word': word, 'x': x, 'y': y, 'direction': direction});
    placedWords.add(word);
    if (direction == 'H') {
      for (int i = 0; i < word.length; i++) grid['${x + i}\_$y'] = word[i];
    } else {
      for (int i = 0; i < word.length; i++) grid['${x}\_${y + i}'] = word[i];
    }
  }

  bool tryPlaceWord(String word) {
    for (var placedInfo in wordPositions) {
      String placedWord = placedInfo['word'];
      int px = placedInfo['x'];
      int py = placedInfo['y'];
      String pdir = placedInfo['direction'];

      for (int i = 0; i < placedWord.length; i++) {
        for (int j = 0; j < word.length; j++) {
          if (placedWord[i] == word[j]) {
            int nx = pdir == 'H' ? px + i : px - j;
            int ny = pdir == 'H' ? py - j : py + i;
            String ndir = pdir == 'H' ? 'V' : 'H';

            if (canPlace(word, nx, ny, ndir)) {
              placeWord(word, nx, ny, ndir);
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Map<String, dynamic> generate() {
    if (words.isEmpty) return {'positions': [], 'unplaced': []};
    placeFirstWord(words[0]);
    List<String> unplaced = [];
    for (int i = 1; i < words.length; i++) {
      if (!tryPlaceWord(words[i])) unplaced.add(words[i]);
    }

    if (wordPositions.isEmpty) return {'positions': [], 'unplaced': []};
    int minX = wordPositions.map((p) => p['x'] as int).reduce((a, b) => a < b ? a : b);
    int minY = wordPositions.map((p) => p['y'] as int).reduce((a, b) => a < b ? a : b);

    for (var pos in wordPositions) {
      pos['x'] = (pos['x'] as int) - minX;
      pos['y'] = (pos['y'] as int) - minY;
    }

    return {'positions': wordPositions, 'unplaced': unplaced};
  }
}

void main() {
  var levelsData = [
    [["E", "L", "M", "A", "S"], ["ELMAS", "SELAM", "ALEM", "AMEL", "ELMA", "MESA"], ["SEL", "SAL", "MAS", "LAM", "ELA", "MAL", "ASL"]],
    [["K", "A", "L", "E", "M"], ["KALEM", "KEMAL", "EMLAK", "KELAM", "ALEM", "KALE"], ["ELA", "KEM", "KAL", "LAK", "LAM", "MAL"]],
    [["O", "R", "M", "A", "N"], ["ORMAN", "ROMAN", "ONAR", "NORM", "ORAN", "ROM"], ["OMA", "NAM", "NAR", "MOR", "RAM", "OMA"]],
    [["H", "A", "B", "E", "R"], ["HABER", "BAHAR", "HARE", "HEBA", "REHA"], ["RAB", "HER", "BAR", "BRE", "HAR", "BAH", "ABE", "BER"]], 
    [["K", "İ", "T", "A", "P"], ["KİTAP", "PATİK", "İPTAL", "KATİP", "TAKİP", "PAKET"], ["PİL", "TİP", "KİT", "PİK", "KAT", "PAK", "AİT"]],
    [["G", "Ü", "N", "E", "Ş"], ["GÜNEŞ", "GÜMÜŞ", "GÜNE", "GEN", "ŞEN"], ["GÜN", "ŞEY", "GÜR", "ÜN", "NE", "EŞ"]],
    [["D", "E", "N", "İ", "Z"], ["DENİZ", "ZİNDE", "DİZGİ", "DİZ", "DİN"], ["ZİL", "ZOR", "NED", "ZİG", "İN", "İZ"]],
    [["Ç", "İ", "Ç", "E", "K"], ["ÇİÇEK", "KEÇİ", "ÇEKİ", "ÇEKE", "İÇ", "EK", "Kİ"], ["ÇEK", "KİÇ", "ÇİĞ", "ÇİL"]],
    [["V", "A", "T", "A", "N"], ["VATAN", "TAVAN", "VANA", "VAAT", "TAVA", "NARA"], ["VAN", "TAV", "ANA", "ATA", "ANT"]],
    [["S", "E", "V", "G", "İ"], ["SEVGİ", "VERGİ", "EVGİ", "SERİ", "SEV", "EVSİ"], ["GİZ", "GİR", "SİG", "GEZ", "SİS"]],
    [["D", "Ü", "N", "Y", "A"], ["DÜNYA", "YÜN", "YAD", "AYDIN", "DAYAN"], ["YÜN", "DÜN", "YAN", "AY", "YA", "AN"]],
    [["Z", "A", "M", "A", "N"], ["ZAMAN", "AZMAN", "NAMAZ", "AMAN", "AZAM", "MANA"], ["ZAM", "NAM", "AMA", "NAZ", "ZAN"]],
    [["S", "O", "N", "U", "Ç"], ["SONUÇ", "ONUR", "SORU", "SUÇ", "SON"], ["UÇ", "ON", "US", "ÇOK", "SAÇ"]],
    [["K", "A", "N", "A", "T"], ["KANAT", "NAKAT", "TANK", "TAKA", "KANT", "ATAK"], ["KAN", "ANA", "KAT", "TAN", "ANT"]],
    [["G", "Ö", "Z", "E", "L"], ["GÖZEL", "GÖZLÜ", "ÖZEL", "GÖZ", "ÖZE", "GÖLE"], ["ÖZ", "GEL", "ZİL", "ZOR"]],
    [["R", "E", "S", "İ", "M"], ["RESİM", "ESİR", "REİS", "MİRS", "SERİ", "MİDE"], ["SİM", "MİR", "MİS", "İRS", "SER", "REM"]],
    [["Y", "I", "L", "D", "I", "Z"], ["YILDIZ", "YILLIK", "YILIŞ", "YILI", "DIŞ", "YIL"], ["ZIT", "ZİL", "ZAR", "ZOR", "ZIH"]],
    [["B", "A", "Y", "R", "A", "K"], ["BAYRAK", "YARBA", "KABAY", "KABAR", "KAYA", "YARA", "AYAR"], ["RAY", "KAY", "YAR", "BAR", "RAB", "KAR"]],
    [["T", "O", "P", "R", "A", "K"], ["TOPRAK", "KOPAR", "PARK", "ORTAK", "AKKOR", "KROKİ"], ["POT", "ROT", "KOP", "KART", "KAR", "KOT"]],
    [["Ş", "A", "H", "A", "N", "E"], ["ŞAHANE", "HAŞİN", "AŞİNA", "HANE", "AHA", "ŞAH", "ANA"], ["HAN", "NAAŞ", "ŞAN", "HAŞ", "AŞ"]]
  ];

  List<String> outputDart = [];

  for (int i = 0; i < levelsData.length; i++) {
    var level = levelsData[i];
    List<String> letters = (level[0] as List).cast<String>();
    List<String> words = (level[1] as List).cast<String>();
    List<String> extras = (level[2] as List).cast<String>();

    var cg = CrosswordGenerator(words);
    var res = cg.generate();
    List<Map<String, dynamic>> positions = res['positions'] as List<Map<String, dynamic>>;
    List<String> unplaced = res['unplaced'] as List<String>;

    List<String> dartWords = [];
    for (var pos in positions) {
      dartWords.add('WordPosition(word: "${pos['word']}", x: ${pos['x']}, y: ${pos['y']}, direction: "${pos['direction']}")');
    }

    String lettersStr = letters.map((l) => '"$l"').join(', ');
    
    // Combine extras and unplaced, ensuring unique
    var allExtras = <String>{...extras, ...unplaced}.toList();
    String extrasStr = allExtras.map((e) => '"$e"').join(', ');

    String levelCode = '''
  // Level ${i + 1}
  LevelModel(
    id: ${i + 1}, letters: [$lettersStr],
    words: [${dartWords.join(', ')}],
    extras: [$extrasStr],
  ),''';
    outputDart.add(levelCode);
  }

  File('generated_levels.txt').writeAsStringSync(outputDart.join('\\n'));
  print('Successfully generated \${levelsData.length} premium levels.');
}
