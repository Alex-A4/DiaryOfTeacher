import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class PhotoCard extends StatelessWidget {
  PhotoCard(
      {Key key,
      @required this.photoUrl,
      this.boxFit = BoxFit.cover,
      this.width = 150,
      this.height = 100,
      this.background,
      this.deleteFunc})
      : super(key: key) {
    background = background ?? Colors.grey[600];
    deleteFunc == null ? this.topPadding = 0.0 : this.topPadding = 10.0;
  }

  VoidCallback deleteFunc;
  double width;
  double height;
  double topPadding;
  BoxFit boxFit;
  Color background;

  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(PhotoDisplayRoute(photoUrl: photoUrl));
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: topPadding, left: 10.0, right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: AdvancedNetworkImage(photoUrl,
                            useDiskCache: true,
                            cacheRule: CacheRule(maxAge: Duration(days: 7))),
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

class PhotoDisplayRoute<T> extends PopupRoute<T> {
  final String photoUrl;

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
                child: ZoomableWidget(
                  maxScale: 3.0,
                  enableRotate: true,
                  child: TransitionToImage(
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(10.0),
                    placeholder: CircularProgressIndicator(),
                    image: AdvancedNetworkImage(photoUrl,
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: Duration(days: 7))),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return photoDialog;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  PhotoDisplayRoute({this.photoUrl});
}
