import 'package:flutter/material.dart';

import 'constants.dart';

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.icon_name,
    required this.section_name,
    required this.index,
    required this.onPress,
  });

  final List<IconData> icon_name;
  final List<String> section_name;
  final int index;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(.3),
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
              color: lightColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: primaryColor,
                width: 2,
                style: BorderStyle.solid,
              )),
          height: 95,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: lightColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    icon_name[index],
                    size: 60,
                    color: primaryColor,
                  ),
                ),
              ),
              Text(
                section_name[index],
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
