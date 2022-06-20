import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BottomAppBarItem extends StatelessWidget {
  const BottomAppBarItem({
    Key? key,
    required this.artboard,
    required this.onpress,
    required this.currentIndex,
    required this.tabIndex,
    required this.input,
  }) : super(key: key);

  final Artboard? artboard;
  final VoidCallback onpress;
  final int currentIndex;
  final int tabIndex;
  final SMIInput<bool>? input;

  @override
  Widget build(BuildContext context) {
    if (input != null) {
      input!.value = currentIndex == tabIndex;
    }
    return SizedBox(
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: onpress,
        child: artboard == null ? const SizedBox() : Rive(artboard: artboard!),
      ),
    );
  }
}
