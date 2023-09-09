import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  double height = 200;
  LoadingWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      padding: const EdgeInsets.all(20),
      height: height,
      child: Center(
        child: LoadingAnimationWidget.beat(
          color: const Color.fromARGB(255, 86, 136, 224),
          size: 40,
        ),
      ),
    );
  }
}
