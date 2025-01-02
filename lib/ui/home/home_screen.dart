import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/ui/auth/sign_in_screen.dart';
import 'package:social_app/ui/home/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomTextOne(text: "Home Screen",color: Colors.white,),

      actions: [
        IconButton(onPressed: (){
          Get.to(()=>SearchScreen());
        }, icon: Icon(Icons.search))
      ],
      ),
      drawer: Drawer(
child: ListView(
  children: [
    ListTile(
      title: CustomTextTwo(text: "Sign Out"),
      onTap: () async{
        FirebaseAuth.instance.signOut();
        Get.offAll(SignInScreen());

      },
    )
  ],
),
      ),
    );
  }
}
