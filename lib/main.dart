import 'package:flutter/material.dart';

import 'features/search/screens/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String searchScreen = "/";
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //close the keypad whenever the user taps on an inactive widget
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: MyApp.searchScreen,
        routes: {
          MyApp.searchScreen: (context) => SearchPage(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
