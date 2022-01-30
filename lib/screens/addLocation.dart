import 'package:clinique_doctor/screens/info.dart';
import 'package:clinique_doctor/model/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

LatLng? _center;
LatLng? newLocation;

class AddLocation extends StatefulWidget {
  final ModelDoctorInfo model;
  final File file;

  const AddLocation({Key? key, required this.model, required this.file})
      : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  late GoogleMapController _myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition _cameraPosition;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _myController = controller;

    await _determinePosition();

    _myController.animateCamera(
      CameraUpdate.newLatLngZoom(_center!, 13),
    );
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _center!, zoom: 17.0);

      newLocation = _center;
      markers[MarkerId('id-1')] = Marker(
        position: _center!,
        markerId: MarkerId('id-1'),
        draggable: true,
        onDragEnd: (newPosition) {
          newLocation = newPosition;
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      initialCameraPosition: _cameraPosition == null
                          ? CameraPosition(
                              target: LatLng(20.5937, 78.9629), zoom: 13)
                          : _cameraPosition,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: () async {
                            print("tapped");
                            _determinePosition();
                            _myController.animateCamera(
                                CameraUpdate.newLatLngZoom(_center!, 13));
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.map, size: 30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF8A1818),
                      textStyle: const TextStyle(fontSize: 18),
                      elevation: 2,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Information(
                                newLocation!, widget.model, widget.file)));
                  },
                  child: Text(
                    'ADD LOCATION',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
