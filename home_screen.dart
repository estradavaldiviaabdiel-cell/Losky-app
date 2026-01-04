import 'package:flutter/material.dart';
import '../services/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map user = {};
  int balance = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      user = args as Map;
      // balance isn't returned on login in this simplified flow; could fetch separately
    }
  }

  void _openRewards() {
    Navigator.pushNamed(context, '/rewards', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Losky Factory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Color(0xFFE6F7EA),
              child: ListTile(
                title: Text(user['name'] ?? 'Usuario'),
                subtitle: Text('Balance: $balance beneficios'),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _openRewards, child: Text('Ver recompensas'))
          ],
        ),
      ),
    );
  }
}