import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'form_screen.dart';

/// Halaman detail satu wishlist, lengkap dengan riwayat tabungan.
class DetailScreen extends StatefulWidget {
  final String wishUid;

  const DetailScreen({super.key, required this.wishUid});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<SavingRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = context.read<WishlistState>().getSavingHistory(widget.wishUid);
  }

  Future<void> _addSaving(BuildContext context, AppColorsTheme c) async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: c.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Tabungan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.text),
              ),
              const SizedBox(height: 14),
              _field(amountCtrl, 'Jumlah (Rp)', c, keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _field(noteCtrl, 'Catatan (opsional)', c),
              const SizedBox(height: 18),
              Center(
                child: PrimaryButton(
                  label: 'Simpan',
                  c: c,
                  onTap: () => Navigator.of(ctx).pop(true),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
      if (amount > 0) {
        await context.read<WishlistState>().addToSaved(
              widget.wishUid,
              amount,
              note: noteCtrl.text.trim(),
            );
        if (!mounted) return;
        setState(_loadHistory);
      }
    }
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    AppColorsTheme c, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: c.inputBg,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(color: c.text, fontFamily: 'Nunito'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: c.textSub, fontFamily: 'Nunito'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AppColorsTheme c) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('Hapus Wishlist?', style: TextStyle(color: c.text)),
        content: Text(
          'Wishlist dan riwayat tabungannya akan dihapus permanen.',
          style: TextStyle(color: c.textSub, fontFamily: 'Nunito'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: TextStyle(color: c.textSub)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Hapus', style: TextStyle(color: c.deleteText)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<WishlistState>().deleteWish(widget.wishUid);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WishlistState>();
    final c = AppColorsTheme(state.isDark);

    WishItem? found;
    for (final item in state.wishes) {
      if (item.uid == widget.wishUid) {
        found = item;
        break;
      }
    }

    if (found == null) {
      // Wishlist sudah dihapus, kembali ke list.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return Scaffold(backgroundColor: c.bg, body: const SizedBox.shrink());
    }

    final w = found;
    final cat = categoryOf(w.category);
    final p = pct(w.saved, w.budget);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.tag,
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back, color: c.text, size: 20),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => FormScreen(editWish: w)),
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.tag,
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.edit_outlined, color: c.text, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _confirmDelete(context, c),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.tag,
                        border: Border.all(color: c.deleteBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.delete_outline, color: c.deleteText, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Emoji + title + category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: w.done ? null : c.heroBg,
                      color: w.done ? c.doneCardBg : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        w.done ? '✅' : w.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: c.text,
                            decoration: w.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CategoryTag(cat: cat, c: c),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              if (w.location.isNotEmpty) _infoRow('📍', 'Lokasi', w.location, c),
              if (w.targetDate.isNotEmpty)
                _infoRow('📅', 'Target Tanggal', _formatDate(w.targetDate), c),
              const SizedBox(height: 8),

              // Progress card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border.all(color: c.border),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Tabungan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Nunito',
                            color: c.text,
                          ),
                        ),
                        Text(
                          '$p%',
                          style: TextStyle(fontSize: 13, fontFamily: 'Nunito', color: c.textSub),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    WishProgressBar(saved: w.saved, budget: w.budget, c: c, height: 10),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatRp(w.saved)} terkumpul',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            color: c.accent,
                          ),
                        ),
                        Text(
                          'dari ${formatRp(w.budget)}',
                          style: TextStyle(fontSize: 13, fontFamily: 'Nunito', color: c.textSub),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (w.note.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.noteBg,
                    border: Border.all(color: c.borderNote),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    w.note,
                    style: TextStyle(fontSize: 13, fontFamily: 'Nunito', color: c.textMid),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Actions
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: '+ Tambah Tabungan',
                      c: c,
                      onTap: () => _addSaving(context, c),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GhostButton(
                    label: w.done ? 'Batal Tercapai' : 'Tandai Tercapai',
                    c: c,
                    onTap: () => context.read<WishlistState>().toggleDone(w.uid),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Riwayat Tabungan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.text),
              ),
              const SizedBox(height: 10),

              FutureBuilder<List<SavingRecord>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: c.accent)),
                    );
                  }

                  final records = snapshot.data ?? [];
                  if (records.isEmpty) {
                    return Text(
                      'Belum ada riwayat tabungan',
                      style: TextStyle(color: c.textSub, fontFamily: 'Nunito'),
                    );
                  }

                  return Column(
                    children: records.map((r) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.surface,
                          border: Border.all(color: c.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '+ ${formatRp(r.amount)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                      color: c.accent,
                                    ),
                                  ),
                                  if (r.note.isNotEmpty)
                                    Text(
                                      r.note,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Nunito',
                                        color: c.textSub,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm').format(r.date),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito',
                                color: c.textSub,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String icon, String label, String value, AppColorsTheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: c.text,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontFamily: 'Nunito', color: c.textSub),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat('dd MMMM yyyy').format(d);
  }
}
