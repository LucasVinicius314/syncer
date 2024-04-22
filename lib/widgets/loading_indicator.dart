import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.size,
    required this.strokeWidth,
  });

  factory LoadingIndicator.medium() {
    return const LoadingIndicator(size: 24, strokeWidth: 4);
  }

  factory LoadingIndicator.small() {
    return const LoadingIndicator(size: 16, strokeWidth: 3);
  }

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.square(size)),
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );
  }
}
