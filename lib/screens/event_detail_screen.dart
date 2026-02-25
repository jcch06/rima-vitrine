import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import '../config/site_config.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/event_registration_dialog.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? _event;
  bool _isLoading = true;
  int? _registrationCount;

  bool get _isFull =>
      _event?.maxCapacity != null &&
      _registrationCount != null &&
      _registrationCount! >= _event!.maxCapacity!;

  int? get _placesRestantes =>
      (_event?.maxCapacity != null && _registrationCount != null)
          ? _event!.maxCapacity! - _registrationCount!
          : null;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    await initializeDateFormatting('fr_FR', null);
    try {
      final event = await SupabaseService.getEventById(widget.eventId);
      if (mounted) {
        setState(() {
          _event = event;
          _isLoading = false;
        });
      }
      if (event != null && event.maxCapacity != null) {
        _loadRegistrationCount(event.id);
      }
    } catch (e) {
      debugPrint('[EVENT_DETAIL] Error loading event: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadRegistrationCount(String eventId) async {
    try {
      final count =
          await SupabaseService.getEventRegistrationCount(eventId);
      if (mounted) {
        setState(() => _registrationCount = count);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),

            if (_isLoading)
              const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_event == null)
              SizedBox(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_outlined,
                        size: 48,
                        color: SiteConfig.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Événement introuvable',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 24,
                          color: SiteConfig.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _BackButton(onTap: () => context.go('/')),
                    ],
                  ),
                ),
              )
            else ...[
              // Hero banner
              _buildHeroBanner(isDesktop),
              // Content
              _buildContent(isDesktop),
            ],

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(bool isDesktop) {
    final double bannerHeight = isDesktop ? 420 : 280;

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image or gradient
          if (_event!.imageUrl != null && _event!.imageUrl!.isNotEmpty)
            Image.network(
              _event!.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildGradientBanner(),
            )
          else
            _buildGradientBanner(),

          // Dark overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Date badge top-left
          Positioned(
            top: 24,
            left: isDesktop ? 80 : 24,
            child: _buildDateBadge(),
          ),

          // Relative time badge top-right
          Positioned(
            top: 28,
            right: isDesktop ? 80 : 24,
            child: _buildRelativeTimeBadge(),
          ),

          // Title overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 24,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_event!.status == 'cancelled')
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'ANNULÉ',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  Text(
                    _event!.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: isDesktop ? 52 : 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SiteConfig.primaryColor.withOpacity(0.9),
            SiteConfig.primaryColor,
            const Color(0xFF1E3D2A),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _BannerPatternPainter(),
          ),
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SiteConfig.goldAccent.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge() {
    final day = _event!.dateStart.day.toString();
    final month = DateFormat('MMM', 'fr_FR').format(_event!.dateStart).toUpperCase();

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: SiteConfig.primaryColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            month,
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: SiteConfig.goldAccent,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelativeTimeBadge() {
    final label = _getRelativeTimeLabel(_event!.dateStart);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.sourceSans3(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDesktop) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40 : 24,
          vertical: isDesktop ? 60 : 40,
        ),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main content
                  Expanded(flex: 3, child: _buildMainContent(isDesktop)),
                  const SizedBox(width: 40),
                  // Sidebar info
                  Expanded(flex: 2, child: _buildSidebar()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCards(),
                  const SizedBox(height: 32),
                  _buildMainContent(isDesktop),
                ],
              ),
      ),
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back link
        _BackButton(onTap: () => context.go('/')),
        const SizedBox(height: 32),

        // Date & time section
        _buildDateTimeSection(isDesktop),
        const SizedBox(height: 36),

        // Description
        if (_event!.description != null && _event!.description!.isNotEmpty) ...[
          Text(
            'À propos',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _event!.description!,
            style: GoogleFonts.sourceSans3(
              fontSize: 17,
              color: SiteConfig.textSecondary,
              height: 1.8,
            ),
          ),
        ],

        // Registration button
        const SizedBox(height: 36),
        _buildRegistrationButton(),
      ],
    );
  }

  Widget _buildRegistrationButton() {
    if (_isFull) {
      return _FullBadgeButton();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RegisterButton(
          onPressed: () => showEventRegistrationDialog(context, _event!),
        ),
        if (_placesRestantes != null) ...[
          const SizedBox(height: 10),
          Text(
            '$_placesRestantes place${_placesRestantes! > 1 ? 's' : ''} restante${_placesRestantes! > 1 ? 's' : ''}',
            style: GoogleFonts.sourceSans3(
              fontSize: 14,
              color: SiteConfig.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeSection(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SiteConfig.oliveLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: SiteConfig.primaryColor),
              const SizedBox(width: 10),
              Text(
                'Date & Horaire',
                style: GoogleFonts.sourceSans3(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SiteConfig.primaryColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _formatFullDate(_event!.dateStart),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'à ${DateFormat('HH\'h\'mm', 'fr_FR').format(_event!.dateStart)}',
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              color: SiteConfig.textSecondary,
            ),
          ),
          if (_event!.dateEnd != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 1,
                  color: SiteConfig.goldAccent.withOpacity(0.4),
                ),
                const SizedBox(width: 8),
                Text(
                  'jusqu\'au',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 13,
                    color: SiteConfig.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 1,
                  color: SiteConfig.goldAccent.withOpacity(0.4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _formatFullDate(_event!.dateEnd!),
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: SiteConfig.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'à ${DateFormat('HH\'h\'mm', 'fr_FR').format(_event!.dateEnd!)}',
              style: GoogleFonts.sourceSans3(
                fontSize: 16,
                color: SiteConfig.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        const SizedBox(height: 64), // align with content after back button
        _buildInfoCards(),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        // Location
        if (_event!.location != null && _event!.location!.isNotEmpty)
          _DetailInfoCard(
            icon: Icons.location_on_outlined,
            label: 'LIEU',
            value: _event!.location!,
            accentColor: SiteConfig.primaryColor,
          ),

        // Capacity
        if (_event!.maxCapacity != null) ...[
          const SizedBox(height: 16),
          _DetailInfoCard(
            icon: Icons.people_outline,
            label: 'CAPACITÉ',
            value: _placesRestantes != null
                ? '$_placesRestantes / ${_event!.maxCapacity} places'
                : '${_event!.maxCapacity} places',
            accentColor: _isFull ? SiteConfig.textLight : SiteConfig.accentColor,
          ),
        ],

        // Price
        const SizedBox(height: 16),
        _DetailInfoCard(
          icon: (_event!.price == null || _event!.price == 0)
              ? Icons.celebration_outlined
              : Icons.euro_outlined,
          label: 'TARIF',
          value: (_event!.price == null || _event!.price == 0)
              ? 'Gratuit'
              : '${_event!.price!.toStringAsFixed(2)} €',
          accentColor: SiteConfig.goldAccent,
        ),
      ],
    );
  }

  // ============================================
  // HELPERS
  // ============================================

  String _formatFullDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }

  String _getRelativeTimeLabel(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays == 0) {
      if (diff.isNegative) return 'En cours';
      return 'Aujourd\'hui';
    } else if (diff.inDays == 1) {
      return 'Demain';
    } else if (diff.inDays == 2) {
      return 'Après-demain';
    } else if (diff.inDays < 7) {
      return 'Dans ${diff.inDays} jours';
    } else if (diff.inDays < 14) {
      return 'La semaine prochaine';
    } else if (diff.inDays < 30) {
      return 'Dans ${(diff.inDays / 7).floor()} semaines';
    } else {
      return 'Dans ${(diff.inDays / 30).floor()} mois';
    }
  }
}

