/// Pokemon Model Class
/// ใช้เก็บข้อมูล Pokemon ที่ได้จาก API
class Pokemon {
  final String name;
  final String url;

  // Constructor
  Pokemon({
    required this.name,
    required this.url,
  });

  /// ดึง ID จาก URL
  /// URL มีรูปแบบ: https://pokeapi.co/api/v2/pokemon/1/
  /// เราต้องดึงเลข 1 ออกมา
  int get id {
    // แยก URL ด้วย / แล้วเอาตัวเลขก่อนสุดท้าย
    final parts = url.split('/');
    // parts จะเป็น ['https:', '', 'pokeapi.co', 'api', 'v2', 'pokemon', '1', '']
    // เราต้องการ index ที่ -2 (ตัวก่อนสุดท้าย)
    return int.parse(parts[parts.length - 2]);
  }

  /// สร้าง URL รูปภาพ Pokemon
  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  /// Factory constructor สำหรับสร้าง Pokemon จาก JSON
  /// JSON ที่ได้จาก API มีหน้าตาแบบนี้:
  /// {
  ///   "name": "bulbasaur",
  ///   "url": "https://pokeapi.co/api/v2/pokemon/1/"
  /// }
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// แปลง Pokemon กลับเป็น JSON (ไว้ใช้ในอนาคต)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'Pokemon(name: $name, id: $id)';
  }
}