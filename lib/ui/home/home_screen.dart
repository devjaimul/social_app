import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/ui/auth/sign_in_screen.dart';
import 'package:social_app/ui/home/search_screen.dart';

import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isNotEqualTo: currentUserId) // Exclude current user
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(user['userName']),
                subtitle: Text(user['email']),
                onTap: () {
                  // Navigate to chat screen with selected user
                  Get.to(() => ChatScreen(
                    chatPartnerId: users[index].id,
                    chatPartnerName: user['userName'],
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
