import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/brutalist_theme.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import 'game_screen.dart';
import '../widgets/market_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showModal(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      decoration: BoxDecoration(
                        color: BrutalistTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BrutalistTheme.black, width: 5),
                        boxShadow: const [
                          BoxShadow(color: BrutalistTheme.black, offset: Offset(8, 8)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          content,
                        ],
                      ),
                    ),
                    Positioned(
                      top: -16,
                      right: -16,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: BrutalistTheme.accentRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                            boxShadow: const [
                              BoxShadow(color: BrutalistTheme.black, offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset)),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "✕",
                              style: TextStyle(
                                color: BrutalistTheme.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      backgroundColor: provider.currentTheme.primaryColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Enforce center max width
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxHeight < 600;
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DottedBackgroundPainter(),
                    ),
                  ),
                  SafeArea(
                child: Column(
                  children: [
                    // Top Navigation Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBox(
                            bg: BrutalistTheme.accentYellow,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${provider.totalCoins}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text("🪙", style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showModal(
                                context,
                                "AYARLAR",
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildModalButton(
                                      label: "🔊 SES: ${provider.soundOn ? 'AÇIK' : 'KAPALI'}",
                                      bg: BrutalistTheme.white,
                                      onTap: () => provider.toggleSound(),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildModalButton(
                                      label: "Sıfırla & Çıkış",
                                      bg: BrutalistTheme.accentRed,
                                      textColor: BrutalistTheme.white,
                                      onTap: () async {
                                        await AuthService.signOut();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: _buildBox(
                              padding: const EdgeInsets.all(12),
                              child: const Text("⚙️", style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Side Bar & Streak Area
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  int progress = provider.completedTasksProgress;
                                  int limit = provider.tasksCompletedLimit;
                                  _showModal(
                                    context,
                                    "GÖREVLER",
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildTaskRow(
                                          "10 Ekstra Kelime Bul",
                                          1.0,
                                          BrutalistTheme.accentYellow,
                                          "+50🪙",
                                          () {
                                            provider.claimReward(50);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        _buildTaskRow(
                                          "5 Bölüm Geç",
                                          progress / limit,
                                          Colors.grey.shade300,
                                          "$progress/$limit",
                                          null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: _buildBox(
                                  padding: const EdgeInsets.all(12),
                                  child: const Text("📋", style: TextStyle(fontSize: 22)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () => provider.claimReward(50),
                                child: _buildBox(
                                  padding: const EdgeInsets.all(12),
                                  child: const Text("🎁", style: TextStyle(fontSize: 22)),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: provider.streak >= 3
                                ? Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: BrutalistTheme.accentRed,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                                        boxShadow: const [
                                          BoxShadow(color: BrutalistTheme.black, offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset)),
                                        ],
                                      ),
                                      child: Text(
                                        "🔥 ${provider.streak} SERİ",
                                        style: const TextStyle(
                                          color: BrutalistTheme.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          // Balances out the side bar visually
                          const SizedBox(width: 50),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildBox(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                                child: Text(
                                  "BÖLÜM ${provider.currentLevel.id}",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 20 : 30),
                              SizedBox(
                                width: 280,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const GameScreen()),
                                    );
                                  },
                                  child: _buildBox(
                                    bg: BrutalistTheme.accentYellow,
                                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 20 : 26),
                                    child: const Center(
                                      child: Text(
                                        "OYNA ▶",
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: 280,
                                child: GestureDetector(
                                  onTap: () {
                                    _showModal(context, "MARKET", const MarketModalContent());
                                  },
                                  child: _buildBox(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: const Center(
                                      child: Text(
                                        "🛒 MARKET",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // User Info Footer
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 4),
                      child: Text(
                        "👤 ${AuthService.displayName}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  ),
);
  }

  Widget _buildBox({
    Color bg = BrutalistTheme.white,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    required Widget child,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(BrutalistTheme.borderWidth > 3 ? 16 : 14),
        border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
        boxShadow: const [
          BoxShadow(color: BrutalistTheme.black, offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildModalButton({
    required String label,
    Color bg = BrutalistTheme.white,
    Color textColor = BrutalistTheme.black,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BrutalistTheme.borderWidth > 3 ? 16 : 10),
          border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
          boxShadow: const [
            BoxShadow(color: BrutalistTheme.black, offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: textColor,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskRow(String title, double progress, Color btnBg, String btnLabel, VoidCallback? onTap) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: BrutalistTheme.accentGreen,
                        borderRadius: BorderRadius.circular(4),
                        border: const Border(
                          right: BorderSide(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: btnBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                boxShadow: const [
                  BoxShadow(color: BrutalistTheme.black, offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset)),
                ],
              ),
              child: Text(
                btnLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
