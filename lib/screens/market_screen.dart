import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/brutalist_theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: BrutalistTheme.nightBg,
      appBar: _buildAppBar(context, provider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle("OYUN İÇİ GÜÇLENDİRİCİLER"),
            const SizedBox(height: 15),
            _buildMegaHintCard(context, provider),
            const SizedBox(height: 15),
            _buildVowelScannerCard(context, provider),
            const SizedBox(height: 30),
            
            _buildSectionTitle("AVATARLAR (ÇAKMA BAYKUŞLAR)"),
            const SizedBox(height: 15),
            _buildAvatarGrid(context, provider),
            const SizedBox(height: 30),
            
            _buildSectionTitle("ALTIN SATIN AL (YAKINDA)"),
            const SizedBox(height: 15),
            _buildIapPlaceholderCard(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, GameProvider provider) {
    return AppBar(
      backgroundColor: BrutalistTheme.nightBg,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: BrutalistTheme.black, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        "MAĞAZA",
        style: TextStyle(
          color: BrutalistTheme.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: BrutalistTheme.accentYellow,
            border: Border.all(color: BrutalistTheme.black, width: 3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(2, 2))],
          ),
          child: Row(
            children: [
              const Text("🪙", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                "\${provider.totalCoins}",
                style: const TextStyle(fontWeight: FontWeight.w900, color: BrutalistTheme.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: BrutalistTheme.black,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildMegaHintCard(BuildContext context, GameProvider provider) {
    return _MarketCard(
      title: "Mega İpucu",
      description: "Bulunmamış rastgele bir kelimenin tamamını sihirli bir şekilde açar.",
      icon: "🪄",
      price: 100,
      color: BrutalistTheme.accentPurple,
      onTap: () {
        if (provider.useMegaHint()) {
           Navigator.of(context).pop(); // Go back to game to see it
        }
      },
    );
  }

  Widget _buildVowelScannerCard(BuildContext context, GameProvider provider) {
    return _MarketCard(
      title: "Sesli Harf Tarayıcı",
      description: "Tablodaki tüm sesli harfleri (A, E, I, İ, O, Ö, U, Ü) kısa süreliğine görünür yapar.",
      icon: "🅰️",
      price: 75,
      color: BrutalistTheme.bgBlue,
      onTap: () {
        if (provider.useVowelScanner()) {
           Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildAvatarGrid(BuildContext context, GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: BrutalistTheme.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrutalistTheme.black, width: 4),
        boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6))],
      ),
      child: Column(
        children: [
          const Text("🦉", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: BrutalistTheme.accentYellow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BrutalistTheme.black, width: 3),
            ),
            child: const Text(
              "YAKINDA",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Yeni baykuş kostümleri çok yakında eklenecek!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIapPlaceholderCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: BrutalistTheme.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrutalistTheme.black, width: 4),
        boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6))],
      ),
      child: Column(
        children: [
          const Text("💳", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: BrutalistTheme.accentRed,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BrutalistTheme.black, width: 3),
            ),
            child: const Text(
              "YAKINDA",
              style: TextStyle(
                color: BrutalistTheme.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Gerçek parayla paket satın alımları yakında aktif olacak.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final int price;
  final Color color;
  final VoidCallback onTap;

  const _MarketCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.price,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BrutalistTheme.black, width: 4),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6))],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: BrutalistTheme.white,
                shape: BoxShape.circle,
                border: Border.all(color: BrutalistTheme.black, width: 3),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrutalistTheme.white)),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: BrutalistTheme.accentYellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BrutalistTheme.black, width: 3),
              ),
              child: Column(
                children: [
                  const Text("SATIN AL", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                  Row(
                    children: [
                      const Text("🪙", style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Text("$price", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
