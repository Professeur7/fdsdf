// import 'package:fashion2/config/palette.dart';
// import 'package:fashion2/models/chat/message.dart';
// import 'package:fashion2/models/chat/widgets/message_content.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SentMessage extends ConsumerWidget {
//   final Message message;

//   const SentMessage({
//     Key? key,
//     required this.message,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           const SizedBox(width: 15),
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.all(12.0),
//               decoration: const BoxDecoration(
//                 color: Palette.messengerBlue,
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(20),
//                     bottomLeft: Radius.circular(20)),
//               ),
//               child: Wrap(
//                 children: [
//                   MessageContents(
//                     message: message,
//                     isSentMessage: true,
//                   ),
//                   const SizedBox(width: 5),
//                   message.seen
//                       ? const Icon(
//                           Icons.done_all,
//                           color: Palette.whiteColor,
//                         )
//                       : const Icon(
//                           Icons.check,
//                           color: Palette.whiteColor,
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
