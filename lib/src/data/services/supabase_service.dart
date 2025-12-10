import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/guardian.dart';

class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  // =====================================================
  // CEK APAKAH WALI SUDAH ABSEN HARI INI
  // =====================================================
  Future<bool> hasAttendanceToday(int guardianId, String eventName) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final data = await _client
        .from('attendances')
        .select()
        .eq('guardian_id', guardianId)
        .eq('event_name', eventName)
        .gte('scanned_at', start.toIso8601String()) // FIX
        .lt('scanned_at', end.toIso8601String()) // FIX
        .maybeSingle();

    return data != null;
  }

  // =====================================================
  // GET GUARDIAN BY ID
  // =====================================================
  Future<Guardian?> getGuardianById(int idWali) async {
    final data = await _client
        .from('guardians')
        .select()
        .eq('id_wali', idWali)
        .maybeSingle();

    if (data == null) return null;
    return Guardian.fromMap(data as Map<String, dynamic>);
  }

  // =====================================================
  // INSERT ATTENDANCE
  // =====================================================
  Future<void> insertAttendance({
    required int guardianId,
    String? eventName,
  }) async {
    await _client.from('attendances').insert({
      'guardian_id': guardianId,
      'event_name': eventName ?? 'Wisuda Santri',
      // scanned_at otomatis dari DB
    });
  }

  // =====================================================
  // TOTAL GUARDIANS
  // =====================================================
  Future<int> getTotalGuardians() async {
    final data = await _client.from('guardians').select('id_wali');
    return data.length;
  }

  // =====================================================
  // TOTAL ATTENDANCES
  // =====================================================
  Future<int> getTotalAttendances() async {
    final data = await _client.from('attendances').select('id');
    return data.length;
  }

  // =====================================================
  // GET PRESENT GUARDIANS (yang sudah hadir)
  // =====================================================
  Future<List<Guardian>> getPresentGuardians() async {
    final data = await _client
        .from('attendances')
        .select('guardian_id, guardians!inner(*)')
        .order('guardian_id');

    return data
        .map<Guardian>((row) => Guardian.fromMap(row['guardians']))
        .toList();
  }

  // =====================================================
  // GET ABSENT GUARDIANS (yang belum hadir)
  // =====================================================
  Future<List<Guardian>> getAbsentGuardians() async {
    final present = await _client.from('attendances').select('guardian_id');

    final presentIds = present
        .map<int>((e) => e['guardian_id'] as int)
        .toList();

    // Jika belum ada yang hadir → semua dianggap belum hadir
    if (presentIds.isEmpty) {
      final all = await _client.from('guardians').select().order('id_wali');
      return all.map<Guardian>((e) => Guardian.fromMap(e)).toList();
    }

    // Ambil yang id_wali TIDAK ada di daftar present
    final data = await _client
        .from('guardians')
        .select()
        .not('id_wali', 'in', presentIds)
        .order('id_wali');

    return data.map<Guardian>((e) => Guardian.fromMap(e)).toList();
  }
}
