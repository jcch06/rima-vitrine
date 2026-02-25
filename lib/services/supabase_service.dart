import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/site_config.dart';
import '../models/blog_post.dart';
import '../models/event.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static const String _eventColumns =
      'id, vendor_id, title, description, location, date_start, date_end, image_url, max_capacity, price, status, created_at';

  static const String _blogColumns =
      'id, vendor_id, title, slug, content, excerpt, featured_image, category, status, published_at, created_at, updated_at';

  /// Récupérer les événements actifs à venir du vendeur
  static Future<List<Event>> getUpcomingEvents() async {
    debugPrint('[SUPABASE] Fetching upcoming events for vendor: ${SiteConfig.vendorId}');

    // Utiliser le début de la journée UTC pour inclure les événements d'aujourd'hui
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final filterDate = todayStart.toIso8601String();
    debugPrint('[SUPABASE] Filter date_start >= $filterDate');

    final response = await client
        .from('events')
        .select(_eventColumns)
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('status', 'active')
        .gte('date_start', filterDate)
        .order('date_start', ascending: true);

    debugPrint('[SUPABASE] Found ${(response as List).length} upcoming events');

    return (response as List)
        .map((json) => Event.fromJson(json))
        .toList();
  }

  /// Récupérer un événement par son ID
  static Future<Event?> getEventById(String id) async {
    final response = await client
        .from('events')
        .select(_eventColumns)
        .eq('id', id)
        .eq('vendor_id', SiteConfig.vendorId)
        .maybeSingle();

    if (response == null) return null;
    return Event.fromJson(response);
  }

  /// Récupérer tous les articles publiés du vendeur
  static Future<List<BlogPost>> getBlogPosts() async {
    debugPrint('[SUPABASE] Fetching blog posts for vendor: ${SiteConfig.vendorId}');

    final response = await client
        .from('blog_posts')
        .select(_blogColumns)
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('status', 'published')
        .order('published_at', ascending: false);

    debugPrint('[SUPABASE] Response: $response');
    debugPrint('[SUPABASE] Found ${(response as List).length} posts');

    return (response as List)
        .map((json) => BlogPost.fromJson(json))
        .toList();
  }

  /// Récupérer un article par slug
  static Future<BlogPost?> getBlogPostBySlug(String slug) async {
    final response = await client
        .from('blog_posts')
        .select(_blogColumns)
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
        .select(_blogColumns)
        .eq('vendor_id', SiteConfig.vendorId)
        .eq('status', 'published')
        .eq('category', category)
        .order('published_at', ascending: false);

    return (response as List)
        .map((json) => BlogPost.fromJson(json))
        .toList();
  }

  /// Compter le nombre d'inscrits à un événement
  static Future<int> getEventRegistrationCount(String eventId) async {
    final response = await client
        .from('event_registrations')
        .select()
        .eq('event_id', eventId)
        .count(CountOption.exact);
    return response.count;
  }

  /// Inscrire un participant à un événement
  static Future<void> registerForEvent({
    required String eventId,
    required String name,
    required String email,
    String? phone,
  }) async {
    await client.from('event_registrations').insert({
      'event_id': eventId,
      'name': name,
      'email': email,
      'phone': phone,
    });
  }
}
