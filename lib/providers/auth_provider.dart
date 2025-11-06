import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthState _authState = AuthState.initial;
  String? _errorMessage;
  User? _user;

  AuthState get authState => _authState;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    });
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      _errorMessage = "Passwords don't match";
      _setState(AuthState.error);
      return;
    }

    print('Iniciando registro con email: $email'); // Log de depuración
    _setState(AuthState.loading);
    try {
      print('Intentando crear usuario en Firebase Auth...'); // Log de depuración
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuario creado exitosamente en Auth con ID: ${userCredential.user?.uid}'); // Log de depuración

      print('Preparando para guardar en Firestore...'); // Log de depuración
      final userData = {
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'profileData': {
          'avatarUrl': '',
          'bio': '',
          'preferences': {
            'emailNotifications': true,
            'darkMode': false
          }
        },
        'stats': {
          'journalEntries': 0,
          'streakDays': 0,
          'lastEntryDate': null
        }
      };
      print('Datos a guardar: $userData'); // Log de depuración

      try {
        print('Intentando guardar en Firestore para el usuario ID: ${userCredential.user!.uid}');
        // Add user details to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
        print('Datos guardados exitosamente en Firestore');
        
        // Verificar que los datos se guardaron
        final savedData = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (savedData.exists) {
          print('Verificación: Datos encontrados en Firestore');
          print('Datos guardados: ${savedData.data()}');
        } else {
          print('ERROR: No se encontraron los datos después de guardar');
        }
      } catch (e) {
        print('ERROR al guardar en Firestore: $e');
        throw e; // Re-lanzar el error para manejarlo arriba
      }
      print('Datos guardados exitosamente en Firestore'); // Log de depuración

      _errorMessage = null;
      _user = userCredential.user;
      await Future.delayed(const Duration(milliseconds: 500)); // Pequeña pausa para asegurar que Firestore termine
      _setState(AuthState.authenticated);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      _errorMessage = message;
      _setState(AuthState.error);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading);
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
      _user = userCredential.user;
      await _updateLastLogin(); // Actualizar último login
      _setState(AuthState.authenticated);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        case 'invalid-credential':
          message = 'The supplied credentials are invalid.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      _errorMessage = message;
      _setState(AuthState.error);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
    }
  }

  _setState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_authState == AuthState.error) {
      _authState = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (_user != null) {
        final docSnapshot = await _firestore.collection('users').doc(_user!.uid).get();
        if (docSnapshot.exists) {
          return docSnapshot.data();
        }
      }
      return null;
    } catch (e) {
      _errorMessage = 'Error getting user data: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  // Actualizar datos del usuario
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).update(data);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error updating user data: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Actualizar último login
  Future<void> _updateLastLogin() async {
    if (_user != null) {
      try {
        await _firestore.collection('users').doc(_user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error updating last login: ${e.toString()}');
      }
    }
  }
}