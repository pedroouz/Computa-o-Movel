import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class Mensagem {
  final String texto;
  final bool minha;
  final DateTime hora;
  Mensagem(this.texto, {required this.minha, DateTime? hora})
      : hora = hora ?? DateTime.now();
}


class Ex5ChatPage extends StatefulWidget {
  const Ex5ChatPage({super.key});

  @override
  State<Ex5ChatPage> createState() => _Ex5ChatPageState();
}

class _Ex5ChatPageState extends State<Ex5ChatPage> {
  final List<Mensagem> _mensagens = [
    Mensagem('Olá! Sou o suporte. Como posso ajudar?', minha: false),
  ];
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  StreamSubscription<RemoteMessage>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = NotificationService.instance.foregroundStream.listen((msg) {
      final texto = msg.data['texto'] as String? ??
          msg.notification?.body ??
          'Nova mensagem';
      _adicionar(Mensagem(texto, minha: false));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _adicionar(Mensagem m) {
    if (!mounted) return;
    setState(() => _mensagens.add(m));
    // Rola para a última mensagem após o frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _enviar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    _controller.clear();
    _adicionar(Mensagem(texto, minha: true));
    // Resposta simulada, para testar sem servidor.
    Future.delayed(const Duration(seconds: 1), () {
      _adicionar(Mensagem('Recebi: "$texto"', minha: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ex. 5 - Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: _mensagens.length,
              itemBuilder: (_, i) {
                final m = _mensagens[i];
                return Align(
                  alignment:
                      m.minha ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: m.minha
                          ? cores.primaryContainer
                          : cores.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(m.texto),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _enviar(),
                      decoration: const InputDecoration(
                        hintText: 'Digite uma mensagem',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _enviar,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
