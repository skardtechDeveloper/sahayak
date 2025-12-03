// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Initialize services here

  // Example:
  // sl.registerLazySingleton(() => ChatService());
  // sl.registerLazySingleton(() => AuthService());
  // sl.registerLazySingleton(() => StorageService());

  debugPrint('Dependency injection initialized');
}
