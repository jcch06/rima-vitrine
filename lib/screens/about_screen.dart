import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/site_config.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),

            // Hero Section
            _buildHeroSection(isDesktop),

            // Story Section
            _buildStorySection(isDesktop),

            // Values Section
            _buildValuesSection(isDesktop),

            // Timeline Section
            _buildTimelineSection(isDesktop),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop) {
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
            SiteConfig.oliveLight,
            SiteConfig.backgroundColor,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'NOTRE HISTOIRE',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            SiteConfig.aboutSubtitle,
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 52 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Decorative line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 1,
                color: SiteConfig.goldAccent.withOpacity(0.5),
              ),
              const SizedBox(width: 16),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: SiteConfig.goldAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 1,
                color: SiteConfig.goldAccent.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 28,
        vertical: isDesktop ? 100 : 60,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Expanded(
                  child: _buildImageSection(),
                ),
                const SizedBox(width: 80),
                // Text content
                Expanded(
                  child: _buildTextContent(isDesktop),
                ),
              ],
            )
          : Column(
              children: [
                _buildImageSection(),
                const SizedBox(height: 48),
                _buildTextContent(isDesktop),
              ],
            ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SiteConfig.primaryColor.withOpacity(0.1),
            SiteConfig.terracottaLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: SiteConfig.primaryColor.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: SiteConfig.goldAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SiteConfig.accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🌳',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 20),
                Text(
                  'Le Cèdre du Liban',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: SiteConfig.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(bool isDesktop) {
    final paragraphs = SiteConfig.aboutContent.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quote
        Container(
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: SiteConfig.goldAccent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            '"La cuisine, c\'est l\'art de transformer\nl\'amour en saveurs."',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 28 : 24,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 48),
        ...paragraphs.map((paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                paragraph.trim(),
                style: GoogleFonts.sourceSans3(
                  fontSize: isDesktop ? 17 : 16,
                  color: SiteConfig.textSecondary,
                  height: 1.8,
                ),
              ),
            )),
      ],
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
        color: SiteConfig.cardColor,
      ),
      child: Column(
        children: [
          Text(
            'NOS VALEURS',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ce qui nous définit',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 42 : 28,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _ValueCard(
                icon: '🫒',
                title: 'Terroir',
                description:
                    'Chaque produit raconte l\'histoire de sa terre d\'origine, du Mont-Liban à la vallée de la Bekaa.',
                isDesktop: isDesktop,
              ),
              _ValueCard(
                icon: '👨‍🍳',
                title: 'Artisanat',
                description:
                    'Nous travaillons exclusivement avec des producteurs qui perpétuent des savoir-faire ancestraux.',
                isDesktop: isDesktop,
              ),
              _ValueCard(
                icon: '💚',
                title: 'Durabilité',
                description:
                    'Des pratiques respectueuses de l\'environnement, de la production jusqu\'à la livraison.',
                isDesktop: isDesktop,
              ),
              _ValueCard(
                icon: '🤝',
                title: 'Partage',
                description:
                    'La cuisine libanaise est faite pour être partagée. C\'est cette convivialité que nous vous transmettons.',
                isDesktop: isDesktop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 28,
        vertical: isDesktop ? 100 : 60,
      ),
      child: Column(
        children: [
          Text(
            'NOTRE PARCOURS',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Les étapes de notre aventure',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 42 : 28,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _TimelineItem(
            year: '2018',
            title: 'L\'idée germe',
            description:
                'Lors d\'un voyage au Liban, naît l\'envie de partager ces saveurs avec la France.',
            isLeft: true,
            isDesktop: isDesktop,
          ),
          _TimelineItem(
            year: '2019',
            title: 'Première sélection',
            description:
                'Rencontre avec nos premiers producteurs partenaires dans la montagne libanaise.',
            isLeft: false,
            isDesktop: isDesktop,
          ),
          _TimelineItem(
            year: '2021',
            title: 'Ouverture en ligne',
            description:
                'Lancement de notre boutique en ligne pour partager nos trésors avec toute la France.',
            isLeft: true,
            isDesktop: isDesktop,
          ),
          _TimelineItem(
            year: '2024',
            title: 'Et demain...',
            description:
                'Toujours plus de découvertes, toujours plus de saveurs à vous faire découvrir.',
            isLeft: false,
            isDesktop: isDesktop,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatefulWidget {
  final String icon;
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isDesktop ? 260 : 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.icon,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
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
              fontSize: 16,
              color: SiteConfig.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final bool isLeft;
  final bool isDesktop;
  final bool isLast;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.description,
    required this.isLeft,
    required this.isDesktop,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return _buildMobileItem();
    }
    return _buildDesktopItem();
  }

  Widget _buildDesktopItem() {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left content
          Expanded(
            child: isLeft ? _buildContent() : const SizedBox(),
          ),
          // Center line
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: SiteConfig.goldAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SiteConfig.goldAccent.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: SiteConfig.oliveLight,
                  ),
                ),
            ],
          ),
          // Right content
          Expanded(
            child: !isLeft ? _buildContent() : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: SiteConfig.goldAccent,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 100,
                  color: SiteConfig.oliveLight,
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 0),
      margin: EdgeInsets.only(bottom: isDesktop ? 20 : 0),
      child: Column(
        crossAxisAlignment:
            isDesktop && !isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SiteConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              year,
              style: GoogleFonts.sourceSans3(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SiteConfig.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              color: SiteConfig.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
