import 'dart:ffi';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:poster_clip_flutter/core/common/type_def.dart';

final loginRepositoryProvider = Provider((ref) {
  return LoginRepository();
});

class LoginRepository {
  FutureVoid validateAndSubmit(String mobileNumber) async {
    try {
      if (mobileNumber != "" && mobileNumber.length == 10) {
        // Simulate API call or authentication logic
        await Future.delayed(const Duration(seconds: 2), () {});
      } else {
        throw "Enter Valid Mobile Number.";
      }
      // ignore: void_checks
      return const Right(Void);
    } catch (E) {
      return Left(Failure(E.toString()));
    }
  }
}
