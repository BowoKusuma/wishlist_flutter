import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'db.dart';
import 'models.dart';

const _uuid = Uuid();

class WishlistState extends ChangeNotifier {
  List<WishItem> _wishes = [];
  bool _isDark = false;
  bool _isLoading = true;

  List<WishItem> get wishes => _wishes;
  bool get isDark => _isDark;
  bool get isLoading => _isLoading;

  WishlistState() {
    _load();
  }

  Future<void> _load() async {
    final isar = IsarDB.instance;

    // Cek apakah ada data, jika tidak ada lakukan seeding
    final count =
        await isar.wishItems.where().filter().not().uidStartsWith('__').count();
    if (count == 0) {
      await _seedData(isar);
    }

    await _reloadWishes();

    final settings = await isar.wishItems
        .where()
        .filter()
        .uidEqualTo('__settings__')
        .findFirst();
    _isDark = settings?.done ?? false;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _seedData(Isar isar) async {
    await isar.writeTxn(() async {
      for (final seed in kSeedWishes) {
        final item = WishItem()
          ..uid = seed.uid
          ..title = seed.title
          ..category = seed.category
          ..location = seed.location
          ..targetDate = seed.targetDate
          ..budget = seed.budget
          ..saved = seed.saved
          ..note = seed.note
          ..done = seed.done
          ..emoji = seed.emoji;
        await isar.wishItems.put(item);
      }
      final settings = WishItem()
        ..uid = '__settings__'
        ..title = ''
        ..category = ''
        ..location = ''
        ..targetDate = ''
        ..budget = 0
        ..saved = 0
        ..note = ''
        ..done = false
        ..emoji = '';
      await isar.wishItems.put(settings);
    });
  }

  Future<void> _saveSettings() async {
    final isar = IsarDB.instance;
    await isar.writeTxn(() async {
      final settings = await isar.wishItems
              .where()
              .filter()
              .uidEqualTo('__settings__')
              .findFirst() ??
          (WishItem()
            ..uid = '__settings__'
            ..title = ''
            ..category = ''
            ..location = ''
            ..targetDate = ''
            ..budget = 0
            ..saved = 0
            ..note = ''
            ..emoji = '');
      settings.done = _isDark;
      await isar.wishItems.put(settings);
    });
  }

  Future<void> _reloadWishes() async {
    final isar = IsarDB.instance;
    _wishes = await isar.wishItems
        .where()
        .filter()
        .not().uidStartsWith('__')
        .sortByTitle()
        .findAll();
    notifyListeners();
  }

  Future<void> addWish(WishItem wish) async {
    final isar = IsarDB.instance;
    wish.uid = _uuid.v4();
    await isar.writeTxn(() async {
      await isar.wishItems.put(wish);
    });
    await _reloadWishes();
  }

  Future<void> updateWish(WishItem wish) async {
    final isar = IsarDB.instance;
    await isar.writeTxn(() async {
      await isar.wishItems.put(wish);
    });
    await _reloadWishes();
  }

  Future<void> deleteWish(String uid) async {
    final isar = IsarDB.instance;
    await isar.writeTxn(() async {
      final item =
          await isar.wishItems.where().filter().uidEqualTo(uid).findFirst();
      if (item != null) {
        await isar.savingRecords
            .where()
            .filter()
            .wishUidEqualTo(uid)
            .deleteAll();
        await isar.wishItems.delete(item.id);
      }
    });
    await _reloadWishes();
  }

  Future<void> toggleDone(String uid) async {
    final isar = IsarDB.instance;
    final item =
        await isar.wishItems.where().filter().uidEqualTo(uid).findFirst();
    if (item == null) return;
    await isar.writeTxn(() async {
      item.done = !item.done;
      await isar.wishItems.put(item);
    });
    await _reloadWishes();
  }

  Future<void> toggleDark() async {
    _isDark = !_isDark;
    _saveSettings(); // Simpan di background
    notifyListeners();
  }

  Future<void> addToSaved(String uid, int amount, {String note = ''}) async {
    final isar = IsarDB.instance;
    final item =
        await isar.wishItems.where().filter().uidEqualTo(uid).findFirst();
    if (item == null) return;

    final record = SavingRecord()
      ..wishUid = uid
      ..amount = amount
      ..date = DateTime.now()
      ..note = note;

    await isar.writeTxn(() async {
      item.saved += amount;
      await isar.wishItems.put(item);
      await isar.savingRecords.put(record);
      await item.savingRecords.load();
      item.savingRecords.add(record);
      await item.savingRecords.save();
    });
    await _reloadWishes();
  }

  Future<List<SavingRecord>> getSavingHistory(String uid) async {
    final isar = IsarDB.instance;
    return isar.savingRecords
        .where()
        .filter()
        .wishUidEqualTo(uid)
        .sortByDateDesc()
        .findAll();
  }

  int get totalBudget =>
      _wishes.where((w) => !w.done).fold(0, (sum, w) => sum + w.budget);
  int get totalSaved =>
      _wishes.where((w) => !w.done).fold(0, (sum, w) => sum + w.saved);
  int get doneCount => _wishes.where((w) => w.done).length;
}
