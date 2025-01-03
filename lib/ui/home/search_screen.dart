import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/global%20widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTEController = TextEditingController();
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Search For a User",
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            CustomTextField(
              controller: searchTEController,
              hintText: "Search by username",
              onChanged: (value) {
                name = value.trim(); // Trim whitespace
                setState(() {});
              },
            ),
            SizedBox(height: 16.h),
            if (name != null && name!.isNotEmpty && name!.length > 3)
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("userName", isEqualTo: name)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return Text("No user found with username: $name");
                    }
                    return Flexible(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = docs[index];
                          return ListTile(
                            title: Text(doc['userName']),
                            subtitle: Text(doc['email']),
                          );
                        },
                      ),
                    );
                  }
                  return Text("No results found.");
                },
              ),
          ],
        ),
      ),
    );
  }
}
