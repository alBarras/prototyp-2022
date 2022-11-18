import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_firestore.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_storage.dart';

class AppBloc implements Bloc {
  late FirestoreBloc _firestoreBloc;
  late StorageBloc _storageBloc;

  AppBloc() {
    _firestoreBloc = FirestoreBloc();
    _storageBloc = StorageBloc();
  }

  FirestoreBloc get firestoreBloc => _firestoreBloc;
  StorageBloc get storageBloc => _storageBloc;

  @override
  void dispose() {}
}
