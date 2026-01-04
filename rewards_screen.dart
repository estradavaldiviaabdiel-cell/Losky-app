import 'package:flutter/material.dart';
import '../services/api.dart';
import 'redeem_qr_screen.dart';

class RewardsScreen extends StatefulWidget {
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  List rewards = [];
  Map user = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) user = args as Map;
    _load();
  }

  void _load() async {
    final res = await Api.getRewards();
    setState(() {
      rewards = res['rewards'] ?? [];
    });
  }

  void _redeem(String rewardId) async {
    final res = await Api.redeem(rewardId, user['id']);
    if (res['redemption'] != null) {
      final redemption = res['redemption'];
      // qr_payload is stored as JSON string { payload, signature }
      final signed = redemption['qr_payload'];
      Navigator.pushNamed(context, '/redeem_qr', arguments: signed);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo redimir')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recompensas'),
      ),
      body: ListView.builder(
        itemCount: rewards.length,
        itemBuilder: (context, i) {
          final r = rewards[i];
          return ListTile(
            title: Text(r['title']),
            subtitle: Text('${r['description']} - stock: ${r['stock']}'),
            trailing: ElevatedButton(onPressed: () => _redeem(r['id']), child: Text('Redimir')),
          );
        },
      ),
    );
  }
}