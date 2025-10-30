// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../components/custom_text_field.dart';
// import '../constants/validator.dart';
// import '../providers/auth_provider.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isAcceptTerms = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AuthProvider>().addListener(_authStateListener);
//     });
//   }

//   void _authStateListener() {
//     if (!mounted) return;
//     final authProvider = context.read<AuthProvider>();

//     if (authProvider.errorMessage != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(authProvider.errorMessage!),
//           backgroundColor: Colors.red,
//         ),
//       );
//       authProvider.clearError();
//     }

//     if (authProvider.authState == AuthState.authenticated) {
//       // Mostrar mensaje de éxito antes de navegar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Registration successful!'),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       // Usar Future.delayed para asegurar que el SnackBar sea visible
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       });
//     }
//   }

//   void _handleSignUp() {
//     if (_formKey.currentState!.validate()) {
//       if (!_isAcceptTerms) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please accept the terms and conditions'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       final authProvider = context.read<AuthProvider>();
//       authProvider.signUp(
//         username: _usernameController.text,
//         email: _emailController.text,
//         password: _passwordController.text,
//         confirmPassword: _confirmPasswordController.text,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Register',
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   label: 'Username',
//                   controller: _usernameController,
//                   placeholder: 'Enter your username',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your username';
//                     }
//                     if (value.length < 3) {
//                       return 'Username must be at least 3 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 CustomTextField(
//                   label: 'Email',
//                   controller: _emailController,
//                   placeholder: 'Enter your email',
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(
//                       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                     ).hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 CustomTextField(
//                   label: 'Password',
//                   controller: _passwordController,
//                   placeholder: 'Enter your password',
//                   isPassword: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 CustomTextField(
//                   label: 'Confirm Password',
//                   controller: _confirmPasswordController,
//                   placeholder: 'Confirm your password',
//                   isPassword: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _isAcceptTerms,
//                       onChanged: (value) {
//                         setState(() {
//                           _isAcceptTerms = value ?? false;
//                         });
//                       },
//                     ),
//                     const Text('Accept terms and conditions'),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: authProvider.authState == AuthState.loading
//                             ? null
//                             : _handleSignUp,
//                         child: Text(
//                           authProvider.authState == AuthState.loading
//                               ? 'Loading...'
//                               : 'Register',
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Align(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     text: TextSpan(
//                       text: 'Already have an account? ',
//                       style: const TextStyle(color: Colors.black, fontSize: 20),
//                       children: [
//                         TextSpan(
//                           text: 'Login',
//                           style: const TextStyle(color: Colors.blue),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               Navigator.pop(context);
//                             },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isAcceptTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<AuthProvider>().addListener(_authStateListener);
      } catch (e) {
        debugPrint('Warning: no se pudo añadir listener: $e');
      }
    });
  }

  void _authStateListener() {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();

    if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      authProvider.clearError();
    }

    if (authProvider.authState == AuthState.authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registro exitoso!'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isAcceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor acepta los términos y condiciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    await authProvider.signUp(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

  }

  @override
  void dispose() {
    try {
      context.read<AuthProvider>().removeListener(_authStateListener);
    } catch (e) {
      debugPrint('Warning: no se pudo remover listener: $e');
    }

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final loading = authProvider.authState == AuthState.loading;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FB),
          body: Stack(
            children: [
              SafeArea(
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

                      // Título principal
                      const Text(
                        'Bloom Journal',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Subtítulo
                      Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Únete a nuestra comunidad 🌸',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Nombre de usuario
                              CustomTextField(
                                controller: _usernameController,
                                placeholder: 'Nombre de usuario',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu nombre de usuario';
                                  }
                                  if (value.length < 3) {
                                    return 'Debe tener al menos 3 caracteres';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Correo
                              CustomTextField(
                                controller: _emailController,
                                placeholder: 'Correo electrónico',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu correo electrónico';
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

                              // Contraseña
                              CustomTextField(
                                controller: _passwordController,
                                placeholder: 'Contraseña',
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'Debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Confirmar contraseña
                              CustomTextField(
                                controller: _confirmPasswordController,
                                placeholder: 'Confirmar contraseña',
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor confirma tu contraseña';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Las contraseñas no coinciden';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              // Checkbox términos
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isAcceptTerms,
                                    activeColor: const Color(0xFF6C63FF),
                                    onChanged: (value) {
                                      setState(() {
                                        _isAcceptTerms = value ?? false;
                                      });
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Acepto los términos y condiciones',
                                      style: TextStyle(
                                        color: Color.fromARGB(221, 65, 65, 65),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // Botón de registro
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 110, 231, 183),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: loading ? null : () => _handleSignUp(),
                                  child: Text(
                                    loading ? 'Cargando...' : 'Registrarse',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 50),

                              RichText(
                                text: TextSpan(
                                  text: "¿Ya tienes una cuenta? ",
                                  style: const TextStyle(
                                    color: Color.fromARGB(221, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Inicia sesión.',
                                      style: const TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
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

              if (loading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

