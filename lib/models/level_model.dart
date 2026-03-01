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
  // Level 1
  LevelModel(
    id: 1, letters: ["E", "L", "M", "A", "S"],
    words: [WordPosition(word: "ELMAS", x: 3, y: 3, direction: "H"), WordPosition(word: "SELAM", x: 3, y: 2, direction: "V"), WordPosition(word: "ALEM", x: 5, y: 0, direction: "V"), WordPosition(word: "AMEL", x: 6, y: 3, direction: "V"), WordPosition(word: "ELMA", x: 0, y: 5, direction: "H"), WordPosition(word: "MESA", x: 2, y: 0, direction: "H")],
    extras: ["SEL", "SAL", "MAS", "LAM", "ELA", "MAL", "ASL"],
  ),
  // Level 2
  LevelModel(
    id: 2, letters: ["K", "A", "L", "E", "M"],
    words: [WordPosition(word: "KALEM", x: 3, y: 4, direction: "H"), WordPosition(word: "KEMAL", x: 3, y: 4, direction: "V"), WordPosition(word: "EMLAK", x: 5, y: 2, direction: "V"), WordPosition(word: "KELAM", x: 7, y: 0, direction: "V"), WordPosition(word: "ALEM", x: 0, y: 6, direction: "H"), WordPosition(word: "KALE", x: 1, y: 8, direction: "H")],
    extras: ["ELA", "KEM", "KAL", "LAK", "LAM", "MAL"],
  ),
  // Level 3
  LevelModel(
    id: 3, letters: ["O", "R", "M", "A", "N"],
    words: [WordPosition(word: "ORMAN", x: 3, y: 2, direction: "H"), WordPosition(word: "ROMAN", x: 3, y: 1, direction: "V"), WordPosition(word: "ONAR", x: 6, y: 0, direction: "V"), WordPosition(word: "NORM", x: 0, y: 3, direction: "H"), WordPosition(word: "ORAN", x: 0, y: 5, direction: "H"), WordPosition(word: "ROM", x: 5, y: 0, direction: "H")],
    extras: ["OMA", "NAM", "NAR", "MOR", "RAM"],
  ),
  // Level 4
  LevelModel(
    id: 4, letters: ["H", "A", "B", "E", "R", "A"],
    words: [WordPosition(word: "HABER", x: 2, y: 3, direction: "H"), WordPosition(word: "BAHAR", x: 2, y: 1, direction: "V"), WordPosition(word: "HARE", x: 5, y: 0, direction: "V"), WordPosition(word: "HEBA", x: 0, y: 1, direction: "H"), WordPosition(word: "REHA", x: 6, y: 3, direction: "V")],
    extras: ["RAB", "HER", "BAR", "BRE", "HAR", "BAH", "ABE", "BER"],
  ),
  // Level 5
  LevelModel(
    id: 5, letters: ["K", "İ", "T", "A", "P", "L", "E"],
    words: [WordPosition(word: "KİTAP", x: 4, y: 4, direction: "H"), WordPosition(word: "PATİK", x: 4, y: 0, direction: "V"), WordPosition(word: "İPTAL", x: 5, y: 4, direction: "V"), WordPosition(word: "KATİP", x: 7, y: 3, direction: "V"), WordPosition(word: "TAKİP", x: 0, y: 0, direction: "H"), WordPosition(word: "PAKET", x: 0, y: 2, direction: "H")],
    extras: ["PİL", "TİP", "KİT", "PİK", "KAT", "PAK", "AİT"],
  ),
  // Level 6
  LevelModel(
    id: 6, letters: ["G", "Ü", "N", "E", "Ş", "Ü", "M", "Y", "R"],
    words: [WordPosition(word: "GÜNEŞ", x: 0, y: 2, direction: "H"), WordPosition(word: "GÜMÜŞ", x: 0, y: 2, direction: "V"), WordPosition(word: "GÜNE", x: 2, y: 0, direction: "V"), WordPosition(word: "GEN", x: 2, y: 0, direction: "H"), WordPosition(word: "ŞEN", x: 4, y: 2, direction: "V")],
    extras: ["GÜN", "ŞEY", "GÜR", "ÜN", "NE", "EŞ"],
  ),
  // Level 7
  LevelModel(
    id: 7, letters: ["D", "E", "N", "İ", "Z", "İ", "G", "L", "O", "R"],
    words: [WordPosition(word: "DENİZ", x: 2, y: 3, direction: "H"), WordPosition(word: "ZİNDE", x: 2, y: 0, direction: "V"), WordPosition(word: "DİZGİ", x: 5, y: 2, direction: "V"), WordPosition(word: "DİZ", x: 0, y: 0, direction: "H"), WordPosition(word: "DİN", x: 0, y: 2, direction: "H")],
    extras: ["ZİL", "ZOR", "NED", "ZİG", "İN", "İZ"],
  ),
  // Level 8
  LevelModel(
    id: 8, letters: ["Ç", "İ", "Ç", "E", "K", "E", "Ğ", "L"],
    words: [WordPosition(word: "ÇİÇEK", x: 1, y: 3, direction: "H"), WordPosition(word: "KEÇİ", x: 1, y: 1, direction: "V"), WordPosition(word: "ÇEKİ", x: 3, y: 3, direction: "V"), WordPosition(word: "ÇEKE", x: 4, y: 0, direction: "V"), WordPosition(word: "İÇ", x: 3, y: 6, direction: "H"), WordPosition(word: "EK", x: 0, y: 1, direction: "H"), WordPosition(word: "Kİ", x: 5, y: 3, direction: "V")],
    extras: ["ÇEK", "KİÇ", "ÇİĞ", "ÇİL"],
  ),
  // Level 9
  LevelModel(
    id: 9, letters: ["V", "A", "T", "A", "N", "R"],
    words: [WordPosition(word: "VATAN", x: 3, y: 2, direction: "H"), WordPosition(word: "TAVAN", x: 3, y: 0, direction: "V"), WordPosition(word: "VANA", x: 6, y: 1, direction: "V"), WordPosition(word: "VAAT", x: 0, y: 0, direction: "H"), WordPosition(word: "TAVA", x: 0, y: 3, direction: "H"), WordPosition(word: "NARA", x: 3, y: 4, direction: "H")],
    extras: ["VAN", "TAV", "ANA", "ATA", "ANT"],
  ),
  // Level 10
  LevelModel(
    id: 10, letters: ["S", "E", "V", "G", "İ", "S", "R", "Z"],
    words: [WordPosition(word: "SEVGİ", x: 2, y: 2, direction: "H"), WordPosition(word: "VERGİ", x: 3, y: 1, direction: "V"), WordPosition(word: "EVGİ", x: 5, y: 0, direction: "V"), WordPosition(word: "SERİ", x: 0, y: 5, direction: "H"), WordPosition(word: "EVSİ", x: 5, y: 0, direction: "H"), WordPosition(word: "SEV", x: 0, y: 5, direction: "V")],
    extras: ["GİZ", "GİR", "SİG", "GEZ", "SİS"],
  ),
  // Level 11
  LevelModel(
    id: 11, letters: ["D", "Ü", "N", "Y", "A", "A", "I"],
    words: [WordPosition(word: "DÜNYA", x: 0, y: 4, direction: "H"), WordPosition(word: "AYDIN", x: 0, y: 2, direction: "V"), WordPosition(word: "DAYAN", x: 2, y: 0, direction: "V"), WordPosition(word: "YÜN", x: 3, y: 4, direction: "V"), WordPosition(word: "YAD", x: 0, y: 0, direction: "H")],
    extras: ["YÜN", "DÜN", "YAN", "AY", "YA", "AN"],
  ),
  // Level 12
  LevelModel(
    id: 12, letters: ["Z", "A", "M", "A", "N"],
    words: [WordPosition(word: "ZAMAN", x: 3, y: 3, direction: "H"), WordPosition(word: "AZMAN", x: 3, y: 2, direction: "V"), WordPosition(word: "NAMAZ", x: 5, y: 1, direction: "V"), WordPosition(word: "AMAN", x: 7, y: 0, direction: "V"), WordPosition(word: "AZAM", x: 0, y: 4, direction: "H"), WordPosition(word: "MANA", x: 0, y: 2, direction: "H")],
    extras: ["ZAM", "NAM", "AMA", "NAZ", "ZAN"],
  ),
  // Level 13
  LevelModel(
    id: 13, letters: ["S", "O", "N", "U", "Ç", "R", "K", "A"],
    words: [WordPosition(word: "SONUÇ", x: 0, y: 3, direction: "H"), WordPosition(word: "ONUR", x: 1, y: 3, direction: "V"), WordPosition(word: "SORU", x: 3, y: 0, direction: "V"), WordPosition(word: "SUÇ", x: 0, y: 5, direction: "H"), WordPosition(word: "SON", x: 3, y: 0, direction: "H")],
    extras: ["UÇ", "ON", "US", "ÇOK", "SAÇ"],
  ),
  // Level 14
  LevelModel(
    id: 14, letters: ["K", "A", "N", "A", "T"],
    words: [WordPosition(word: "KANAT", x: 3, y: 2, direction: "H"), WordPosition(word: "NAKAT", x: 3, y: 0, direction: "V"), WordPosition(word: "TANK", x: 5, y: 0, direction: "V"), WordPosition(word: "TAKA", x: 7, y: 2, direction: "V"), WordPosition(word: "KANT", x: 0, y: 4, direction: "H"), WordPosition(word: "ATAK", x: 7, y: 3, direction: "H")],
    extras: ["KAN", "ANA", "KAT", "TAN", "ANT"],
  ),
  // Level 15
  LevelModel(
    id: 15, letters: ["G", "Ö", "Z", "E", "L", "Ü", "İ", "O", "R"],
    words: [WordPosition(word: "GÖZEL", x: 2, y: 2, direction: "H"), WordPosition(word: "GÖZLÜ", x: 2, y: 2, direction: "V"), WordPosition(word: "ÖZEL", x: 4, y: 1, direction: "V"), WordPosition(word: "GÖLE", x: 6, y: 0, direction: "V"), WordPosition(word: "GÖZ", x: 0, y: 4, direction: "H"), WordPosition(word: "ÖZE", x: 6, y: 1, direction: "H")],
    extras: ["ÖZ", "GEL", "ZİL", "ZOR"],
  ),
  // Level 16
  LevelModel(
    id: 16, letters: ["R", "E", "S", "İ", "M", "D"],
    words: [WordPosition(word: "RESİM", x: 3, y: 3, direction: "H"), WordPosition(word: "ESİR", x: 3, y: 0, direction: "V"), WordPosition(word: "REİS", x: 5, y: 0, direction: "V"), WordPosition(word: "MİRS", x: 7, y: 3, direction: "V"), WordPosition(word: "SERİ", x: 0, y: 2, direction: "H"), WordPosition(word: "MİDE", x: 0, y: 0, direction: "H")],
    extras: ["SİM", "MİR", "MİS", "İRS", "SER", "REM"],
  ),
  // Level 17
  LevelModel(
    id: 17, letters: ["Y", "I", "L", "D", "I", "Z", "L", "K", "Ş", "T", "İ", "A", "R", "O", "H"],
    words: [WordPosition(word: "YILDIZ", x: 2, y: 2, direction: "H"), WordPosition(word: "YILLIK", x: 2, y: 2, direction: "V"), WordPosition(word: "YILIŞ", x: 4, y: 0, direction: "V"), WordPosition(word: "YILI", x: 6, y: 1, direction: "V"), WordPosition(word: "DIŞ", x: 1, y: 6, direction: "H"), WordPosition(word: "YIL", x: 0, y: 4, direction: "H")],
    extras: ["ZIT", "ZİL", "ZAR", "ZOR", "ZIH"],
  ),
  // Level 18
  LevelModel(
    id: 18, letters: ["B", "A", "Y", "R", "A", "K"],
    words: [WordPosition(word: "BAYRAK", x: 3, y: 4, direction: "H"), WordPosition(word: "YARBA", x: 3, y: 1, direction: "V"), WordPosition(word: "KABAY", x: 5, y: 0, direction: "V"), WordPosition(word: "KABAR", x: 7, y: 3, direction: "V"), WordPosition(word: "KAYA", x: 0, y: 2, direction: "H"), WordPosition(word: "YARA", x: 0, y: 5, direction: "H"), WordPosition(word: "AYAR", x: 5, y: 1, direction: "H")],
    extras: ["RAY", "KAY", "YAR", "BAR", "RAB", "KAR"],
  ),
  // Level 19
  LevelModel(
    id: 19, letters: ["T", "O", "P", "R", "A", "K", "K", "İ"],
    words: [WordPosition(word: "TOPRAK", x: 0, y: 2, direction: "H"), WordPosition(word: "KOPAR", x: 1, y: 1, direction: "V"), WordPosition(word: "ORTAK", x: 3, y: 1, direction: "V"), WordPosition(word: "AKKOR", x: 5, y: 1, direction: "V"), WordPosition(word: "KROKİ", x: 5, y: 3, direction: "H"), WordPosition(word: "PARK", x: 8, y: 0, direction: "V")],
    extras: ["POT", "ROT", "KOP", "KART", "KAR", "KOT"],
  ),
  // Level 20
  LevelModel(
    id: 20, letters: ["Ş", "A", "H", "A", "N", "E", "İ"],
    words: [WordPosition(word: "ŞAHANE", x: 1, y: 3, direction: "H"), WordPosition(word: "HAŞİN", x: 1, y: 1, direction: "V"), WordPosition(word: "AŞİNA", x: 4, y: 3, direction: "V"), WordPosition(word: "HANE", x: 6, y: 0, direction: "V"), WordPosition(word: "AHA", x: 0, y: 1, direction: "H"), WordPosition(word: "ŞAH", x: 3, y: 7, direction: "H"), WordPosition(word: "ANA", x: 0, y: 5, direction: "H")],
    extras: ["HAN", "NAAŞ", "ŞAN", "HAŞ", "AŞ"],
  ),
  // Level 21
  LevelModel(
    id: 21, letters: ["B", "İ", "L", "G", "İ"],
    words: [WordPosition(word: "BİLGİ", x: 0, y: 0, direction: "H"), WordPosition(word: "BİL", x: 0, y: 0, direction: "V")],
    extras: ["İL", "LİG"],
  ),
  // Level 22
  LevelModel(
    id: 22, letters: ["Y", "A", "Z", "I"],
    words: [WordPosition(word: "YAZI", x: 0, y: 0, direction: "H"), WordPosition(word: "YAZ", x: 0, y: 0, direction: "V")],
    extras: ["AZ", "AY"],
  ),
  // Level 23
  LevelModel(
    id: 23, letters: ["K", "A", "Y", "I", "K"],
    words: [WordPosition(word: "KAYIK", x: 0, y: 0, direction: "H"), WordPosition(word: "KAY", x: 0, y: 0, direction: "V")],
    extras: ["AYI", "YIK", "YAK"],
  ),
  // Level 24
  LevelModel(
    id: 24, letters: ["S", "A", "N", "A", "T"],
    words: [WordPosition(word: "SANAT", x: 0, y: 0, direction: "H"), WordPosition(word: "SANA", x: 0, y: 0, direction: "V")],
    extras: ["SAN", "NAT", "ATA"],
  ),
  // Level 25
  LevelModel(
    id: 25, letters: ["Z", "E", "K", "A"],
    words: [WordPosition(word: "ZEKA", x: 0, y: 0, direction: "H"), WordPosition(word: "KEZA", x: 2, y: 0, direction: "V")],
    extras: ["KAZ", "EZ"],
  ),
  // Level 26
  LevelModel(
    id: 26, letters: ["A", "Y", "N", "A"],
    words: [WordPosition(word: "AYNA", x: 0, y: 0, direction: "H"), WordPosition(word: "YAN", x: 1, y: 0, direction: "V")],
    extras: ["AY", "AN"],
  ),
  // Level 27
  LevelModel(
    id: 27, letters: ["Ç", "İ", "Ç", "E", "K"],
    words: [WordPosition(word: "ÇİÇEK", x: 0, y: 0, direction: "H"), WordPosition(word: "ÇEK", x: 2, y: 0, direction: "V")],
    extras: ["İÇ", "EK"],
  ),
  // Level 28
  LevelModel(
    id: 28, letters: ["B", "Ö", "C", "E", "K"],
    words: [WordPosition(word: "BÖCEK", x: 0, y: 0, direction: "H"), WordPosition(word: "CEK", x: 2, y: 0, direction: "V")],
    extras: ["EK", "BEK"],
  ),
  // Level 29
  LevelModel(
    id: 29, letters: ["H", "A", "V", "A"],
    words: [WordPosition(word: "HAVA", x: 0, y: 0, direction: "H"), WordPosition(word: "VAHA", x: 2, y: 0, direction: "V")],
    extras: ["AV", "HA", "AH"],
  ),
  // Level 30
  LevelModel(
    id: 30, letters: ["G", "E", "M", "İ"],
    words: [WordPosition(word: "GEMİ", x: 0, y: 0, direction: "H"), WordPosition(word: "GEM", x: 0, y: 0, direction: "V")],
    extras: ["Mİ", "ME"],
  ),
  // Level 31
  LevelModel(
    id: 31, letters: ["U", "Ç", "A", "K"],
    words: [WordPosition(word: "UÇAK", x: 0, y: 0, direction: "H"), WordPosition(word: "UÇ", x: 0, y: 0, direction: "V")],
    extras: ["AÇ", "AK", "KAÇ"],
  ),
  // Level 32
  LevelModel(
    id: 32, letters: ["O", "R", "M", "A", "N"],
    words: [WordPosition(word: "ORMAN", x: 0, y: 0, direction: "H"), WordPosition(word: "MOR", x: 2, y: 0, direction: "V")],
    extras: ["ON", "NAM"],
  ),
  // Level 33
  LevelModel(
    id: 33, letters: ["K", "Ö", "P", "E", "K"],
    words: [WordPosition(word: "KÖPEK", x: 0, y: 0, direction: "H"), WordPosition(word: "PEK", x: 2, y: 0, direction: "V")],
    extras: ["EK", "KEP"],
  ),
  // Level 34
  LevelModel(
    id: 34, letters: ["A", "R", "S", "L", "A", "N"],
    words: [WordPosition(word: "ARSLAN", x: 0, y: 0, direction: "H"), WordPosition(word: "NAR", x: 5, y: 0, direction: "V")],
    extras: ["AR", "LAN", "SAL"],
  ),
  // Level 35
  LevelModel(
    id: 35, letters: ["T", "A", "V", "U", "K"],
    words: [WordPosition(word: "TAVUK", x: 0, y: 0, direction: "H"), WordPosition(word: "TAV", x: 0, y: 0, direction: "V")],
    extras: ["KUT", "AK", "AT"],
  ),
  // Level 36
  LevelModel(
    id: 36, letters: ["M", "E", "Y", "V", "E"],
    words: [WordPosition(word: "MEYVE", x: 0, y: 0, direction: "H"), WordPosition(word: "MEY", x: 0, y: 0, direction: "V")],
    extras: ["EV", "ME", "YEM"],
  ),
  // Level 37
  LevelModel(
    id: 37, letters: ["B", "A", "L", "I", "K"],
    words: [WordPosition(word: "BALIK", x: 0, y: 0, direction: "H"), WordPosition(word: "BAL", x: 0, y: 0, direction: "V")],
    extras: ["AL", "KIL", "BAK"],
  ),
  // Level 38
  LevelModel(
    id: 38, letters: ["K", "U", "Z", "U"],
    words: [WordPosition(word: "KUZU", x: 0, y: 0, direction: "H"), WordPosition(word: "KUZ", x: 0, y: 0, direction: "V")],
    extras: ["UZ"],
  ),
  // Level 39
  LevelModel(
    id: 39, letters: ["A", "T", "E", "Ş"],
    words: [WordPosition(word: "ATEŞ", x: 0, y: 0, direction: "H"), WordPosition(word: "AT", x: 0, y: 0, direction: "V")],
    extras: ["EŞ", "TAŞ", "AŞ"],
  ),
  // Level 40
  LevelModel(
    id: 40, letters: ["S", "U", "Y", "U"],
    words: [WordPosition(word: "SUYU", x: 0, y: 0, direction: "H"), WordPosition(word: "SUY", x: 0, y: 0, direction: "V")],
    extras: ["SU", "UY"],
  ),
  // Level 41
  LevelModel(
    id: 41, letters: ["R", "E", "N", "K"],
    words: [WordPosition(word: "RENK", x: 0, y: 0, direction: "H"), WordPosition(word: "KEN", x: 3, y: 0, direction: "V")],
    extras: ["EN", "NE", "ERK"],
  ),
  // Level 42
  LevelModel(
    id: 42, letters: ["D", "O", "Ğ", "A"],
    words: [WordPosition(word: "DOĞA", x: 0, y: 0, direction: "H"), WordPosition(word: "DAĞ", x: 0, y: 0, direction: "V")],
    extras: ["AĞ", "OD"],
  ),
  // Level 43
  LevelModel(
    id: 43, letters: ["D", "E", "N", "İ", "Z"],
    words: [WordPosition(word: "DENİZ", x: 0, y: 0, direction: "H"), WordPosition(word: "DİN", x: 0, y: 0, direction: "V")],
    extras: ["EN", "NE", "İZ", "DİZ"],
  ),
  // Level 44
  LevelModel(
    id: 44, letters: ["Ş", "E", "H", "İ", "R"],
    words: [WordPosition(word: "ŞEHİR", x: 0, y: 0, direction: "H"), WordPosition(word: "ŞER", x: 0, y: 0, direction: "V")],
    extras: ["EŞ", "RE", "HER"],
  ),
  // Level 45
  LevelModel(
    id: 45, letters: ["B", "A", "H", "A", "R"],
    words: [WordPosition(word: "BAHAR", x: 0, y: 0, direction: "H"), WordPosition(word: "BAR", x: 0, y: 0, direction: "V")],
    extras: ["AH", "HA", "AB", "ARA", "HAR"],
  ),
  // Level 46
  LevelModel(
    id: 46, letters: ["Y", "A", "Ğ", "I", "Ş"],
    words: [WordPosition(word: "YAĞIŞ", x: 0, y: 0, direction: "H"), WordPosition(word: "YAĞ", x: 0, y: 0, direction: "V")],
    extras: ["AY", "AŞ", "ŞA"],
  ),
  // Level 47
  LevelModel(
    id: 47, letters: ["K", "A", "Y", "A"],
    words: [WordPosition(word: "KAYA", x: 0, y: 0, direction: "H"), WordPosition(word: "KAY", x: 0, y: 0, direction: "V")],
    extras: ["AY", "YA", "AK"],
  ),
  // Level 48
  LevelModel(
    id: 48, letters: ["O", "K", "Y", "A", "N", "U", "S"],
    words: [WordPosition(word: "OKYANUS", x: 0, y: 0, direction: "H"), WordPosition(word: "KANO", x: 1, y: 0, direction: "V")],
    extras: ["OK", "SU", "SON", "YAK"],
  ),
  // Level 49
  LevelModel(
    id: 49, letters: ["G", "Ö", "K", "Y", "Ü", "Z", "Ü"],
    words: [WordPosition(word: "GÖKYÜZÜ", x: 0, y: 0, direction: "H"), WordPosition(word: "GÖZ", x: 0, y: 0, direction: "V")],
    extras: ["ÖK", "YÜZ", "KÖY"],
  ),
  // Level 50
  LevelModel(
    id: 50, letters: ["B", "İ", "L", "G", "E"],
    words: [WordPosition(word: "BİLGE", x: 0, y: 0, direction: "H"), WordPosition(word: "BİL", x: 0, y: 0, direction: "V"), WordPosition(word: "GEL", x: 3, y: 0, direction: "V")],
    extras: ["İL", "BEL", "LİG"],
  ),
  // Level 51
  LevelModel(
    id: 51, letters: ["P", "N", "İ", "S", "A"],
    words: [
      WordPosition(word: "NİSAP", x: 0, y: 0, direction: "H"),
      WordPosition(word: "NASİP", x: 0, y: 0, direction: "V"),
      WordPosition(word: "PİS", x: 2, y: 2, direction: "H")
    ],
    extras: ["PAS", "SİN", "ASİ", "ANİ", "İSA", "PİS"],
  ),
  // Level 52
  LevelModel(
    id: 52, letters: ["A", "Y", "H", "L", "A"],
    words: [
      WordPosition(word: "HALAY", x: 0, y: 0, direction: "H"),
      WordPosition(word: "HAYAL", x: 0, y: 0, direction: "V"),
      WordPosition(word: "YAL", x: 4, y: 0, direction: "V")
    ],
    extras: ["HALA", "HAL", "AYA", "YAL", "AY", "YA", "AH"],
  ),
  // Level 53
  LevelModel(
    id: 53, letters: ["Ü", "E", "R", "P", "S"],
    words: [
      WordPosition(word: "SÜPER", x: 0, y: 0, direction: "H"),
      WordPosition(word: "SÜRE", x: 0, y: 0, direction: "V"),
      WordPosition(word: "PÜRE", x: 2, y: 0, direction: "V")
    ],
    extras: ["PRES", "PES", "SER", "ÜS", "ER"],
  ),
  // Level 54
  LevelModel(
    id: 54, letters: ["B", "E", "Y", "A", "Z"],
    words: [
      WordPosition(word: "BEYAZ", x: 0, y: 0, direction: "H"),
      WordPosition(word: "BAZ", x: 0, y: 0, direction: "V"),
      WordPosition(word: "YAZ", x: 2, y: 0, direction: "V")
    ],
    extras: ["BEZ", "BAY", "YAZ", "AY", "YA", "AB"],
  ),
];

