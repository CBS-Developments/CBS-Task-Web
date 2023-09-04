import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'colors.dart';

class ChartBox extends StatelessWidget {

  final String centerText;
  final String footerText;
  final  percent;

  const ChartBox({super.key, required this.centerText, required this.footerText, this.percent});

  @override
  Widget build(BuildContext context) {


    return Container(
      width:180,
      height:180 ,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          // shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),

            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ]
      ),
      child: CircularPercentIndicator(
        radius: 50,
        lineWidth: 6,
        animation: true,
        percent: percent,
        center: new Text(
          centerText,
          style:
          new TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        footer:
        Padding(
          padding:  EdgeInsets.only(top: 15),
          child: Text(
            footerText,
            style:
            TextStyle( fontSize: 14),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppColor.complete,
        backgroundColor: AppColor.pending,
      ),

    );
  }
}
