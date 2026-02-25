import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import '../config/site_config.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  List<Event>? _events;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await initializeDateFormatting('fr_FR', null);
    try {
      final events = await SupabaseService.getUpcomingEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _loaded = true;
        });
      }
    } catch (e) {
      debugPrint('[EVENTS] Error loading events: $e');
      if (mounted) {
        setState(() {
          _events = [];
          _loaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ne pas afficher la section si pas encore chargé ou aucun événement
    if (!_loaded || _events == null || _events!.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 28,
        vertical: isDesktop ? 100 : 60,
      ),
      decoration: BoxDecoration(
        color: SiteConfig.oliveLight.withOpacity(0.3),
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(isDesktop),
          SizedBox(height: isDesktop ? 60 : 40),
          // Events grid
          _buildEventsGrid(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDesktop) {
    return Column(
      children: [
        // Label
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color: SiteConfig.primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              'ÉVÉNEMENTS À VENIR',
              style: GoogleFonts.sourceSans3(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SiteConfig.primaryColor,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Title
        Text(
          'Retrouvez-nous\nbientôt',
          style: GoogleFonts.cormorantGaramond(
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.w500,
            color: SiteConfig.textColor,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Decorative divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 1,
              color: SiteConfig.goldAccent.withOpacity(0.4),
            ),
            const SizedBox(width: 12),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: SiteConfig.goldAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 1,
              color: SiteConfig.goldAccent.withOpacity(0.4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventsGrid(bool isDesktop, bool isTablet) {
    if (isDesktop) {
      // Desktop: grille 2 colonnes style magazine
      final List<Widget> rows = [];
      for (int i = 0; i < _events!.length; i += 2) {
        final first = _events![i];
        final second = (i + 1 < _events!.length) ? _events![i + 1] : null;

        rows.add(
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < _events!.length ? 32 : 0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _EventCard(event: first, isDesktop: true),
                  ),
                  if (second != null) ...[
                    const SizedBox(width: 32),
                    Expanded(
                      child: _EventCard(event: second, isDesktop: true),
                    ),
                  ] else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        );
      }
      return Column(children: rows);
    }

    // Mobile / Tablet: cartes empilées
    return Column(
      children: _events!.asMap().entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: entry.key < _events!.length - 1 ? 24 : 0,
          ),
          child: _EventCard(event: entry.value, isDesktop: false),
        );
      }).toList(),
    );
  }
}

// ============================================
// EVENT CARD
// ============================================

class _EventCard extends StatefulWidget {
  final Event event;
  final bool isDesktop;

  const _EventCard({required this.event, required this.isDesktop});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _isHovered = false;
  bool _descriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: SiteConfig.primaryColor.withOpacity(_isHovered ? 0.12 : 0.06),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 16 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image banner with date overlay
              _buildImageBanner(),
              // Content
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Relative time indicator
                    _buildRelativeTime(),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      widget.event.title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: SiteConfig.textColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date range
                    _buildDateRange(),
                    // Description
                    if (widget.event.description != null &&
                        widget.event.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildDescription(),
                    ],
                    const SizedBox(height: 20),
                    // Info chips
                    _buildInfoChips(),
                    const SizedBox(height: 24),
                    // CTA button
                    _buildCtaButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBanner() {
    const double bannerHeight = 220;

    return SizedBox(
      height: bannerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image or gradient placeholder
          if (widget.event.imageUrl != null &&
              widget.event.imageUrl!.isNotEmpty)
            Image.network(
              widget.event.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildGradientPlaceholder(),
            )
          else
            _buildGradientPlaceholder(),

          // Subtle dark overlay for contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.15),
                  ],
                ),
              ),
            ),
          ),

          // Date badge — calendar style, top left
          Positioned(
            top: 20,
            left: 20,
            child: _buildDateBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SiteConfig.primaryColor.withOpacity(0.85),
            SiteConfig.primaryColor,
            const Color(0xFF1E3D2A),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative pattern
          CustomPaint(
            size: const Size(double.infinity, 220),
            painter: _EventPatternPainter(),
          ),
          // Decorative circle
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SiteConfig.goldAccent.withOpacity(0.08),
              ),
            ),
          ),
          // Calendar icon centered
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_outlined,
                size: 40,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge() {
    final day = widget.event.dateStart.day.toString();
    final month = DateFormat('MMM', 'fr_FR').format(widget.event.dateStart).toUpperCase();

    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
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
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: SiteConfig.primaryColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            month,
            style: GoogleFonts.sourceSans3(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: SiteConfig.goldAccent,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelativeTime() {
    final label = _getRelativeTimeLabel(widget.event.dateStart);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SiteConfig.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.sourceSans3(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SiteConfig.primaryColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildDateRange() {
    final startFormatted = _formatEventDate(widget.event.dateStart);

    if (widget.event.dateEnd != null) {
      final endFormatted = _formatEventDate(widget.event.dateEnd!);
      return Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 15,
            color: SiteConfig.textLight,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '$startFormatted  →  $endFormatted',
              style: GoogleFonts.sourceSans3(
                fontSize: 14,
                color: SiteConfig.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          Icons.schedule_outlined,
          size: 15,
          color: SiteConfig.textLight,
        ),
        const SizedBox(width: 6),
        Text(
          startFormatted,
          style: GoogleFonts.sourceSans3(
            fontSize: 14,
            color: SiteConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.event.description!,
          maxLines: _descriptionExpanded ? 100 : 3,
          overflow: _descriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: SiteConfig.textSecondary,
            height: 1.7,
          ),
        ),
        if (widget.event.description!.length > 120 && !_descriptionExpanded)
          GestureDetector(
            onTap: () => setState(() => _descriptionExpanded = true),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Voir plus',
                style: GoogleFonts.sourceSans3(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SiteConfig.primaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (widget.event.location != null &&
            widget.event.location!.isNotEmpty)
          _InfoChip(
            icon: Icons.location_on_outlined,
            label: widget.event.location!,
          ),
        if (widget.event.maxCapacity != null)
          _InfoChip(
            icon: Icons.people_outline,
            label: '${widget.event.maxCapacity} places',
          ),
        _PriceChip(price: widget.event.price),
      ],
    );
  }

  Widget _buildCtaButton() {
    return _EventCtaButton(
      label: 'Plus d\'infos',
      onTap: () {
        context.go('/evenements/${widget.event.id}');
      },
    );
  }

  // ============================================
  // HELPERS
  // ============================================

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

  String _formatEventDate(DateTime date) {
    return DateFormat('d MMM HH\'h\'mm', 'fr_FR').format(date);
  }
}

// ============================================
// INFO CHIP
// ============================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: SiteConfig.backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: SiteConfig.textLight.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: SiteConfig.textSecondary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.sourceSans3(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SiteConfig.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// PRICE CHIP
// ============================================

class _PriceChip extends StatelessWidget {
  final double? price;

  const _PriceChip({required this.price});

  @override
  Widget build(BuildContext context) {
    final isFree = price == null || price == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isFree
            ? SiteConfig.primaryColor.withOpacity(0.08)
            : SiteConfig.goldAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isFree
              ? SiteConfig.primaryColor.withOpacity(0.15)
              : SiteConfig.goldAccent.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFree ? Icons.celebration_outlined : Icons.euro_outlined,
            size: 14,
            color: isFree ? SiteConfig.primaryColor : SiteConfig.secondaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            isFree ? 'Gratuit' : '${price!.toStringAsFixed(2)} €',
            style: GoogleFonts.sourceSans3(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isFree ? SiteConfig.primaryColor : SiteConfig.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// CTA BUTTON
// ============================================

class _EventCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _EventCtaButton({required this.label, required this.onTap});

  @override
  State<_EventCtaButton> createState() => _EventCtaButtonState();
}

class _EventCtaButtonState extends State<_EventCtaButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _isHovered ? SiteConfig.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered
                  ? SiteConfig.primaryColor
                  : SiteConfig.primaryColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.sourceSans3(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? Colors.white : SiteConfig.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: _isHovered ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _isHovered ? Colors.white : SiteConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// PATTERN PAINTER (subtle background for placeholder)
// ============================================

class _EventPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = -10; i < 20; i++) {
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
