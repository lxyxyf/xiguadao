import 'package:flutter/material.dart';

class WarpDemo extends StatefulWidget {
  const WarpDemo({super.key});

  @override
  _WarpDemoState createState() => _WarpDemoState();
}

class _WarpDemoState extends State<WarpDemo> {

  List<Widget> list = [];  //将添加的图片存放在列表中

  //初始化状态，给list添加值，这时候调用了一个自定义方法`buildAddButton`
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.add(buildAddButton());
  }

  @override
  Widget build(BuildContext context) {
    //得到屏幕的高度和宽度，用来设置Container的宽和高
    final width=MediaQuery.of(context).size.width;
    final heigth=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Warp流式布局"),
      ),
      body: Center(
        child: Opacity(
          opacity: 0.8,
          child: Container(
            width: width-50,
            height: 200,
            color: Colors.grey,
            //添加流式布局
            child: Wrap(
              spacing: 26.0,
              children: list,  //设置边距
            ),
          ),
        ),
      ),
    );
  }

  //显示加号的按钮，用于添加图片
  @override
  Widget buildAddButton(){
    //返回一个手势Widget，只用用于显示事件
    return GestureDetector(
      //布局设置
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80.0,
          height: 80.0,
          color: Colors.black45,
          child: const Icon(Icons.add),
        ),
      ),
      //事件的点击事件
      onTap: (){
        if(list.length<9){  //添加的图片最多9个
          //更新状态
          setState(() {
            list.insert(list.length-1, buildPhoto());
          });
        }
      },
    );
  }

  //添加图片的布局
  Widget buildPhoto(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 80.0,
        height: 80.0,
        color: Colors.amber,
        child: const Center(
          child: Text('图片'),
        ),
      ),
    );
  }
}
