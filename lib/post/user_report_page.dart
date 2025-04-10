//用户举报

import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';

class UseReportPage extends StatefulWidget {
  final String userName;
  const UseReportPage({super.key, required this.userName});
  @override
  State<StatefulWidget> createState() {
    return UseReportPageState();
  }
}

class UseReportPageState extends State<UseReportPage> {
  List<bool> isSelectSource = [];
  List<dynamic> dataSource = [];

  final TextEditingController _contentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dataSource = [
      '色情相关',
      '头像、虚假资料',
      '婚托、饭托、酒托等',
      '骚扰信息',
      '诈骗钱财、虚假中奖信息',
      '养老诈骗',
      '其他',
    ];
    for (int i = 0; i < dataSource.length; i++) {
      var isSelect = false;
      isSelectSource.add(isSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 70, bottom: 25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
//收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: _createView(),
        ),
      ),
    );
  }

  Widget _createView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "取消",
                  style: TextStyle(
                      fontSize: 15.0, color: Color.fromRGBO(49, 49, 49, 1.0)),
                ),
              ),
              Text(
                "举报用户: ${widget.userName}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _report();
                },
                child: const Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 40,
          color: const Color.fromRGBO(245, 246, 248, 1.0),
          padding: const EdgeInsets.only(left: 18),
          child: const Text(
            "请选择原因 (可多选) ",
            style: TextStyle(
                fontSize: 13.0, color: Color.fromRGBO(152, 153, 156, 1.0)),
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(context, index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return index == dataSource.length
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: const Color.fromRGBO(238, 238, 238, 1.0),
                        );
                },
                itemCount: dataSource.length + 1),
          ),
        )
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == dataSource.length) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color.fromRGBO(244, 244, 244, 1.0),
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        width: MediaQuery.of(context).size.width,
        height: 120,
        child: TextField(
          controller: _contentController,
          style: const TextStyle(fontSize: 15.0, color: Colors.black87),
          decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 11.5),
            border: InputBorder.none,
            hintText: "请输入您想反馈的问题",
            hintStyle: TextStyle(
                fontSize: 14.0, color: Color.fromRGBO(210, 210, 210, 1.0)),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          isSelectSource[index] = !isSelectSource[index];
          setState(() {});
        },
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                isSelectSource[index] = !isSelectSource[index];
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelectSource[index] == true
                      ? Colors.red
                      : Colors.transparent,
                  border: Border.all(
                      color: isSelectSource[index] == true
                          ? Colors.transparent
                          : const Color.fromRGBO(149, 149, 149, 1.0),
                      width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                ),
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: isSelectSource[index] == true
                      ? Colors.white
                      : Colors.transparent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(dataSource[index].toString()),
            ),
          ],
        ),
      ),
    );
  }

  void _report() async {
    bool haveSelect = false;
    for (int i = 0; i < isSelectSource.length; i++) {
      if (isSelectSource[i] == true) {
        haveSelect = true;
        break;
      }
    }
    if (haveSelect == false && _contentController.text.isEmpty) {
      BotToast.showText(text: "请选择原因或输入您想举报的问题");
      return;
    }
    BotToast.showLoading();
    Future.delayed(const Duration(milliseconds: 300), () {
      BotToast.closeAllLoading();
      BotToast.showText(text: "感谢您的反馈,经平台核实后属实我们将严厉处理!");
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
