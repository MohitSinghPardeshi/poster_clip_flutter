import 'dart:ffi';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:poster_clip_flutter/core/common/type_def.dart';
import 'package:poster_clip_flutter/core/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userDetailRepositoryProvider = Provider<UserDetailRepository>((ref) {
  return UserDetailRepository(ref.watch(sharedPrefsProvider), ref);
});

class UserDetailRepository {
  final SharedPreferences _sharedPreferences;
  final ProviderRef _ref;
  UserDetailRepository(SharedPreferences sharedPreferences, ProviderRef ref)
      : _sharedPreferences = sharedPreferences,
        _ref = ref;

  FutureVoid validateAndSubmit(
      File? userProfile, String name, String desg) async {
    try {
      if (name != "" && desg != "" && userProfile != null) {
        _sharedPreferences.setString('name', name);
        _sharedPreferences.setString('designation', desg);
        _sharedPreferences.setString('profileImagePath', userProfile.path);

        //dummy login && save dummy token
        final authStatusNotifier = _ref.watch(authStatusProvider.notifier);
        authStatusNotifier.state = true;
        _sharedPreferences.setString('token', '${name}_$desg');
      } else {
        name.isEmpty
            ? throw "Enter Name."
            : desg.isEmpty
                ? throw "Enter Designation."
                : userProfile == null
                    ? throw "Select User Image."
                    : "";
      }
      return const Right(Void);
    } catch (E) {
      return Left(Failure(E.toString()));
    }
  }
}
