import 'package:flutter/material.dart';

class PedidoPage extends StatelessWidget {
  final String pedidoId;

  const PedidoPage({super.key, required this.pedidoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedido #$pedidoId')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delivery_dining, size: 80),
            const SizedBox(height: 16),
            Text('Pedido #$pedidoId',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('Status: Saiu para entrega'),
          ],
        ),
      ),
    );
  }
}
