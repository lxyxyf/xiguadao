import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return DeleteAccountPageState();
  }
}

class DeleteAccountPageState extends State<DeleteAccountPage> {
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
                    '账号注销',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'images/jinggao.png',
              width: 53.5,
              height: 48,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              '账号注销',
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 27.5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 9, right: 9),
              height: 82,
              margin: const EdgeInsets.only(left: 25, right: 25),
              decoration: const BoxDecoration(
                  color: Color(0xffEEEEEE),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                            color: Color(0xff333333),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.5))),
                      ),
                      const SizedBox(
                        width: 5.5,
                      ),
                      const Text(
                        '身份、账号信息',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                            color: Color(0xff333333),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.5))),
                      ),
                      const SizedBox(
                        width: 5.5,
                      ),
                      const Text(
                        '个人隐私信息',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              margin: const EdgeInsets.only(left: 25.5, right: 25.5),
              child: const Text(
                '请再次确定是否注销账号,账号注销后将清除账号的全部数据，无法找回，请谨慎操作',
                maxLines: 5,
                style: TextStyle(color: Color(0xff999999), fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 122,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                //退出登录
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 15),
                            width: MediaQuery.of(context).size.width - 30,
                            height: 100,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                const Text(
                                  '确认注销此账号?',
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 12.5,
                                ),
                                Container(
                                  height: 0.5,
                                  color: const Color(0xffEEEEEE),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    accountDelete();
                                  },
                                  child: const Text(
                                    '注销',
                                    style: TextStyle(
                                        color: Color(0xffD81E06),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              alignment: Alignment.center,
                              child: const Text(
                                '取消',
                                style: TextStyle(
                                    color: Color(0xff4794F4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 25, right: 25),
                height: 50,
                decoration: const BoxDecoration(
                    color: Color(0xffFE7A24),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: const Text(
                  '确定注销',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///退出登录
  void accountDelete() async {
    //删除本地数据
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('UserId');
    sharedPreferences.remove('AccessToken');
    sharedPreferences.remove('RefreshToken');

    //返回登录
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }
}
