import 'package:flutter/cupertino.dart';

class CircularImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isAssetImage;

  const CircularImageWidget({super.key, required this.imagePath, required this.width, required this.height, required this.isAssetImage});

  @override
  Widget build(BuildContext context) {
    return isAssetImage
        ? Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.fill,
          )
        : Image.network(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.fill,
          );
  }
}
