import 'package:flutter/material.dart';

class FilterCategoryWidget extends StatelessWidget {
  final String? label;
  final int? selected;
  final int? value;
  final ValueChanged<int?>? onChanged;

  const FilterCategoryWidget(
      {Key? key, this.label, this.selected, this.onChanged, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int?>(
          groupValue: selected,
          onChanged: onChanged,
          value: value,
        ),
        Text('$label')
      ],
    );
  }
}
