import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/guardian.dart';

class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  // ==============================
  //  AMBIL DATA WALI BERDASARKAN ID
  // ==============================
  Future<Guardian?> getGuardianById(int idWali) async {
    final data = await _client
        .from('guardians')
        .select()
        .eq('id_wali', idWali)
        .maybeSingle();

    if (data == null) return null;
    return Guardian.fromMap(data as Map<String, dynamic>);
  }

  // ==============================
  //  INSERT ABSENSI
  // ==============================
  Future<void> insertAttendance({
    required int guardianId,
    String? eventName,
  }) async {
    await _client.from('attendances').insert({
      'guardian_id': guardianId,
      'event_name': eventName ?? 'Wisuda Santri',
    });
  }

  // ==============================
  //  HITUNG TOTAL WALI MURID
  // ==============================
  Future<int> getTotalGuardians() async {
    final data = await _client.from('guardians').select('id_wali');
    return data.length;
  }

  // ==============================
  //  HITUNG TOTAL YANG SUDAH HADIR
  // ==============================
  Future<int> getTotalAttendances() async {
    final data = await _client.from('attendances').select('id');
    return data.length;
  }

  // ==============================
  //  AMBIL DAFTAR YANG HADIR
  // ==============================
  Future<List<Guardian>> getPresentGuardians() async {
    final data = await _client
        .from('attendances')
        .select('guardian_id, guardians!inner(*)')
        .order('guardian_id', ascending: true);

    return data
        .map<Guardian>((row) => Guardian.fromMap(row['guardians']))
        .toList();
  }

  // ==============================
  //  AMBIL DAFTAR YANG BELUM HADIR
  // ==============================
  Future<List<Guardian>> getAbsentGuardians() async {
    // Ambil semua ID yang hadir
    final present = await _client.from('attendances').select('guardian_id');

    final presentIds = present
        .map<int>((e) => e['guardian_id'] as int)
        .toList();

    // Jika belum ada yang hadir, kembalikan seluruh wali
    if (presentIds.isEmpty) {
      final all = await _client.from('guardians').select().order('id_wali');
      return all.map<Guardian>((e) => Guardian.fromMap(e)).toList();
    }

    // Ambil yang id_wali tidak ada dalam presentIds
    final data = await _client
        .from('guardians')
        .select()
        .not('id_wali', 'in', presentIds)
        .order('id_wali');

    return data.map<Guardian>((e) => Guardian.fromMap(e)).toList();
  }
}
