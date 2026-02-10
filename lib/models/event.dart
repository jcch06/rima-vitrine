class Event {
  final String id;
  final String vendorId;
  final String title;
  final String? description;
  final String? location;
  final DateTime dateStart;
  final DateTime? dateEnd;
  final String? imageUrl;
  final int? maxCapacity;
  final double? price;
  final String status;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.vendorId,
    required this.title,
    this.description,
    this.location,
    required this.dateStart,
    this.dateEnd,
    this.imageUrl,
    this.maxCapacity,
    this.price,
    required this.status,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      vendorId: json['vendor_id'],
      title: json['title'] ?? '',
      description: json['description'],
      location: json['location'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: json['date_end'] != null ? DateTime.parse(json['date_end']) : null,
      imageUrl: json['image_url'],
      maxCapacity: json['max_capacity'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
