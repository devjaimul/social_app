import 'package:flutter/material.dart';
import 'package:social_app/global%20widgets/custom_text.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomTextOne(text: "Search For a User",color: Colors.white,),),
    );
  }
}
