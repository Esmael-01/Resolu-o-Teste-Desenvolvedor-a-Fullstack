import 'package:flutter/cupertino.dart';

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("shooping card")),
    );
  }
}
