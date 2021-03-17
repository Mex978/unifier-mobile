import 'package:flutter/material.dart';
import 'package:unifier_mobile/app/modules/work/utils/enums.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';

import '../../utils/extensions.dart';

class ChapterItemWidget extends StatelessWidget {
  final Chapter item;
  final Function onTap;
  final double width;
  final double height;
  final ChapterState state;

  const ChapterItemWidget({
    Key? key,
    required this.item,
    required this.onTap,
    required this.width,
    required this.height,
    this.state = ChapterState.idle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = state.getColors(context);

    return Container(
      width: width,
      height: height,
      child: TextButton(
        onPressed: () => onTap(),
        child: Text('${item.number}'),
        style: TextButton.styleFrom(
          primary: colors['primary'],
          backgroundColor: colors['backgroundColor'],
        ),
      ),
    );
  }
}
