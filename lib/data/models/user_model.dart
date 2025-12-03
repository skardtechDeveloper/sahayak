// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  String email;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String subscription;

  @HiveField(5)
  int tokens;

  @HiveField(6)
  DateTime? subscriptionExpiry;

  @HiveField(7)
  Map<String, dynamic> preferences;

  @HiveField(8)
  DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.subscription = 'free',
    this.tokens = 100,
    this.subscriptionExpiry,
    this.preferences = const {},
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      subscription: data['subscription'] ?? 'free',
      tokens: data['tokens'] ?? 100,
      subscriptionExpiry: data['subscriptionExpiry'] != null
          ? (data['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'subscription': subscription,
      'tokens': tokens,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
      'preferences': preferences,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? subscription,
    int? tokens,
    DateTime? subscriptionExpiry,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      subscription: subscription ?? this.subscription,
      tokens: tokens ?? this.tokens,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
