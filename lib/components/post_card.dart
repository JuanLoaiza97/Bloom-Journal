import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screen/edit_post_screen.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String title;
  final String description;
  final int mood;
  final Timestamp createdAt;

  const PostCard({
    super.key,
    required this.postId,
    required this.title,
    required this.description,
    required this.mood,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    // emojis locales (mismos del create_post_screen)
    final moodImages = [
      'assets/images/emojis/Feliz.png',
      'assets/images/emojis/Molesto.png',
      'assets/images/emojis/Neutral.png',
      'assets/images/emojis/Tranquilo.png',
      'assets/images/emojis/Triste.png',
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditPostScreen(
              postId: postId,
              title: title,
              description: description,
              mood: mood,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(moodImages[mood], width: 50, height: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
