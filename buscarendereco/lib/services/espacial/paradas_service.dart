import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:buscareferencia/models/paradas_model.dart';

class paradasService {
  static const String _url = 'https://www.sistemas.dftrans.df.gov.br/parada/geo/paradas/wgs';

  static Future<List<Stop>> buscarParadas() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List).map((feature) {
        return Stop.fromJson(feature);
      }).toList();
    } else {
      throw Exception('Falha para carregar as paradas');
    }
  }
}
