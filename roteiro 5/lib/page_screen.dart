import 'package:flutter/material.dart';
import 'storage_service.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final StorageService storage = StorageService();

  String selectedPage = 'Página A';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLastPage();
  }

  Future<void> loadLastPage() async {
    final page = await storage.loadLastPage();

    if (!mounted) return;

    setState(() {
      selectedPage = page;
      loading = false;
    });
  }

  Future<void> selectPage(String page) async {
    setState(() {
      selectedPage = page;
    });

    await storage.saveLastPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Última Página Acessada'),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Você está na $selectedPage',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () => selectPage('Página A'),
                      child: const Text('Página A'),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () => selectPage('Página B'),
                      child: const Text('Página B'),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () => selectPage('Página C'),
                      child: const Text('Página C'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}