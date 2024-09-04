import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageNetwork extends StatefulWidget {
  final String imgUrl;
  const ImageNetwork({super.key, required this.imgUrl});

  @override
  State<ImageNetwork> createState() => _ImageNetworkState();
}

class _ImageNetworkState extends State<ImageNetwork> {
  bool showFull = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          showFull = !showFull;
        });
      },
      child: SizedBox(
        height: showFull ? null : 200,
        width: double.infinity,
        child: Image.network(
          widget.imgUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(child: CupertinoActivityIndicator());
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Text('Unfound');
          },
          fit: showFull ? BoxFit.contain : BoxFit.cover,
        ),
      ),
    );
  }
}
