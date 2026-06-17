import 'dart:convert';
import 'package:flutter_refresh_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* using 'shared_preferences' package in order to simply store values locally instead of massing with DBs*/

// GET (single)
Future<UserData?> getUser(String userName) async {
  final users = await readUsers();
  try {
    return users.firstWhere((u) => u.userName == userName);
  } catch (_) {
    return null;
  }
}

// GET (all)
Future<List<UserData>> readUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('users');
  if (raw == null) return [];
  final List<dynamic> decoded = jsonDecode(raw);
  return decoded.map((e) => UserData.fromMap(e)).toList();
}

// POST (single)
Future<void> saveUser(UserData user) async {
  final prefs = await SharedPreferences.getInstance();
  final users = await readUsers();
  users.add(user);
  await prefs.setString(
    'users',
    jsonEncode(users.map((u) => u.toMap()).toList()),
  );
}

// UPDATE (single)
Future<void> updateUser(String userName, UserData updated) async {
  final prefs = await SharedPreferences.getInstance();
  final users = await readUsers();
  final index = users.indexWhere((u) => u.userName == userName);
  if (index == -1) return;
  users[index] = updated;
  await prefs.setString(
    'users',
    jsonEncode(users.map((u) => u.toMap()).toList()),
  );
}

// DELETE (single)
Future<void> deleteUser(String userName) async {
  final prefs = await SharedPreferences.getInstance();
  final users = await readUsers();
  users.removeWhere((u) => u.userName == userName);
  await prefs.setString(
    'users',
    jsonEncode(users.map((u) => u.toMap()).toList()),
  );
}
