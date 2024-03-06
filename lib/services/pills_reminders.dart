import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getReminders() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? data = prefs.getStringList('reminders');
  print(data != null ?data.map((e) => json.decode(e)).toList(): []);
  return data != null ? data.map((e) => json.decode(e)).toList() : [];
}

Future<List<dynamic>> addReminder(Map<String, dynamic> reminder) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> data = prefs.getStringList('reminders') ?? [];
  data.add(json.encode(reminder));
  await prefs.setStringList('reminders', data);
  return data.map((e) => json.decode(e)).toList();
}

Future<List<dynamic>> removeReminder(Map<String, dynamic> reminder) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> data = prefs.getStringList('reminders') ?? [];
  data.remove(json.encode(reminder));
  await prefs.setStringList('reminders', data);
  return data.map((e) => json.decode(e)).toList();
}

Future<List<dynamic>> updateReminder(Map<String, dynamic> reminder) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> data = prefs.getStringList('reminders') ?? [];
  final int index = data.indexWhere((element) => json.decode(element)['id'] == reminder['id']);
  data[index] = json.encode(reminder);
  await prefs.setStringList('reminders', data);
  return data.map((e) => json.decode(e)).toList();
}

Future<void> clearReminders() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('reminders');
}
