import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/site_config.dart';

class Navbar extends StatefulWidget {
  final bool transparent;

  const Navbar({super.key, this.transparent = false});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;
    final isTablet = screenWidth > 600 && screenWidth <= 1100;
    final isSmallMobile = screenWidth < 400;
    final bgColor = widget.transparent
        ? Colors.transparent
        : SiteConfig.surfaceColor.withOpacity(0.95);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : (isTablet ? 30 : 16),
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: widget.transparent
            ? null
            : Border(
                bottom: BorderSide(
                  color: SiteConfig.primaryColor.withOpacity(0.08),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () => context.go('/'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: SiteConfig.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🌿', style: TextStyle(fontSize: 20)),
                  ),
                ),
                if (!isSmallMobile) ...[
                  const SizedBox(width: 10),
                  Text(
                    SiteConfig.businessName,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: isDesktop ? 20 : 17,
                      fontWeight: FontWeight.w700,
                      color: widget.transparent ? Colors.white : SiteConfig.textColor,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          if (isDesktop) ...[
            _NavLink(
              label: 'Accueil',
              path: '/',
              transparent: widget.transparent,
            ),
            _NavLink(
              label: 'Notre Histoire',
              path: '/notre-histoire',
              transparent: widget.transparent,
            ),
            _NavLink(
              label: 'Blog',
              path: '/blog',
              transparent: widget.transparent,
            ),
            _NavLink(
              label: 'Recettes',
              path: '/recettes',
              transparent: widget.transparent,
            ),
            _NavLink(
              label: 'Événements',
              path: '/evenements',
              transparent: widget.transparent,
            ),
            _NavLink(
              label: 'Contact',
              path: '/contact',
              transparent: widget.transparent,
            ),
            const SizedBox(width: 24),
            _OrderButton(
              transparent: widget.transparent,
              compact: false,
              iconOnly: false,
            ),
          ] else ...[
            _OrderButton(
              transparent: widget.transparent,
              compact: isTablet,
              iconOnly: isSmallMobile,
            ),
            const SizedBox(width: 8),
            _MobileMenuButton(transparent: widget.transparent),
          ],
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String path;
  final bool transparent;

  const _NavLink({
    required this.label,
    required this.path,
    this.transparent = false,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isActive = currentPath == widget.path;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.sourceSans3(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: widget.transparent
                      ? (isActive ? Colors.white : Colors.white70)
                      : (isActive ? SiteConfig.primaryColor : SiteConfig.textSecondary),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isActive ? 24 : (_isHovered ? 16 : 0),
                decoration: BoxDecoration(
                  color: widget.transparent
                      ? SiteConfig.goldAccent
                      : SiteConfig.primaryColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderButton extends StatefulWidget {
  final bool transparent;
  final bool compact;
  final bool iconOnly;

  const _OrderButton({this.transparent = false, this.compact = false, this.iconOnly = false});

  @override
  State<_OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<_OrderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse(SiteConfig.storeUrl),
          webOnlyWindowName: '_self',
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: widget.iconOnly ? 14 : (widget.compact ? 20 : 28),
            vertical: widget.iconOnly ? 14 : (widget.compact ? 12 : 14),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [
                      SiteConfig.secondaryColor,
                      SiteConfig.accentColor,
                    ]
                  : [
                      SiteConfig.primaryColor,
                      SiteConfig.primaryColor.withOpacity(0.9),
                    ],
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: (_isHovered ? SiteConfig.secondaryColor : SiteConfig.primaryColor)
                    .withOpacity(0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: widget.iconOnly
              ? const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 20,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.compact ? 'Boutique' : 'Boutique en ligne',
                      style: GoogleFonts.sourceSans3(
                        fontSize: widget.compact ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final bool transparent;

  const _MobileMenuButton({this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu_rounded,
        color: transparent ? Colors.white : SiteConfig.textColor,
        size: 28,
      ),
      onPressed: () => _showMobileMenu(context),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: SiteConfig.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SiteConfig.textLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            _MobileMenuItem(
              icon: Icons.home_rounded,
              label: 'Accueil',
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            _MobileMenuItem(
              icon: Icons.auto_stories_rounded,
              label: 'Notre Histoire',
              onTap: () {
                Navigator.pop(context);
                context.go('/notre-histoire');
              },
            ),
            _MobileMenuItem(
              icon: Icons.article_rounded,
              label: 'Blog',
              onTap: () {
                Navigator.pop(context);
                context.go('/blog');
              },
            ),
            _MobileMenuItem(
              icon: Icons.restaurant_menu_rounded,
              label: 'Carnet de Saveurs',
              onTap: () {
                Navigator.pop(context);
                context.go('/recettes');
              },
            ),
            _MobileMenuItem(
              icon: Icons.event_rounded,
              label: 'Événements',
              onTap: () {
                Navigator.pop(context);
                context.go('/evenements');
              },
            ),
            _MobileMenuItem(
              icon: Icons.mail_rounded,
              label: 'Contact',
              onTap: () {
                Navigator.pop(context);
                context.go('/contact');
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  launchUrl(
                    Uri.parse(SiteConfig.storeUrl),
                    webOnlyWindowName: '_self',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SiteConfig.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Découvrir la boutique',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MobileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: SiteConfig.oliveLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: SiteConfig.primaryColor, size: 22),
      ),
      title: Text(
        label,
        style: GoogleFonts.sourceSans3(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: SiteConfig.textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: SiteConfig.textLight,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
