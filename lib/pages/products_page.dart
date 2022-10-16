import 'package:flutter/material.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductList>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products manager'),
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productList.itemsCount,
            itemBuilder: (ctx, index) =>
                Text(productList.items[index].description),
          ),
        ));
  }
}
