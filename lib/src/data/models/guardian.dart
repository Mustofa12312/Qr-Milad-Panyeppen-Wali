class Guardian {
  final int idWali;
  final String namaWali;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String namaMurid;
  final String kelasMurid;

  Guardian({
    required this.idWali,
    required this.namaWali,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.namaMurid,
    required this.kelasMurid,
  });

  String get alamatLengkap => '$desa, $kecamatan, $kabupaten';

  factory Guardian.fromMap(Map<String, dynamic> map) {
    return Guardian(
      idWali: map['id_wali'] as int,
      namaWali: (map['nama_wali'] ?? '') as String,
      desa: (map['desa'] ?? '') as String,
      kecamatan: (map['kecamatan'] ?? '') as String,
      kabupaten: (map['kabupaten'] ?? '') as String,
      namaMurid: (map['nama_murid'] ?? '') as String,
      kelasMurid: (map['kelas_murid'] ?? '') as String,
    );
  }
}
