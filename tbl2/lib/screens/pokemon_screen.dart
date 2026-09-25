import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();

  final PokemonService _pokemonService = PokemonService();

  Pokemon? pokemon;

  bool isLoading = false;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Exercício 7:
    // Carrega automaticamente o Pokémon 1 ao abrir a tela.
    searchPokemon('1');
  }

  // Busca um Pokémon pelo nome ou número
  Future<void> searchPokemon(String term) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await _pokemonService.fetchPokemon(term);

      setState(() {
        pokemon = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        pokemon = null;
        isLoading = false;
        errorMessage = 'Pokémon não encontrado.';
      });
    }
  }

  // Toca o som do Pokémon
  Future<void> playCry() async {
    if (pokemon != null && pokemon!.cryUrl.isNotEmpty) {
      await _audioPlayer.stop();

      await _audioPlayer.play(
        UrlSource(pokemon!.cryUrl),
      );
    }
  }

  // Deixa a primeira letra do nome maiúscula
  String formatName(String name) {
    if (name.isEmpty) {
      return '';
    }

    return name[0].toUpperCase() + name.substring(1);
  }

  // Pokémon anterior
  void previousPokemon() {
    if (pokemon == null) {
      return;
    }

    if (pokemon!.id > 1) {
      searchPokemon(
        (pokemon!.id - 1).toString(),
      );
    }
  }

  // Próximo Pokémon
  void nextPokemon() {
    if (pokemon == null) {
      return;
    }

    searchPokemon(
      (pokemon!.id + 1).toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Flutter'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ==========================================
            // CAMPO DE BUSCA
            // ==========================================

            TextField(
              controller: _controller,

              decoration: const InputDecoration(
                labelText: 'Nome ou número do Pokémon',
                hintText: 'Ex: pikachu ou 25',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // ==========================================
            // BOTÃO BUSCAR
            // ==========================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    searchPokemon(
                      _controller.text.trim(),
                    );
                  }
                },

                child: const Text('Buscar'),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================
            // CARREGANDO
            // ==========================================

            if (isLoading)
              const CircularProgressIndicator(),

            // ==========================================
            // ERRO
            // ==========================================

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),

                child: Text(
                  errorMessage,

                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),

            // ==========================================
            // POKÉMON
            // ==========================================

            if (!isLoading && pokemon != null)

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    // ==================================
                    // NOME
                    // ==================================

                    Text(
                      formatName(
                        pokemon!.name,
                      ),

                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==================================
                    // NÚMERO
                    // ==================================

                    Text(
                      '#${pokemon!.id}',

                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================
                    // IMAGEM
                    // ==================================

                    if (pokemon!.imageUrl.isNotEmpty)

                      Image.network(
                        pokemon!.imageUrl,

                        height: 220,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Text(
                            'Erro ao carregar imagem.',
                          );
                        },
                      ),

                    const SizedBox(height: 15),

                    // ==================================
                    // BOTÃO DE SOM
                    // ==================================

                    ElevatedButton.icon(
                      onPressed: playCry,

                      icon: const Icon(
                        Icons.volume_up,
                      ),

                      label: const Text(
                        'Tocar som',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================
                    // ANTERIOR / PRÓXIMO
                    // ==================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,

                      children: [

                        ElevatedButton(
                          onPressed:
                              pokemon!.id > 1
                                  ? previousPokemon
                                  : null,

                          child: const Text(
                            'Anterior',
                          ),
                        ),

                        ElevatedButton(
                          onPressed: nextPokemon,

                          child: const Text(
                            'Próximo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}