import 'package:flutter/material.dart';
import 'package:poster_clip_flutter/features/home_screen/screens/home_screen.dart';
import 'package:poster_clip_flutter/features/login/screens/login_screen.dart';
import 'package:poster_clip_flutter/features/user_detail_form/screens/user_details_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
    '/user-details/:mobile': (routeData) => MaterialPage(
          child: UserDetailsScreen(mobile: routeData.pathParameters['mobile']),
        ),
  },
);
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/user-details-update/': (routeData) => const MaterialPage(
          child: UserDetailsScreen(
            mobile: '',
            isUpdate: true,
          ),
        ),
  },
);
