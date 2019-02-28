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
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(_PhotoDisplayRoute(
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                photoUrl: photoUrl));
          },
          child: Material(
            color: Colors.grey[300],
            elevation: 5.0,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
            ),
          ),
        ));
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
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget photoDialog = MediaQuery.removePadding(
      removeLeft: true,
      removeRight: true,
      context: context,
      child: Center(
        child: GestureDetector(
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: 300,
            height: 300,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    return photoDialog;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  _PhotoDisplayRoute(
      {this.barrierLabel, this.photoUrl, this.width, this.height});
}
