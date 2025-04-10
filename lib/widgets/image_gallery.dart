import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
    this.imageHeaders,
    required this.imageProvider,
    this.options = const ImageGalleryOptions(),
  });

  final Map<String, String>? imageHeaders;

  final ImageProvider imageProvider;
  final ImageGalleryOptions options;

  Widget _imageGalleryLoadingBuilder(ImageChunkEvent? event) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Dismissible(
          key: const Key('photo_view_gallery'),
          direction: DismissDirection.down,
          onDismissed: (direction) {
            Navigator.pop(context);
          },
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                builder: (BuildContext context, int index) =>
                    PhotoViewGalleryPageOptions(
                  imageProvider: imageProvider,
                  minScale: options.minScale,
                  maxScale: options.maxScale,
                ),
                itemCount: 1,
                loadingBuilder: (context, event) =>
                    _imageGalleryLoadingBuilder(event),
                pageController: PageController(initialPage: 0),
                scrollPhysics: const ClampingScrollPhysics(),
              ),
              Positioned.directional(
                end: 16,
                textDirection: Directionality.of(context),
                top: 56,
                child: CloseButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class ImageGalleryOptions {
  const ImageGalleryOptions({
    this.maxScale,
    this.minScale,
  });

  final dynamic maxScale;

  final dynamic minScale;
}
