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
  bool gpsicon = false;
  //
  late LocationData currentPosition = LocationData.fromMap({});
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialcamerapoisition = LatLng(13.707376, 100.356107);

  late Marker marker;
  List<Marker> markers = <Marker>[
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'ปทุมธานี',
        snippet: 'ปทุมธานีก่อนเข้าตัวเมืองถนนพัง ควรหลีกเลี่ยงเส้นทาง',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(14.0208383, 100.5250267),
    ),
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'ราชบุรี',
        snippet: 'อุบัติเหตุรถกระบะเสียหลักชนก่อนถึงตลาด บ้านโป่ง',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(13.8110767, 99.87524),
    ),
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'กรุงเทพมหานคร',
        snippet: 'มีอุบัติเหตุชนรถมอเตอร์ไซต์บาดเจ็บหนัก',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(13.75633, 100.501765),
    ),
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'ชัยนาท',
        snippet: 'จักรยานยนต์เสียหลัก',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(15.1851967, 100.1251233),
    ),
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'สกลนคร',
        snippet: 'ต้นไม้ยาวกว่า 20 เมตรล้มทับถนนเข้าเมืองสกลฯ',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(17.1545983, 104.134835),
    ),
    Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      infoWindow: InfoWindow(
        title: 'สมุทรสาคร',
        snippet: 'มีด่านก่อนแยกกระทุ่มแบน',
      ),
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(13.6544783, 100.2492783),
    ),
    //------------//
    // Marker(
    //   markerId: MarkerId('myMarker'),
    //   draggable: true,
    //   infoWindow: InfoWindow(
    //     title: 'กรุงเทพมหานคร',
    //     snippet: 'test',
    //   ),
    //   onTap: () {
    //     print('Marker Tapped');
    //   },
    //   position: LatLng(13.75633, 100.501765),
    // ),
    //------------//
  ];

  //populateClients

  String myLocation = "no";
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print(
        "oncreate ${initialcamerapoisition.latitude} : ${initialcamerapoisition.longitude}");
    print(
        "oncreate ${initialcamerapoisition.latitude} : ${initialcamerapoisition.longitude}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialcamerapoisition,
          zoom: 7,
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
        elevation: 1,
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
          mapType: MapType.normal,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getLoc();
          gpsicon = true;
        },
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        tooltip: 'Me',
        autofocus: true,
        child: gpsicon
            ? Icon(
                Icons.gps_fixed,
                color: Color.fromARGB(255, 86, 140, 255),
              )
            : Icon(
                Icons.gps_not_fixed,
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
      setState(() {
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
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    } else {
      customIcon = BitmapDescriptor.defaultMarker;
    }
  }
}
