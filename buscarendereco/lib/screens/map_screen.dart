import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:buscareferencia/services/geolocator_service.dart';
import 'package:buscareferencia/models/marker.dart';
import 'package:buscareferencia/utils/helpers.dart';
import 'package:buscareferencia/models/stop.dart';
import 'package:buscareferencia/models/address.dart';

import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  final Address destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _userLocation = LatLng(0, 0);
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  Stop? _nearestStartStop;
  Stop? _nearestEndStop;
  List<dynamic> _routes = [];
  final MarkerService _markerService = MarkerService();

  @override
  void initState() {
    super.initState();
    _setUserLocation();
  }

  void _setUserLocation() async {
    _userLocation = await GeolocatorService.getCurrentLocation();
    _setNearestStops();
  }

  void _setNearestStops() async {
    try {
      final stops = await StopService.fetchStops();
      final destination = widget.destination;

      final nearestStartStop = Helpers.findNearestStop(_userLocation, stops);
      final nearestEndStop = Helpers.findNearestStop(LatLng(destination.lat, destination.lon), stops);

      setState(() {
        _nearestStartStop = nearestStartStop;
        _nearestEndStop = nearestEndStop;
      });

      if (_nearestStartStop != null && _nearestEndStop != null) {
        await _fetchRoutes(_nearestStartStop!.codDftrans, _nearestEndStop!.codDftrans);
      }
    } catch (e) {
      print('Erro ao definir as paradas mais próximas: $e');
    }
  }

  Future<void> _fetchRoutes(int paradaOrigem, int paradaDestino) async {
    try {
      final routes = await ApiService.fetchRoutes(paradaOrigem, paradaDestino);
      setState(() {
        _routes = routes;
      });

      for (var i = 0; i < routes.length; i++) {
        String linha = routes[i]['linha'];
        await _fetchLineGeoJson(linha, i);
      }

      List<int> codDftransList = [paradaOrigem, paradaDestino];
      if (routes.length > 1) {
        codDftransList.insert(1, routes[0]['parada_destino']);
      }
      await _fetchStops(codDftransList);
    } catch (e) {
      print('Erro ao buscar rotas: $e');
    }
  }

  Future<void> _fetchLineGeoJson(String linha, int index) async {
    try {
      final lineDetails = await ApiService.fetchLineGeoJson(linha);
      for (var feature in lineDetails) {
        if (feature['geometry']['type'] == 'LineString') {
          final coords = feature['geometry']['coordinates'];
          final polylinePoints = coords.map<LatLng>((point) => LatLng(point[1], point[0])).toList();

          setState(() {
            _polylines.add(Polyline(
              points: polylinePoints,
              strokeWidth: 4.0,
              color: _getLineColor(index),
            ));
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar LineString para a linha $linha: $e');
    }
  }

  Future<void> _fetchStops(List<int> codDftransList) async {
    try {
      setState(() {
        _markers.clear();
      });

      final stopDetails = await ApiService.fetchStops(codDftransList);
      final newMarkers = stopDetails.map((feature) {
        final coords = feature['geometry']['coordinates'];
        final stopLatLng = LatLng(coords[1], coords[0]);

        return Marker(
          width: 80.0,
          height: 80.0,
          point: stopLatLng,
          builder: (ctx) => Icon(
            Icons.directions_bus,
            color: Colors.orange,
            size: 40.0,
          ),
        );
      }).toList();

      setState(() {
        _markers = newMarkers;
      });
    } catch (e) {
      print('Erro ao buscar detalhes das paradas: $e');
    }
  }

  Color _getLineColor(int index) {
    if (index == 0) {
      return Colors.red;
    } else if (index == 1) {
      return Colors.green;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roteiro de viagem'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-15.78869450034934, -47.88936481492598),
              zoom: 14.0,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _markers,
              ),
              PolylineLayer(
                polylines: _polylines,
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.4,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _routes.length,
                  itemBuilder: (context, index) {
                    final route = _routes[index];
                    return ListTile(
                      leading: Icon(Icons.directions_bus, color: _getLineColor(index)),
                      title: Text(
                        'Linha: ${route['linha']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Parada de Origem: ${route['parada_origem']}\n'
                        'Parada de Destino: ${route['parada_destino']}',
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
