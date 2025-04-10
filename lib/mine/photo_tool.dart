import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

typedef PageChanged = void Function(int index);

class PictureOverview extends StatefulWidget {
  final List imageItems; //图片列表
  final int defaultIndex; //默认第几张
  final PageChanged pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  final Decoration decoration; //背景设计

  PictureOverview(
      {required this.imageItems,
        this.defaultIndex = 1,
        required this.pageChanged,
        this.direction = Axis.horizontal,
        required this.decoration})
      : assert(imageItems != null);
  @override
  _PictureOverviewState createState() => _PictureOverviewState();
}

class _PictureOverviewState extends State<PictureOverview> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    currentIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.imageItems[index]),
                    );
                  },
                  scrollDirection: widget.direction,
                  itemCount: widget.imageItems.length,
                  backgroundDecoration:
                  BoxDecoration(color: Colors.black),
                  pageController:
                  PageController(initialPage: widget.defaultIndex),
                  onPageChanged: (index) => setState(() {
                    currentIndex = index;
                    if (widget.pageChanged != null) {
                      widget.pageChanged(index);
                    }
                  }))),
          Positioned(
            bottom: 20,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text("${currentIndex + 1}/${widget.imageItems.length}",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 1)),
                      ],
                    ))),
          ),
          Positioned(//右上角关闭
            top: 40,
            right: 40,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 20,
              child: GestureDetector(
                onTap: () {
                  //隐藏预览
                  Navigator.pop(context);
                },
                child: Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          Positioned(//数量显示
            right: 20,
            top: 20,
            child: Text(
              '${currentIndex + 1}/${widget.imageItems.length}',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}