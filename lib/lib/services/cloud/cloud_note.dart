import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.text});

  CloudNote.fromSnaphot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
  documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  text = snapshot.data()[textFieldName] as String;
}
