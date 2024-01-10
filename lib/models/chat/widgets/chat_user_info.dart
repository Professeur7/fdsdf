
// import 'package:fashion2/config/palette.dart';
// import 'package:fashion2/screen/error_screen.dart';
// import 'package:fashion2/screen/loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ChatUserInfo extends ConsumerWidget {
//   const ChatUserInfo({
//     super.key,
//     required this.userId,
//   });

//   final String userId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userInfo = ref.watch(
//       getUserInfoByIdProvider(userId),
//     );

//     return userInfo.when(
//       data: (user) {
//         return Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(user.profilePicUrl),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.fullName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Palette.blackColor,
//                   ),
//                 ),
//                 const Text(
//                   'Messenger',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Palette.greyColor,
//                   ),
//                 )
//               ],
//             ),
//           ],
//         );
//       },
//       error: (error, stackTrace) {
//         return ErrorScreen(error: error.toString());
//       },
//       loading: () {
//         return const Loader();
//       },
//     );
//   }
// }
