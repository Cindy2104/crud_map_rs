import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/rumahsakit_model.dart';

class FullMapsScreen extends StatefulWidget {
  final RumahSakit rumahSakit;

  const FullMapsScreen({super.key, required this.rumahSakit});

  @override
  State<FullMapsScreen> createState() => _FullMapsScreenState();
}

class _FullMapsScreenState extends State<FullMapsScreen> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  MapType _mapType = MapType.normal;
  String? _styleMap;

  void _onMapTypeButtonPressed() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _loadMapStyle(String path) async {
    final style = await rootBundle.loadString(path);
    setState(() => _styleMap = style);
  }

  void _standardStyle() => setState(() => _styleMap = null);
  void _darkStyle() => _loadMapStyle('assets/style_map/style_dark.json');
  void _retroStyle() => _loadMapStyle('assets/style_map/style_retro.json');

  @override
  Widget build(BuildContext context) {
    final posisi = LatLng(
      widget.rumahSakit.latitude,
      widget.rumahSakit.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rumahSakit.nama,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: posisi, zoom: 15),
            markers: {
              Marker(
                markerId: MarkerId('rs-${widget.rumahSakit.id}'),
                position: posisi,
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 4, color: Colors.black26),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.rumahSakit.nama,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text("Tipe: ${widget.rumahSakit.tipe}"),
                          SizedBox(height: 4),
                          Text("Telp: ${widget.rumahSakit.noTelpon}"),
                        ],
                      ),
                    ),
                    posisi,
                  );
                },
              ),
            },
            onMapCreated: (controller) {
              _customInfoWindowController.googleMapController = controller;
              if (_styleMap != null) {
                controller.setMapStyle(_styleMap);
              }
            },
            onTap: (_) => _customInfoWindowController.hideInfoWindow!(),
            mapType: _mapType,
            style: _styleMap,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 130,
            width: 200,
            offset: 50,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    _mapType == MapType.normal
                        ? Icons.map
                        : Icons.satellite_alt,
                  ),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _standardStyle,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.wb_sunny),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _darkStyle,
                  backgroundColor: Colors.grey[850],
                  child: Icon(Icons.dark_mode, color: Colors.white),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _retroStyle,
                  backgroundColor: Colors.brown,
                  child: Icon(Icons.location_city, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
