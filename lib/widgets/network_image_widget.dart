import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode colorBlendMode;
  final String defaultImageName;

  final AlignmentGeometry? alignment;
  final bool optimization;
  final bool? isResize;

  const NetImage(
    this.url, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment,
    this.color,
    this.colorBlendMode = BlendMode.srcATop,
    this.optimization = false,
    this.defaultImageName = 'images/placehold_image.png',
    this.isResize = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty || !url!.contains('http')) {
      return _errorView();
    }
    var cUrl = transUrl(url!);

    return SizedBox(
        width: width,
        height: height,
        child: isResize == true
            ? FadeInImage(
                image: ResizeImage(CachedNetworkImageProvider(cUrl),
                    width: window.physicalSize.width ~/ 3),
                placeholder: AssetImage(defaultImageName),
                fit: fit,
                imageErrorBuilder: (context, error, stackTrace) {
                  return _errorView();
                })
            : CachedNetworkImage(
                fit: fit,
                imageUrl: cUrl,
                placeholder: (context, url) =>
                    _errorView(), //const CircularProgressIndicator(),
                errorWidget: (context, url, error) => _errorView(),
              ));
  }

  Widget _errorView() {
    // todo 错误图片
    return SizedBox(
      width: width,
      height: height,
      // child: Text("error Img"),
      child: Image.asset(
        defaultImageName,
        fit: BoxFit.cover,
      ),
    );
  }

  static String transUrl(String current) {
    var cUrl = current;
    cUrl = imageurl(cUrl);

    if (!current.startsWith("http")) {}
    return cUrl;
  }

  static image(String? url) {
    return FadeInImage.assetNetwork(
      placeholder: 'images/placehold_image.png',
      image: url ?? "",
    );
  }

  static imageurl(String? url) {
    return url?.replaceAll(".avif", "") ?? "";
  }
}
