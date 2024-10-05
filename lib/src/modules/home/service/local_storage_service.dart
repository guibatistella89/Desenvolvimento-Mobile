import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _historyKey = 'cep_history';

  Future<void> saveHistory(Map<String, dynamic> address) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getHistory();

    String addressString = '${address['cep']}, ${address['logradouro']}, ${address['bairro']}, ${address['localidade']}, ${address['uf']}';
    if (!history.contains(addressString)) {
      history.add(addressString);
      await prefs.setStringList(_historyKey, history);
    }
  }

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }
}
