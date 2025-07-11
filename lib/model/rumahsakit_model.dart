class RumahSakit {
  final int? id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String tipe;
  final double latitude;
  final double longitude;

  RumahSakit({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory RumahSakit.fromJson(Map<String, dynamic> json) {
    return RumahSakit(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelpon: json['no_telpon'],
      tipe: json['tipe'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'no_telpon': noTelpon,
      'tipe': tipe,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }
}