// ============================================
// REGISTER BUTTON
// ============================================

class _RegisterButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _RegisterButton({required this.onPressed});

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [SiteConfig.secondaryColor, SiteConfig.accentColor]
                  : [
                      SiteConfig.primaryColor,
                      SiteConfig.primaryColor.withOpacity(0.9)
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isHovered
                        ? SiteConfig.secondaryColor
                        : SiteConfig.primaryColor)
                    .withOpacity(0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'S\'inscrire à cet événement',
                style: GoogleFonts.sourceSans3(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.how_to_reg_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// FULL BADGE BUTTON (disabled state)
// ============================================

class _FullBadgeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: SiteConfig.textLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Complet',
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: SiteConfig.textLight,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.event_busy_rounded,
            color: SiteConfig.textLight,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ============================================
// DETAIL INFO CARD
// ============================================

class _DetailInfoCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _DetailInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  State<_DetailInfoCard> createState() => _DetailInfoCardState();
}

class _DetailInfoCardState extends State<_DetailInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 24 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.accentColor
                    : widget.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                widget.icon,
                size: 22,
                color: _isHovered ? Colors.white : widget.accentColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: SiteConfig.textLight,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SiteConfig.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// BACK BUTTON
// ============================================

class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: _isHovered ? const Offset(-0.15, 0) : Offset.zero,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: _isHovered ? SiteConfig.primaryColor : SiteConfig.textLight,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Retour à l\'accueil',
              style: GoogleFonts.sourceSans3(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isHovered ? SiteConfig.primaryColor : SiteConfig.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// PATTERN PAINTER
// ============================================

class _BannerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = -10; i < 30; i++) {
      final startX = i * 50.0;
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
