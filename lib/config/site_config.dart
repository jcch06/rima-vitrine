import 'package:flutter/material.dart';

class SiteConfig {
  // ============================================
  // CONFIGURATION CLIENT - ÉPICERIE LIBANAISE
  // ============================================

  // Identifiant vendeur Paniero
  static const String vendorId = '1b6b18be-a22d-4c58-8c11-6aa9763fdd5b';
  static const String vendorSlug = 'cedre-gourmet';

  // Infos business
  static const String businessName = 'Escale Libanaise';
  static const String tagline = 'L\'art de vivre libanais, livré chez vous';
  static const String description =
      'Découvrez les trésors culinaires du Liban : huile d\'olive ancestrale, zaatar parfumé, halva artisanal et mille délices authentiques sélectionnés avec passion.';

  // Coordonnées
  static const String phone = '01 42 33 44 55';
  static const String email = 'bonjour@cedre-gourmet.fr';
  static const String address = '28 rue du Faubourg Saint-Antoine, 75012 Paris';
  static const String googleMapsUrl = 'https://maps.google.com/?q=28+rue+du+Faubourg+Saint-Antoine+Paris';

  // Réseaux sociaux
  static const String? instagram = 'https://instagram.com/cedregourmet';
  static const String? facebook = null;

  // Lien vers boutique Paniero
  static const String storeUrl = 'https://app.paniero.fr/store/kebab';

  // ============================================
  // PALETTE MÉDITERRANÉENNE RAFFINÉE
  // ============================================

  // Couleurs principales
  static const Color primaryColor = Color(0xFF2D5A3D);      // Olive profond
  static const Color secondaryColor = Color(0xFFB8860B);    // Or antique
  static const Color accentColor = Color(0xFFC4704A);       // Terracotta doux

  // Fonds et surfaces
  static const Color backgroundColor = Color(0xFFFAF6F1);   // Crème chaud
  static const Color surfaceColor = Color(0xFFFFFFFF);      // Blanc pur
  static const Color cardColor = Color(0xFFFFFBF7);         // Ivoire

  // Textes
  static const Color textColor = Color(0xFF2C2416);         // Brun profond
  static const Color textSecondary = Color(0xFF6B5D4D);     // Brun moyen
  static const Color textLight = Color(0xFF9A8B7A);         // Brun clair

  // Accents décoratifs
  static const Color goldAccent = Color(0xFFD4AF37);        // Or vif
  static const Color oliveLight = Color(0xFFE8EDE5);        // Olive très clair
  static const Color terracottaLight = Color(0xFFF5E6DE);   // Terracotta pâle

  // Images
  static const String heroImage = 'assets/images/hero.jpg';
  static const String logoImage = 'assets/images/logo.png';

  // Supabase (partagé Paniero)
  static const String supabaseUrl = 'https://chgbqoxklkcjzniiemkh.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoZ2Jxb3hrbGtjanpuaWllbWtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1NjcyMzksImV4cCI6MjA3MjE0MzIzOX0.V4wPaYL2f19v-wMRmlrZ9lVp177RIwzEY2YHfI1LzUE';

  // SEO
  static const String siteTitle = 'Escale Libanaise | Épicerie Fine Libanaise Paris';
  static const String metaDescription =
      'Épicerie fine libanaise à Paris. Huile d\'olive, zaatar, halva, mezzé et produits authentiques du Liban. Livraison à domicile.';

  // About page content
  static const String aboutTitle = 'Notre Histoire';
  static const String aboutSubtitle = 'Un voyage gustatif au cœur du Liban';
  static const String aboutContent = '''
Escale Libanaise est née d'une passion transmise de génération en génération. Notre famille cultive l'olivier depuis plus d'un siècle dans les montagnes du Mont-Liban.

Chaque produit que nous sélectionnons raconte une histoire : celle des artisans qui perpétuent des savoir-faire millénaires, celle des terroirs généreux qui offrent leurs plus beaux fruits.

Du zaatar cueilli à l'aube dans la vallée de la Bekaa à l'huile d'olive pressée à froid de nos oliveraies familiales, nous vous invitons à découvrir l'authenticité et la richesse de la gastronomie libanaise.
''';

  // Contact page content
  static const String contactTitle = 'Parlons saveurs';
  static const String contactSubtitle =
      'Une question sur nos produits ? Un conseil pour vos recettes ? Nous sommes là pour vous.';

  // Section titles
  static const String welcomeTitle = 'Bienvenue';
  static const String welcomeSubtitle = 'Les saveurs du Levant à votre table';
  static const String blogTitle = 'Carnet de Saveurs';
  static const String blogSubtitle = 'Recettes, traditions et secrets de cuisine libanaise';
}

// ============================================
// THÈME FLUTTER PERSONNALISÉ
// ============================================

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        primaryColor: SiteConfig.primaryColor,
        scaffoldBackgroundColor: SiteConfig.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SiteConfig.primaryColor,
          primary: SiteConfig.primaryColor,
          secondary: SiteConfig.secondaryColor,
          tertiary: SiteConfig.accentColor,
          background: SiteConfig.backgroundColor,
          surface: SiteConfig.surfaceColor,
        ),
        cardTheme: CardThemeData(
          color: SiteConfig.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: SiteConfig.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: SiteConfig.primaryColor,
            side: BorderSide(color: SiteConfig.primaryColor.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: SiteConfig.textLight.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: SiteConfig.textLight.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: SiteConfig.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      );
}
