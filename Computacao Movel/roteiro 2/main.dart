// EX 004
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ProdutoPage(),
  ));
}

class ProdutoPage extends StatelessWidget {
  const ProdutoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Notebook Dell',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Notebook com processador Intel Core i5, '
                    '8 GB de RAM e SSD de 512 GB.',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'R\$ 3.499,00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Image.network(
                'https://picsum.photos/300',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
