import 'package:json_annotation/json_annotation.dart';

// ⬇️ part directive - บอกว่าไฟล์นี้มีส่วนที่ generate
part 'pokemon.g.dart';

/// Pokemon Model ที่ใช้ json_serializable
/// Annotations จะบอก generator ว่าต้องสร้างอะไรบ้าง
@JsonSerializable()
class Pokemon {
  final String name;
  final String url;

  const Pokemon({
    required this.name,
    required this.url,
  });

  /// Getter สำหรับ ID
  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }

  /// Getter สำหรับ Image URL
  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  /// Factory constructor จาก JSON
  /// _$PokemonFromJson จะถูก generate ในไฟล์ .g.dart
  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);

  /// แปลงเป็น JSON
  /// _$PokemonToJson จะถูก generate ในไฟล์ .g.dart
  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  @override
  String toString() => 'Pokemon(name: $name, id: $id)';
}