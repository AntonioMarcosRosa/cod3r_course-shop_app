import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_component.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/cart_item.dart';
import '../models/cart.dart';
import '../models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Text(
                    'R\$ ${cart.totalAmount}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            ?.color),
                  ),
                ),
                const Spacer(),
                CartButton(cart: cart)
              ],
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) => CartItemComponent(items[index]),
        ))
      ]),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: widget.cart.items.isEmpty
                ? null
                : () async {
                    try {
                      setState(() => _isLoading = true);
                      await Provider.of<OrderList>(
                        context,
                        listen: false,
                      ).addOrder(widget.cart);
                      widget.cart.clear();
                    } on HttpException catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(error.toString()),
                        ],
                      )));
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
            style: TextButton.styleFrom(
                textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
            child: const Text('BUY'));
  }
}
