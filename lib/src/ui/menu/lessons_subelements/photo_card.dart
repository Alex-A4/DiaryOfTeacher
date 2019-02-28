import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoCard extends StatelessWidget {
  PhotoCard(
      {Key key, @required this.photoUrl, this.width = 150, this.height = 100})
      : super(key: key);

  double width;
  double height;

  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(_PhotoDisplayRoute(
              photoUrl: photoUrl));
        },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(photoUrl),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

class _PhotoDisplayRoute<T> extends PopupRoute<T> {
  final String photoUrl;
  final double width;
  final double height;

  @override
  Color get barrierColor => Colors.white24;


  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Photo';


  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget photoDialog = MediaQuery.removePadding(
      removeLeft: true,
      removeRight: true,
      context: context,
        child: GestureDetector(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(photoUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
    );

    return photoDialog;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  _PhotoDisplayRoute(
      {this.photoUrl, this.width, this.height});
}
