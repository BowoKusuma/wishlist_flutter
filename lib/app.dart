import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'theme.dart';
import 'screens/list_screen.dart';

class WishlistApp extends StatelessWidget {
  const WishlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WishlistState(),
      child: Consumer<WishlistState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'My Bucket List',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const ListScreen(),
          );
        },
      ),
    );
  }
}
