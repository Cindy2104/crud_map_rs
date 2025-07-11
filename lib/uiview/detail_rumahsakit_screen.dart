import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/rumahsakit_model.dart';
import 'full_maps_screen.dart';

class DetailRumahSakitScreen extends StatelessWidget {
  final RumahSakit rumahSakit;

  const DetailRumahSakitScreen({super.key, required this.rumahSakit});

  Widget buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng posisi = LatLng(rumahSakit.latitude, rumahSakit.longitude);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text(
          "Detail Rumah Sakit",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.local_hospital, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Informasi Rumah Sakit",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 25),
                    buildDetailRow(
                      'Nama',
                      rumahSakit.nama,
                      Icons.local_hospital,
                      Colors.pink,
                    ),
                    Divider(),
                    buildDetailRow(
                      'Alamat',
                      rumahSakit.alamat,
                      Icons.location_on,
                      Colors.orange,
                    ),
                    Divider(),
                    buildDetailRow(
                      'No Telpon',
                      rumahSakit.noTelpon,
                      Icons.phone,
                      Colors.teal,
                    ),
                    Divider(),
                    buildDetailRow(
                      'Tipe',
                      rumahSakit.tipe,
                      Icons.category,
                      Colors.indigo,
                    ),
                    Divider(),
                    buildDetailRow(
                      'Latitude',
                      rumahSakit.latitude.toString(),
                      Icons.map,
                      Colors.green,
                    ),
                    buildDetailRow(
                      'Longitude',
                      rumahSakit.longitude.toString(),
                      Icons.map_outlined,
                      Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullMapsScreen(rumahSakit: rumahSakit),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: posisi,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('rs-${rumahSakit.id}'),
                            position: posisi,
                            infoWindow: InfoWindow(title: rumahSakit.nama),
                          ),
                        },
                        zoomControlsEnabled: false,
                        onTap: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FullMapsScreen(rumahSakit: rumahSakit),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Text(
                            "Lihat di Maps",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
