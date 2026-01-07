import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'إنجاز برو',
      
      // Remove locale settings to avoid localization errors
      // We'll handle RTL manually in each screen
      
      // Theme Configuration
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // You can add Arabic fonts later
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),


        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ),
      
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}
