import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

import '../manga_chapter_controller.dart';

class MangaPageImage extends StatefulWidget {
  final int index;

  const MangaPageImage({Key? key, required this.index}) : super(key: key);

  @override
  _MangaPageImageState createState() => _MangaPageImageState();
}

class _MangaPageImageState extends State<MangaPageImage> with AutomaticKeepAliveClientMixin {
  final controller = Modular.get<MangaChapterController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final imageUrl = controller.mangaChapter.value.images?[widget.index] ?? '';

    return Column(
      children: [
        Image.network(
          imageUrl,
          width: size.width,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes as int) : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Error on load image!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: UnifierColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        if (imageUrl == controller.mangaChapter.value.images?.last)
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
