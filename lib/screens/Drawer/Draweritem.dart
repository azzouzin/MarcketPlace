import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:e_commerce/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Mydraweritem extends StatelessWidget {
  Mydraweritem(
      {super.key,
      required this.title,
      required this.containercolor,
      required this.txtcolor,
      required this.iconcolor});
  final String title;
  final Color txtcolor;
  final Color iconcolor;
  final Color containercolor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      width: MediaQuery.of(context).size.width - 80.0,
      height: MediaQuery.of(context).size.height / 15,
      padding: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
        color: containercolor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Icon(
                    Icons.ac_unit_rounded,
                    color: iconcolor,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: txtcolor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
