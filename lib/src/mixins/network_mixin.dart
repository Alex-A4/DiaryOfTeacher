import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';

//ImageUploader helps to upload image to firebase with specified imageName
abstract class ImageUploader with CheckConnectivity {
  //Upload image file to cloud firestore and return the url
  Future<String> uploadImage(File image, String imageName) async {
    if (!await isConnected()) throw 'Отсутствует интернет соединение';

    StorageReference reference =
        FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = reference.putFile(image);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();

    return url;
  }
}

//Mixin to check is phone connected to internet
mixin CheckConnectivity {
  Future<bool> isConnected() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return false;

    return true;
  }
}
