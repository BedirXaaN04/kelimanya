import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/brutalist_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showModal(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(25),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  BrutalistBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BrutalistBox(
                          backgroundColor: BrutalistTheme.accentYellow,
                          padding: 8,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        content,
                      ],
                    ),
                  ),
                  Positioned(
                    top: -15,
                    right: -15,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: BrutalistTheme.accentRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                        ),
                        child: const Center(
                          child: Text("X", style: TextStyle(color: BrutalistTheme.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Header
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BrutalistBox(
                    backgroundColor: BrutalistTheme.accentYellow,
                    padding: 10,
                    child: Row(
                      children: [
                        Text("${provider.totalCoins}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        const Text("🪙", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showModal(context, "AYARLAR", Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BrutalistButton(
                            padding: 12,
                            onPressed: () {},
                            child: const Text("🔊 SES: AÇIK", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
                          BrutalistButton(
                            padding: 12,
                            backgroundColor: BrutalistTheme.accentRed,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("KAPAT", style: TextStyle(color: BrutalistTheme.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ));
                    },
                    child: const BrutalistBox(
                      padding: 10,
                      child: Text("⚙️", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),

            // Sidebar
            Positioned(
              left: 20,
              top: 100,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showModal(context, "GÖREVLER", const Text("Görevler yakında...", style: TextStyle(fontWeight: FontWeight.bold)));
                    },
                    child: const BrutalistBox(
                      padding: 10,
                      child: Text("📋", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      _showModal(context, "HEDİYE", const Text("Günlük ödül yakında...", style: TextStyle(fontWeight: FontWeight.bold)));
                    },
                    child: const BrutalistBox(
                      padding: 10,
                      child: Text("🎁", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                ],
              ),
            ),

            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BrutalistBox(
                    child: Text(
                      "SEVİYE ${provider.currentLevel.id}",
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 250,
                    child: BrutalistButton(
                      backgroundColor: BrutalistTheme.accentYellow,
                      padding: 20,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GameScreen()),
                        );
                      },
                      child: const Text("OYNA", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: BrutalistButton(
                      padding: 15,
                      onPressed: () {
                        _showModal(context, "MARKET", const Text("Market yakında...", style: TextStyle(fontWeight: FontWeight.bold)));
                      },
                      child: const Text("🛒 MARKET", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
