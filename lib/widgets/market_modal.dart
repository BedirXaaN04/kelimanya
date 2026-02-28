import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/brutalist_theme.dart';
import '../models/theme_model.dart';

class MarketModalContent extends StatelessWidget {
  const MarketModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    
    return SizedBox(
      height: 400,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: StoreThemes.themes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final themeInfo = StoreThemes.themes[index];
          final bool isUnlocked = provider.unlockedThemes.contains(themeInfo.id);
          final bool isActive = provider.activeThemeId == themeInfo.id;
          
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BrutalistTheme.white,
              border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: BrutalistTheme.black,
                  offset: Offset(4, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: themeInfo.gradientColors,
                          ),
                          border: Border.all(color: BrutalistTheme.black, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              themeInfo.name,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isUnlocked ? "Açık" : "${themeInfo.cost} 🪙",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? BrutalistTheme.accentGreen : BrutalistTheme.accentRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionBtn(context, provider, themeInfo, isUnlocked, isActive),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionBtn(
    BuildContext context, 
    GameProvider provider, 
    ThemeModel themeInfo, 
    bool isUnlocked, 
    bool isActive
  ) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: BrutalistTheme.accentYellow,
          border: Border.all(color: BrutalistTheme.black, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text("AKTİF", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    
    if (isUnlocked) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrutalistTheme.white,
          side: const BorderSide(color: BrutalistTheme.black, width: 2),
          elevation: 0,
        ),
        onPressed: () {
          provider.equipTheme(themeInfo.id);
        },
        child: const Text("SEÇ", style: TextStyle(color: BrutalistTheme.black, fontWeight: FontWeight.bold)),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.totalCoins >= themeInfo.cost ? BrutalistTheme.accentGreen : Colors.grey.shade400,
        side: const BorderSide(color: BrutalistTheme.black, width: 2),
        elevation: 0,
      ),
      onPressed: () {
        if (provider.totalCoins >= themeInfo.cost) {
          provider.purchaseTheme(themeInfo);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${themeInfo.name} teması satın alındı!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Yetersiz altın!")),
          );
        }
      },
      child: const Text("SATIN AL", style: TextStyle(color: BrutalistTheme.white, fontWeight: FontWeight.bold)),
    );
  }
}
