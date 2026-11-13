import 'package:flutter/material.dart';

import '../services/lifecycle_service.dart';

class Ex1LifecyclePage extends StatefulWidget {
  const Ex1LifecyclePage({super.key});

  @override
  State<Ex1LifecyclePage> createState() => _Ex1LifecyclePageState();
}

class _Ex1LifecyclePageState extends State<Ex1LifecyclePage> {
  final _service = LifecycleService.instance;

  @override
  void initState() {
    super.initState();
    _service.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex. 1 - Lifecycle')),
      body: Column(
        children: [
          const SizedBox(height: 32),
          ValueListenableBuilder<AppLifecycleState?>(
            valueListenable: _service.estado,
            builder: (_, estado, __) => Text(
              LifecycleService.descricao(estado),
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Minimize o app e volte para ver as transições.'),
          const Divider(height: 32),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _service.historico,
              builder: (_, lista, __) => ListView.builder(
                itemCount: lista.length,
                itemBuilder: (_, i) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 18),
                  title: Text(lista[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
