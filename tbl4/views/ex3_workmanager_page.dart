import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/background_service.dart';
import '../services/lifecycle_service.dart';

class Ex3WorkManagerPage extends StatefulWidget {
  const Ex3WorkManagerPage({super.key});

  @override
  State<Ex3WorkManagerPage> createState() => _Ex3WorkManagerPageState();
}

class _Ex3WorkManagerPageState extends State<Ex3WorkManagerPage>
    with WidgetsBindingObserver {
  DateTime? _ultima;
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carregar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); 
    final iso = prefs.getString(chaveUltimaSync);
    if (!mounted) return;
    setState(() {
      _ultima = iso == null ? null : DateTime.tryParse(iso);
      _contador = prefs.getInt(chaveContadorSync) ?? 0;
    });
  }

  void _msg(String texto) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(texto)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex. 3 - WorkManager')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Sincronizações executadas: $_contador',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(_ultima == null
                ? 'Última sincronização: nunca'
                : 'Última sincronização: '
                    '${LifecycleService.formatarCompleto(_ultima!)}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                await BackgroundService.registrarPeriodica();
                _msg('Tarefa periódica registrada (a cada 15 min)');
              },
              child: const Text('Registrar tarefa periódica (15 min)'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () async {
                await BackgroundService.registrarUnica();
                _msg('Tarefa única registrada. Minimize o app e aguarde.');
              },
              child: const Text('Executar uma vez agora (teste)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                await BackgroundService.cancelar();
                _msg('Tarefas canceladas');
              },
              child: const Text('Cancelar tarefas'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _carregar,
              child: const Text('Atualizar dados da tela'),
            ),
            const Spacer(),
            const Text(
              'Obs.: o Android decide o momento exato da execução '
              '(Doze, otimização de bateria). O intervalo mínimo é 15 min.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
