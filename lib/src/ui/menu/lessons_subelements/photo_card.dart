import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoCard extends StatelessWidget {
  PhotoCard(
      {Key key,
      @required this.photoUrl,
      this.boxFit = BoxFit.cover,
      this.width = 150,
      this.height = 100,
      this.deleteFunc})
      : super(key: key) {
    deleteFunc == null ? this.topPadding = 0.0 : this.topPadding = 10.0;
  }

  VoidCallback deleteFunc;
  double width;
  double height;
  double topPadding;
  BoxFit boxFit;

  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(_PhotoDisplayRoute(photoUrl: photoUrl));
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: topPadding, left: 10.0, right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(photoUrl),
                        fit: boxFit)),
              ),
            ),
          ),
          deleteFunc == null
              ? Container()
              : Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: Container(
                      width: 25,
                      height: 25,
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.grey[400]),
                      child: Center(
                        child: GestureDetector(
                          onTap: deleteFunc,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
        ],
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
                  width: 330,
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(photoUrl),
                        fit: BoxFit.contain),
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

  _PhotoDisplayRoute({this.photoUrl, this.width, this.height});
}
