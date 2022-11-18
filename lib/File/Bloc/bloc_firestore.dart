import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/File/Model/model_file.dart';

class FirestoreBloc implements Bloc {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> addFile(String _fileName, String _userName, String _description, String _extension) async {
    bool _isOk = false;
    Map<String, dynamic> newFileMap = {};
    await _db.collection(COLLECTION_FILES).add(newFileMap).then((docRef) async {
      newFileMap = {
        "fileName": _fileName,
        "userName": _userName,
        "description": _description,
        "extension": _extension,
        "uploadDate": FieldValue.serverTimestamp(),
        "id": docRef.id.toString(),
      };
      await _db.collection(COLLECTION_FILES).doc(docRef.id).set(newFileMap).then((isOk) {
        _isOk = true;
      });
    });
    return _isOk;
  }

  Future<bool> removeFile(String fileId) async {
    bool _isOk = false;
    await _db.collection(COLLECTION_FILES).doc(fileId).delete();
    return _isOk;
  }

  Future<List<ModelFile>> getAllFiles() async {
    List<ModelFile> allFiles = [];

    await _db.collection(COLLECTION_FILES).get().then((value) {
      for (var file in value.docs) {
        if (file.exists) {
          try {
            allFiles.add(ModelFile.fromMap(file.data()));
          } catch (e) {}
        }
      }
    });

    return allFiles;
  }

  @override
  void dispose() {}
}
