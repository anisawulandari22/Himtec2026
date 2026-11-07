class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String sector;
  final String provider; // 'google' or 'email'
  final String memberId;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.sector = 'Pertanian & Peternakan',
    this.provider = 'email',
    required this.memberId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'sector': sector,
      'provider': provider,
      'memberId': memberId,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Pengguna AGL',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      sector: json['sector'] as String? ?? 'Pertanian & Peternakan',
      provider: json['provider'] as String? ?? 'email',
      memberId: json['memberId'] as String? ?? 'AGL-ID-8829',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? sector,
    String? provider,
    String? memberId,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      sector: sector ?? this.sector,
      provider: provider ?? this.provider,
      memberId: memberId ?? this.memberId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
