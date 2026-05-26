import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  AuthSession._();

  static const String _tokenKey = 'auth_access_token';
  static const String _nameKey = 'auth_user_name';
  static const String _roleKey = 'auth_user_role';
  static const String _reminderShownKey = 'auth_tumbuh_reminder_shown';
  
  
  static const String _expiryTimeKey = 'auth_expiry_time';
  static const String _lastActivityKey = 'auth_last_activity';

  static String? token;
  static String? userName;
  static String? role;
  static bool isReminderShown = false;
  
  static DateTime? expiryTime;
  static DateTime? lastActivityTime;
  
  static const int idleTimeoutMinutes = 15;

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static bool get isSessionValid {
    if (!isLoggedIn) return false;
    if (expiryTime == null) return true; // Fallback aman kalau user login dari versi app lama
    
    final now = DateTime.now();
    
    if (now.isAfter(expiryTime!)) {
      return false;
    }
    
    if (lastActivityTime != null) {
      final idleDuration = now.difference(lastActivityTime!);
      if (idleDuration.inMinutes >= idleTimeoutMinutes) {
        return false;
      }
    }
    
    return true;
  }

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    userName = prefs.getString(_nameKey);
    role = prefs.getString(_roleKey);
    isReminderShown = prefs.getBool(_reminderShownKey) ?? false;

    final expiryStr = prefs.getString(_expiryTimeKey);
    final activityStr = prefs.getString(_lastActivityKey);
    
    if (expiryStr != null) {
      expiryTime = DateTime.tryParse(expiryStr);
    } else if (token != null) {
      expiryTime = DateTime.now().add(const Duration(hours: 24));
      lastActivityTime = DateTime.now();
      await prefs.setString(_expiryTimeKey, expiryTime!.toIso8601String());
      await prefs.setString(_lastActivityKey, lastActivityTime!.toIso8601String());
    }
    
    if (activityStr != null) lastActivityTime = DateTime.tryParse(activityStr);
  }

  static Future<void> save({
    required String accessToken,
    String? name,
    String? userRole,
    int? expiresIn,
  }) async {
    token = accessToken;
    userName = name;
    role = userRole;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    isReminderShown = false;
    await prefs.setBool(_reminderShownKey, false);
    
    if (name != null) await prefs.setString(_nameKey, name);
    if (userRole != null) await prefs.setString(_roleKey, userRole);
    
    final now = DateTime.now();
    expiryTime = now.add(Duration(seconds: expiresIn ?? 86400)); // Default 24 jam kalau backend tidak kirim
    lastActivityTime = now;
    
    await prefs.setString(_expiryTimeKey, expiryTime!.toIso8601String());
    await prefs.setString(_lastActivityKey, lastActivityTime!.toIso8601String());
  }

  static Future<void> clear() async {
    token = null;
    userName = null;
    role = null;
    isReminderShown = false;
    expiryTime = null; // 🆕 Hapus memori waktu
    lastActivityTime = null; // 🆕 Hapus memori waktu

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_reminderShownKey);
    await prefs.remove(_expiryTimeKey); // 🆕 Hapus dari disk
    await prefs.remove(_lastActivityKey); // 🆕 Hapus dari disk
  }

  static Future<void> updateActivity() async {
    final now = DateTime.now();
    lastActivityTime = now;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastActivityKey, now.toIso8601String());
  }

  static Future<void> markReminderShown() async {
    isReminderShown = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderShownKey, true);
  }
}