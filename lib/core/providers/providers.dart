import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a provider to manage authentication status
final authStatusProvider = StateProvider<bool>((ref) {
  final sharedPreferences = ref.watch(sharedPrefsProvider);
  final token = sharedPreferences.getString('token');
  return token != null;
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // This will be initialized in main()
});

final logoutProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPrefsProvider);
  final authStatusNotifier = ref.watch(authStatusProvider.notifier);

  return () async {
    await sharedPreferences.clear(); // Clear all data
    authStatusNotifier.state = false; // Update auth status
  };
});
