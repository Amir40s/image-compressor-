class UserModel {
  final DateTime? createdAt;
  final String deviceId;
  final String plan;
  final bool premium;
  final int trialsLeft;
  final DateTime? updatedAt;

  UserModel({
    this.createdAt,
    required this.deviceId,
    required this.plan,
    required this.premium,
    required this.trialsLeft,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      createdAt: map["createdAt"]?.toDate(),

      deviceId: map["deviceId"] ?? "",

      plan: map["plan"] ?? "FREE",

      premium: map["premium"] ?? false,

      trialsLeft: map["trialsLeft"] ?? 0,

      updatedAt: map["updatedAt"]?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "deviceId": deviceId,
      "plan": plan,
      "premium": premium,
      "trialsLeft": trialsLeft,
      "updatedAt": updatedAt,
    };
  }

  UserModel copyWith({
    DateTime? createdAt,
    String? deviceId,
    String? plan,
    bool? premium,
    int? trialsLeft,
    DateTime? updatedAt,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      plan: plan ?? this.plan,
      premium: premium ?? this.premium,
      trialsLeft: trialsLeft ?? this.trialsLeft,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}