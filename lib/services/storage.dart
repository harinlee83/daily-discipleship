import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getDownloadURL(String storagePath) {
    final Reference ref = storage.ref().child(storagePath);
    return ref.getDownloadURL();
  }
}
