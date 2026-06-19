import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models.dart';

class IsarDB {
  IsarDB._();

  static Isar? _isar;

  static Isar get instance {
    assert(_isar != null, 'IsarDB belum diinisialisasi. Panggil IsarDB.init() di main().');
    return _isar!;
  }

  static Future<void> init() async {
    if (_isar != null && _isar!.isOpen) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [WishItemSchema, SavingRecordSchema],
      directory: dir.path,
      name: 'wishlist_db',
    );
  }

  static Future<void> close() async {
    await _isar?.close();
  }
}