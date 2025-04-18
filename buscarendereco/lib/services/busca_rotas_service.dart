import 'dart:convert';
import 'package:http/http.dart' as http;

class BuscaRotasService {
    static Future<List<dynamic>> buscarRotas(int paradaOrigem, int paradaDestino) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/rotas/?origem=$paradaOrigem&destino=$paradaDestino'));
      print('Requisição buscarRotas feita com status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Resposta da API buscarRotas: ${response.body}');
        return json.decode(response.body)['rota'];
      } else {
        print('Erro na requisição buscarRotas: ${response.body}');
        throw Exception('Falha ao buscar rota');
      }
    } catch (e) {
      print('Erro ao fazer requisição fetchRoutes: $e');
      throw Exception('Erro ao buscar rota');
    }
  }
}