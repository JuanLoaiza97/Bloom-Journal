import 'package:flutter/material.dart';

class SearchPosts extends StatefulWidget {
  final Function(String) onSearch;

  const SearchPosts({super.key, required this.onSearch});

  @override
  State<SearchPosts> createState() => _SearchPostsState();
}

class _SearchPostsState extends State<SearchPosts> {
  final TextEditingController _controller = TextEditingController();

  // ✅ Normaliza el texto: elimina tildes y pone todo en minúscula
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
    return TextField(
      controller: _controller,
      onChanged: (value) {
        // 🔤 Envía el texto normalizado al padre (HomeScreen)
        widget.onSearch(normalize(value));
      },
      decoration: InputDecoration(
        hintText: 'Buscar publicaciones...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF6C63FF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
