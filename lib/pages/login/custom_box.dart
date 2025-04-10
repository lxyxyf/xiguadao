import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

class CustomBox extends StatelessWidget {
  final String title;
  final WheelSlider wheelSlider;
  final Text? valueText;

  const CustomBox(
      {Key? key,
        required this.title,
        required this.wheelSlider,
        this.valueText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(

      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(
            height: 0.0,
          ),
          valueText ?? Container(),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: const Image(
              image: AssetImage('images/sanjiao.png'),
              width: 10.5,
              fit: BoxFit.fitWidth,
            ),
          ),

          wheelSlider,
        ],
      ),
    );
  }
}