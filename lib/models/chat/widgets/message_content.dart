// import 'package:fashion2/config/palette.dart';
// import 'package:fashion2/models/chat/message.dart';
// import 'package:fashion2/page/client/clienViewPubPage.dart';
// import 'package:flutter/material.dart';

// class MessageContents extends StatelessWidget {
//   const MessageContents({
//     super.key,
//     required this.message,
//     this.isSentMessage = false,
//   });

//   final Message message;
//   final bool isSentMessage;

//   @override
//   Widget build(BuildContext context) {
//     if (message.messageType == 'text') {
//       return Text(
//         message.message,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//           color: isSentMessage ? Palette.whiteColor : Palette.blackColor,
//         ),
//       );
//     } else {
//       return PublicationsClient(
//           // fileUrl: message.message,
//           // fileType: message.messageType,
//           );
//     }
//   }
// }
