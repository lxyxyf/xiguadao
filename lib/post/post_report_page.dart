import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class PostReportPage extends StatefulWidget {
  const PostReportPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PostReportPageState();
  }
}

class PostReportPageState extends State<PostReportPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 24,
              padding: const EdgeInsets.only(left: 15, bottom: 5),
              alignment: Alignment.bottomLeft,
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  const Text(
                    '举报',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              padding: const EdgeInsets.only(
                  left: 25.5, right: 25.5, top: 15, bottom: 34.5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '举报内容',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8.5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.5),
                    height: 150,
                    decoration: const BoxDecoration(
                        color: Color(0xffF9F9F9),
                        borderRadius: BorderRadius.all(Radius.circular(7.5))),
                    child: TextField(
                      controller: controller,
                      maxLines: 99,
                      maxLength: 150,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                          hintText: '请详细并准确的描述你所遇到的情况，以便客服人员快速为你进行处理',
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 11,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 21.5,
                  ),
                  const Row(
                    children: [
                      Text(
                        '联系方式',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '（选填）',
                        style: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 13.5,
                  ),
                  Container(
                    height: 0.5,
                    color: const Color(0xffEEEEEE),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    child: const Row(
                      children: [
                        Text(
                          '你的名字',
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 21.5,
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              hintText: '请填写真实姓名',
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 14,
                              )),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: const Color(0xffEEEEEE),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    child: Row(
                      children: [
                        const Text(
                          '你的手机号',
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 21.5,
                        ),
                        const Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              hintText: '请填写真实手机号',
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 14,
                              )),
                        )),
                        Container(
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.text.isEmpty) {
                            BotToast.showText(text: '请填写举报内容');
                            return;
                          }
                          BotToast.showText(text: '您的举报已经提交至平台进行审核处理');
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color(0xffFE7A24).withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: const Text(
                            '提交',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
