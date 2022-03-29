import 'package:cafe_and_resto/databases/database_service.dart';
import 'package:cafe_and_resto/screens/login/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartDetail extends StatefulWidget {
  final String productId;
  final String cartId;
  final String name;
  int qty;
  final String description;
  int price;
  final String image;
  final int priceBase;

  CartDetail({
    required this.productId,
    required this.cartId,
    required this.name,
    required this.qty,
    required this.description,
    required this.price,
    required this.image,
    required this.priceBase,
  });

  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  final moneyCurrency = new NumberFormat("#,##0", "en_US");
  var _qty = TextEditingController();

  @override
  void initState() {
    super.initState();
    _qty.text = widget.qty.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Keranjang',
        ),
        backgroundColor: Color(0xfffbbb5b),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton(
            onSelected: _handleClick,
            itemBuilder: (BuildContext context) {
              return {'Kurangi kuantitas produk', 'Hapus produk dari keranjang'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              (widget.image != '')
                  ? widget.image
                  : 'https://images.unsplash.com/photo-1579621970795-87facc2f976d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga: Rp.' + moneyCurrency.format(widget.price),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Pembelian: ' + widget.qty.toString() + ' pcs',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleClick(String value) {
    switch (value) {
      case 'Kurangi kuantitas produk':
        _showConfirmAddProduct();
        break;
      case 'Hapus produk dari keranjang':
        _deleteProduct(context);
        break;
    }
  }

  _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                'Konfirmasi Menghapus',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Icon(
                Icons.delete,
                color: Color(0xfffbbb5b),
              ),
            ],
          ),
          content: Text(
              'Apakah anda yakin ingin menghapus produk "${widget.name}" dari keranjang ?'),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {

                await FirebaseFirestore.instance
                    .collection('product')
                    .doc(widget.productId)
                    .get()
                    .then((value) {
                  int qtyFinal = value.data()!['quantity'] +
                      widget.qty;

                  FirebaseFirestore.instance
                      .collection('product')
                      .doc(widget.productId)
                      .update({
                    'quantity': qtyFinal,
                  });
                });

                await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(widget.cartId)
                    .delete()
                    .then(
                      (value) => {
                        toast(
                          'Berhasil Menghapus Produk ${widget.name} dari keranjang',
                        ),
                      },
                    )
                    .catchError(
                  (error) {
                    toast(
                        'Gagal Menghapus Produk ${widget.name} dari keranjang');
                  },
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showConfirmAddProduct() {
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
                  'Kurangi Kuantitas Produk',
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
                'Tersedia ${widget.qty} pcs, anda ingin mengurangi berapa banyak produk ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Form(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _qty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Kurangi kuantitas',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kuantitas tidak boleh kosong';
                      } else if (int.parse(_qty.text) >= widget.qty) {
                        return 'Maksimal ${widget.qty - 1} produk';
                      } else if (_qty.text == '0') {
                        return 'Minimal 1 produk';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
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
                print(_qty.text);
                print(widget.qty);

                if (int.parse(_qty.text) < widget.qty) {
                  int price =
                      (widget.qty - int.parse(_qty.text)) * widget.priceBase;

                  await DatabaseService.updateCart(
                    widget.cartId,
                    widget.qty - int.parse(_qty.text),
                    price,
                  );

                  await FirebaseFirestore.instance
                      .collection('product')
                      .doc(widget.productId)
                      .get()
                      .then((value) {
                    int qtyFinal = value.data()!['quantity'] +
                        int.parse(_qty.text);

                    FirebaseFirestore.instance
                        .collection('product')
                        .doc(widget.productId)
                        .update({
                      'quantity': qtyFinal,
                    });
                  });

                  Navigator.of(context).pop();

                  setState(() {
                    widget.qty = widget.qty - int.parse(_qty.text);
                    widget.price = price;
                  });
                } else {
                  toast("minimal harus tersisa 1 produk");
                }
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }
}
