import 'dart:convert';
import 'dart:io';
import 'package:diary_of_teacher/src/mixins/network_mixin.dart';
import 'package:diary_of_teacher/src/models/list_of_images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

//TimeoutController is a singleton class which contains
// information about all images which user upload to spend timeout
class TimeoutController extends ImageUploader {
  static TimeoutController _controller;
  static JsonCodec _codec = JsonCodec();

  ListOfImages _images;

  ListOfImages get images => _images;

  //private constructor
  TimeoutController._();

  //Get singleton instance
  static TimeoutController getInstance() {
    return _controller;
  }

  //Create singleton instance of controller and restore all data
  static Future buildController() async {
    if (_controller == null) {
      _controller = TimeoutController._();
      await _controller.restoreFromCache();
    }
  }

  //Restore list of images from local storage
  Future restoreFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String images = prefs.getString('timeoutImages');
    if (images != null)
      _images = ListOfImages.fromJson(_codec.decode(images));
    else
      _images = ListOfImages();
  }

  //Save list of images to local storage
  Future saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeoutImages', _codec.encode(_images.toJson()));
  }

  //Upload image file to cloud firestore
  Future uploadImageFile(File image) async {
    String url =
        await uploadImage(image, Uuid().v1()).catchError((err) => throw err);

    _images.urls.add(url);
    await saveToCache();
  }

  //Remove image from the list
  void deleteImageFromList(String image) {
    images.urls.remove(image);
  }
}
