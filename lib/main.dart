import 'package:flutter/material.dart';
import 'db.dart';
import 'app.dart';

void main() async {
  // Wajib dipanggil sebelum async di main
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Isar database
  await IsarDB.init();

  runApp(const WishlistApp());
}
