import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/site_config.dart';
import '../models/blog_post.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  /// Récupérer tous les articles publiés du vendeur
  static Future<List<BlogPost>> getBlogPosts() async {
    final response = await client
        .from('blog_posts')
        .select()
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('status', 'published')
        .order('published_at', ascending: false);

    return (response as List)
        .map((json) => BlogPost.fromJson(json))
        .toList();
  }

  /// Récupérer un article par slug
  static Future<BlogPost?> getBlogPostBySlug(String slug) async {
    final response = await client
        .from('blog_posts')
        .select()
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('slug', slug)
        .eq('status', 'published')
        .maybeSingle();

    if (response == null) return null;
    return BlogPost.fromJson(response);
  }

  /// Récupérer les articles par catégorie
  static Future<List<BlogPost>> getBlogPostsByCategory(String category) async {
    final response = await client
        .from('blog_posts')
        .select()
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('status', 'published')
        .eq('category', category)
        .order('published_at', ascending: false);

    return (response as List)
        .map((json) => BlogPost.fromJson(json))
        .toList();
  }
}
