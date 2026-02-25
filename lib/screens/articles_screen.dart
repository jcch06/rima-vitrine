import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/site_config.dart';
import '../models/blog_post.dart';
import '../services/supabase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<BlogPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final allPosts = await SupabaseService.getBlogPosts();
      final articles = allPosts
          .where((p) =>
              p.category == null ||
              p.category!.toLowerCase() != 'recette')
          .toList();
      if (mounted) {
        setState(() {
          _posts = articles;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[ARTICLES_SCREEN] Error loading posts: $e');
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
              color: SiteConfig.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: SiteConfig.secondaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: SiteConfig.secondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'BLOG',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SiteConfig.secondaryColor,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Notre Blog',
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 52 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Actualités, conseils et découvertes autour de la culture libanaise',
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
              'Chargement des articles...',
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
              color: SiteConfig.terracottaLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.article_outlined,
                size: 48,
                color: SiteConfig.secondaryColor.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Les articles arrivent bientôt',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Notre blog est en préparation.\nRevenez vite pour découvrir nos articles !',
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600 && screenWidth <= 900;

    int crossAxisCount = 1;
    double childAspectRatio = 1.1;

    if (isDesktop) {
      crossAxisCount = 3;
      childAspectRatio = 0.75;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _posts.length,
      itemBuilder: (_, index) => _ArticleCard(
        post: _posts[index],
        index: index,
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  final BlogPost post;
  final int index;

  const _ArticleCard({required this.post, required this.index});

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/blog/${widget.post.slug}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: SiteConfig.primaryColor.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                          ),
                          child: Text(
                            widget.post.category!,
                            style: GoogleFonts.sourceSans3(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: SiteConfig.primaryColor,
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
                          'Lire l\'article',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: SiteConfig.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: SiteConfig.primaryColor,
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
    );
  }

  Widget _buildPlaceholder() {
    final colors = [
      SiteConfig.terracottaLight,
      SiteConfig.oliveLight,
      SiteConfig.goldAccent.withOpacity(0.2),
    ];

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
        child: Icon(
          Icons.article_outlined,
          size: 56,
          color: SiteConfig.secondaryColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
