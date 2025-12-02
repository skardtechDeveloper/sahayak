import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String subscription;
  @HiveField(5)
  final int tokens;
  @HiveField(6)
  final DateTime subscriptionExpiry;
  @HiveField(7)
  final Map<String, dynamic> preferences;
  @HiveField(8)
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    this.subscription = 'free',
    this.tokens = 100,
    required this.subscriptionExpiry,
    this.preferences = const {},
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      subscription: data['subscription'] ?? 'free',
      tokens: data['tokens'] ?? 100,
      subscriptionExpiry: (data['subscriptionExpiry'] as Timestamp).toDate(),
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
      'subscriptionExpiry': Timestamp.fromDate(subscriptionExpiry),
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