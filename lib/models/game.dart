class Game {
  final String id;
  final String title;
  final String genre;
  final String platform;
  final double rating;
  final bool isFavorite;
  final String status; // Playing, Completed, Not Started, On Hold, Wishlist
  final String notes;
  final int playtimeHours;
  final DateTime dateAdded;
  final DateTime? completedDate;
  final List<String> tags;
  final String? coverImage;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.platform,
    required this.rating,
    this.isFavorite = false,
    this.status = 'Not Started',
    this.notes = '',
    this.playtimeHours = 0,
    DateTime? dateAdded,
    this.completedDate,
    this.tags = const [],
    this.coverImage,
  }) : dateAdded = dateAdded ?? DateTime.now();

  // Convert Game to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'platform': platform,
      'rating': rating,
      'isFavorite': isFavorite,
      'status': status,
      'notes': notes,
      'playtimeHours': playtimeHours,
      'dateAdded': dateAdded.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'tags': tags,
      'coverImage': coverImage,
    };
  }

  // Create Game from Map
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      rating: (json['rating'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      status: json['status'] as String? ?? 'Not Started',
      notes: json['notes'] as String? ?? '',
      playtimeHours: json['playtimeHours'] as int? ?? 
                     (json['playtime'] as num?)?.toInt() ?? 0, // Support both field names
      dateAdded: json['dateAdded'] != null 
          ? DateTime.parse(json['dateAdded'] as String)
          : DateTime.now(),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List)
          : [],
      coverImage: json['coverImage'] as String?,
    );
  }

  // Create a copy with updated fields
  Game copyWith({
    String? id,
    String? title,
    String? genre,
    String? platform,
    double? rating,
    bool? isFavorite,
    String? status,
    String? notes,
    int? playtimeHours,
    DateTime? dateAdded,
    DateTime? completedDate,
    List<String>? tags,
    String? coverImage,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      platform: platform ?? this.platform,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      playtimeHours: playtimeHours ?? this.playtimeHours,
      dateAdded: dateAdded ?? this.dateAdded,
      completedDate: completedDate ?? this.completedDate,
      tags: tags ?? this.tags,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  bool get isWishlist => status == 'Wishlist';
  bool get isCompleted => status == 'Completed' || status == 'Selesai';
  bool get isPlaying => status == 'Playing' || status == 'Sedang Dimainkan';
  
  // Compatibility getters
  double get playtime => playtimeHours.toDouble();
  String get statusIndonesian {
    switch (status) {
      case 'Playing':
        return 'Sedang Dimainkan';
      case 'Completed':
        return 'Selesai';
      case 'Wishlist':
        return 'Wishlist';
      case 'On Hold':
        return 'Ditunda';
      case 'Not Started':
        return 'Belum Dimulai';
      default:
        return status;
    }
  }
}
