import 'package:flutter/material.dart';
import 'package:nusabomdemais/pages/homePage.dart';
import 'package:nusabomdemais/pages/searchPage.dart';
import 'package:nusabomdemais/pages/shoopingCardPage.dart';
import 'package:nusabomdemais/responsive.dart';
import 'package:nusabomdemais/themes/light_color.dart';
import 'package:nusabomdemais/themes/theme.dart';
import 'package:nusabomdemais/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:nusabomdemais/widgets/extentions.dart';
import 'package:nusabomdemais/widgets/sideMenu.dart';
import 'package:nusabomdemais/widgets/title_text.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isHomePageSelected = true;
  bool isSearchPage = false;
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (Responsive.isDesktop(context) || Responsive.isTablet(context))
            RotatedBox(
                quarterTurns: 4,
                child: _icon(Icons.sort, color: Colors.black54)),
          if (Responsive.isMobile(context)) Container(),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: Image.asset("assets/user.png"),
            ),
          ).ripple(() {},
              borderRadius: const BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            !isHomePageSelected
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.delete_outline,
                      color: LightColor.orange,
                    ),
                  ).ripple(() {},
                    borderRadius: const BorderRadius.all(Radius.circular(13)))
                : const SizedBox()
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0) {
      setState(() {
        isHomePageSelected = true;
        isSearchPage = false;
      });
    } else if (index == 1) {
      setState(() {
        isHomePageSelected = false;
        isSearchPage = true;
      });
    } else {
      setState(() {
        isHomePageSelected = false;
        isSearchPage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: AppTheme.fullHeight(context) - 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffbfbfb),
                    Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _appBar(),
                  if (Responsive.isDesktop(context) ||
                      Responsive.isTablet(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: SideMenu(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeInToLinear,
                            switchOutCurve: Curves.easeOutBack,
                            child: Stack(
                              children: [
                                isHomePageSelected
                                    ? MyHomePage()
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(),
                                      ),
                                isSearchPage
                                    ? SearchPage()
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Container(),
                                      ),
                              ],
                            ),
                          ),
                          /*Expanded(
                            child:
                          ),*/
                        )
                      ],
                    ),
                  if (Responsive.isMobile(context))
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: Stack(
                          children: [
                            isHomePageSelected
                                ? MyHomePage()
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(),
                                  ),
                            isSearchPage
                                ? SearchPage()
                                : Align(
                                    alignment: Alignment.center,
                                    child: Container(),
                                  ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: (!Responsive.isMobile(context))
                  ? const Text("")
                  : CustomBottomNavigationBar(
                      onIconPresedCallback: onBottomIconPressed,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
