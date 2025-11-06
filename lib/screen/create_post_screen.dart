import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int? selectedMood;

  final List<String> moodImages = [
    'assets/images/emojis/Feliz.png',
    'assets/images/emojis/Molesto.png',
    'assets/images/emojis/Neutral.png',
    'assets/images/emojis/Tranquilo.png',
    'assets/images/emojis/Triste.png',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un estado de ánimo 🥺')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay usuario autenticado 😢')),
        );
        return;
      }

      // ✅ Guardar post con UID y timestamp doble
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email ?? '',
        'mood': selectedMood,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'localCreatedAt': Timestamp.now(),
      });

      Navigator.pop(context); // cerrar loading
      Navigator.pop(context); // volver al home

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota publicada correctamente 💚')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        title: const Text(
          'Nueva nota',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¿Cómo te sientes hoy?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),

                // Emojis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(moodImages.length, (index) {
                    final isSelected = selectedMood == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMood = index),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C63FF).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6C63FF)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          moodImages[index],
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 35),
                const Text('Título',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _titleController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Escribe un título' : null,
                  decoration: InputDecoration(
                    hintText: 'Escribe un título breve...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.title, color: Color(0xFF6C63FF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text('Exprésate',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Cuéntanos cómo te sientes'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Escribe cómo te sientes...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _createPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 110, 231, 183),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Publicar',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
