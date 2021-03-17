import 'package:flutter/material.dart';

class ChapterBottomNavigationBarWidget extends StatelessWidget {
  final Function() onPreviousButtonPressed;
  final Function() onNextButtonPressed;
  final bool visible;
  final int? number;

  const ChapterBottomNavigationBarWidget({
    Key? key,
    required this.onPreviousButtonPressed,
    required this.visible,
    required this.onNextButtonPressed,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heightContainer = 60.0;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      curve: Curves.ease,
      bottom: visible ? 0 : -1 * heightContainer,
      height: heightContainer,
      child: Container(
        width: width,
        height: heightContainer,
        child: Material(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              // vertical: 5.0,
              horizontal: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _navigationButton(
                  context: context,
                  icon: Icons.arrow_back,
                  onPressed: onPreviousButtonPressed,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${number ?? 'Indefinido'}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _navigationButton(
                  context: context,
                  icon: Icons.arrow_forward,
                  onPressed: onNextButtonPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _navigationButton({
  required BuildContext context,
  required IconData icon,
  required void Function() onPressed,
}) {
  return Container(
    width: 48,
    height: 48,
    child: TextButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
    ),
  );
}
