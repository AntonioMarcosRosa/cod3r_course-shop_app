import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrderComponent extends StatefulWidget {
  final Order order;

  const OrderComponent({
    super.key,
    required this.order,
  });

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 24 + 10.0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                  'Pedido: ${widget.order.id}   (R\$ ${widget.order.total})'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded ? itemsHeight : 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: ListView(
                children: widget.order.products
                    .map((order) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${order.quantity}x R\$  ${order.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
