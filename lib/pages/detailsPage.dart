import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nusabomdemais/model/product.dart';
import 'package:nusabomdemais/themes/light_color.dart';
import 'package:nusabomdemais/themes/theme.dart';
import 'package:nusabomdemais/widgets/extentions.dart';
import 'package:nusabomdemais/responsive.dart';
import 'package:nusabomdemais/widgets/title_text.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.productId}) : super(key: key);

  String productId;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;

  final _controller = PageController();

  static const _kDuration = Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (Responsive.isMobile(context))
            _icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
              size: 15,
              padding: 12,
              isOutLine: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          if (Responsive.isDesktop(context) || Responsive.isTablet(context))
            Container(),
          _icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? LightColor.red : LightColor.lightGrey,
              size: 15,
              padding: 12,
              isOutLine: false, onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          }),
        ],
      ),
    );
  }

  Widget _icon(
    IconData icon, {
    Color color = LightColor.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    required Function onPressed,
  }) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _detailWidget(Product product) {
    return Container(
      width: Responsive.isDesktop(context) || Responsive.isTablet(context)
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width,
      height: Responsive.isDesktop(context) || Responsive.isTablet(context)
          ? MediaQuery.of(context).size.height * 0.79
          : MediaQuery.of(context).size.height,
      padding: AppTheme.padding.copyWith(bottom: 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      //color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 5),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: TitleText(text: product.name, fontSize: 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const TitleText(
                            text: "\$ ",
                            fontSize: 16,
                            color: LightColor.red,
                          ),
                          TitleText(
                            text: product.price,
                            fontSize: 25,
                          ),
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Icon(Icons.star,
                              color: LightColor.yellowColor, size: 17),
                          Icon(Icons.star,
                              color: LightColor.yellowColor, size: 17),
                          Icon(Icons.star,
                              color: LightColor.yellowColor, size: 17),
                          Icon(Icons.star,
                              color: LightColor.yellowColor, size: 17),
                          Icon(Icons.star_border, size: 17),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            category(product),
            const SizedBox(
              height: 20,
            ),
            _description(product),
          ],
        ),
      ),
    );
  }

  Widget category(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Available Category",
          fontSize: 14,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            categoryWidget(product.details.adjective),
            categoryWidget(product.details.material, isSelected: true),
          ],
        )
      ],
    );
  }

  Widget categoryWidget(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _description(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(
          text: "Description",
          fontSize: 14,
        ),
        const SizedBox(height: 5),
        TitleText(
          text: product.description,
          fontSize: 12,
        ),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  Widget _productImage(Product product) {
    return Column(
      children: [
        Container(
          height: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? MediaQuery.of(context).size.height * 0.80
              : MediaQuery.of(context).size.height * 0.35,
          width: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: product.gallery.length,
                  // clipBehavior: Clip.hardEdge,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: Image.network(
                        product.gallery[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: Responsive.isDesktop(context) ||
                        Responsive.isTablet(context)
                    ? MediaQuery.of(context).size.width * 0.49
                    : MediaQuery.of(context).size.width,
                margin: EdgeInsets.zero,
                color: Colors.grey[800],
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: DotsIndicator(
                    controller: _controller,
                    itemCount: product.gallery.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xfffbfbfb),
                Color(0xfff7f7f7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: FutureBuilder(
                future: getProductDetail(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    // List<dynamic>? map = snapshot.data as List?;
                    Map<String, dynamic> map =
                        snapshot.data as Map<String, dynamic>;

                    Product product = Product.fromJson(map);

                    if (Responsive.isMobile(context)) {
                      return Column(
                        children: <Widget>[
                          _appBar(),
                          _productImage(product),
                          Expanded(child: _detailWidget(product))
                        ],
                      );
                    }
                    if (Responsive.isDesktop(context) ||
                        Responsive.isTablet(context)) {
                      return Column(
                        children: <Widget>[
                          _appBar(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productImage(product),
                              Expanded(child: _detailWidget(product))
                            ],
                          )
                          /*Row(
                            children: [
                              _productImage(product),
                              Expanded(child: _detailWidget(product))
                            ],
                          )*/
                        ],
                      );
                    }
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
                })),
      ),
    );
  }

  Future getProductDetail() async {
    final response = await http.get(Uri.parse(
        'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider/${widget.productId}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
