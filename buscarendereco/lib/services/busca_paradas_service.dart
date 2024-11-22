import 'dart:convert';
import 'package:http/http.dart' as http;

class BuscaParadasService {
    static Future<List<dynamic>> buscarParadas(List<int> codDftransList) async {
    try {
      final codDftransParams = codDftransList.map((e) => "codDftrans=$e").join('&');
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/paradas/geo/?$codDftransParams'));
      print('Requisição fetchbuscarParadasStops feita com status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Resposta da API buscarParadas: ${response.body}');
        return json.decode(response.body)['features'];
      } else {
        print('Erro na requisição buscarParadas: ${response.body}');
        throw Exception('Falha ao buscar detalhes de paradas');
      }
    } catch (e) {
      print('Erro ao fazer requisição buscarParadas: $e');
      throw Exception('Erro ao buscar paradas');
    }
  }
}