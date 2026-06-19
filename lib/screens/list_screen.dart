import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WishlistState>();
    final c = AppColorsTheme(state.isDark);

    // Tampilkan loading indicator saat Isar belum selesai load
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: c.bg,
        body: Center(
          child: CircularProgressIndicator(color: c.accent),
        ),
      );
    }

    final filtered = _filter == 'all'
        ? state.wishes
        : _filter == 'done'
            ? state.wishes.where((w) => w.done).toList()
            : state.wishes.where((w) => w.category == _filter).toList();

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MY',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  color: c.textSub,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'Bucket List ✨',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: c.text,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              DarkModeButton(
                                isDark: state.isDark,
                                c: c,
                                onToggle: state.toggleDark,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _openAdd(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: c.accent,
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: const Text(
                                    '+ Tambah',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: '📋',
                            value: '${state.wishes.length}',
                            label: 'Wishlist',
                            c: c,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            icon: '🎉',
                            value: '${state.doneCount}',
                            label: 'Tercapai',
                            c: c,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            icon: '💰',
                            value:
                                '${pct(state.totalSaved, state.totalBudget == 0 ? 1 : state.totalBudget)}%',
                            label: 'Dana Terkumpul',
                            c: c,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Total budget bar
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.surface,
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8)
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Budget Dibutuhkan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  color: c.text,
                                ),
                              ),
                              Text(
                                '${pct(state.totalSaved, state.totalBudget == 0 ? 1 : state.totalBudget)}%',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    color: c.textSub),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          WishProgressBar(
                            saved: state.totalSaved,
                            budget: state.totalBudget == 0
                                ? 1
                                : state.totalBudget,
                            c: c,
                          ),
                          const SizedBox(height: 7),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${formatRp(state.totalSaved)} terkumpul',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    color: c.accent,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'dari ${formatRp(state.totalBudget)}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    color: c.textSub),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter pills
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterPill(
                            icon: '🌟',
                            label: 'Semua',
                            active: _filter == 'all',
                            c: c,
                            onTap: () =>
                                setState(() => _filter = 'all'),
                          ),
                          const SizedBox(width: 8),
                          FilterPill(
                            icon: '✅',
                            label: 'Tercapai',
                            active: _filter == 'done',
                            c: c,
                            onTap: () =>
                                setState(() => _filter = 'done'),
                          ),
                          ...kCategories.map((cat) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 8),
                                child: FilterPill(
                                  icon: cat.icon,
                                  label: cat.label,
                                  active: _filter == cat.id,
                                  c: c,
                                  onTap: () => setState(
                                      () => _filter = cat.id),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Wish cards
            if (filtered.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌙',
                          style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada wishlist di sini',
                        style: TextStyle(
                          color: c.textSub,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final w = filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _WishCard(wish: w, c: c),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
  }
}

class _WishCard extends StatelessWidget {
  final WishItem wish;
  final AppColorsTheme c;

  const _WishCard({required this.wish, required this.c});

  @override
  Widget build(BuildContext context) {
    final cat = categoryOf(wish.category);
    final p = pct(wish.saved, wish.budget);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            // uid dipakai, bukan id (int Isar)
            builder: (_) => DetailScreen(wishUid: wish.uid),
          ),
        );
      },
      child: AnimatedOpacity(
        opacity: wish.done ? 0.72 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12)
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji box
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: wish.done ? null : c.heroBg,
                  color: wish.done ? c.doneCardBg : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    wish.done ? '✅' : wish.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            wish.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: c.text,
                              decoration: wish.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        CategoryTag(cat: cat, c: c),
                      ],
                    ),
                    if (wish.location.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '📍 ${wish.location}',
                        style: TextStyle(
                            fontSize: 12,
                            color: c.textSub,
                            fontFamily: 'Nunito'),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatRp(wish.saved),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            color: c.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$p% dari ${formatRp(wish.budget)}',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Nunito',
                              color: c.textSub),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    WishProgressBar(
                        saved: wish.saved,
                        budget: wish.budget,
                        c: c),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
