import 'package:flutter/material.dart';
import '../models/pokemon_freezed.dart';
import '../models/pokemon_state.dart';
import '../services/pokemon_service.dart';

class PokemonFreezedScreen extends StatefulWidget {
  const PokemonFreezedScreen({super.key});

  @override
  State<PokemonFreezedScreen> createState() => _PokemonFreezedScreenState();
}

class _PokemonFreezedScreenState extends State<PokemonFreezedScreen> {
  final PokemonService _service = PokemonService();

  // ใช้ Union Type เก็บ state
  PokemonState _state = const PokemonState.initial();

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    // เปลี่ยนเป็น loading
    setState(() {
      _state = const PokemonState.loading();
    });

    try {
      final list = await _service.getPokemonList(limit: 100);

      // แปลงเป็น PokemonFreezed
      final freezedList = list
          .map((p) => PokemonFreezed(name: p.name, url: p.url))
          .toList();

      // เปลี่ยนเป็น success
      setState(() {
        _state = PokemonState.success(pokemonList: freezedList);
      });
    } catch (e) {
      // เปลี่ยนเป็น error
      setState(() {
        _state = PokemonState.error(message: e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❄️ Freezed Pokemon'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPokemon,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // ⬇️ ใช้ when เพื่อ handle ทุก case
    return _state.when(
      initial: () => const Center(
        child: Text('กดปุ่ม refresh เพื่อโหลด'),
      ),

      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.cyan),
            SizedBox(height: 16),
            Text('กำลังโหลด...'),
          ],
        ),
      ),

      success: (pokemonList) => RefreshIndicator(
        onRefresh: _loadPokemon,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];
            return _buildPokemonCard(pokemon);
          },
        ),
      ),

      error: (message) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('เกิดข้อผิดพลาด'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPokemon,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(PokemonFreezed pokemon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            pokemon.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon),
          ),
        ),
        title: Text(
          pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('#${pokemon.id.toString().padLeft(3, '0')}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}