import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  Future<Map<String, dynamic>> fetchAddressByCep(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar o CEP');
    }
  }
}
