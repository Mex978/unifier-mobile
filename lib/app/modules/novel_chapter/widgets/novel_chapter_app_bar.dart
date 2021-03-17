import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/novel_chapter/novel_chapter_controller.dart';

class NovelChapterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final NovelChapterController controller;

  NovelChapterAppBar({Key? key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Tooltip(
        message: 'Lista de capítulos',
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RxBuilder(
            builder: (_) {
              return Flexible(
                child: Text(
                  controller.novelChapter.value.title ?? 'Novel Chapter',
                  overflow: TextOverflow.visible,
                  // textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

// class NovelChapterAppBar extends PreferredSize {
//   final NovelChapterController? controller;

//   NovelChapterAppBar({Key? key, this.controller})
//       : super(
//           key: key,
//           preferredSize: Size.fromHeight(56),
//           child: Container(),
//         );

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: Tooltip(
//         message: 'Lista de capítulos',
//         child: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Modular.to
//               .popUntil((route) => route.settings.name == '/chapters'),
//         ),
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           RxBuilder(
//             builder: (_) {
//               return Flexible(
//                 child: Text(
//                   controller?.novelChapter?.title ?? 'Novel Chapter',
//                   overflow: TextOverflow.visible,
//                   // textAlign: TextAlign.center,
//                   maxLines: 2,
//                   softWrap: true,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(56);
// }
