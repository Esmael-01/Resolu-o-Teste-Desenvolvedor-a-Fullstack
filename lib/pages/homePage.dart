import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nusabomdemais/model/product.dart';
import 'package:nusabomdemais/pages/detailsPage.dart';
import 'package:nusabomdemais/responsive.dart';
import 'package:nusabomdemais/themes/light_color.dart';
import 'package:nusabomdemais/themes/theme.dart';
import 'package:nusabomdemais/widgets/extentions.dart';
import 'package:nusabomdemais/widgets/title_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getAllProduct() async {
    final response = await http.get(Uri.parse(
        'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget productWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * 1.39,
      child: FutureBuilder(
        future: getAllProduct(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<dynamic>? map = snapshot.data as List?;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: Responsive.isDesktop(context) ||
                        Responsive.isTablet(context)
                    ? 4
                    : 2,
              ),
              itemCount: map!.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = Product.fromJson(map[index]);
                return Container(
                  decoration: const BoxDecoration(
                    color: LightColor.background,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xfff8f8f8),
                          blurRadius: 15,
                          spreadRadius: 10),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Image.network(
                        product.gallery[0],
                      )),
                      TitleText(
                        text: product.name,
                        fontSize: 14,
                      ),
                      TitleText(
                        text: product.price.toString(),
                        fontSize: 16,
                      ),
                      TitleText(
                        text:
                            '${double.parse(product.discountValue) * 100}% off',
                        fontSize: 12,
                        color: LightColor.orange,
                      ),
                    ],
                  ).ripple(
                    () {
                      Get.to(() => DetailsPage(
                            productId: product.id,
                          ));
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Transform.scale(
            scale: 0.5,
            child: const SizedBox(
              height: 500,
              // width: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[productWidget()],
        ),
      ),
    );
  }
}
