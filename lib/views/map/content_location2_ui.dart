// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// const MAPBOX_ACCESS_TOKEN =
//     'pk.eyJ1IjoiY2hpcmF0aGVwNjE5IiwiYSI6ImNsMW40M2lodzA3Z3UzYm05ODlpc3ZxMWgifQ.pSoFfrMgE4b3v1PI8nnejw';
// const MAPBOX_STYLE = 'mapbox/dark-v10';
// const MARKER_COLOR = Color(0xff3dc5a7);
// final _myLocation = LatLng(13.7248936, 100.4930243);

// class Locat2UI extends StatefulWidget {
//   const Locat2UI({Key? key}) : super(key: key);

//   @override
//   State<Locat2UI> createState() => _Locat2UIState();
// }

// class _Locat2UIState extends State<Locat2UI> {
//   int currentIndex = 2;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Amimated Markers'),
//         actions: [
//           IconButton(
//             icon: Icon(FontAwesomeIcons.filter),
//             onPressed: () => null,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               minZoom: 5,
//               maxZoom: 15,
//               zoom: 13,
//               // center: _myLocation,
//             ),
//             nonRotatedLayers: [
//               TileLayerOptions(
//                 urlTemplate:
//                     'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
//                 additionalOptions: {
//                   'accessToken': MAPBOX_ACCESS_TOKEN,
//                   'id': MAPBOX_STYLE,
//                 },
//               ),
//               MarkerLayerOptions(),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class _MyLocationMarker extends StatelessWidget {
//   const _MyLocationMarker({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       width: 50,
//       decoration: BoxDecoration(
//         color: MARKER_COLOR,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
