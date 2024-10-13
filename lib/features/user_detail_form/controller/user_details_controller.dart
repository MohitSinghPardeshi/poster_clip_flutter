import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/common/common_widget.dart';
import 'package:poster_clip_flutter/features/user_detail_form/repository/user_details_repository.dart';
import 'package:routemaster/routemaster.dart';

final userDetailsControllerProvider =
    StateNotifierProvider<UserDetailsController, bool>(
  (ref) => UserDetailsController(
      userDetailRepository: ref.watch(userDetailRepositoryProvider)),
);

class UserDetailsController extends StateNotifier<bool> {
  final UserDetailRepository _userDetailRepository;
  UserDetailsController({required UserDetailRepository userDetailRepository})
      : _userDetailRepository = userDetailRepository,
        super(false);

  void validateAndSubmit(File? userProfile, String name, String desg,
      BuildContext context, bool isUpdate) async {
    state = true;
    final response =
        await _userDetailRepository.validateAndSubmit(userProfile, name, desg);
    state = false;
    response.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (!isUpdate) showSnackBar(context, "PASSED");
        isUpdate
            ? Routemaster.of(context).pop()
            : Routemaster.of(context).replace('/');
      },
    );
  }
}
