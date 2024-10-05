import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/http_service.dart';
import '../service/local_storage_service.dart';

class CepController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  final LocalStorageService _localStorageService = LocalStorageService();

  Map<String, dynamic>? address;
  bool loading = false;
  String? errorMessage;
  String? lastSearchedCep;

  Future<void> fetchCep(String cep) async {
    loading = true;
    notifyListeners();
    errorMessage = null;

    try {
      final data = await _httpService.fetchAddressByCep(cep);
      address = data;
      lastSearchedCep = cep;  
      await _localStorageService.saveHistory(data); 
    } catch (error) {
      errorMessage = 'Erro ao buscar CEP: ${error.toString()}';
      address = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<List<String>> getHistory() async {
    return await _localStorageService.getHistory();
  }

  Future<void> openMapsForLastAddress() async {
    if (lastSearchedCep != null && address != null) {
      String query = '${address!['logradouro']}, ${address!['bairro']}, ${address!['localidade']}, ${address!['uf']}';
      String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(query)}';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Erro ao abrir o mapa.';
      }
    } else {
      throw 'Nenhum endereço disponível encontrado.';
    }
  }
}
