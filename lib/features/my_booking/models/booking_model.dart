class BookingModel {
  final String id;
  final String serviceId;
  final String title;
  final String image;
  final String date;
  final String price;
  final String status;

  const BookingModel({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.image,
    required this.date,
    required this.price,
    this.status = '',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      serviceId: (json['serviceId'] ?? json['service']?['id'] ?? '').toString(),
      title: (json['service']?['title'] ?? json['title'] ?? 'Service').toString(),
      image: (json['service']?['image'] ?? json['image'] ?? '').toString(),
      date: (json['date'] ?? json['createdAt'] ?? '').toString(),
      price: '\$${json['service']?['price'] ?? json['price'] ?? '0'}',
      status: (json['status'] ?? '').toString(),
    );
  }
}