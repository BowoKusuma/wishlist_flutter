import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Form untuk menambah wishlist baru, atau mengedit wishlist
/// yang sudah ada (kirim [editWish] untuk mode edit).
class FormScreen extends StatefulWidget {
  final WishItem? editWish;

  const FormScreen({super.key, this.editWish});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _emojiCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _budgetCtrl;
  late final TextEditingController _savedCtrl;
  late final TextEditingController _noteCtrl;

  late String _category;
  DateTime? _targetDate;

  bool get _isEdit => widget.editWish != null;

  @override
  void initState() {
    super.initState();
    final w = widget.editWish;
    _titleCtrl = TextEditingController(text: w?.title ?? '');
    _emojiCtrl = TextEditingController(text: w?.emoji ?? '✨');
    _locationCtrl = TextEditingController(text: w?.location ?? '');
    _budgetCtrl = TextEditingController(text: w != null ? w.budget.toString() : '');
    _savedCtrl = TextEditingController(text: w != null ? w.saved.toString() : '0');
    _noteCtrl = TextEditingController(text: w?.note ?? '');
    _category = w?.category ?? kCategories.first.id;
    _targetDate = (w != null && w.targetDate.isNotEmpty) ? DateTime.tryParse(w.targetDate) : null;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _emojiCtrl.dispose();
    _locationCtrl.dispose();
    _budgetCtrl.dispose();
    _savedCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  void _save(BuildContext context) {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul wishlist tidak boleh kosong')),
      );
      return;
    }

    final budget = int.tryParse(_budgetCtrl.text.trim()) ?? 0;
    final saved = int.tryParse(_savedCtrl.text.trim()) ?? 0;
    final emoji = _emojiCtrl.text.trim().isEmpty ? '✨' : _emojiCtrl.text.trim();
    final targetDateStr =
        _targetDate != null ? DateFormat('yyyy-MM-dd').format(_targetDate!) : '';

    final state = context.read<WishlistState>();

    if (_isEdit) {
      final w = widget.editWish!;
      w.title = title;
      w.category = _category;
      w.location = _locationCtrl.text.trim();
      w.targetDate = targetDateStr;
      w.budget = budget;
      w.saved = saved;
      w.note = _noteCtrl.text.trim();
      w.emoji = emoji;
      state.updateWish(w);
    } else {
      final w = WishItem()
        ..uid = ''
        ..title = title
        ..category = _category
        ..location = _locationCtrl.text.trim()
        ..targetDate = targetDateStr
        ..budget = budget
        ..saved = saved
        ..note = _noteCtrl.text.trim()
        ..done = false
        ..emoji = emoji;
      state.addWish(w);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WishlistState>();
    final c = AppColorsTheme(state.isDark);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  const SizedBox(width: 12),
                  Text(
                    _isEdit ? 'Edit Wishlist' : 'Tambah Wishlist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: c.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _label('Judul', c),
              _textField(_titleCtrl, c, hint: 'cth. Liburan ke Bali'),
              const SizedBox(height: 16),

              _label('Emoji', c),
              _textField(_emojiCtrl, c, hint: '✨'),
              const SizedBox(height: 16),

              _label('Kategori', c),
              _categoryPicker(c),
              const SizedBox(height: 16),

              _label('Lokasi', c),
              _textField(_locationCtrl, c, hint: 'cth. Bali, Indonesia'),
              const SizedBox(height: 16),

              _label('Target Tanggal', c),
              _datePicker(c),
              const SizedBox(height: 16),

              _label('Budget (Rp)', c),
              _textField(_budgetCtrl, c, hint: '0', keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              _label('Dana Terkumpul (Rp)', c),
              _textField(_savedCtrl, c, hint: '0', keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              _label('Catatan', c),
              _textField(_noteCtrl, c, hint: 'Tulis catatan...', maxLines: 3),
              const SizedBox(height: 28),

              Center(
                child: PrimaryButton(
                  label: _isEdit ? 'Simpan Perubahan' : 'Tambah Wishlist',
                  onTap: () => _save(context),
                  c: c,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, AppColorsTheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: c.text,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController ctrl,
    AppColorsTheme c, {
    String hint = '',
    TextInputType? keyboardType,
    int maxLines = 1,
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
        maxLines: maxLines,
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

  Widget _categoryPicker(AppColorsTheme c) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kCategories.map((cat) {
        final active = _category == cat.id;
        return GestureDetector(
          onTap: () => setState(() => _category = cat.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? c.accent : c.tag,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat.icon, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  cat.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : c.tagText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _datePicker(AppColorsTheme c) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.inputBg,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: c.textSub),
            const SizedBox(width: 10),
            Text(
              _targetDate != null
                  ? DateFormat('dd MMMM yyyy').format(_targetDate!)
                  : 'Pilih tanggal',
              style: TextStyle(
                color: _targetDate != null ? c.text : c.textSub,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
