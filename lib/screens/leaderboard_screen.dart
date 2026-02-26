import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/brutalist_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalistTheme.backgroundBlue,
      appBar: AppBar(
        title: const Text('TR SIRALAMASI', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: BrutalistTheme.backgroundBlue,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('level', descending: true)
            .orderBy('coins', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Sıralama yüklenirken hata oluştu."));
          }

          final users = snapshot.data?.docs ?? [];
          
          if (users.isEmpty) {
             return const Center(child: Text("Henüz sıralamada kimse yok."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final name = userData['displayName'] ?? 'Anonim';
              final level = userData['level'] ?? 0;
              final coins = userData['coins'] ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index == 0 ? BrutalistTheme.accentYellow : index == 1 ? Colors.grey.shade300 : index == 2 ? Colors.orange.shade300 : Colors.white,
                    border: Border.all(color: BrutalistTheme.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
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
                      Row(
                        children: [
                          Text("#${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 15),
                          Text(name, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                           Text("Sv. $level", style: const TextStyle(fontWeight: FontWeight.bold, color: BrutalistTheme.accentGreen)),
                           Text("$coins 🪙", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
