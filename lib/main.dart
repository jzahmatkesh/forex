import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'module/MyProvider.dart';
import 'screen/Admin.dart';
import 'screen/Dashboard.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyProvider()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forex trading signal',
      debugShowCheckedModeBanner: false,
      theme: context.watch<MyProvider>().themeData,
      // home: Dashboard()
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Dashboard(),
        '/Admin': (BuildContext context) => Admin(),
      },
    );
  }
}
