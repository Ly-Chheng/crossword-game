import 'package:flutter/material.dart';

class BackgroundImage {
  // For full-screen background images
  static Widget buildBackgroundImage(ImageProvider imageProvider) {
    return Positioned.fill(
      child: Image(
        image: imageProvider,
        fit: BoxFit.fill,
      ),
    );
  }

  // For custom-sized asset images
  static Widget buildCustomAssetImage({
    required String imagepath,
    required double width,
    required double height,
  }) {
    return Image.asset(
      imagepath,
      width: width,
      height: height,
    );
  }

  // Background Image for a Container
  static BoxDecoration buildContainerBackground({String? imagePath, double opacity = 0.2,}) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath!),
        fit: BoxFit.fill,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(opacity),
          BlendMode.darken,
        ),
      ),
    );
  }
}
