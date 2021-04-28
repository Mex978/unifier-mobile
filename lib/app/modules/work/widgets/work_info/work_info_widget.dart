import 'package:flutter/material.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';
import 'package:unifier_mobile/app/shared/widgets/cover/cover_widget.dart';

class WorkInfoWidget extends StatelessWidget {
  final WorkResult? item;
  final double space;

  const WorkInfoWidget({Key? key, this.item, this.space = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageWidth = (130).truncate().toDouble();
    final imageHeight = (imageWidth / 0.6).truncate().toDouble();
    final _containerColor = UnifierColors.tertiaryColor;
    final _shadow = BoxShadow(
      color: Colors.black.withOpacity(.32),
      blurRadius: 3,
      spreadRadius: 3,
    );

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [_shadow],
            ),
            child: Container(
              color: _containerColor,
              padding: EdgeInsets.all(8),
              height: imageHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoverWidget(
                    coverUrl: item?.cover ?? '',
                    height: imageHeight,
                    width: imageWidth,
                  ),
                  SizedBox(width: size.width * .04),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item!.title}',
                            style: TextStyle(
                              fontSize: imageHeight * .065,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: size.height * .006),
                          field(
                            context,
                            'Autor(es)',
                            item?.author?.split(',').join(', '),
                            fontSize: imageHeight * .06,
                          ),
                          field(
                            context,
                            'Capítulos',
                            '${item!.chaptersCount}',
                            fontSize: imageHeight * .06,
                          ),
                          field(
                            context,
                            'Avaliação',
                            item!.rate,
                            fontSize: imageHeight * .06,
                          ),
                          field(
                            context,
                            'Status',
                            item!.status,
                            fontSize: imageHeight * .06,
                          ),
                          field(
                            context,
                            'Ano',
                            '${item!.year}',
                            fontSize: imageHeight * .06,
                          ),
                          field(
                            context,
                            'Gênero(s)',
                            item!.tags?.join(', '),
                            fontSize: imageHeight * .06,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: space),
          (item?.description ?? '').isEmpty
              ? Container()
              : Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _containerColor,
                    boxShadow: [_shadow],
                  ),
                  child: field(
                    context,
                    'Sinopse',
                    '${item?.description}',
                    fontSize: 14.0,
                    justify: true,
                  ),
                ),
        ],
      ),
    );
  }

  Widget field(BuildContext context, String title, String? content, {double fontSize = 11, bool justify = false}) {
    if (content == null) return Container();

    return RichText(
      textAlign: justify ? TextAlign.justify : TextAlign.start,
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: fontSize),
        children: [
          TextSpan(
            text: title + ': ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: content),
        ],
      ),
    );
  }
}
