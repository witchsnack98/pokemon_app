import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  /// ดึงรายการ Pokemon
  Future<List<Pokemon>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // ใช้ fromJson ที่ generate มา
        return results.map((json) => Pokemon.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Pokemon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Pokemon: $e');
    }
  }

  /// ดึงข้อมูลละเอียดของ Pokemon
  Future<PokemonDetail> getPokemonDetail(int id) async {
    try {
      final url = Uri.parse('$baseUrl/pokemon/$id');
      print('🌐 Fetching detail: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ใช้ fromJson ที่ generate มา - จัดการ nested objects ให้หมด!
        return PokemonDetail.fromJson(data);
      } else {
        throw Exception('Failed to load Pokemon detail: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Failed to load Pokemon detail: $e');
    }
  }
}