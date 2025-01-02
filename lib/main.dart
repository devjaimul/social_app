import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_app/ui/auth/sign_in_screen.dart';
import 'package:social_app/ui/auth/sign_up_screen.dart';
import 'package:social_app/ui/home/home_screen.dart';
import 'package:social_app/utlis/app_colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(

      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,child){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            appBarTheme: AppBarTheme(centerTitle: true,backgroundColor:AppColors.primaryColor,foregroundColor: Colors.white)
          ),
          home:FirebaseAuth.instance.currentUser==null?SignInScreen():HomeScreen(),
        );
},
    );
  }
}

