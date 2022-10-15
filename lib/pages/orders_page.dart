import 'package:flutter/material.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/order_component.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
      ),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, index) => OrderComponent(order: orders.items[index]),
      ),
      drawer: const AppDrawer(),
    );
  }
}
