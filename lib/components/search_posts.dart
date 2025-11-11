import 'package:flutter/material.dart';

class SearchPosts extends StatefulWidget {
  final Function(String) onSearch;
  final Function(int?) onMoodSelected;

  const SearchPosts({
    super.key,
    required this.onSearch,
    required this.onMoodSelected,
  });

  @override
  State<SearchPosts> createState() => _SearchPostsState();
}

class _SearchPostsState extends State<SearchPosts> {
  final TextEditingController _controller = TextEditingController();

  //Generaliza todo
  String normalize(String text) {
    const withAccents = 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ';
    const withoutAccents = 'aeiouAEIOUaeiouAEIOU';
    String normalized = text.toLowerCase();
    for (int i = 0; i < withAccents.length; i++) {
      normalized = normalized.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return normalized;
  }

  final List<String> moodImages = [
    'assets/images/emojis/Feliz.png',
    'assets/images/emojis/Molesto.png',
    'assets/images/emojis/Neutral.png',
    'assets/images/emojis/Tranquilo.png',
    'assets/images/emojis/Triste.png',
  ];

  int? selectedMood; // Guarda el estado de ánimo seleccionado

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) {
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
        ),

        const SizedBox(height: 10),

        // ✅ FILTRO DE ESTADOS DE ÁNIMO
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(moodImages.length, (index) {
            final isSelected = selectedMood == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedMood == index) {
                    selectedMood = null; // Selector de iconos
                  } else {
                    selectedMood = index;
                  }
                });

                widget.onMoodSelected(selectedMood);
              },
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
                child: Image.asset(moodImages[index], width: 40, height: 40),
              ),
            );
          }),
        ),
      ],
    );
  }
}
