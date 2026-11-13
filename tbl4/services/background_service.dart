import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const String nomeTarefaSync = 'sincronizarDados';
const String idTarefaSync = 'syncTask';
const String chaveUltimaSync = 'ultimaSincronizacao';
const String chaveContadorSync = 'contadorSincronizacoes';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Executando tarefa background: $task');

    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final contador = (prefs.getInt(chaveContadorSync) ?? 0) + 1;
    await prefs.setInt(chaveContadorSync, contador);
    await prefs.setString(chaveUltimaSync, DateTime.now().toIso8601String());

    debugPrint('Sincronização fake concluída (#$contador)');
    return Future.value(true);
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  static Future<void> registrarPeriodica() async {
    await Workmanager().registerPeriodicTask(
      idTarefaSync,
      nomeTarefaSync,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> registrarUnica() async {
    await Workmanager().registerOneOffTask(
      'syncTaskOneOff-${DateTime.now().millisecondsSinceEpoch}',
      nomeTarefaSync,
    );
  }

  static Future<void> cancelar() async {
    await Workmanager().cancelAll();
  }
}
