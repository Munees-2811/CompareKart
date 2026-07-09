import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/auth_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/price_alert_provider.dart';
import 'providers/comparison_provider.dart';

import 'screens/auth_screen.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const CompareKartApp());
}

class CompareKartApp extends StatelessWidget {
  const CompareKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => PriceAlertProvider()),
        ChangeNotifierProvider(create: (_) => ComparisonProvider()),
      ],
      child: MaterialApp(
        title: 'CompareKart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D47A1),
            primary: const Color(0xFF0D47A1),
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const AppRootSelector(),
      ),
    );
  }
}

class AppRootSelector extends StatelessWidget {
  const AppRootSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const MainLayout();
    } else {
      return const AuthScreen();
    }
  }
}
