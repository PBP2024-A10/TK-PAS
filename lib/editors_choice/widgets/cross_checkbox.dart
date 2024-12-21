import 'package:flutter/material.dart';

class CrossCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color checkColor;
  final Color activeColor;

  const CrossCheckbox({
    required this.value,
    required this.onChanged,
    required this.checkColor,
    required this.activeColor,
    Key? key,
  }) : super(key: key);

  @override
  _CrossCheckboxState createState() => _CrossCheckboxState();
}

class _CrossCheckboxState extends State<CrossCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
          color: widget.value ? widget.activeColor : Colors.transparent,
        ),
        width: 24.0,
        height: 24.0,
        child: widget.value
            ? Icon(Icons.close, size: 20.0, color: widget.checkColor)
            : null,
      ),
    );
  }
}