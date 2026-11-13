import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/notification_service.dart';
import 'pedido_page.dart';


class Ex4PushPage extends StatelessWidget {
  const Ex4PushPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = NotificationService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Ex. 4 - Push + Deep link')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text('Token FCM deste dispositivo:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ValueListenableBuilder<String?>(
              valueListenable: service.token,
              builder: (context, token, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(token ??
                      'Indisponível (Firebase não configurado ou sem permissão)'),
                  if (token != null)
                    TextButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar token'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: token));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token copiado')),
                        );
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 32),
            const Text('Como testar', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              '1. No Firebase Console > Cloud Messaging, crie uma mensagem de teste.\n'
              '2. Cole o token acima como destinatário.\n'
              '3. Em "Dados personalizados", adicione a chave pedidoId com valor 123.\n'
              '4. Teste nos três cenários: app aberto, minimizado e fechado.\n'
              '5. Ao tocar na notificação, a tela do Pedido #123 deve abrir.',
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PedidoPage(pedidoId: '123')),
              ),
              child: const Text('Simular abertura do pedido #123'),
            ),
          ],
        ),
      ),
    );
  }
}
