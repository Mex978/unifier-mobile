import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String? description;
  final String? title;

  const ErrorDialogWidget({Key? key, this.description, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title!),
      content: Text(description!),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: Navigator.of(context).pop,
        )
      ],
    );
  }
}
