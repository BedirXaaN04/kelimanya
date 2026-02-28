import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/interactive_wheel.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/toast_notification.dart';
import '../widgets/animated_owl.dart';
import '../theme/brutalist_theme.dart';
import '../services/ad_service.dart';
import 'market_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _winModalShown = false;

  void _showWinModal(BuildContext context, GameProvider provider) {
    if (_winModalShown) return;
    _winModalShown = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: BrutalistTheme.accentGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BrutalistTheme.black, width: 5),
                boxShadow: const [
                  BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "HARİKA! 🎉",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: BrutalistTheme.white,
                      shadows: [Shadow(color: BrutalistTheme.black, offset: Offset(3, 3))],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Bölümü Tamamladın!",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: BrutalistTheme.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: BrutalistTheme.black, width: 3),
                      boxShadow: const [
                        BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
                      ],
                    ),
                    child: const Text("🪙 +50", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _winModalShown = false;
                      provider.nextLevel();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: BrutalistTheme.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: BrutalistTheme.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: const Center(
                        child: Text("DEVAM ET →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
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
    final int mainFound = provider.foundWords.where((f) => !f.startsWith('_x')).length;
    final int mainTotal = provider.currentLevel.words.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isLevelCompleted() && provider.foundWords.isNotEmpty && !_winModalShown) {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!context.mounted) return;
          if (mounted) _showWinModal(context, provider);
        });
      }
    });

    return Scaffold(
      body: Container(
        color: BrutalistTheme.nightBg,
        child: Stack(
          children: [
            // Dotted Background
            Positioned.fill(
              child: CustomPaint(
                painter: _DottedBgPainter(),
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // ── HEADER ──
                  _buildHeader(provider, mainFound, mainTotal),

                  const SizedBox(height: 4),

                  SizedBox(
                    width: 60,
                    height: 60,
                    child: AnimatedOwl(
                      isHappy: provider.isOwlHappy || (provider.isLevelCompleted() && provider.foundWords.isNotEmpty),
                      isAngry: provider.isOwlAngry,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── GRID + HINTS ROW ──
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // Grid takes most space, safely scaled
                          const Expanded(
                            child: CrosswordGrid(),
                          ),
                          // Hint buttons column on right, safe from overflow
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildHintBtn(provider, "🚀", 100, "rocket"),
                                  const SizedBox(height: 12),
                                  _buildHintBtn(provider, "💡", 25, "single"),
                                  const SizedBox(height: 12),
                                  _buildShuffleBtn(provider),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── WHEEL ──
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InteractiveWheel(letters: provider.currentShuffledLetters),
                    ),
                  ),

                  // ── BOTTOM ACTIONS ROW ──
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBonusButton(provider),
                        _buildUndoButton(),
                        _buildGiftButton(provider),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Confetti overlay
            Positioned.fill(
              child: ConfettiOverlay(
                show: provider.showConfetti,
              ),
            ),

            // Toast notification
            if (provider.toastMessage != null)
              ToastNotification(message: provider.toastMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GameProvider provider, int mainFound, int mainTotal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Row(
        children: [
          // Home button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: BrutalistTheme.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BrutalistTheme.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3)),
                ],
              ),
              child: const Text("🏠", style: TextStyle(fontSize: 16)),
            ),
          ),
          
          const SizedBox(width: 8),

          // Center: Level + Progress
          Expanded(
            child: Column(
              children: [
                Text(
                  "BÖLÜM ${provider.currentLevel.id}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: BrutalistTheme.white,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: BrutalistTheme.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: BrutalistTheme.black, width: 3),
                    boxShadow: const [
                      BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3)),
                    ],
                  ),
                  child: Text(
                    "BULUNAN $mainFound/$mainTotal",
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Coin display
          GestureDetector(
            onTap: () {
               Navigator.of(context).push(
                 PageRouteBuilder(
                   pageBuilder: (context, animation, secondaryAnimation) => const MarketScreen(),
                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                     return FadeTransition(opacity: animation, child: child);
                   },
                 ),
               );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: BrutalistTheme.accentYellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BrutalistTheme.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3)),
                ],
              ),
              child: Text(
                "${provider.totalCoins}🪙",
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintBtn(GameProvider provider, String icon, int cost, String type) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            if (provider.totalCoins >= cost) {
              AdService().showRewardedAd(
                onRewardEarned: () {
                  provider.useHint(type);
                  provider.showToast("İpucu açıldı!");
                },
                onAdFailed: () {
                  provider.useHint(type);
                  provider.showToast("İpucu açıldı!");
                },
              );
            } else {
              provider.showToast("Altın Yetersiz! 😢");
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: BrutalistTheme.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BrutalistTheme.black, width: 3),
              boxShadow: const [
                BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
              ],
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: BrutalistTheme.accentRed,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: BrutalistTheme.black, width: 2),
            ),
            child: Text("$cost", style: const TextStyle(color: BrutalistTheme.white, fontSize: 8, fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }

  Widget _buildShuffleBtn(GameProvider provider) {
    return GestureDetector(
      onTap: () => provider.shuffleLetters(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: BrutalistTheme.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [
            BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
          ],
        ),
        child: const Center(child: Text("🔀", style: TextStyle(fontSize: 16))),
      ),
    );
  }

  // ── BOTTOM ACTION HELPERS ──
  Widget _buildUndoButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: BrutalistTheme.accentYellow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [
            BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
          ],
        ),
        child: const Text("↩ GERİ AL", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildBonusButton(GameProvider provider) {
    int count = provider.foundWords.where((w) => w.startsWith('_x')).length;
    return GestureDetector(
      onTap: () => _showBonusModal(provider),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: BrutalistTheme.accentPurple,
          shape: BoxShape.circle,
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text("W", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BrutalistTheme.white)),
            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: BrutalistTheme.accentRed, shape: BoxShape.circle),
                  child: Text("$count", style: const TextStyle(fontSize: 10, color: BrutalistTheme.white, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftButton(GameProvider provider) {
    return GestureDetector(
      onTap: () {
        AdService().showRewardedAd(
          onRewardEarned: () {
            provider.claimReward(50);
            provider.showToast("🎁 +50 🪙 Şahane!");
          },
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: BrutalistTheme.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3))],
        ),
        child: const Center(
          child: Text("🎁\nİZLE", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, height: 1.1)),
        ),
      ),
    );
  }

  void _showBonusModal(GameProvider provider) {
    final List<String> bonusWords = provider.foundWords
        .where((w) => w.startsWith('_x'))
        .map((w) => w.substring(2))
        .toList();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BrutalistTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BrutalistTheme.black, width: 4),
                boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("BONUS KELİMELER", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text("Ekstra kelimeler sana Altın kazandırır! (+2🪙 / kelime)", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 15),
                  bonusWords.isEmpty
                      ? const Padding(padding: EdgeInsets.all(20.0), child: Text("Henüz bonus kelime bulunamadı.", style: TextStyle(fontWeight: FontWeight.w600)))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: bonusWords.map((w) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: BrutalistTheme.accentYellow,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: BrutalistTheme.black, width: 2),
                              ),
                              child: Text(w, style: const TextStyle(fontWeight: FontWeight.w900)),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(color: BrutalistTheme.accentRed, borderRadius: BorderRadius.circular(8), border: Border.all(color: BrutalistTheme.black, width: 3)),
                      child: const Text("KAPAT", style: TextStyle(color: BrutalistTheme.white, fontWeight: FontWeight.w900)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DottedBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xfffcd53f)
      ..style = PaintingStyle.fill;
    const spacing = 30.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
