import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final bool isLogin;
  final Function(String, String) onLogin;
  final Function(String, String) onRegister;
  final VoidCallback onToggleForm;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onLogin,
    required this.onRegister,
    required this.onToggleForm,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Icon(Icons.lock, size: 50, color: Colors.black),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || !emailRegex.hasMatch(val)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null) {
                  return 'Password must be at least 6 characters and include letters and numbers';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (isLogin) {
                      onLogin(emailController.text, passwordController.text);
                    } else {
                      onRegister(emailController.text, passwordController.text);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLogin ? 'Login' : 'Register',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onToggleForm,
              child: Text(
                isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login",
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
