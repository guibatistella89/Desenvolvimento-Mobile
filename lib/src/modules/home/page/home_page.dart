import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/cep_controller.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cepController = Provider.of<CepController>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, 
        title: Center( 
          child: Text(
            'Fast Location',
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              color: Colors.white, 
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5), 
                  offset: Offset(2.0, 2.0), 
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'Digite o CEP de destino',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) async {
                await cepController.fetchCep(value);
              },
            ),
            SizedBox(height: 16),
            if (cepController.address != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logradouro: ${cepController.address!['logradouro']}', style: TextStyle(fontSize: 16)),
                  Text('Bairro: ${cepController.address!['bairro']}', style: TextStyle(fontSize: 16)),
                  Text('Cidade: ${cepController.address!['localidade']}', style: TextStyle(fontSize: 16)),
                  Text('Estado: ${cepController.address!['uf']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                ],
              ),
            _buildElevatedButton(context, 'Buscar Endereço', () async {
              String cep = _cepController.text;
              await cepController.fetchCep(cep);
            }),
            SizedBox(height: 16),
            _buildElevatedButton(context, 'Histórico de Pesquisa', () async {
              _showHistoryDialog(context);
            }),
            SizedBox(height: 16),
            _buildElevatedButton(context, 'Rota', () async {
              await cepController.openMapsForLastAddress(); 
            }),
            SizedBox(height: 16),
            if (cepController.loading) 
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            if (cepController.errorMessage != null)
              Text(cepController.errorMessage!, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildElevatedButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  void _showHistoryDialog(BuildContext context) async {
    final cepController = Provider.of<CepController>(context, listen: false);
    List<String> history = await cepController.getHistory();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('CEPs Pesquisados'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(history[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Voltar'),
            ),
          ],
        );
      },
    );
  }
}
