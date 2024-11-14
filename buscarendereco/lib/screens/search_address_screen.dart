import 'package:flutter/material.dart';
import 'package:buscareferencia/services/api_service.dart';
import 'package:buscareferencia/models/address.dart';
import 'package:buscareferencia/screens/map_screen.dart';

class SearchAddressScreen extends StatefulWidget {
  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  void _searchAddress(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await ApiService.searchAddress(query);
      setState(() {
        _addresses = results.map((data) => Address.fromJson(data)).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar endereços. Tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: !isDesktop
            ? Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    color: const Color(0xFF375b8d),
                    tooltip: "Menu lateral",
                  );
                },
              )
            : null,
        title: Center(
          child: Image.asset(
            'assets/images/logomaiorDFnoponto.png',
            height: 65,
            semanticLabel: 'logo DF no Ponto',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Para onde vamos?',
                        hintStyle: const TextStyle(fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            width: 1.0,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (String value) {
                        _searchAddress(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF375b8d),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        _searchAddress(_controller.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : _addresses.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemCount: _addresses.length,
                            itemBuilder: (context, index) {
                              final address = _addresses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    address.displayName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                              destination: _addresses[index])),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Digite um endereço para começar a busca.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
