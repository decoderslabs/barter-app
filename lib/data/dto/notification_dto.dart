class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.deepLink,
    this.read = false,
    this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final String? deepLink;
  final bool read;
  final String? createdAt;

  factory NotificationDto.fromJson(Map<String, dynamic> json) => NotificationDto(
        id: json['id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        deepLink: json['deep_link'] as String?,
        read: json['read'] as bool? ?? false,
        createdAt: json['created_at'] as String?,
      );
}
