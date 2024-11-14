  import 'package:flutter/material.dart';
import '../themes/tema_tela.dart';

// Classe que gerencia o tema do aplicativo
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode; // Define o tema inicial como o modo claro

  // Getter para acessar o tema atual
  ThemeData get themeData => _themeData;

  // Setter para atualizar o tema e notificar os ouvintes (widgets dependentes)
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notifica os ouvintes para atualizarem a interface
  }

  // Método para alternar entre o modo claro e escuro
  void toggleTheme() {
    // Verifica se o tema atual é o modo claro
    if (_themeData == lightMode) {
      themeData = darkMode; // Altera para o modo escuro
    } else {
      themeData = lightMode; // Caso contrário, altera para o modo claro
    }
  }
}