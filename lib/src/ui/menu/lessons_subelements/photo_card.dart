import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoCard extends StatelessWidget {
  PhotoCard(
      {Key key, @required this.photoUrl, this.width = 100, this.height = 100})
      : super(key: key);

  double width;
  double height;

  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      child: GestureDetector(
//        onTap: ,
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          width: width,
          height: height,
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
