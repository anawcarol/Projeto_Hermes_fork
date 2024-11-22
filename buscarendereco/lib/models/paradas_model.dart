import 'package:latlong2/latlong.dart';

class Stop {
  final LatLng point;
  final int codDftrans;  // Definido como int

  Stop({required this.point, required this.codDftrans});

  // Construtor de fábrica para criar um objeto Stop a partir de JSON
  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      point: LatLng(json['geometry']['coordinates'][1], json['geometry']['coordinates'][0]),
      codDftrans: int.parse(json['properties']['codDftrans']),  // Converte de String para int
    );
  }
}
