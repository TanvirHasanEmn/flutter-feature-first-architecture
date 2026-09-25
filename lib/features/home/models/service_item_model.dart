class ServiceUserModel {
  final String id;
  final String userName;
  final String profileImage;
  final String address;
  final double rating;

  const ServiceUserModel({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.address,
    required this.rating,
  });

  factory ServiceUserModel.fromJson(Map<String, dynamic> json) {
    return ServiceUserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      userName: (json['userName'] ?? 'Service Provider').toString(),
      profileImage: (json['profileImage'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ServiceItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final double avgRating;
  final ServiceUserModel user;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.avgRating,
    required this.user,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: (json['image'] ?? '').toString(),
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      user: json['user'] is Map<String, dynamic>
          ? ServiceUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : const ServiceUserModel(
        id: '',
        userName: '',
        profileImage: '',
        address: '',
        rating: 0.0,
      ),
    );
  }
}