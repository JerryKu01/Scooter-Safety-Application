import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:scooter_safety_application/components/GpsData.dart";
import "package:scooter_safety_application/components/GpsDataService.dart";
import "package:scooter_safety_application/main.dart";

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GpsDataService _gpsDataService = GpsDataService();
  final MapController _mapController = MapController();
  bool _mapInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Tracker')),
      body: StreamBuilder<GpsData>(
        stream: _gpsDataService.getCurrentLocationStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final gpsData = snapshot.data!;

            // Update the map's center when new data comes in
            if (_mapInitialized) {
              _mapController.move(
                LatLng(gpsData.latitude, gpsData.longitude),
                _mapController.camera.zoom,
              );
            }

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(gpsData.latitude, gpsData.longitude),
                initialZoom: 15.0,
                onMapReady: () {
                  setState(() {
                    _mapInitialized = true;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(gpsData.latitude, gpsData.longitude),
                      width: 80.0,
                      height: 80.0,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
