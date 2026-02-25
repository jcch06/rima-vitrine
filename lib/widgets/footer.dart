import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/site_config.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SiteConfig.textColor,
            SiteConfig.textColor.withOpacity(0.95),
          ],
        ),
      ),
      child: Column(
        children: [
          // Décoration supérieure - motif méditerranéen
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SiteConfig.primaryColor,
                  SiteConfig.goldAccent,
                  SiteConfig.accentColor,
                  SiteConfig.goldAccent,
                  SiteConfig.primaryColor,
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 32,
              vertical: 60,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo et description
                      Expanded(flex: 2, child: _buildBrandSection()),
                      const SizedBox(width: 60),
                      // Navigation
                      Expanded(child: _buildNavSection(context)),
                      const SizedBox(width: 40),
                      // Contact
                      Expanded(flex: 2, child: _buildContactSection()),
                    ],
                  )
                : Column(
                    children: [
                      _buildBrandSection(),
                      const SizedBox(height: 40),
                      _buildContactSection(),
                      const SizedBox(height: 32),
                      _buildSocialSection(),
                    ],
                  ),
          ),

          // Copyright
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 32,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '© ${DateTime.now().year} ${SiteConfig.businessName}',
                    style: GoogleFonts.sourceSans3(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Propulsé par ',
                      style: GoogleFonts.sourceSans3(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Paniero',
                      style: GoogleFonts.sourceSans3(
                        color: SiteConfig.goldAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SiteConfig.primaryColor,
                    SiteConfig.primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🌿', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SiteConfig.businessName,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Épicerie Fine Libanaise',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: SiteConfig.goldAccent,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Les saveurs authentiques du Liban, sélectionnées avec passion et livrées chez vous.',
          style: GoogleFonts.sourceSans3(
            fontSize: 15,
            color: Colors.white60,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildNavSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NAVIGATION',
          style: GoogleFonts.sourceSans3(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SiteConfig.goldAccent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        _FooterNavLink(label: 'Accueil', path: '/'),
        _FooterNavLink(label: 'Notre Histoire', path: '/notre-histoire'),
        _FooterNavLink(label: 'Carnet de Saveurs', path: '/blog'),
        _FooterNavLink(label: 'Contact', path: '/contact'),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT',
          style: GoogleFonts.sourceSans3(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SiteConfig.goldAccent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        _FooterContactItem(
          icon: Icons.location_on_outlined,
          text: SiteConfig.address,
          onTap: () => launchUrl(Uri.parse(SiteConfig.googleMapsUrl)),
        ),
        const SizedBox(height: 16),
        _FooterContactItem(
          icon: Icons.phone_outlined,
          text: SiteConfig.phone,
          onTap: () => launchUrl(Uri.parse('tel:${SiteConfig.phone}')),
        ),
        const SizedBox(height: 16),
        _FooterContactItem(
          icon: Icons.email_outlined,
          text: SiteConfig.email,
          onTap: () => launchUrl(Uri.parse('mailto:${SiteConfig.email}')),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Row(
      children: [
        if (SiteConfig.instagram != null)
          _SocialButton(
            icon: Icons.camera_alt_outlined,
            onTap: () => launchUrl(Uri.parse(SiteConfig.instagram!)),
          ),
        if (SiteConfig.facebook != null) ...[
          const SizedBox(width: 12),
          _SocialButton(
            icon: Icons.facebook_outlined,
            onTap: () => launchUrl(Uri.parse(SiteConfig.facebook!)),
          ),
        ],
      ],
    );
  }
}

class _FooterNavLink extends StatefulWidget {
  final String label;
  final String path;

  const _FooterNavLink({required this.label, required this.path});

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {}, // Navigation handled by go_router if needed
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isHovered ? 16 : 0,
                height: 1,
                color: SiteConfig.goldAccent,
                margin: EdgeInsets.only(right: _isHovered ? 8 : 0),
              ),
              Text(
                widget.label,
                style: GoogleFonts.sourceSans3(
                  fontSize: 15,
                  color: _isHovered ? Colors.white : Colors.white60,
                  fontWeight: _isHovered ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterContactItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _FooterContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<_FooterContactItem> createState() => _FooterContactItemState();
}

class _FooterContactItemState extends State<_FooterContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isHovered
                    ? SiteConfig.primaryColor.withOpacity(0.3)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                size: 18,
                color: _isHovered ? SiteConfig.goldAccent : Colors.white54,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.text,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 15,
                    color: _isHovered ? Colors.white : Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _isHovered
                ? SiteConfig.primaryColor
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? SiteConfig.primaryColor
                  : Colors.white.withOpacity(0.15),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
