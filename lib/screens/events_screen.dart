import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../config/site_config.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> _events = [];
  bool _isLoading = true;

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
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[EVENTS_SCREEN] Error loading events: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            _buildHeader(isDesktop),
            _buildEventsSection(isDesktop),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
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
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: SiteConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: SiteConfig.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: SiteConfig.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'ÉVÉNEMENTS',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SiteConfig.primaryColor,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nos événements\nà venir',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 52 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Dégustations, ateliers cuisine et rencontres autour des saveurs du Liban',
              style: GoogleFonts.sourceSans3(
                fontSize: isDesktop ? 18 : 16,
                color: SiteConfig.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 80 : 48,
      ),
      child: _isLoading
          ? _buildLoadingState()
          : _events.isEmpty
              ? _buildEmptyState(isDesktop)
              : _buildEventsGrid(isDesktop),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(SiteConfig.primaryColor),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chargement des événements...',
              style: GoogleFonts.sourceSans3(
                fontSize: 16,
                color: SiteConfig.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 100 : 60),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: SiteConfig.oliveLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.event_outlined,
                size: 48,
                color: SiteConfig.primaryColor.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Aucun événement pour le moment',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'De nouveaux événements seront bientôt annoncés.\nRevenez nous voir !',
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

  Widget _buildEventsGrid(bool isDesktop) {
    if (isDesktop) {
      final List<Widget> rows = [];
      for (int i = 0; i < _events.length; i += 2) {
        final first = _events[i];
        final second = (i + 1 < _events.length) ? _events[i + 1] : null;

        rows.add(
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < _events.length ? 32 : 0),
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

    return Column(
      children: _events.asMap().entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: entry.key < _events.length - 1 ? 24 : 0,
          ),
          child: _EventCard(event: entry.value, isDesktop: false),
        );
      }).toList(),
    );
  }
}

// ============================================
// EVENT CARD (mirrors EventsSection card)
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
      child: GestureDetector(
        onTap: () => context.go('/evenements/${widget.event.id}'),
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
                _buildImageBanner(),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRelativeTime(),
                      const SizedBox(height: 12),
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
                      _buildDateRange(),
                      if (widget.event.description != null &&
                          widget.event.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDescription(),
                      ],
                      const SizedBox(height: 20),
                      _buildInfoChips(),
                      const SizedBox(height: 24),
                      _buildCtaButton(),
                    ],
                  ),
                ),
              ],
            ),
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
          if (widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty)
            Image.network(
              widget.event.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildGradientPlaceholder(),
            )
          else
            _buildGradientPlaceholder(),
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
    final now = DateTime.now();
    final diff = widget.event.dateStart.difference(now);
    String label;

    if (diff.inDays == 0) {
      label = diff.isNegative ? 'En cours' : 'Aujourd\'hui';
    } else if (diff.inDays == 1) {
      label = 'Demain';
    } else if (diff.inDays == 2) {
      label = 'Après-demain';
    } else if (diff.inDays < 7) {
      label = 'Dans ${diff.inDays} jours';
    } else if (diff.inDays < 14) {
      label = 'La semaine prochaine';
    } else if (diff.inDays < 30) {
      label = 'Dans ${(diff.inDays / 7).floor()} semaines';
    } else {
      label = 'Dans ${(diff.inDays / 30).floor()} mois';
    }

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
    String format(DateTime d) => DateFormat('d MMM HH\'h\'mm', 'fr_FR').format(d);
    final startFormatted = format(widget.event.dateStart);

    if (widget.event.dateEnd != null) {
      final endFormatted = format(widget.event.dateEnd!);
      return Row(
        children: [
          Icon(Icons.schedule_outlined, size: 15, color: SiteConfig.textLight),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '$startFormatted  \u2192  $endFormatted',
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
        Icon(Icons.schedule_outlined, size: 15, color: SiteConfig.textLight),
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
        if (widget.event.location != null && widget.event.location!.isNotEmpty)
          _buildChip(Icons.location_on_outlined, widget.event.location!),
        if (widget.event.maxCapacity != null)
          _buildChip(Icons.people_outline, '${widget.event.maxCapacity} places'),
        _buildPriceChip(),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: SiteConfig.backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: SiteConfig.textLight.withOpacity(0.15)),
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

  Widget _buildPriceChip() {
    final isFree = widget.event.price == null || widget.event.price == 0;

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
            isFree ? 'Gratuit' : '${widget.event.price!.toStringAsFixed(2)} \u20ac',
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

  Widget _buildCtaButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: SiteConfig.primaryColor.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Plus d\'infos',
            style: GoogleFonts.sourceSans3(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: SiteConfig.primaryColor,
          ),
        ],
      ),
    );
  }
}
