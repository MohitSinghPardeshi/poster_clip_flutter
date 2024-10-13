import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/providers/providers.dart';
import 'package:poster_clip_flutter/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsNotifier extends StateNotifier<UserModel> {
  final SharedPreferences prefs;
  UserDetailsNotifier(this.prefs)
      : super(
          UserModel(
            name: prefs.getString('name') ?? '',
            designation: prefs.getString('designation') ?? '',
            profileImagePath: prefs.getString('profileImagePath') ?? '',
          ),
        );

  // Method to update user data and notify listeners
  void updateUser(String name, String designation, String profileImagePath) {
    state = UserModel(
      name: name,
      designation: designation,
      profileImagePath: profileImagePath,
    );

    // Save updated data to SharedPreferences
    prefs.setString('name', name);
    prefs.setString('designation', designation);
    prefs.setString('profileImagePath', profileImagePath);
  }
}

// Create the provider for accessing the UserDetailsNotifier
final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, UserModel>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return UserDetailsNotifier(prefs);
});
