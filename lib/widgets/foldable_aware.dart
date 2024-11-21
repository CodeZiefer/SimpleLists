import 'package:flutter/material.dart';

class FoldableAware extends StatelessWidget {
  final Widget unfoldedScreen;
  final Widget foldedScreen;

  const FoldableAware({
    required this.unfoldedScreen,
    required this.foldedScreen,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double aspectRatio = mediaQuery.size.width / mediaQuery.size.height;
    
    // Assuming folded state has a significantly different aspect ratio
    final bool isFolded = aspectRatio < 1.0;  // Adjust threshold as needed

    return isFolded ? foldedScreen : unfoldedScreen;
  }
}
