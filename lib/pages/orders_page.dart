import 'package:flutter/material.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/order_component.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).listOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
      ),
      body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).listOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print(snapshot.connectionState);
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<OrderList>(
                builder: (ctx, orders, child) => RefreshIndicator(
                  onRefresh: () => _refreshOrders(context),
                  child: ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, index) =>
                        OrderComponent(order: orders.items[index]),
                  ),
                ),
              );
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}
