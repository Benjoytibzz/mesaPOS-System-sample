import 'package:flutter/material.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  // final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'PIN / Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                LoginController.login(
                  context,
                  _username.text,
                  _password.text,
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
