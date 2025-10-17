import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Register', style: const TextStyle(fontSize:30, fontWeight: FontWeight.bold)),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle registration logic here
                },
                child: const Text('Register'),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ), 
      )
    );
  }
}