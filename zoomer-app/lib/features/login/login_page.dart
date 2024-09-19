import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/grades.dart';
import '../../services/authentication_service.dart';
import '../../dependency_injector.dart';
import 'dart:developer';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();

  Future<void> _authenticate(BuildContext context) async {
    try {
      final user = await authenticationService.login();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
        return;
      } else {
        // Get the school name from user info
        final userInfo = user.userInfo;
        final schoolName = userInfo['name'] as String?;
        
        if (schoolName != null) {
          // Save school name to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('school_name', schoolName);
          
          log('Logged in as: $schoolName');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('School name not found. Please try again.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
      log('Login error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _authenticate(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}