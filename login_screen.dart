import 'package:flutter/material.dart';
import '../services/api.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  void _register() async {
    final res = await Api.register(_nameCtrl.text, _emailCtrl.text, _phoneCtrl.text);
    if (res['user'] != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: res['user']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro falló')));
    }
  }

  void _login() async {
    final res = await Api.login(_emailCtrl.text);
    if (res['user'] != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: res['user']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login falló')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Losky Factory - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _phoneCtrl, decoration: InputDecoration(labelText: 'Teléfono')),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(onPressed: _register, child: Text('Registrarme')),
                SizedBox(width: 8),
                OutlinedButton(onPressed: _login, child: Text('Entrar')),
              ],
            )
          ],
        ),
      ),
    );
  }
}