import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_app.dart';
import 'package:prototyp_flutter/File/Bloc/firebase_options.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/MainScreen/screens/main_screen.dart';

double safeAreaScreenHeight = 0, safeAreaScreenWidth = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // //For potential web problems
  // if (kIsWeb) {
  //   //For Web:
  //   await Firebase.initializeApp(options: FirebaseOptions(apiKey: configurations.apiKey, appId: configurations.appId, messagingSenderId: configurations.messagingSenderId, projectId: configurations.projectId));
  // } else {
  //   //For Mobile:
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler); //Notifications when the app is in the background (it seems to not work on iOS)
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({
    Key? key,
  }) : super(key: key);
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        title: GENERAL_APP_NAME,
        home: SafeArea(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            safeAreaScreenWidth = constraints.maxWidth;
            safeAreaScreenHeight = constraints.maxHeight;
            return MainScreen();
          }),
        ),
      ),
    );
  }
}
