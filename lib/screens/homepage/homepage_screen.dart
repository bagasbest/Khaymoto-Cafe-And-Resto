import 'package:cafe_and_resto/screens/homepage/product/product_screen.dart';
import 'package:cafe_and_resto/screens/homepage/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'balance/balance_screen.dart';
import 'cart/cart_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final tabs = [
    ProductScreen(),
    CartScreen(),
    TransactionScreen(),
    BalanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.all_inbox,
              color: Color(0xfffbbb5b),
            ),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon:  Icon(
              Icons.shopping_cart,
              color: Color(0xfffbbb5b),
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon:  Icon(
              Icons.payment,
              color: Color(0xfffbbb5b),
            ),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon:  Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xfffbbb5b),
            ),
            label: 'Pendapatan',
          ),
        ],
        selectedItemColor: Color(0xfffbbb5b),

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}