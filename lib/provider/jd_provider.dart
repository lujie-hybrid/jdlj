import 'package:flutter/material.dart';
import 'package:jdlj/provider/models/m_cart.dart' show MCart;
import 'package:jdlj/provider/models/tab_nav.dart';
import 'package:jdlj/provider/models/user.dart';
import 'package:provider/provider.dart';
export './models/m_cart.dart';
export './models/tab_nav.dart';
export './models/user.dart';

class JdProvider {
  static init({BuildContext context, Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MCart(),
        ),
        ChangeNotifierProvider(
          create: (_) => TabDt(),
        ),
        ChangeNotifierProvider(
          create: (_) => JdUser(),
        )
      ],
      child: child,
    );
  }

  static T value<T>(BuildContext context) {
    return Provider.of(context);
  }

  static Consumer connect<T>(
      {Function(BuildContext context, T value, Widget child) builder,
      Widget child}) {
    return Consumer<T>(builder: builder, child: child);
  }

  static Consumer2 connect2<T, R>(
      {Function(BuildContext context, T value, R val, Widget child) builder,
      Widget child}) {
    return Consumer2<T, R>(builder: builder, child: child);
  }
}
