import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class MapPage extends StatelessWidget {
  final SearchResult place;

  MapPage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name ?? "Map"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(place.geometry!.location!.lat!, place.geometry!.location!.lng!),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId(place.placeId ?? ''),
            position: LatLng(place.geometry!.location!.lat!, place.geometry!.location!.lng!),
            infoWindow: InfoWindow(title: place.name),
          ),
        },
      ),
    );
  }
}
