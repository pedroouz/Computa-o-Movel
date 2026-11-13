import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifecycleService with WidgetsBindingObserver {
  LifecycleService._();
  static final LifecycleService instance = LifecycleService._();

  static const chaveUltimoBackground = 'ultimoBackground';

  final ValueNotifier<AppLifecycleState?> estado = ValueNotifier(null);

  final ValueNotifier<List<String>> historico = ValueNotifier([]);

  bool _iniciado = false;

  void start() {
    if (_iniciado) return;
    _iniciado = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    if (!_iniciado) return;
    _iniciado = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    estado.value = state;

    final hora = _formatar(DateTime.now());
    historico.value = ['$hora  →  ${descricao(state)}', ...historico.value];
    debugPrint('Lifecycle: ${descricao(state)}');

    if (state == AppLifecycleState.paused) {
      _salvarHorarioBackground();
    }
  }

  Future<void> _salvarHorarioBackground() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      chaveUltimoBackground,
      DateTime.now().toIso8601String(),
    );
  }

  Future<DateTime?> lerUltimoBackground() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getString(chaveUltimoBackground);
    return valor == null ? null : DateTime.tryParse(valor);
  }

  static String descricao(AppLifecycleState? s) {
    switch (s) {
      case AppLifecycleState.resumed:
        return 'App em foreground (resumed)';
      case AppLifecycleState.inactive:
        return 'App inativo (inactive)';
      case AppLifecycleState.paused:
        return 'App em background (paused)';
      case AppLifecycleState.detached:
        return 'App detached';
      case AppLifecycleState.hidden:
        return 'App hidden';
      case null:
        return 'Aplicativo iniciado';
    }
  }

  static String _formatar(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.hour)}:${dois(d.minute)}:${dois(d.second)}';
  }

  static String formatarCompleto(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year} ${_formatar(d)}';
  }
}
