import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/search_posts.dart';
import '../components/post_card.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  int? _moodFilter;

  String normalize(String text) {
    const withAccents = 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ';
    const withoutAccents = 'aeiouAEIOUaeiouAEIOU';
    String normalized = text.toLowerCase();
    for (int i = 0; i < withAccents.length; i++) {
      normalized = normalized.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF6C63FF),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BARRA DE BÚSQUEDA Y ICONOS DE EMOCIONES
              SearchPosts(
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                onMoodSelected: (mood) {
                  setState(() {
                    _moodFilter = mood;
                  });
                },
              ),

              const SizedBox(height: 20),

              // POSTS
              Expanded(
                child: user == null
                    ? const Center(
                        child: Text(
                          'Debes iniciar sesión 😅',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('userId', isEqualTo: user.uid)
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];

                          // ✅ Filtro
                          final filteredDocs = docs.where((doc) {
                            final data =
                                doc.data() as Map<String, dynamic>? ?? {};

                            final title = normalize(data['title'] ?? '');
                            final desc = normalize(data['description'] ?? '');
                            final mood = data['mood'] as int?;

                            final search = _searchQuery;

                            final matchesText =
                                search.isEmpty ||
                                title.contains(search) ||
                                desc.contains(search);

                            final matchesMood =
                                _moodFilter == null || _moodFilter == mood;

                            return matchesText && matchesMood;
                          }).toList();

                          if (filteredDocs.isEmpty) {
                            return const Center(
                              child: Text(
                                'No hay coincidencias 🔍',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredDocs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  filteredDocs[index].data()
                                      as Map<String, dynamic>;

                              return PostCard(
                                postId: filteredDocs[index].id,
                                title: data['title'] ?? '',
                                description: data['description'] ?? '',
                                mood: data['mood'] ?? 0,
                                createdAt: data['createdAt'] ?? Timestamp.now(),
                              );
                            },
                          );
                        },
                      ),
              ),

              const SizedBox(height: 10),

              //CREAR POST
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreatePostScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 231, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '¿Cómo me siento?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
