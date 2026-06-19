import 'package:isar/isar.dart';

part 'models.g.dart';

// ── Isar Collections ─────────────────────────────────────────────

@collection
class WishItem {
  Id id = Isar.autoIncrement;

  /// UUID string, dipakai sebagai identifier di UI layer
  @Index(unique: true)
  late String uid;

  late String title;
  late String category;
  late String location;
  late String targetDate;
  late int budget;
  late int saved;
  late String note;
  late bool done;
  late String emoji;

  /// Relasi ke riwayat tabungan
  final savingRecords = IsarLinks<SavingRecord>();
}

@collection
class SavingRecord {
  Id id = Isar.autoIncrement;

  /// uid dari WishItem pemilik record ini
  @Index()
  late String wishUid;

  late int amount;
  late DateTime date;
  late String note;
}

// ── Non-Isar helpers (tetap sama) ────────────────────────────────

class WishCategory {
  final String id;
  final String label;
  final String icon;

  const WishCategory({required this.id, required this.label, required this.icon});
}

const List<WishCategory> kCategories = [
  WishCategory(id: 'travel',     label: 'Perjalanan', icon: '✈️'),
  WishCategory(id: 'experience', label: 'Pengalaman',  icon: '🎯'),
  WishCategory(id: 'item',       label: 'Barang',      icon: '🛍️'),
  WishCategory(id: 'learn',      label: 'Belajar',     icon: '📖'),
  WishCategory(id: 'food',       label: 'Kuliner',     icon: '🍜'),
];

WishCategory categoryOf(String id) =>
    kCategories.firstWhere((c) => c.id == id, orElse: () => kCategories.first);

// ── Seed data (dipakai saat DB kosong) ───────────────────────────

class SeedWish {
  final String uid;
  final String title;
  final String category;
  final String location;
  final String targetDate;
  final int budget;
  final int saved;
  final String note;
  final bool done;
  final String emoji;

  const SeedWish({
    required this.uid,
    required this.title,
    required this.category,
    required this.location,
    required this.targetDate,
    required this.budget,
    required this.saved,
    required this.note,
    required this.done,
    required this.emoji,
  });
}

const List<SeedWish> kSeedWishes = [
  SeedWish(
    uid: 'seed-1',
    title: 'Raja Ampat',
    category: 'travel',
    location: 'Papua Barat, Indonesia',
    targetDate: '2025-12-01',
    budget: 8000000,
    saved: 3200000,
    note: 'Snorkeling & lihat manta ray langsung',
    done: false,
    emoji: '🌊',
  ),
  SeedWish(
    uid: 'seed-2',
    title: 'Nonton Konser Coldplay',
    category: 'experience',
    location: 'Jakarta, Indonesia',
    targetDate: '2025-08-15',
    budget: 2500000,
    saved: 2500000,
    note: 'Udah impian dari SMA!',
    done: true,
    emoji: '🎵',
  ),
  SeedWish(
    uid: 'seed-3',
    title: 'Kamera Sony ZV-E10',
    category: 'item',
    location: '',
    targetDate: '2025-09-01',
    budget: 5500000,
    saved: 1500000,
    note: 'Buat konten travel',
    done: false,
    emoji: '📷',
  ),
];

// ── Utility functions ─────────────────────────────────────────────

String formatRp(int n) {
  final s = n.toString();
  final buffer = StringBuffer('Rp ');
  int counter = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    if (counter > 0 && counter % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
    counter++;
  }
  return buffer.toString().split('').reversed.join('');
}

int pct(int saved, int budget) {
  if (budget == 0) return 0;
  return (saved / budget * 100).round().clamp(0, 100);
}
