import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/rumahsakit_model.dart';
import 'detail_rumahsakit_screen.dart';
import 'edit_rumahsakit_screen.dart';
import 'tambah_rumahsakit_screen.dart';

class ListRumahSakitScreen extends StatefulWidget {
  @override
  _ListRumahSakitScreenState createState() => _ListRumahSakitScreenState();
}

class _ListRumahSakitScreenState extends State<ListRumahSakitScreen> {
  List<RumahSakit> listRS = [];

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.228:8000/api/rumahsakit'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        listRS = data.map((json) => RumahSakit.fromJson(json)).toList();
      });
    }
  }

  Future<void> deleteData(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.43.228:8000/api/rumahsakit/$id'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Data berhasil dihapus")));
      fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Rumah Sakit",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body:
          listRS.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listRS.length,
                        itemBuilder: (context, index) {
                          final rs = listRS[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Icon(
                                  Icons.local_hospital,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                rs.nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(rs.noTelpon),
                              trailing: Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditRumahSakitScreen(
                                                rumahSakit: rs,
                                              ),
                                        ),
                                      );
                                      if (result == true) fetchData();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text('Konfirmasi'),
                                              content: Text(
                                                'Anda yakin ingin menghapus data?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('Batal'),
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(),
                                                ),
                                                TextButton(
                                                  child: Text('Hapus'),
                                                  onPressed: () async {
                                                    Navigator.of(ctx).pop();
                                                    await deleteData(rs.id!);
                                                  },
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailRumahSakitScreen(
                                          rumahSakit: rs,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahRumahSakitScreen()),
          );
          if (result == true) fetchData();
        },
      ),
    );
  }
}
