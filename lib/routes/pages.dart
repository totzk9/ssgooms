import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../screens/auth.dart';
import '../screens/event.dart';
import '../screens/home.dart';
import '../viewmodels/authviewmodel.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/homeviewmodel.dart';

part 'routes.dart';

class Pages {
  Pages._();

  static final Map<String, Widget Function(BuildContext)> routes =
      <String, Widget Function(BuildContext)>{
    Routes.home: (BuildContext context) {
      return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext providerContext) => HomeViewModel(),
        child: const HomeView(),
      );
    },
    Routes.auth: (BuildContext context) {
      return ChangeNotifierProvider<AuthViewModel>(
        create: (BuildContext providerContext) => AuthViewModel(),
        child: const AuthView(),
      );
    },
    Routes.event: (BuildContext context) {
      final Event event = ModalRoute.of(context)!.settings.arguments! as Event;
      return ChangeNotifierProvider<EventViewModel>(
        create: (BuildContext providerContext) => EventViewModel(
          event: event,
        ),
        child: const EventView(),
      );
    },
  };
}
