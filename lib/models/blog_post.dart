class BlogPost {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String? excerpt;
  final String? featuredImage;
  final String? category;
  final DateTime? publishedAt;
  final DateTime createdAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.excerpt,
    this.featuredImage,
    this.category,
    this.publishedAt,
    required this.createdAt,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'],
      featuredImage: json['featured_image'],
      category: json['category'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
