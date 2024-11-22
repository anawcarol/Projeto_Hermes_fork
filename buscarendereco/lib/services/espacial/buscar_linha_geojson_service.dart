import 'dart:convert';
import 'package:http/http.dart' as http;

class BuscarLinhaGeojsonService {
    static Future<List<dynamic>> buscarLinhaGeoJson(String linha) async {
    final response = await http.get(Uri.parse('https://www.sistemas.dftrans.df.gov.br/percurso/linha/numero/$linha/WGS'));
    print('Requisição buscarLinhaGeoJson para linha $linha feita com status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Resposta da API buscarLinhaGeoJson para linha $linha');
      return json.decode(response.body)['features']; // Retorna a feature LineString
    } else {
      throw Exception('Falha ao buscar linha $linha');
    }
  }
}