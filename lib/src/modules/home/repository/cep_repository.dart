import 'dart:convert';
import 'package:http/http.dart' as http;

class CepRepository {
  final String baseUrl = 'https://viacep.com.br/ws';

  Future<Map<String, dynamic>?> fetchCep(String cep) async {
    final response = await http.get(Uri.parse('$baseUrl/$cep/json/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao carregar CEP: ${response.statusCode}');
    }
  }
}
