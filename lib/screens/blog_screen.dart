import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/site_config.dart';
import '../models/blog_post.dart';
import '../services/supabase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<BlogPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await SupabaseService.getBlogPosts();
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[BLOG_SCREEN] Error loading posts: $e');
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

            // Hero Header
            _buildHeader(isDesktop),

            // Posts Grid
            _buildPostsSection(isDesktop),

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
            SiteConfig.terracottaLight,
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
              color: SiteConfig.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: SiteConfig.accentColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '📖',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  'CARNET DE SAVEURS',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SiteConfig.accentColor,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            SiteConfig.blogTitle,
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 52 : 36,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              SiteConfig.blogSubtitle,
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

  Widget _buildPostsSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 80 : 48,
      ),
      child: _isLoading
          ? _buildLoadingState()
          : _posts.isEmpty
              ? _buildEmptyState(isDesktop)
              : _buildPostsGrid(isDesktop),
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
              'Chargement des recettes...',
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
              child: Text(
                '🍽️',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Les recettes arrivent bientôt',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Notre carnet de saveurs est en préparation.\nRevenez vite pour découvrir nos recettes !',
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

  Widget _buildPostsGrid(bool isDesktop) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 1,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        childAspectRatio: isDesktop ? 0.75 : 1.1,
      ),
      itemCount: _posts.length,
      itemBuilder: (_, index) => _BlogCard(
        post: _posts[index],
        index: index,
      ),
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogPost post;
  final int index;

  const _BlogCard({required this.post, required this.index});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go('/blog/${widget.post.slug}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -8.0 : 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: SiteConfig.primaryColor
                    .withOpacity(_isHovered ? 0.15 : 0.06),
                blurRadius: _isHovered ? 40 : 24,
                offset: Offset(0, _isHovered ? 16 : 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.post.featuredImage != null
                          ? Image.network(
                              widget.post.featuredImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                      // Overlay gradient
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black
                                    .withOpacity(_isHovered ? 0.3 : 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Category badge
                      if (widget.post.category != null)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              widget.post.category!,
                              style: GoogleFonts.sourceSans3(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: SiteConfig.primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: SiteConfig.textColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      if (widget.post.excerpt != null)
                        Expanded(
                          child: Text(
                            widget.post.excerpt!,
                            style: GoogleFonts.sourceSans3(
                              fontSize: 14,
                              color: SiteConfig.textSecondary,
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      // Read more link
                      Row(
                        children: [
                          Text(
                            'Lire la recette',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: SiteConfig.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(
                              _isHovered ? 4 : 0,
                              0,
                              0,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: SiteConfig.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    // Different placeholder colors based on index
    final colors = [
      SiteConfig.oliveLight,
      SiteConfig.terracottaLight,
      SiteConfig.goldAccent.withOpacity(0.2),
    ];
    final emojis = ['🥗', '🍲', '🥙', '🧆', '🫓', '🍯'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[widget.index % colors.length],
            colors[(widget.index + 1) % colors.length],
          ],
        ),
      ),
      child: Center(
        child: Text(
          emojis[widget.index % emojis.length],
          style: TextStyle(fontSize: 56),
        ),
      ),
    );
  }
}
