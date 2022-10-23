import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/utils/constants.dart';
import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.orderBaseUrl}.json'),
      body: jsonEncode({
        'date': date.toIso8601String(),
        'total': cart.totalAmount,
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                })
            .toList(),
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          date: date,
          products: cart.items.values.toList(),
        ));
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.removeAt(0);
      throw HttpException(
        message: 'Não foi possível fechar o pedido.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> listOrders() async {
    final response =
        await http.get(Uri.parse('${Constants.orderBaseUrl}.json'));

    if (response.body == 'null') return;

    if (response.statusCode >= 400) {
      throw HttpException(
        message: 'Houve um erro ao carregar os pedidos',
        statusCode: response.statusCode,
      );
    }
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      _items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>)
              .map((product) => CartItem(
                    id: product['id'],
                    productId: product['productId'],
                    name: product['name'],
                    quantity: product['quantity'],
                    price: product['price'],
                  ))
              .toList(),
        ),
      );
    });
    notifyListeners();
  }
}
