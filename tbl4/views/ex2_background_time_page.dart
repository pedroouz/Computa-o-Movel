import 'package:flutter/material.dart';

import '../services/lifecycle_service.dart';


class Ex2BackgroundTimePage extends StatefulWidget {
  const Ex2BackgroundTimePage({super.key});

  @override
  State<Ex2BackgroundTimePage> createState() => _Ex2BackgroundTimePageState();
}

class _Ex2BackgroundTimePageState extends State<Ex2BackgroundTimePage>
    with WidgetsBindingObserver {
  DateTime? _ultimo;

  @override
  void initState() {
    super.initState();
    LifecycleService.instance.start();
    WidgetsBinding.instance.addObserver(this);
    _carregar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _carregar() async {
    final valor = await LifecycleService.instance.lerUltimoBackground();
    if (mounted) setState(() => _ultimo = valor);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 300), _carregar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex. 2 - Último background')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.nightlight_round, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Último horário em que o app foi para background:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _ultimo == null
                    ? 'Ainda não foi para background'
                    : LifecycleService.formatarCompleto(_ultimo!),
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'O valor fica salvo em SharedPreferences, então '
                'sobrevive mesmo se o Android matar o processo.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
