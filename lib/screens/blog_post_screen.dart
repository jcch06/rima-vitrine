import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../config/site_config.dart';
import '../models/blog_post.dart';
import '../services/supabase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class BlogPostScreen extends StatefulWidget {
  final String slug;

  const BlogPostScreen({super.key, required this.slug});

  @override
  State<BlogPostScreen> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  BlogPost? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    try {
      final post = await SupabaseService.getBlogPostBySlug(widget.slug);
      if (mounted) {
        setState(() {
          _post = post;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[BLOG_POST_SCREEN] Error loading post: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

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
            else if (_post == null)
              const SizedBox(
                height: 400,
                child: Center(child: Text('Article introuvable')),
              )
            else ...[
              // Header image
              if (_post!.featuredImage != null)
                Container(
                  width: double.infinity,
                  height: isDesktop ? 400 : 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_post!.featuredImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              // Content
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 24,
                    vertical: 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_post!.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: SiteConfig.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _post!.category!,
                            style: TextStyle(
                              color: SiteConfig.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _post!.title,
                        style: TextStyle(
                          fontSize: isDesktop ? 42 : 28,
                          fontWeight: FontWeight.bold,
                          color: SiteConfig.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_post!.publishedAt != null)
                        Text(
                          'Publié le ${_formatDate(_post!.publishedAt!)}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      const SizedBox(height: 40),
                      MarkdownBody(
                        data: _post!.content,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            color: Colors.grey.shade800,
                          ),
                          h2: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: SiteConfig.textColor,
                          ),
                          h3: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: SiteConfig.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Footer(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
