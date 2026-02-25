import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/site_config.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/articles_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/blog_post_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/events_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SiteConfig.supabaseUrl,
    anonKey: SiteConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/notre-histoire', builder: (_, __) => const AboutScreen()),
    GoRoute(path: '/blog', builder: (_, __) => const ArticlesScreen()),
    GoRoute(
      path: '/blog/:slug',
      builder: (_, state) => BlogPostScreen(slug: state.pathParameters['slug']!),
    ),
    GoRoute(path: '/recettes', builder: (_, __) => const BlogScreen()),
    GoRoute(path: '/evenements', builder: (_, __) => const EventsScreen()),
    GoRoute(
      path: '/evenements/:id',
      builder: (_, state) => EventDetailScreen(eventId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: SiteConfig.siteTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: SiteConfig.primaryColor,
        scaffoldBackgroundColor: SiteConfig.backgroundColor,
        // Police display élégante : Cormorant Garamond pour les titres
        // Police body : Source Sans 3 pour le texte courant
        textTheme: TextTheme(
          displayLarge: GoogleFonts.cormorantGaramond(
            fontSize: 72,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
            letterSpacing: -1,
          ),
          displayMedium: GoogleFonts.cormorantGaramond(
            fontSize: 56,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.cormorantGaramond(
            fontSize: 44,
            fontWeight: FontWeight.w500,
            color: SiteConfig.textColor,
          ),
          headlineLarge: GoogleFonts.cormorantGaramond(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
          ),
          headlineMedium: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: SiteConfig.textColor,
          ),
          headlineSmall: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: SiteConfig.textColor,
          ),
          titleLarge: GoogleFonts.sourceSans3(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
          ),
          titleMedium: GoogleFonts.sourceSans3(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
            letterSpacing: 0.5,
          ),
          bodyLarge: GoogleFonts.sourceSans3(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: SiteConfig.textSecondary,
            height: 1.7,
          ),
          bodyMedium: GoogleFonts.sourceSans3(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: SiteConfig.textSecondary,
            height: 1.6,
          ),
          labelLarge: GoogleFonts.sourceSans3(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
            letterSpacing: 1.2,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: SiteConfig.primaryColor,
          primary: SiteConfig.primaryColor,
          secondary: SiteConfig.secondaryColor,
          tertiary: SiteConfig.accentColor,
          surface: SiteConfig.surfaceColor,
        ),
      ),
      routerConfig: _router,
    );
  }
}
