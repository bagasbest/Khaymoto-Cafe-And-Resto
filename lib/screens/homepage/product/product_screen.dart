import 'dart:ui';

import 'package:cafe_and_resto/screens/homepage/product/product_add_screen.dart';
import 'package:cafe_and_resto/screens/homepage/product/product_list.dart';
import 'package:cafe_and_resto/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String> _category = ['Semua Produk', 'Makanan', 'Minuman'];
  var _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => ProductAdd());
          Navigator.push(context, route);
        },
        backgroundColor: Color(0xfffbbb5b),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 40,
              left: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Produk Tersedia',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xfffbbb5b),
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showDialogLogout();
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 77,
            ),
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 90, left: 16, right: 16),
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
              hint: Text(
                'Pilih Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Not necessary for Option 1
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue.toString();
                  print(_selectedCategory);
                });
              },
              items: _category.map((category) {
                return DropdownMenuItem(
                  child: new Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: category,
                );
              }).toList(),
            ),
          ),

          /// tampilkan semua produk tersedia
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 130),
            child: StreamBuilder(
              stream: (_selectedCategory == "Semua Produk" ||
                      _selectedCategory == null)
                  ? FirebaseFirestore.instance.collection('product').snapshots()
                  : (_selectedCategory == 'Makanan')
                      ? FirebaseFirestore.instance
                          .collection('product')
                          .where('category', isEqualTo: 'Makanan')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('product')
                          .where('category', isEqualTo: 'Minuman')
                          .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data!.size > 0)
                      ? ListOfProduct(
                          document: snapshot.data!.docs,
                        )
                      : _emptyData();
                } else {
                  return _emptyData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Produk\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  _showDialogLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Color(0xfffbbb5b),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Konfirmasi Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Apakah anda yakin ingin Logout ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }
}
