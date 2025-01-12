import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callId; // Unique call ID
  final bool isVideoCall; // Video or audio call

  const CallPage({
    Key? key,
    required this.callId,
    this.isVideoCall = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1090900800, // Replace with your Zego app ID
      appSign: '2f8ccb56cb0ad1b05796855f964aba6023a366dacfacea67cc0b30fef28d977f', // Replace with your app sign
      userID: "user_${DateTime.now().millisecondsSinceEpoch}", // Unique user ID
      userName: "User_${DateTime.now().millisecondsSinceEpoch}", // Unique user name
      callID: callId,
      config: isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          : ZegoUIKitPrebuiltCallConfig.groupVoiceCall(),
    );
  }
}
