import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListOfBalance extends StatelessWidget {
  final List<DocumentSnapshot> document;

  ListOfBalance({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String transactionId = document[document.length - 1 - i]['transactionId'].toString();
        int price = document[document.length - 1 - i]['priceTotal'];
        String date = document[document.length - 1 - i]['date'];

        final moneyCurrency = new NumberFormat("#,##0", "en_US");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Transaksi: INV-$transactionId'),
            Text('Tanggal: ' + date),
            Text('Pendapatan: Rp.${moneyCurrency.format(price)}'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            )
          ],
        );
      },
    );
  }
}