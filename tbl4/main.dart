import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'services/background_service.dart';
import 'services/notification_service.dart';
import 'views/ex1_lifecycle_page.dart';
import 'views/ex2_background_time_page.dart';
import 'views/ex3_workmanager_page.dart';
import 'views/ex4_push_page.dart';
import 'views/ex5_chat_page.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundService.initialize();

  try {
    await Firebase.initializeApp();
    await NotificationService.instance.initialize(navigatorKey);
  } catch (e) {
    debugPrint('Firebase não configurado: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Computação Móvel - Background',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = <(String, String, Widget)>[
      ('Exercício 1', 'Detectar e mostrar o lifecycle', const Ex1LifecyclePage()),
      ('Exercício 2', 'Salvar horário ao ir para background', const Ex2BackgroundTimePage()),
      ('Exercício 3', 'WorkManager com sincronização fake', const Ex3WorkManagerPage()),
      ('Exercício 4', 'Push notification abrindo tela específica', const Ex4PushPage()),
      ('Exercício 5', 'Chat atualizado em foreground', const Ex5ChatPage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Background e Lifecycle')),
      body: ListView(
        children: [
          for (final (titulo, sub, page) in itens)
            ListTile(
              title: Text(titulo),
              subtitle: Text(sub),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              ),
            ),
        ],
      ),
    );
  }
}
