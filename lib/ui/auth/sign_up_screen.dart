import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/global%20widgets/custom_text_button.dart';
import 'package:social_app/global%20widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTEController =TextEditingController();
    TextEditingController emailTEController =TextEditingController();
    TextEditingController passTEController =TextEditingController();
    GlobalKey<FormState> formKey=GlobalKey();
    String? email,password,userName;
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Sign up"),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.h),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: nameTEController,hintText: "User Name",onChanged: (value){userName=value;},),
            SizedBox(height: 10.h,),
            CustomTextField(controller: emailTEController,hintText: "Email",isEmail: true,onChanged: (value){email=value;},),
            SizedBox(height: 10.h,),
            CustomTextField(controller: passTEController,hintText: "Password",isPassword: true,onChanged: (value){password=value;}),
            SizedBox(height: 30.h,),
          CustomTextButton(

            text: "Sign Up",
            onTap: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );

              Get.snackbar("Success", 'Sign up successful!');
                } catch (e) {


                 Get.snackbar("Error", " ${e.toString()}");
                }
              }
            },
          )

          ],
        ),)
      ),
    );
  }
}
