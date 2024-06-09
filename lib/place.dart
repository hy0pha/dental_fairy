import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class PlacePage extends StatefulWidget {
  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  late GooglePlace googlePlace;
  GoogleMapController? mapController;
  List<SearchResult> places = [];
  bool isLoading = false;
  Set<Marker> markers = {};
  Position? currentPosition;
  SearchResult? selectedPlace;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyCf1H9o_lkvDpiQyLIe5k3VnH24bWrsZuk");
    _checkPermissionAndFetchLocation();
  }

  Future<void> _checkPermissionAndFetchLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied.');
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
        markers.add(Marker(
          markerId: MarkerId('currentPosition'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        ));
      });
      _fetchNearbyDentists(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      return Future.error('Failed to get current location.');
    }
  }

  Future<void> _fetchNearbyDentists(double lat, double lng) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      var result = await googlePlace.search.getNearBySearch(
        Location(lat: lat, lng: lng),
        1500,
        type: "dentist",
      );

      if (result != null && result.results != null) {
        setState(() {
          places = result.results!;
          markers.addAll(places.take(30).map((place) => Marker(
            markerId: MarkerId(place.placeId ?? ''),
            position: LatLng(place.geometry!.location!.lat!, place.geometry!.location!.lng!),
            infoWindow: InfoWindow(title: place.name),
          )));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching places: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchMapsUrl(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _navigateToMapPage() {
    if (selectedPlace != null) {
      final lat = selectedPlace!.geometry!.location!.lat!;
      final lng = selectedPlace!.geometry!.location!.lng!;
      _launchMapsUrl(lat, lng);
    } else {
      print("No place selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff6eb1d9);

    return Scaffold(
      backgroundColor: Color(0xffe0f7fa), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xffe0f7fa), // 배경색 변경
        title: Text("근처 치과 찾기", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: isLoading
          ? Center(child: Text("Loading...", style: TextStyle(color: textColor)))
          : Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  title: Text(place.name ?? "No name available", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  subtitle: Text(place.vicinity ?? "No address available", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  onTap: () {
                    setState(() {
                      selectedPlace = place;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToMapPage,
            child: Text("지도 보기", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(textColor),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PlacePage(),
  ));
}
