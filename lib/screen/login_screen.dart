import 'package:bloom_journal/providers/auth_provider.dart' as auth;
import 'package:bloom_journal/screen/home_screen.dart';
import 'package:bloom_journal/screen/register_screen.dart';
import 'package:bloom_journal/screen/forgot_password_screen.dart'; // ✅ Import agregado
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen superior
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Título
              const Text(
                'Bloom Journal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 70),

              // Subtítulo
              Text(
                'Inicio',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 40),

              // Formulario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo correo
                      CustomTextField(
                        controller: _emailController,
                        placeholder: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Correo electrónico inválido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Campo contraseña
                      CustomTextField(
                        controller: _passwordController,
                        placeholder: 'Contraseña',
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Botón principal
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              110,
                              231,
                              183,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            final authProvider = Provider.of<auth.AuthProvider>(
                              context,
                              listen: false,
                            );
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              await authProvider.signIn(
                                email: email,
                                password: password,
                              );

                              if (authProvider.authState ==
                                  auth.AuthState.authenticated) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                                final displayed =
                                    authProvider.errorMessage ??
                                    'Error al iniciar sesión.';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(displayed)),
                                );
                              }
                            } catch (e) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error inesperado: ${e.toString()}',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Texto registrar
                      RichText(
                        text: TextSpan(
                          text: "¿Aún no tienes una cuenta? ",
                          style: const TextStyle(
                            color: Color.fromARGB(221, 65, 65, 65),
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Crea una.',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ Texto recuperar contraseña (corregido)
                      RichText(
                        text: TextSpan(
                          text: "¿Olvidaste tu contraseña? ",
                          style: const TextStyle(
                            color: Color.fromARGB(221, 62, 62, 62),
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Recupérala',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
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
