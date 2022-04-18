import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocatUI extends StatefulWidget {
  const LocatUI({Key? key}) : super(key: key);

  @override
  State<LocatUI> createState() => _LocatUIState();
}

class _LocatUIState extends State<LocatUI> {
  int currentIndex = 2;
  //
  late LocationData currentPosition = LocationData.fromMap({});
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialcamerapoisition = LatLng(13.707376, 100.356107);

  late Marker marker;
  List<Marker> markers = <Marker>[];

  String myLocation = "no";
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print(
        "oncreate ${initialcamerapoisition.latitude} : ${initialcamerapoisition.longitude}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialcamerapoisition,
          zoom: 15,
        ),
      ),
    );
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leadingWidth: 0,
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/alertlogo.png',
                width: 85,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialcamerapoisition,
            zoom: 5,
          ),
          markers: Set<Marker>.of(markers),
          mapType: MapType.terrain,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLoc,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        tooltip: 'Me',
        autofocus: true,
        child: Icon(
          Icons.gps_fixed,
          color: Color.fromARGB(255, 86, 140, 255),
        ),
      ),
    );
  }

  setMarkers() {
    createMaker(context);
    markers.add(
      Marker(
        markerId: MarkerId('Home'),
        position: initialcamerapoisition,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: 'My Location',
          snippet: '${currentPosition.latitude} : ${currentPosition.longitude}',
        ),
      ),
    );
  }

  getLoc() async {
    myLocation = "yes";
    print('myLocation $myLocation');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    double? latitude = currentPosition.latitude;
    double? longitude = currentPosition.longitude;

    Location.instance.onLocationChanged.listen((LocationData currentLocation) {
      setState(() async {
        print(
            'Current Loc ${currentLocation.latitude} : ${currentLocation.longitude}');
        initialcamerapoisition = LatLng(latitude!, longitude!);
        mapController
            .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        setMarkers();
        return;
      });
    });
  }

  createMaker(context) {
    if (myLocation == "yes") {
      customIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      customIcon = BitmapDescriptor.defaultMarker;
    }
  }
}
