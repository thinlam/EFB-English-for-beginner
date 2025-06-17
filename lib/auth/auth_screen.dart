import 'package:flutter/material.dart';
import '../database/prebuilt_database.dart';
import 'auth_service.dart';
import 'package:sqflite/sqflite.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  late AuthService authService;
  Database? db;

  @override
  void initState() {
    super.initState();
    openPrebuiltDB().then((database) {
      db = database;
      authService = AuthService(db!);
      print('✅ DB ready at: ${database.path}');
    });
  }

  void _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    if (isLogin) {
      final role = await authService.login(email, password);
      if (role != null) {
        _showMessage('✅ Đăng nhập thành công\nRole: $role');
      } else {
        _showMessage('❌ Sai tài khoản hoặc mật khẩu');
      }
    } else {
      await authService.register(email, password);
      _showMessage('🎉 Đăng ký thành công!');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Đăng nhập' : 'Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Mật khẩu'), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: Text(isLogin ? 'Đăng nhập' : 'Đăng ký')),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
