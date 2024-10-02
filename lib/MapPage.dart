import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:scooter_safety_application/components/GpsData.dart";
import "package:scooter_safety_application/components/GpsDataService.dart";
import "package:scooter_safety_application/main.dart";

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GpsDataService _gpsDataService = GpsDataService();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS Tracker"),
        backgroundColor: MyApp.primaryColor,
      ),
      body: StreamBuilder<GpsData>(
        stream: _gpsDataService.getGpsData(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final gpsData = snapshot.data!;
            _mapController.move(
            LatLng(gpsData.latitude, gpsData.longitude),
            _mapController.camera.zoom
            );

            return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(gpsData.latitude, gpsData.longitude),
                  initialZoom: _mapController.camera.zoom
                ),
                children: [
                  TileLayer(
                    urlTemplate:  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                      markers: [
                        Marker(point: LatLng(gpsData.latitude, gpsData.longitude),
                            width: 80,
                            height: 80,
                            child: Icon(Icons.location_pin,)
                        )
                      ])
                ]);
          }
          else if(snapshot.hasError){
            return Center(child: Text("There is error in the data!!"),);
          }
          return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}
