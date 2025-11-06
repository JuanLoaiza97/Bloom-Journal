// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bloom_journal/screen/login_screen.dart';
// import '../providers/auth_provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _notifications = false;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     final int notesCount = 4; //Cambiar ésta constante por el nombre de la variable correcta

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FB),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(vertical: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const CircleAvatar(
//                       radius: 52,
//                       backgroundColor: Color(0xFFDADADA),
//                       child: Icon(Icons.person, size: 48, color: Colors.white70),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text('¡Bienvenido!',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 24),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Tu Actividad',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 12),

//                           Container(
//                             width: double.infinity,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [Color(0xFF6C63FF), Color(0xFF8B7CFF)],
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withValues(alpha: 0.08),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 )
//                               ],
//                             ),
//                             padding: EdgeInsets.zero,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text('$notesCount',
//                                     style: const TextStyle(
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white)),
//                                 const SizedBox(width: 12),
//                                 const Text('Notas',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white)),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           Row(
//                             children: [
//                               Expanded(
//                                 child: _GradientMiniButton(label: 'Nueva Nota'),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: _GradientMiniButton(label: 'Mis Notas'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 28),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Preferencias',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 12),

//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey.shade200),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withValues(alpha: 0.03),
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 3),
//                                 )
//                               ],
//                             ),
//                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                             child: Row(
//                               children: [
//                                 const Expanded(
//                                     child: Text('Notificaciones',
//                                         style: TextStyle(
//                                             fontSize: 16, fontWeight: FontWeight.w500))),
//                                   Switch(
//                                     value: _notifications,
//                                     onChanged: (v) => setState(() => _notifications = v),

//                                     activeThumbColor: const Color(0xFF6C63FF),

//                                     activeTrackColor: const Color.fromRGBO(108, 99, 255, 0.15),

//                                     inactiveThumbColor: Colors.grey,
//                                     inactiveTrackColor: Colors.grey.shade300,
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 120),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       bottomNavigationBar: SafeArea(
//         top: false, 
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//           child: SizedBox(
//             height: 52,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 padding: EdgeInsets.zero,
//               ),
//               onPressed: () async {
//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (_) => const Center(child: CircularProgressIndicator()),
//                 );
//                 try {
//                   await auth.signOut();
//                 } catch (e) {
//                   // opcional: manejar error
//                 } finally {
//                   if (mounted) {
//                     Navigator.of(context).pop(); // cerrar dialog
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                     );
//                   }
//                 }
//               },
//               child: Ink(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [Color(0xFF6EE7B7), Color(0xFF7DE3C9)],
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Cerrar Sesión',
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GradientMiniButton extends StatelessWidget {
//   final String label;
//   const _GradientMiniButton({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         height: 44,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF8DE6D1), Color(0xFF7DDACB)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             )
//           ],
//         ),
//         alignment: Alignment.center,
//         child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/post_card.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
              // 👋 Bienvenido + ícono de perfil
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

              // 🔍 Barra de búsqueda
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6C63FF)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 📄 Lista de posts del usuario actual
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
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return const Center(
                              child: Text(
                                'Aún no hay publicaciones 📝',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              return PostCard(
                                postId: docs[index].id,
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

              // 💬 Botón inferior “¿Cómo me siento?”
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 110, 231, 183),
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

