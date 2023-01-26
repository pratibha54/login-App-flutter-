import 'package:flutter/material.dart';
import 'package:interactive_forms_with_rive/main_module.dart';
import 'package:interactive_forms_with_rive/module/home/presentation/home_screen.dart';
import 'package:interactive_forms_with_rive/module/home/presentation/register_page.dart';
import 'core/route/app_route.dart';
import 'core/route/app_route_name.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  // MainModule.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login SignUp App",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialRoute: AppRouteName.home,
      onGenerateRoute: AppRoute.generate,
    );
  }
}


handleAuthState() {
  return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return const RegistrationScreen();
        }
      });
}