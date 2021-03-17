import 'package:flutter/material.dart';

import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/cover/cover_widget.dart';

class WorkItemWidget extends StatefulWidget {
  final WorkResult item;
  final Function onTap;

  const WorkItemWidget({Key? key, required this.item, required this.onTap})
      : super(key: key);

  @override
  _WorkItemWidgetState createState() => _WorkItemWidgetState();
}

class _WorkItemWidgetState extends State<WorkItemWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageWidth = ((size.width - (32 + 2 * 8)) / 3).truncate().toDouble();
    final imageHeight = (imageWidth / 0.65).truncate().toDouble();
    final fontSize = imageWidth * .10;

    return Container(
      width: imageWidth,
      child: Column(
        children: [
          Stack(
            children: [
              CoverWidget(
                coverUrl: widget.item.cover ?? '',
                height: imageHeight,
                width: imageWidth,
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Unifier.hideKeyboard(context);
                      widget.onTap();
                    },
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              width: imageWidth,
              child: Text(
                widget.item.title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
