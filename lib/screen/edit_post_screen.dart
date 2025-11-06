import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String title;
  final String description;
  final int mood;

  const EditPostScreen({
    super.key,
    required this.postId,
    required this.title,
    required this.description,
    required this.mood,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _descriptionController;
  late int _selectedMood;

  final List<String> moodImages = [
    'assets/images/emojis/Feliz.png',
    'assets/images/emojis/Molesto.png',
    'assets/images/emojis/Neutral.png',
    'assets/images/emojis/Tranquilo.png',
    'assets/images/emojis/Triste.png',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    _selectedMood = widget.mood;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (_descriptionController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      'description': _descriptionController.text.trim(),
      'mood': _selectedMood,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> _deletePost() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF6F8FB);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Editar nota',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título no editable
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Emojis editables
              const Text(
                '¿Cómo te sientes hoy?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(moodImages.length, (index) {
                  final isSelected = _selectedMood == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = index),
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.sentiment_satisfied, size: 48),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // Descripción editable
              const Text(
                'Descripción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Editar texto...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Botón guardar cambios
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('La descripción no puede estar vacía')),
                      );
                      return;
                    }

                    await _updatePost();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Nota actualizada correctamente 💚')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 231, 183),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Botón eliminar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar nota'),
                        content: const Text(
                            '¿Estás seguro de que deseas eliminar esta nota? Esta acción no se puede deshacer.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar',
                                style: TextStyle(color: Color(0xFFFF6B6B))),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _deletePost();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Nota eliminada correctamente 🗑️')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    'Eliminar esta nota',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
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
