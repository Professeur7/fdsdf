import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/firebase_field_name.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class MessageT {
  String message;
  String? messageId;
  DateTime timestamp;
  bool isTailleur;

  MessageT({
    required this.message,
    this.messageId,
    required this.timestamp,
    required this.isTailleur,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "time": DateTime.now(),
      "isTailleur": false,
      //FirebaseFieldNames.messageType: messageType,
    };
  }

  factory MessageT.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    final file = map.data();
    return MessageT(
        message: file!["message"],
        messageId: map.id,
        timestamp: file["time"].toDate(),
        isTailleur: file["isTailleur"]);
  }
}
