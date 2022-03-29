import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cafe_and_resto/screens/homepage/transaction/transaction_detail_list.dart';
import 'package:cafe_and_resto/screens/login/register_screen.dart';
import 'package:cafe_and_resto/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  final String transactionId;
  final String date;
  final String time;
  final int priceTotal;
  final String deskNumber;

  TransactionDetail({
    required this.transactionId,
    required this.date,
    required this.time,
    required this.priceTotal,
    required this.deskNumber,
  });

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final moneyCurrency = new NumberFormat("#,##0", "en_US");

  var querySnapshot;

  bool isLoading = true;
  bool isRipple = false;

  // PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  // List<PrinterBluetooth> _devices = [];
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String deviceMsg = '';

  // BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    bluetoothPrint.state.listen((val) {
      if (!mounted) return;
      if (val == 12) {
        print('on');
        initPrinter();
      } else if (val == 10) {
        print('off');
        setState(() {
          deviceMsg = 'Bluetooth Mati';
        });
      }
    });

    _initializeTransaction();

    super.initState();
  }

  _initializeTransaction() async {
    querySnapshot = await FirebaseFirestore.instance
        .collection('history_transaction')
        .where(
          'transactionId',
          isEqualTo: widget.transactionId,
        )
        .get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? LoadingWidget()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _showConfirmationDeleteTransaction();
              },
            ),
            appBar: AppBar(
              backgroundColor: Color(0xfffbbb5b),
              title: Text(
                'Transaksi INV-' + widget.transactionId,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      top: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        /// print transaksi
                        if (_devices.isEmpty) {
                          deviceMsg = 'Tidak ada printer terhubung!';
                          toast(deviceMsg);
                        } else {
                          _showPrintDialog();
                        }
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.print,
                              color: Color(0xfffbbb5b),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      right: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        child: (isRipple)
                            ? SpinKitRipple(
                                color: Color(0xfffbbb5b),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode Transaksi: INV-' + widget.transactionId,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Tanggal Transaksi: ' + widget.date,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Nomor Meja: ' + widget.deskNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Waktu Transaksi: ' + widget.time,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Total Harga: Rp.${moneyCurrency.format(widget.priceTotal)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Daftar Produk',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nama Produk',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Kuantitas',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Harga Pokok',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Total Harga',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 230,
                      left: 16,
                      right: 16,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('history_transaction')
                          .where(
                            'transactionId',
                            isEqualTo: widget.transactionId,
                          )
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return (snapshot.hasData)
                            ? (snapshot.data!.size > 0)
                                ? ListOfHistoryTransaction(
                                    document: snapshot.data!.docs,
                                  )
                                : Container()
                            : Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _showConfirmationDeleteTransaction() {
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
                  'Konfirmasi Hapus Transaksi',
                  textAlign: TextAlign.center,
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
                'Apakah anda yakin ingin menghapus transaksi ini ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
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

              /// delete invoice by transactionId
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('invoice')
                    .doc(widget.transactionId)
                    .delete();

                /// delete transaction_history by transactionId
                var snapshot = await FirebaseFirestore.instance
                    .collection('history_transaction')
                    .where('transactionId', isEqualTo: widget.transactionId)
                    .get();
                for (var doc in snapshot.docs) {
                  await doc.reference.delete();
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }

  void initPrinter() {
    bluetoothPrint.startScan(
      timeout: Duration(
        seconds: 2,
      ),
    );

    /// deteksi printer bluetooth
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
        if (_devices.isEmpty) {
          setState(() {
            deviceMsg = "Tidak Ada Printer Terhubung";
          });
        }
      });
    });
  }

  void _showPrintDialog() {
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
                  'Pilih Printer',
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
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      title: Text(
                        _devices[i].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _devices[i].address!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _startPrint(_devices[i]);
                      },
                    );
                  },
                ),
              )
            ],
          ),
          elevation: 10,
        );
      },
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [];

      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "KHAYMOTO\nCAFE & RESTO",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 2,
        ),
      );


      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: 'ID Transaksi: INV-' + widget.transactionId,
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        )
      );

      list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'Tanggal: ' + widget.date,
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          )
      );

      list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'Waktu: ' + widget.time,
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          )
      );

      list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'Total Harga: Rp.${moneyCurrency.format(widget.priceTotal)}',
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 2,
          )
      );


      for(int i = 0; i < querySnapshot.docs.length; i++) {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: querySnapshot.docs[i]['name'].toString(),
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          )
        );

        list.add(
            LineText(
              type: LineText.TYPE_TEXT,
              content: 'Rp. ${moneyCurrency.format(querySnapshot.docs[i]['priceBase'])} x ${querySnapshot.docs[i]['qty'].toString()}',
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
            )
        );

        list.add(
            LineText(
              type: LineText.TYPE_TEXT,
              content: 'Rp ${moneyCurrency.format(querySnapshot.docs[i]['price'])}',
              weight: 0,
              align: LineText.ALIGN_LEFT,
              linefeed: 2,
            )
        );
      }


      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Terima Kasih",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 2,
        ),
      );
    } else {
      toast('Gagal Print Struk');
    }
  }

  // Future<Ticket> _ticket(PaperSize paper) async {
  //   final ticket = Ticket(paper);
  //   ticket.text('KHAYMOTO\nCAFE & RESTO',
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));
  //   ticket.feed(2);
  //   ticket.text('ID Transaksi: INV-' + widget.transactionId);
  //   ticket.text('Tanggal: ' + widget.date);
  //   ticket.text('Waktu: ' + widget.time);
  //   ticket.text('Total Harga: Rp.${moneyCurrency.format(widget.priceTotal)}');
  //   ticket.feed(2);
  //
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     ticket.text(querySnapshot.docs[i]['name'].toString());
  //     ticket.row([
  //       PosColumn(
  //           text:
  //               'Rp. ${moneyCurrency.format(querySnapshot.docs[i]['priceBase'])} x ${querySnapshot.docs[i]['qty'].toString()}',
  //           width: 8),
  //       PosColumn(
  //         text: 'Rp ${moneyCurrency.format(querySnapshot.docs[i]['price'])}',
  //         width: 4,
  //       ),
  //     ]);
  //   }
  //
  //   ticket.feed(2);
  //   ticket.text('Terima Kasih',
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         bold: true,
  //       ));
  //   ticket.cut();
  //   return ticket;
  // }

  @override
  void dispose() {
    bluetoothPrint.stopScan();
    super.dispose();
  }
}
