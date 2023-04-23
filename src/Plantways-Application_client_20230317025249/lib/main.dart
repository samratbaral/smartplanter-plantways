import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_todo/components/bluetooth_plus.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:flutter_todo/screens/account_page.dart';
import 'package:flutter_todo/screens/home_screen.dart';
import 'package:flutter_todo/screens/plant_dashboard.dart';
import 'package:flutter_todo/screens/log_in.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:flutter_todo/realm/app_services.dart';
import 'package:flutter_todo/screens/homepage.dart';
import 'package:flutter_todo/screens/welcome.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final realmConfig = json
      .decode(await rootBundle.loadString('assets/config/atlasConfig.json'));
  String appId = realmConfig['appId'];
  Uri baseUrl = Uri.parse(realmConfig['baseUrl']);

  Timer(const Duration(seconds: 2), () {
    return runApp(MultiProvider(providers: [
      ChangeNotifierProvider<AppServices>(
          create: (_) => AppServices(appId, baseUrl)),
      ChangeNotifierProxyProvider<AppServices, RealmServices?>(
          // RealmServices can only be initialized only if the user is logged in.
          create: (context) => null,
          update: (BuildContext context, AppServices appServices,
              RealmServices? realmServices) {
            return appServices.app.currentUser != null
                ? RealmServices(appServices.app)
                : null;
          }),
    ], child: const App()));
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<RealmServices?>(context, listen: false)?.currentUser;
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Smart Planter: PlantWays Realm Client',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFEEF1F8),
          primarySwatch: Colors.blue,
          fontFamily: "Intel",
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(height: 0),
            border: defaultInputBorder,
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
            errorBorder: defaultInputBorder,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: splashScreen,
        home: Scaffold(
          body: Center(
              child: AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(
              'assets/logo/plantways_round_logo.svg',
            ),
          )),
        ),
        initialRoute: currentUser != null ? '/welcome' : '/welcome',
        routes: {
          // '/login': (context) => LogIn(), // Original To Do
          // '/homepage': (context) => const HomePage(), // Original To Do
          // '/dashboard': (context) => const PlantDashboard() // Original Animation
          '/welcome': (context) => const WelcomePage(),
          '/plantpage': (context) => const PlantPage(),
          '/accountpage': (context) => const AccountPage(),
          '/bluetoothpage': (context) => const FlutterBlueApp(),
        },
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);

// assets/logo/plantways_logo.png
//
// Widget splashScreen = Scaffold(
//   body: Center(
//     child: AspectRatio(
//       aspectRatio: 1.0,
//       child: SvgPicture.asset(
//         'assets/logo/plantways_logo.svg',
//         width: 100,
//         height: 100,
//       ),
//     )
//   ),
// );

// Widget splashScreen = Scaffold(
//   body: Container(
//       color: Colors.lime[200],
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.green, Colors.greenAccent],
//       ),
//     ),
//     child: Center(
//       child: SizedBox(
//         child: AspectRatio(
//           aspectRatio: 1.0,
//           child: SvgPicture.asset(
//               'assets/logo/plantways_logo.svg',
//             width: 300.0,
//             height: 300.0,
//           ),
//         )
//       ),
//     ),
//   ),
// );
