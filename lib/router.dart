import 'package:crepas/auth_repo.dart';
import 'package:crepas/login.dart';
import 'package:crepas/main_navigation_screen.dart';
import 'package:crepas/onboarding/tutorial_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'notifications/notifications_provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final router = Provider((ref) {
  ref.watch(authStateStream);

  return GoRouter(
      observers: [FirebaseAnalyticsObserver(analytics: analytics)],
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != "/tutorial") {
            return "/tutorial";
          }
        }
        return null;
      },
      routes: [
        ShellRoute(
            builder: (context, state, child) {
              ref.read(authRepo).isLoggedIn
                  ? ref.read(notificationsProvider(context))
                  : print(1);
              return child;
            },
            routes: [
              GoRoute(
                path: "/tutorial",
                builder: (context, state) => const TutorialScreen(),
              ),
              GoRoute(
                path: "/login",
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                  path: "/:tab(home|mybook|character)",
                  name: MainNavigation.routeName,
                  builder: (context, state) {
                    final tab = state.params["tab"]!;
                    return MainNavigation(
                      tab: tab,
                    );
                  },
                  routes: const [])
            ])
      ]);
});

// class GoRouterObserver extends NavigatorObserver {
//   GoRouterObserver({required this.analytics});
//   final FirebaseAnalytics analytics;

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     analytics.setCurrentScreen(screenName: route.settings.name);
//     print('PUSHED SCREEN: ${route.settings.name}'); //name comes back null
//   }
// }
