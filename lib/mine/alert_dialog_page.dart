import 'package:flutter/material.dart';

class DialogItem {
  String? title;
  Color? color;

  DialogItem({this.title, this.color});
}

class ShowAlertDialog extends StatefulWidget {
  const ShowAlertDialog({
    Key? key,
    this.contentAlign = TextAlign.left,
    required this.onTap,
    this.itemTitles,
    this.content,
    this.title,
    this.children,
  }) : super(key: key);

  // 内容区域布局
  final TextAlign contentAlign;

  final String? title;

  final String? content;

  // 点击返回index 0 1
  final Function onTap;

  //按钮
  final List<DialogItem>? itemTitles;

  final List<Widget>? children;

  @override
  State<ShowAlertDialog> createState() => _ShowAlertDialogState();
}

class _ShowAlertDialogState extends State<ShowAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            width: MediaQuery.of(context).size.width - 80,
            height: 160.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 17.5,
                ),
                _buildTitleWidget(),
                SizedBox(
                  height: (_hasTitleAndContent() ? 14.0 : 0.0),
                ),
                _buildContentWidget(),
                const SizedBox(height: 22.5),
                Container(
                  height: 1,
                  color: const Color.fromRGBO(216, 216, 216, 1.0),
                ),
                _buildItemWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasTitle() {
    if (widget.title != null && widget.title!.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _hasContent() {
    if (widget.content != null && widget.content!.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _hasTitleAndContent() {
    if (_hasTitle() && _hasContent()) {
      return true;
    }
    return false;
  }

  Widget _buildTitleWidget() {
    bool aHasTitle = _hasTitle();
    if (aHasTitle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "${widget.title}",
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    return Container();
  }

  Widget _buildContentWidget() {
    bool aHasContent = _hasContent();
    if (aHasContent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "${widget.content}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: Color(0xFF999999),
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    return Container();
  }

  Widget _buildItemWidget() {
    if (widget.children != null && widget.children!.isNotEmpty) {
      return SizedBox(
        height: 40.0,
        child: Row(
          children: widget.children!.map((res) {
            int index = widget.children!.indexOf(res);
            return Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.onTap(index);
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color(0xFFF5F5F5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: res,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    if (widget.itemTitles != null && widget.itemTitles!.isNotEmpty) {
      return SizedBox(
        height: 60,
        child: Row(
          children: widget.itemTitles!.map((res) {
            int index = widget.itemTitles!.indexOf(res);
            return buildItem(res, index);
          }).toList(),
        ),
      );
    }

    return Container();
  }

  Widget buildItem(DialogItem item, int index) {
    String? title = item.title;
    Color? color = item.color;
    Color textColor = const Color(0xff333333);
    if (color != null) {
      textColor = color;
    }
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          widget.onTap(index);
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Color.fromRGBO(216, 216, 216, 1.0),
                width: 1,
              ),
            ),
          ),
          child: Text(
            "$title",
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
