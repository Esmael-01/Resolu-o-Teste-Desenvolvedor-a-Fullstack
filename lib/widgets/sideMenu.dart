import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/user.png",
            ),
          ),
          DrawerListTile(
            title: "HOME",
            // svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "SEARCH",
            //  svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
              title: "CARD",
              // svgSrc: "assets/icons/menu_notification.svg",
              press: () {}),
          DrawerListTile(
            title: "FAVORITE",
            // svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    // required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title;
  //final String svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
