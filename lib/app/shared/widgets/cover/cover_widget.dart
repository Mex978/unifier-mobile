import 'package:flutter/material.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

class CoverWidget extends StatelessWidget {
  final double width;
  final double height;
  final String coverUrl;

  CoverWidget(
      {required this.width, required this.height, required this.coverUrl});

  final kBorderWidth = 1.0;
  final borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.32),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ],
        border: Border.all(
          width: kBorderWidth,
          color: UnifierColors.secondaryColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Container(
              child: Center(
                child: Icon(
                  Icons.image,
                  color: UnifierColors.secondaryColor,
                  size: 64,
                ),
              ),
              // height: imageHeight,
              width: width,
              height: height,
            ),
            coverUrl.isEmpty
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(kBorderWidth),
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Image.network(
                        coverUrl,
                        fit: BoxFit.fill,
                        // height: imageHeight,
                        width: width,
                        height: height,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
