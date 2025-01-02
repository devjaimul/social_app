import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/global%20widgets/custom_text_button.dart';
import 'package:social_app/global%20widgets/custom_text_field.dart';
import 'package:social_app/ui/auth/sign_in_screen.dart';
import 'package:social_app/ui/home/home_screen.dart';
import 'package:social_app/utlis/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTEController = TextEditingController();
    TextEditingController emailTEController = TextEditingController();
    TextEditingController passTEController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey();
    String? email, password, userName;
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextOne(text: "Sign up",color: Colors.white,),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: nameTEController,
                  hintText: "User Name",
                  onChanged: (value) {
                    userName = value;
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextField(
                  controller: emailTEController,
                  hintText: "Email",
                  isEmail: true,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextField(
                    controller: passTEController,
                    hintText: "Password",
                    isPassword: true,
                    onChanged: (value) {
                      password = value;
                    }),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextButton(
                  text: "Sign Up",
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      try {
                        UserCredential userCred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );

                        if (userCred.user != null) {
                          var data = {
                            "userName": userName,
                            "email": email,
                            "password": password,
                          };
                          //add to database
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(userCred.user!.uid)
                              .set(data);
                        }

                        Get.snackbar("Success", 'Sign up successful!');
                        Get.offAll(() => const HomeScreen());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        Get.snackbar("!!!", " ${e.toString()}");
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextButton(
                    onPressed: () {
                      Get.to(() => SignInScreen());
                    },
                    child: const CustomTextTwo(
                      text: "Sign In",
                      color: AppColors.primaryColor,
                    )),
              ],
            ),
          )),
    );
  }
}
