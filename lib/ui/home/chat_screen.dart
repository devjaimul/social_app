import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/global%20widgets/custom_text.dart';
import 'package:social_app/utlis/app_colors.dart'; // For formatting timestamps

class ChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  const ChatScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();

  void sendMessage(String? imageUrl) async {
    if (_messageController.text.trim().isEmpty && imageUrl == null) return;

    var message = {
      'senderId': currentUserId,
      'receiverId': widget.chatPartnerId,
      'message': imageUrl ?? _messageController.text.trim(),
      'isImage': imageUrl != null,
      'timestamp': FieldValue.serverTimestamp(),
    };

    var chatId = getChatId(currentUserId, widget.chatPartnerId);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);

    _messageController.clear();
  }

  String getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1\_$userId2' : '$userId2\_$userId1';
  }

  Future<void> sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);

    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    var ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(currentUserId)
        .child(fileName);

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    sendMessage(imageUrl);
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var chatId = getChatId(currentUserId, widget.chatPartnerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data() as Map<String, dynamic>;
                    bool isMe = message['senderId'] == currentUserId;
                    String time = message['timestamp'] != null
                        ? formatTimestamp(message['timestamp'])
                        : '...';
                    if (message['isImage'] == true) {
                      // Image message
                      return Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              message['message'],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              time,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Text message
                      return Column(
                        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                        children: [
                          BubbleSpecialThree(
                            text: message['message'],
                            textStyle: TextStyle(color: isMe?Colors.white:Colors.black,fontSize: 15.sp),
                            color: isMe ? AppColors.primaryColor : Colors.grey[300]!,
                            tail: true,
                            isSender: isMe,

                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 2.h),
                            child: CustomTextTwo(text: time,fontSize: 12.sp,),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
          MessageBar(
            onSend: (text) {
              _messageController.text = text;
              sendMessage(null);
            },
            actions: [
              InkWell(
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: sendImage,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: sendImage,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
