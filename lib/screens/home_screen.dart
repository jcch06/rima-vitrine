import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../config/site_config.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section avec effet parallaxe
            _buildHeroSection(isDesktop, screenHeight),

            // Section Bienvenue
            _buildWelcomeSection(isDesktop),

            // Section Valeurs
            _buildValuesSection(isDesktop),

            // Section CTA
            _buildCtaSection(isDesktop),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop, double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.95,
      child: Stack(
        children: [
          // Fond avec dégradé méditerranéen
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SiteConfig.primaryColor.withOpacity(0.95),
                    SiteConfig.primaryColor,
                    const Color(0xFF1E3D2A),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Motif décoratif subtil
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(),
            ),
          ),

          // Cercles décoratifs flottants
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = math.sin(_floatController.value * math.pi) * 20;
              return Stack(
                children: [
                  Positioned(
                    right: isDesktop ? 100 : 20,
                    top: 150 + offset,
                    child: _buildFloatingCircle(180, SiteConfig.goldAccent.withOpacity(0.1)),
                  ),
                  Positioned(
                    left: isDesktop ? 80 : -50,
                    bottom: 200 - offset,
                    child: _buildFloatingCircle(120, SiteConfig.accentColor.withOpacity(0.08)),
                  ),
                  Positioned(
                    right: isDesktop ? 300 : 100,
                    bottom: 100 + offset * 0.5,
                    child: _buildFloatingCircle(80, Colors.white.withOpacity(0.05)),
                  ),
                ],
              );
            },
          ),

          // Contenu principal
          Positioned.fill(
            child: Column(
              children: [
                const Navbar(transparent: true),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 80 : 28,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Badge décoratif
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: SiteConfig.goldAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: SiteConfig.goldAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'ÉPICERIE FINE LIBANAISE',
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: SiteConfig.goldAccent,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Titre principal
                            Text(
                              SiteConfig.businessName,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: isDesktop ? 80 : 48,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 2,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Ligne décorative
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 1,
                                  color: SiteConfig.goldAccent.withOpacity(0.5),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '✦',
                                  style: TextStyle(
                                    color: SiteConfig.goldAccent,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 60,
                                  height: 1,
                                  color: SiteConfig.goldAccent.withOpacity(0.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Tagline
                            Text(
                              SiteConfig.tagline,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: isDesktop ? 28 : 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.85),
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),

                            // Boutons
                            Wrap(
                              spacing: 20,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                _HeroButton(
                                  label: 'Découvrir nos produits',
                                  primary: true,
                                  onTap: () => launchUrl(Uri.parse(SiteConfig.storeUrl)),
                                ),
                                _HeroButton(
                                  label: 'Notre histoire',
                                  primary: false,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Indicateur de scroll
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Text(
                        'DÉCOUVRIR',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final bounce = math.sin(_floatController.value * math.pi * 2) * 4;
                          return Transform.translate(
                            offset: Offset(0, bounce),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white54,
                              size: 28,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 28,
        vertical: isDesktop ? 120 : 80,
      ),
      child: Column(
        children: [
          // Section header
          Text(
            'BIENVENUE',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Les saveurs du Levant\nà votre table',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 48 : 36,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              SiteConfig.description,
              style: GoogleFonts.sourceSans3(
                fontSize: isDesktop ? 18 : 16,
                color: SiteConfig.textSecondary,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),

          // Produits vedettes
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _ProductHighlight(
                emoji: '🫒',
                title: 'Huile d\'Olive',
                subtitle: 'Première pression à froid',
                isDesktop: isDesktop,
              ),
              _ProductHighlight(
                emoji: '🌿',
                title: 'Zaatar',
                subtitle: 'Mélange traditionnel',
                isDesktop: isDesktop,
              ),
              _ProductHighlight(
                emoji: '🍯',
                title: 'Halva',
                subtitle: 'Douceur artisanale',
                isDesktop: isDesktop,
              ),
              _ProductHighlight(
                emoji: '🧆',
                title: 'Mezzé',
                subtitle: 'Saveurs partagées',
                isDesktop: isDesktop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 28,
        vertical: isDesktop ? 100 : 60,
      ),
      decoration: BoxDecoration(
        color: SiteConfig.oliveLight.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Text(
            'NOS ENGAGEMENTS',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ce qui nous anime',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 42 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _ValueCard(
                icon: Icons.eco_outlined,
                title: 'Authenticité',
                description: 'Des produits sourcés directement auprès d\'artisans libanais passionnés.',
                isDesktop: isDesktop,
              ),
              _ValueCard(
                icon: Icons.favorite_outline,
                title: 'Passion',
                description: 'L\'amour de la cuisine libanaise transmis de génération en génération.',
                isDesktop: isDesktop,
              ),
              _ValueCard(
                icon: Icons.local_shipping_outlined,
                title: 'Fraîcheur',
                description: 'Livraison soignée pour préserver toute la qualité de nos produits.',
                isDesktop: isDesktop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 28,
        vertical: isDesktop ? 100 : 70,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SiteConfig.accentColor.withOpacity(0.08),
            SiteConfig.terracottaLight,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SiteConfig.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '🛒',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Prêt à voyager ?',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 42 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              'Explorez notre sélection de produits d\'exception et laissez-vous transporter par les saveurs du Liban.',
              style: GoogleFonts.sourceSans3(
                fontSize: 17,
                color: SiteConfig.textSecondary,
                height: 1.7,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          _HeroButton(
            label: 'Visiter la boutique',
            primary: true,
            onTap: () => launchUrl(Uri.parse(SiteConfig.storeUrl)),
            dark: true,
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  final bool dark;

  const _HeroButton({
    required this.label,
    required this.primary,
    required this.onTap,
    this.dark = false,
  });

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          decoration: BoxDecoration(
            color: widget.primary
                ? (_isHovered ? SiteConfig.goldAccent : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: widget.primary
                ? null
                : Border.all(
                    color: widget.dark
                        ? SiteConfig.textColor.withOpacity(0.3)
                        : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
            boxShadow: widget.primary && _isHovered
                ? [
                    BoxShadow(
                      color: SiteConfig.goldAccent.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.sourceSans3(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: widget.primary
                  ? SiteConfig.textColor
                  : (widget.dark ? SiteConfig.textColor : Colors.white),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductHighlight extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isDesktop;

  const _ProductHighlight({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isDesktop,
  });

  @override
  State<_ProductHighlight> createState() => _ProductHighlightState();
}

class _ProductHighlightState extends State<_ProductHighlight> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isDesktop ? 200 : 150,
        padding: EdgeInsets.all(widget.isDesktop ? 28 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: SiteConfig.primaryColor.withOpacity(_isHovered ? 0.12 : 0.06),
              blurRadius: _isHovered ? 30 : 20,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
          border: Border.all(
            color: _isHovered
                ? SiteConfig.primaryColor.withOpacity(0.2)
                : Colors.transparent,
          ),
        ),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
              child: Text(
                widget.emoji,
                style: TextStyle(fontSize: widget.isDesktop ? 48 : 36),
              ),
            ),
            SizedBox(height: widget.isDesktop ? 20 : 14),
            Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: widget.isDesktop ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: SiteConfig.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: GoogleFonts.sourceSans3(
                fontSize: 13,
                color: SiteConfig.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDesktop;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDesktop,
  });

  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isDesktop ? 300 : double.infinity,
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 30 : 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _isHovered
                    ? SiteConfig.primaryColor
                    : SiteConfig.oliveLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: _isHovered ? Colors.white : SiteConfig.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: SiteConfig.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: GoogleFonts.sourceSans3(
                fontSize: 15,
                color: SiteConfig.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Pattern painter pour le fond du hero
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dessiner des lignes diagonales subtiles
    for (int i = -20; i < 40; i++) {
      final startX = i * 60.0;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
