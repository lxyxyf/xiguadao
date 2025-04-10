import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class ImagePickerMul extends StatefulWidget {
  final int maxCount; //最大选择图片数量
  final double maxHeight; //图片容器的最大高度
  final Function(List<XFile>) pickerImgCallBack; //选取图片成功之后拿到返回结果
  const ImagePickerMul({
    super.key,
    this.maxCount = 8,
    this.maxHeight = 300.0,
    required this.pickerImgCallBack,
  });

  @override
  State<ImagePickerMul> createState() => _ImagePickerMulState();
}

class _ImagePickerMulState extends State<ImagePickerMul> {
  final List<XFile> _imageFileList = []; //存放图片的数组
  final ImagePicker _picker = ImagePicker();
  dynamic _pickerImageError;
  int _bigImageIndex = 0; //存放需要放大的图片下标

  // 获取当前展示图的数量
  int getImageCount() {
    widget.pickerImgCallBack(_imageFileList);

    if (_imageFileList.length < widget.maxCount) {
      return _imageFileList.length + 1;
    } else {
      return _imageFileList.length;
    }
  }

  void _onImageButtonPressed(
      ImageSource source, {
        double? maxHeight,
        double? maxWidth,
        int? imageQuality,
      }) async {
    try {
      final pickedFileList = await _picker.pickMultipleMedia(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );
      setState(() {
        if (_imageFileList.length < widget.maxCount) {
          if ((_imageFileList.length + pickedFileList.length) <=
              widget.maxCount) {
            //加上新选的不能超过总数量
            for (var element in pickedFileList) {
              _imageFileList.add(element);
            }
          } else {
            EasyLoading.showToast(
              '最多只能选取${widget.maxCount}张图片，多余的图片将会自动删除！',
              duration: const Duration(milliseconds: 1500),
            );
            int avaliableCount = widget.maxCount - _imageFileList.length;
            for (int i = 0; i < avaliableCount; i++) {
              _imageFileList.add(pickedFileList[i]);
            }
          }
        }
      });
    } catch (e) {
      EasyLoading.showToast('$_pickerImageError');
      _pickerImageError = e;
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFileList.removeAt(index);
    });
  }

  void _showBigImage(int index) {
    setState(() {
      _bigImageIndex = index;
    });
    //点击图片放大
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.only(left: 0.0),
          child: PhotoView(
            tightMode: true,
            imageProvider: FileImage(
              File(
                _imageFileList[_bigImageIndex].path,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? displayBigImage() {
    if (_imageFileList.length > _bigImageIndex) {
      return Image.file(
        File(
          _imageFileList[_bigImageIndex].path,
        ),
        fit: BoxFit.cover,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = 0;
    if (_imageFileList.length == widget.maxCount) {
      columnCount = (widget.maxCount / 3).ceil();
    } else {
      columnCount = ((_imageFileList.length + 1) / 3).ceil();
    }
    return _imageFileList.isNotEmpty
        ? Container(
      height: columnCount * (Get.width / 3),
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          if (_imageFileList.length < widget.maxCount) {
            if (index < _imageFileList.length) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      bottom: 0.0,
                      right: 0.0,
                      child: GestureDetector(
                        child: Image.file(
                          File(
                            _imageFileList[index].path,
                          ),
                          fit: BoxFit.cover,
                        ),
                        onTap: () => _showBigImage(index),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      width: 20,
                      height: 20,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onTap: () => _removeImage(index),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              //显示添加符号
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () => _onImageButtonPressed(
                    ImageSource.gallery,
                    imageQuality: 40, //图片压缩
                  ),
                  icon: const Icon(Icons.add_a_photo_outlined),
                ),
              );
            }
          } else {
            //选满了
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    bottom: 0.0,
                    right: 0.0,
                    child: GestureDetector(
                      child: Image.file(
                        File(
                          _imageFileList[index].path,
                        ),
                        fit: BoxFit.cover,
                      ),
                      onTap: () => _showBigImage(index),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    width: 20,
                    height: 20,
                    child: GestureDetector(
                      child: const SizedBox(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => _removeImage(index),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        itemCount: getImageCount(),
      ),
    )
        : SizedBox(
      width: 90,
      height: 90,
      child: IconButton(
        onPressed: () => _onImageButtonPressed(
          ImageSource.gallery,
          imageQuality: 40, //图片压缩
        ),
        icon: const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}
