import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/interactive_wheel.dart';
import '../theme/brutalist_theme.dart';
import '../services/ad_service.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  void _showWinModal(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: BrutalistBox(
              backgroundColor: BrutalistTheme.accentGreen,
              borderColor: BrutalistTheme.black,
              borderStyle: BorderStyle.solid,
              padding: 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("HARİKA!", style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: BrutalistTheme.white, shadows: [Shadow(color: BrutalistTheme.black, offset: Offset(4, 4))])),
                  const SizedBox(height: 10),
                  Text("SEVİYE ${provider.currentLevel.id} BİTTİ", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: BrutalistBox(
                      padding: 25,
                      child: Text("🪙 +50", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  BrutalistButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      provider.nextLevel();
                    },
                    child: const Text("DEVAM ET", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
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

    // Listen to level completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isLevelCompleted() && provider.foundWords.isNotEmpty) {
        _showWinModal(context, provider);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: BrutalistTheme.black, width: 3)),
                color: Color.fromRGBO(255, 255, 255, 0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BrutalistButton(
                    padding: 8,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("🏠 MENÜ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text("SEVİYE ${provider.currentLevel.id}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  BrutalistBox(
                    padding: 8,
                    backgroundColor: BrutalistTheme.accentYellow,
                    child: Text("${provider.totalCoins} 🪙", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Grid
            const Expanded(
              child: CrosswordGrid(),
            ),

            // Hints & Wheel
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  InteractiveWheel(letters: provider.currentShuffledLetters),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHintBtn(context, provider, "🚀", 100, "rocket"),
                        const SizedBox(height: 18),
                        _buildHintBtn(context, provider, "💡", 25, "single"),
                        const SizedBox(height: 18),
                        BrutalistButton(
                          padding: 10,
                          onPressed: () {
                             provider.shuffleLetters();
                          },
                          child: const Text("🔀", style: TextStyle(fontSize: 24)),
                        ),
                      ],
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

  Widget _buildHintBtn(BuildContext context, GameProvider provider, String icon, int cost, String type) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BrutalistButton(
          padding: 10,
          onPressed: () {
            if (provider.totalCoins >= cost) {
              // Trigger rewarded ad before showing hint
              AdService().showRewardedAd(
                onRewardEarned: () {
                  provider.useHint(type);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("İpucu açıldı!")));
                },
                onAdFailed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reklam yüklenemedi, lütfen daha sonra tekrar deneyin.")));
                }
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Altın yetersiz!")));
            }
          },
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: BrutalistTheme.accentRed,
              border: Border.all(color: BrutalistTheme.black, width: 2.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("$cost", style: const TextStyle(color: BrutalistTheme.white, fontSize: 11, fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }
}
