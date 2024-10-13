import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/common/common_widget.dart';
import 'package:poster_clip_flutter/features/login/repository/login_repository.dart';
import 'package:routemaster/routemaster.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, bool>(
  (ref) => LoginController(
    loginRepository: ref.watch(loginRepositoryProvider),
  ),
);

class LoginController extends StateNotifier<bool> {
  final LoginRepository _loginRepository;
  LoginController({required LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(false); // loading

  void validateAndSubmit(String mobileNumber, BuildContext context) async {
    state = true;
    final response = await _loginRepository.validateAndSubmit(mobileNumber);
    state = false;
    response.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Routemaster.of(context).push('/user-details/$mobileNumber');
      },
    );
  }
}
