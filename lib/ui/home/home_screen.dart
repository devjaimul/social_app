import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/global%20widgets/custom_text_button.dart';
import 'package:social_app/global%20widgets/custom_text_field.dart';
import 'package:social_app/ui/auth/sign_in_screen.dart';
import 'package:social_app/ui/home/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController postTEController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const CustomTextOne(
          text: "Home Screen",
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const SearchScreen());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const CustomTextTwo(text: "Sign Out"),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Get.offAll(const SignInScreen());
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Container(
          height: 200.h,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            spacing: 20.h,
            children: [
              CustomTextField(controller:postTEController,hintText: "Post Something", ),
              CustomTextButton(text: "Post", onTap: () async{
                var data={
                  "time":DateTime.now(),
                  "type":"text",
                  "content":postTEController.text,
                  "uid":FirebaseAuth.instance.currentUser!.uid,
                };
                FirebaseFirestore.instance.collection("posts").add(data);
                postTEController.text="";
                setState(() {

                });
              }),
            ],
          ),
        ),
      )
    );
  }
}
