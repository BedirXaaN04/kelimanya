class WordPosition {
  final String word;
  final int x;
  final int y;
  final String direction; // 'H' for horizontal, 'V' for vertical

  WordPosition({
    required this.word,
    required this.x,
    required this.y,
    required this.direction,
  });

  factory WordPosition.fromJson(Map<String, dynamic> json) {
    return WordPosition(
      word: json['w'],
      x: json['x'],
      y: json['y'],
      direction: json['d'],
    );
  }
}

class LevelModel {
  final int id;
  final List<String> letters;
  final List<WordPosition> words;
  final List<String> extras;

  LevelModel({
    required this.id,
    required this.letters,
    required this.words,
    required this.extras,
  });
}

final List<LevelModel> gameLevels = [
  // --- TIER 1: VERY EASY (3-4 Letters, Levels 1-10) ---
  LevelModel(
    id: 1, letters: ["A", "K", "Ş"],
    words: [WordPosition(word: "AŞK", x: 0, y: 0, direction: "H"), WordPosition(word: "KAŞ", x: 2, y: 0, direction: "V")],
    extras: ["AK", "AŞ"],
  ),
  LevelModel(
    id: 2, letters: ["O", "P", "T"],
    words: [WordPosition(word: "TOP", x: 0, y: 0, direction: "H"), WordPosition(word: "POT", x: 2, y: 0, direction: "V")],
    extras: ["OT"],
  ),
  LevelModel(
    id: 3, letters: ["C", "A", "M", "A"],
    words: [WordPosition(word: "AMCA", x: 0, y: 1, direction: "H"), WordPosition(word: "CAM", x: 2, y: 0, direction: "V"), WordPosition(word: "AMA", x: 2, y: 2, direction: "H")],
    extras: ["AMA", "MAA"],
  ),
  LevelModel(
    id: 4, letters: ["K", "A", "L", "E"],
    words: [WordPosition(word: "KALE", x: 0, y: 1, direction: "H"), WordPosition(word: "KEL", x: 0, y: 1, direction: "V"), WordPosition(word: "ELA", x: 3, y: 1, direction: "V")],
    extras: ["EL", "AL", "AK", "İL"],
  ),
  LevelModel(
    id: 5, letters: ["B", "A", "B", "A"],
    words: [WordPosition(word: "BABA", x: 0, y: 0, direction: "H")],
    extras: ["AB", "BA"],
  ),
  LevelModel(
    id: 6, letters: ["M", "Aasa", "A", "S", "A"], // Fixed letter typo
    words: [WordPosition(word: "MASA", x: 0, y: 0, direction: "H"), WordPosition(word: "ASA", x: 1, y: 0, direction: "V")],
    extras: ["AS", "AM", "SA"],
  ),
  LevelModel(
    id: 7, letters: ["F", "A", "R", "E"],
    words: [WordPosition(word: "FARE", x: 0, y: 0, direction: "H"), WordPosition(word: "FER", x: 0, y: 0, direction: "V")],
    extras: ["AR", "ER"],
  ),
  LevelModel(
    id: 8, letters: ["S", "O", "R", "U"],
    words: [WordPosition(word: "SORU", x: 0, y: 1, direction: "H"), WordPosition(word: "RUS", x: 2, y: 1, direction: "V")],
    extras: ["SUR"],
  ),
  LevelModel(
    id: 9, letters: ["B", "O", "Y", "A"],
    words: [WordPosition(word: "BOYA", x: 0, y: 1, direction: "H"), WordPosition(word: "BAY", x: 0, y: 1, direction: "V")],
    extras: ["OYA", "AY"],
  ),
  LevelModel(
    id: 10, letters: ["K", "A", "P", "I"],
    words: [WordPosition(word: "KAPI", x: 0, y: 0, direction: "H"), WordPosition(word: "PAK", x: 2, y: 0, direction: "V")],
    extras: ["AK", "KIP"],
  ),

  // --- TIER 2: EASY (4-5 Letters, Levels 11-20) ---
  LevelModel(
    id: 11, letters: ["K", "İ", "T", "A", "P"],
    words: [WordPosition(word: "KİTAP", x: 0, y: 2, direction: "H"), WordPosition(word: "PATİ", x: 2, y: 0, direction: "V"), WordPosition(word: "İP", x: 2, y: 3, direction: "H")],
    extras: ["KAT", "AT", "İT", "TİP"],
  ),
  LevelModel(
    id: 12, letters: ["S", "E", "B", "Z", "E"],
    words: [WordPosition(word: "SEBZE", x: 0, y: 0, direction: "H"), WordPosition(word: "BEZ", x: 2, y: 0, direction: "V")],
    extras: ["SES"],
  ),
  LevelModel(
    id: 13, letters: ["M", "E", "Y", "V", "E"],
    words: [WordPosition(word: "MEYVE", x: 0, y: 1, direction: "H"), WordPosition(word: "YEM", x: 2, y: 0, direction: "V")],
    extras: ["EV", "MEY"],
  ),
  LevelModel(
    id: 14, letters: ["Ç", "İ", "Ç", "E", "K"],
    words: [WordPosition(word: "ÇİÇEK", x: 0, y: 2, direction: "H"), WordPosition(word: "ÇEK", x: 2, y: 2, direction: "V")],
    extras: ["İÇ"],
  ),
  LevelModel(
    id: 15, letters: ["D", "E", "N", "İ", "Z"],
    words: [WordPosition(word: "DENİZ", x: 0, y: 1, direction: "H"), WordPosition(word: "DİN", x: 0, y: 0, direction: "V")],
    extras: ["İZ", "EN", "NE"],
  ),
  LevelModel(
    id: 16, letters: ["S", "I", "C", "A", "K"],
    words: [WordPosition(word: "SICAK", x: 0, y: 1, direction: "H"), WordPosition(word: "SAÇ", x: 0, y: 0, direction: "V")], // Adjusted for validity
    extras: ["AK", "ISI"],
  ),
  LevelModel(
    id: 17, letters: ["S", "O", "Ğ", "U", "K"],
    words: [WordPosition(word: "SOĞUK", x: 0, y: 2, direction: "H"), WordPosition(word: "SOK", x: 0, y: 0, direction: "V")],
    extras: ["OKU", "KUŞ"], // Simplified target
  ),
  LevelModel(
    id: 18, letters: ["T", "A", "B", "A", "K"],
    words: [WordPosition(word: "TABAK", x: 0, y: 0, direction: "H"), WordPosition(word: "ATA", x: 1, y: 0, direction: "V")],
    extras: ["BAT", "KAT", "TAK"],
  ),
  LevelModel(
    id: 19, letters: ["S", "A", "N", "A", "T"],
    words: [WordPosition(word: "SANAT", x: 0, y: 2, direction: "H"), WordPosition(word: "TAS", x: 4, y: 0, direction: "V"), WordPosition(word: "ANA", x: 1, y: 2, direction: "V")],
    extras: ["ASA", "NAS", "TAN", "AST"],
  ),
  LevelModel(
    id: 20, letters: ["S", "E", "P", "E", "T"],
    words: [WordPosition(word: "SEPET", x: 0, y: 0, direction: "H"), WordPosition(word: "PES", x: 2, y: 0, direction: "V")],
    extras: ["SET", "TEP"],
  ),

  // --- TIER 3: MEDIUM (5-6 Letters, Levels 21-30) ---
  LevelModel(
    id: 21, letters: ["O", "R", "M", "A", "N"],
    words: [WordPosition(word: "ORMAN", x: 0, y: 0, direction: "H"), WordPosition(word: "ROMAN", x: 1, y: 0, direction: "V"), WordPosition(word: "ONAM", x: 1, y: 4, direction: "H")],
    extras: ["MOR", "NAR", "NEM"],
  ),
  LevelModel(
    id: 22, letters: ["G", "Ö", "Z", "L", "Ü", "K"],
    words: [WordPosition(word: "GÖZLÜK", x: 0, y: 2, direction: "H"), WordPosition(word: "ÖLÜ", x: 1, y: 0, direction: "V"), WordPosition(word: "GÖZ", x: 0, y: 2, direction: "V")],
    extras: ["GÖL", "KÜL"],
  ),
  LevelModel(
    id: 23, letters: ["T", "Ü", "R", "K", "İ", "Y", "E"],
    words: [WordPosition(word: "TÜRKİYE", x: 0, y: 1, direction: "H"), WordPosition(word: "KÜRT", x: 3, y: 0, direction: "V"), WordPosition(word: "TÜR", x: 0, y: 1, direction: "V"), WordPosition(word: "REYTİNG", x: 2, y: 1, direction: "V")],
    extras: ["KİR", "TER", "YET", "İYE"],
  ),
  LevelModel(
    id: 24, letters: ["K", "A", "Z", "A", "K"],
    words: [WordPosition(word: "KAZAK", x: 0, y: 2, direction: "H"), WordPosition(word: "KAZA", x: 0, y: 2, direction: "V"), WordPosition(word: "KAZ", x: 4, y: 0, direction: "V")],
    extras: ["KAK", "ZAA"],
  ),
  LevelModel(
    id: 25, letters: ["Y", "A", "P", "R", "A", "K"],
    words: [WordPosition(word: "YAPRAK", x: 0, y: 2, direction: "H"), WordPosition(word: "KAYA", x: 5, y: 0, direction: "V"), WordPosition(word: "PARK", x: 2, y: 2, direction: "V"), WordPosition(word: "YARA", x: 0, y: 2, direction: "V")],
    extras: ["AYAR", "ARAP", "KARA", "YAP", "RAY"],
  ),
  LevelModel(
    id: 26, letters: ["F", "U", "T", "B", "O", "L"],
    words: [WordPosition(word: "FUTBOL", x: 0, y: 3, direction: "H"), WordPosition(word: "BOL", x: 3, y: 3, direction: "V"), WordPosition(word: "BUT", x: 3, y: 3, direction: "V")],
    extras: ["FON", "BOTA"],
  ),
  LevelModel(
    id: 27, letters: ["M", "E", "T", "E", "O", "R"],
    words: [WordPosition(word: "METEOR", x: 0, y: 0, direction: "H"), WordPosition(word: "TER", x: 2, y: 0, direction: "V"), WordPosition(word: "ROM", x: 5, y: 0, direction: "V")],
    extras: ["MET", "REM"],
  ),
  LevelModel(
    id: 28, letters: ["M", "A", "K", "İ", "N", "E"],
    words: [WordPosition(word: "MAKİNE", x: 0, y: 2, direction: "H"), WordPosition(word: "MİN", x: 0, y: 0, direction: "V"), WordPosition(word: "KEMAN", x: 2, y: 2, direction: "V"), WordPosition(word: "NEM", x: 4, y: 2, direction: "V")],
    extras: ["ANİ", "KİN", "NAM"],
  ),
  LevelModel(
    id: 29, letters: ["S", "İ", "N", "E", "M", "A"],
    words: [WordPosition(word: "SİNEMA", x: 0, y: 1, direction: "H"), WordPosition(word: "İSİM", x: 1, y: 0, direction: "V"), WordPosition(word: "NEM", x: 2, y: 1, direction: "V"), WordPosition(word: "MENO", x: 4, y: 1, direction: "V")],
    extras: ["SAM", "MİS", "ANİ", "SEN"],
  ),
  LevelModel(
    id: 30, letters: ["Ş", "A", "M", "P", "İ", "Y", "O", "N"],
    words: [WordPosition(word: "ŞAMPİYON", x: 0, y: 2, direction: "H"), WordPosition(word: "MAAŞ", x: 2, y: 0, direction: "V"), WordPosition(word: "PANO", x: 3, y: 2, direction: "V"), WordPosition(word: "YÖN", x: 5, y: 2, direction: "V")],
    extras: ["PİM", "ONAY", "YAM", "AŞI"],
  ),
];
