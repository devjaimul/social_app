import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/global%20widgets/custom_text_button.dart';
import 'package:social_app/global%20widgets/custom_text_field.dart';
import 'package:social_app/ui/auth/sign_up_screen.dart';
import 'package:social_app/ui/home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailTEController =TextEditingController();
    TextEditingController passTEController =TextEditingController();
    GlobalKey<FormState> formKey=GlobalKey();
    String? email,password;
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextOne(text: "Sign In",color: Colors.white,),
      ),
      body: Padding(
          padding:  EdgeInsets.all(16.h),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(controller: emailTEController,hintText: "Email",isEmail: true,onChanged: (value){email=value;},),
                SizedBox(height: 10.h,),
                CustomTextField(controller: passTEController,hintText: "Password",isPassword: true,onChanged: (value){password=value;}),
                SizedBox(height: 20.h,),

                CustomTextButton(
                    text: "Sign in",
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        try {
                          if (mounted) {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );
                          }

                          Get.snackbar("Success", 'Sign in successful!');
                          Get.offAll(() => const HomeScreen());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'wrong-password') {
                            Get.snackbar("Error", "Wrong password provided.");
                          } else if (e.code == 'user-not-found') {
                            Get.snackbar("Error", "No user found with this email.");
                          } else {
                            Get.snackbar("Error", e.message ?? "An unknown error occurred.");
                          }
                        } catch (e) {
                          Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}");
                        }
                      }
                    }
                ),
                SizedBox(height: 10.h,),
                TextButton(onPressed: (){
                  Get.to(()=>const SignUpScreen());
                }, child: const CustomTextTwo(text: "Sign up")),

              ],
            ),)
      ),
    );
  }
}
