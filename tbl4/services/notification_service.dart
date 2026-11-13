import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../views/pedido_page.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Push em background: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  late GlobalKey<NavigatorState> _navigatorKey;

  final ValueNotifier<String?> token = ValueNotifier(null);

  final StreamController<RemoteMessage> _foreground =
      StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get foregroundStream => _foreground.stream;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    token.value = await messaging.getToken();
    debugPrint('FCM token: ${token.value}');

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Push em foreground: ${message.notification?.title}');
      _foreground.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_abrirTela);

    final inicial = await messaging.getInitialMessage();
    if (inicial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _abrirTela(inicial));
    }
  }

  void _abrirTela(RemoteMessage message) {
    final pedidoId = message.data['pedidoId'] as String?;
    if (pedidoId == null) return;

    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => PedidoPage(pedidoId: pedidoId)),
    );
  }
}
