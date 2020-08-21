import 'package:flutter/material.dart';
import 'package:jdlj/provider/jd_provider.dart';
import 'router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return JdProvider.init(
        context: context,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '京东',
          initialRoute: "/",
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: onGenerateRoute,
        ));
  }
}
