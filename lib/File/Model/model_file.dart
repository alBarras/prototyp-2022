import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ModelFile {
  String name, extension, user, description, id;
  Timestamp uploadDate;

  ModelFile({
    required this.name,
    required this.id,
    required this.extension,
    required this.user,
    required this.description,
    required this.uploadDate,
  });

  ModelFile.fromMap(Map<dynamic, dynamic> map)
      :
        //String
        name = map['fileName'],
        id = map['id'],
        extension = map['extension'],
        user = map['userName'],
        description = map['description'],
        //Timestamp
        uploadDate = map['uploadDate'];

  String getUploadDate() {
    final DateTime date = uploadDate.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
