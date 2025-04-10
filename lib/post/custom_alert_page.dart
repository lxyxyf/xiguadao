import 'package:flutter/cupertino.dart';

class CustomAlertPage extends StatefulWidget {
  final confirmCallback;

  final title;

  final desText;

  const CustomAlertPage(this.confirmCallback, this.title, this.desText, {super.key});

  @override
  _CustomAlertPageState createState() => _CustomAlertPageState();
}

class _CustomAlertPageState extends State<CustomAlertPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: const Alignment(0, 0),
            child: Text(widget.desText),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("取消"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text("确定"),
          onPressed: () {
            widget.confirmCallback('确定');
          },
        ),
      ],
    );
  }
}
