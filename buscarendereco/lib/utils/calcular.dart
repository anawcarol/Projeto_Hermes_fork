import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:buscareferencia/models/paradas_model.dart';

class Calcular {
  // Encontra a parada mais próxima de uma localização específica (LatLng)
  static Stop acharParadaProxima(LatLng location, List<Stop> paradas) {
    Stop? paradaProxima;
    double minDistance = double.infinity;

    for (var parada in paradas) {
      final distancia = distanciaEntre(location, parada.point); // Calcula a distância
      if (distancia < minDistance) {
        minDistance = distancia;
        paradaProxima = parada;
      }
    }

    return paradaProxima!;
  }

  // Calcula a distância entre dois pontos LatLng usando a fórmula do haversine
  static double distanciaEntre(LatLng latLng1, LatLng latLng2) {
    final double radius = 6371; // Raio da Terra em km
    final double dLat = latLng2.latitudeInRad - latLng1.latitudeInRad;
    final double dLon = latLng2.longitudeInRad - latLng1.longitudeInRad;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(latLng1.latitudeInRad) *
            cos(latLng2.latitudeInRad) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distancia = radius * c;

    return distancia;
  }
}

// Extensão da classe LatLng para converter latitude e longitude em radianos
extension on LatLng {
  double get latitudeInRad => latitude * pi / 180;
  double get longitudeInRad => longitude * pi / 180;
}
