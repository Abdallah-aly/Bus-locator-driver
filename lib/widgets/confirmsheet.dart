import 'package:cap_driver/brand_colors.dart';
import 'package:cap_driver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPress;

  ConfirmSheet({this.title, this.subtitle, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Brand-Bold',
                fontSize: 20,
                color: BrandColors.colorText),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: BrandColors.colorTextLight, fontSize: 15),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TaxiOutlineButton(
                    title: 'BACK',
                    color: BrandColors.colorLightGrayFair,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TaxiOutlineButton(
                    title: 'CONFIRM',
                    color: (title == 'GO ONLINE')
                        ? Colors.yellow[700]
                        : Colors.red,
                    onPressed: onPress,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
