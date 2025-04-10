import 'dart:math';
import 'package:flutter/material.dart';
class GestureDemo extends StatelessWidget {
  const GestureDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "gestureDemo",
      home: Scaffold(
        appBar: AppBar(),
        body: RulerWidget(onChanged: (double dx) {
//              print("$dx");
          print("当前刻度值是${dx / 5}");
        }, style: const TextStyle(),),
      ),
    );
  }
}

///绘制一个尺子
///
class RulerWidget extends StatefulWidget {
  ///尺子距离左边的距离
  double leftPadding;

  ///尺子的线宽
  double lineWidth;
  double line1Width;

  ///尺子的线的高度
  double line1Height;

  ///尺子第二高度
  double line2Height;

  ///尺子的第三高度
  double line3Height;
  Color lineColor;
  Color indicationColor;

  ///文字样式
  TextStyle style;

  ///尺子的最大刻度
  double maxScale;

  /// 5个dp对应一个刻度
  int unit;

  ///尺子的高度
  double rulerHeight;

  ///刻度和尺子的距离
  double paddingText;

  ///等边三角形的宽度
  double sanWidth;

  final void Function(double) onChanged;

  RulerWidget(
      {super.key, this.leftPadding = 5,
        this.lineWidth = 2,
        this.line1Width = 1,
        this.line1Height = 10,
        this.line2Height = 15,
        this.line3Height = 20,
        this.lineColor = Colors.blue,
        this.indicationColor = Colors.orange,
        this.maxScale = 100.0,
        this.unit = 5,
        this.rulerHeight = 50,
        this.paddingText = 5,
        this.sanWidth = 5,
        required this.onChanged,
        required this.style});

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<RulerWidget> {
  final ValueNotifier<double> _dx = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onPanUpdate: parse,
        child: CustomPaint(
          size: Size(
              widget.maxScale * widget.unit +
                  widget.leftPadding * 2 +
                  widget.maxScale * widget.lineWidth,
              widget.rulerHeight),
          painter: RulerCustomPainter(widget, _dx),
        ),
      ),
    );
  }

  double dx = 0;

  parse(DragUpdateDetails details) {
    dx += details.delta.dx;
    if (dx > 0) {
      dx = 0;
    }

    if (dx < -80 * widget.unit) {
      dx = -80.0 * widget.unit;
    }
    _dx.value = dx;

    widget.onChanged(dx);
    }
}

class RulerCustomPainter extends CustomPainter {
  RulerWidget widget;
  ValueNotifier<double> dx;

  RulerCustomPainter(this.widget, this.dx) : super(repaint: dx);

  @override
  void paint(Canvas canvas, Size size) {
    /// 当刻度是10的倍数的时候绘制最长刻度，并在刻度下面绘制文字
    /// 当刻度是5的倍数的时候绘制绘制第二长刻度
    /// 其他情况绘制一般的刻度

    canvas.clipRect(Offset.zero & size);

    canvas.save();
    canvas.translate(widget.leftPadding - widget.sanWidth / 2, 3);
    Path path = Path();
    path
      ..moveTo(0, 0)
      ..relativeLineTo(widget.sanWidth, 0)
      ..relativeLineTo(-widget.sanWidth / 2, sqrt(3) * widget.sanWidth / 2)
      ..close();

    canvas.drawPath(path, Paint()..color = const Color(0xFFFE7A24));
    canvas.restore();

    canvas.translate(widget.leftPadding, widget.leftPadding + 3);

    ///重新绘制的时候
    canvas.translate(dx.value, 0);

    for (int i = 0; i <= widget.maxScale; i++) {
      if (i % 10 == 0) {
        canvas.drawLine(
            Offset(i * 5.0, 0),
            Offset(i * 5.0, widget.line3Height),
            Paint()
              ..color = widget.lineColor
              ..strokeWidth = widget.lineWidth);
        drawText(i, canvas);
      } else if (i % 5 == 0) {
        canvas.drawLine(
            Offset(i * 5.0, 0),
            Offset(i * 5.0, widget.line2Height),
            Paint()
              ..color = widget.lineColor
              ..strokeWidth = widget.lineWidth);
      } else {
        canvas.drawLine(
            Offset(i * 5.0, 0),
            Offset(i * 5.0, widget.line1Height),
            Paint()
              ..color = widget.lineColor
              ..strokeWidth = widget.line1Width);
      }
    }
  }

  void drawText(int i, Canvas canvas) {
    var textPainter = TextPainter(
        text: TextSpan(
            text: "$i", style: const TextStyle(fontSize: 12, color: Colors.black)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left);
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(i * 5.0 - 2, widget.line3Height + widget.paddingText));
  }

  @override
  bool shouldRepaint(RulerCustomPainter oldDelegate) {
    return dx != oldDelegate.dx;
  }
}
