import 'package:flutter/material.dart';

// class CustomRoute<T> extends MaterialPageRoute<T> {
//   CustomRoute({
//     required WidgetBuilder builder,
//     RouteSettings? routeSettings,
//   }) : super(builder: builder, settings: routeSettings);

//   @override
//   Widget buildTransitions(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//   }
// }

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  CustomPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
