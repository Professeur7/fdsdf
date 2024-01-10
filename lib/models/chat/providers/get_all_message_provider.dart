// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fashion2/firebase_field_name.dart';
// import 'package:fashion2/firebases_collection_names.dart';
// import 'package:fashion2/models/chat/message.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final getAllMessagesProvider = StreamProvider.autoDispose
//     .family<Iterable<Message>, String>((ref, String chatroomId) {
//   final controller = StreamController<Iterable<Message>>();

//   final sub = FirebaseFirestore.instance
//       .collection(FirebaseCollectionNames.chatrooms)
//       .doc(chatroomId)
//       .collection(FirebaseCollectionNames.messages)
//       .orderBy(FirebaseFieldNames.timestamp, descending: true)
//       .snapshots()
//       .listen((snapshot) {
//     final messages = snapshot.docs.map(
//       (messageData) => Message.fromMap(
//         messageData.data(),
//       ),
//     );
//     controller.sink.add(messages);
//   });

//   ref.onDispose(() {
//     controller.close();
//     sub.cancel();
//   });

//   return controller.stream;
// });
