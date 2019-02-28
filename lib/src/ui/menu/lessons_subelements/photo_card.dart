import 'package:diary_of_teacher/src/app.dart';
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
        onTap: () {
          Navigator.of(context).push(_PhotoDisplayRoute(
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              photoUrl: photoUrl, width: width, height: height));
        },
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

class _PhotoDisplayRoute<T> extends PopupRoute<T> {
  final String photoUrl;
  final double width;
  final double height;

  @override
  Color get barrierColor => theme.accentColor;

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
        child: CachedNetworkImage(imageUrl: photoUrl, width: 400, height: 400,),
      ),
    );

    return photoDialog;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  _PhotoDisplayRoute({this.barrierLabel, this.photoUrl, this.width, this.height});
}
