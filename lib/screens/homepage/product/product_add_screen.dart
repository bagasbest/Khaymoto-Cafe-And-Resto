import 'dart:io';

import 'package:cafe_and_resto/databases/database_service.dart';
import 'package:cafe_and_resto/screens/login/register_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  var _name = TextEditingController();
  var _description = TextEditingController();
  var _quantity = TextEditingController();
  var _price = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool visible = false;
  bool isImageAdd = false;
  XFile? _image;

  List<String> _category = ['Makanan', 'Minuman'];
  var _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbbb5b),
        title: Text('Tambahkan Produk Baru'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 100,
                margin: EdgeInsets.only(
                  top: 16,
                ),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    (!isImageAdd)
                        ? GestureDetector(
                            onTap: () async {
                              _image = await DatabaseService.getImageGallery();
                              if (_image == null) {
                                setState(() {
                                  toast("Gagal ambil foto");
                                });
                              } else {
                                setState(() {
                                  isImageAdd = true;
                                  toast('Berhasil menambah foto');
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: [6, 6],
                                child: Container(
                                  child: Center(
                                    child: Text("* Tambah Foto"),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(
                                _image!.path,
                              ),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 16,
                ),
                height: 20,
                color: Colors.grey[200],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Nama Produk",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _name,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Masukkan Nama Produk",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Nama produk tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Container(
                color: Colors.grey[200],
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Deskripsi Produk",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Masukkan Deskripsi Produk",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Deskripsi produk tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Container(
                color: Colors.grey[200],
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Kategori Produk",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton(
                          underline:Container(),
                          hint: Text(
                            'Pilih Kategori',
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
                              ),
                              value: category,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Container(
                height: 5,
                color: Colors.grey[200],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Harga Produk",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _price,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Masukkan Harga Produk",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Harga produk tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              Container(
                height: 5,
                color: Colors.grey[200],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        child: Row(
                          children: [
                            Text(
                              "Kuantitas Produk",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _quantity,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Masukkan Kuantitas Produk",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Kuantitas produk tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 7,
              ),
              Visibility(
                visible: visible,
                child: SpinKitRipple(
                  color: Colors.orange,
                ),
              ),
              Container(
                height: 16,
                color: Colors.grey[200],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _image != null && _selectedCategory != null) {
                        setState(() {
                          visible = true;
                        });

                        String? url = (_image != null)
                            ? await DatabaseService.uploadImageProduct(_image!)
                            : null;

                        DatabaseService.setProduct(
                          _name.text,
                          _description.text,
                          _selectedCategory,
                          int.parse(_price.text),
                          int.parse(_quantity.text),
                          (url != null) ? url : '',
                        );

                        setState(() {
                          visible = false;
                          _name.text = "";
                          _description.text = "";
                          _quantity.text = "";
                          _price.text = "";
                          _image = null;
                          _selectedCategory = null;
                          isImageAdd = false;
                          showAlertDialog(context);
                        });
                      } else {
                        toast('Pastikan anda mengunggah gambar & memilih kategori produk');
                      }
                    },
                    child: Text("Unggah Produk",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    color: Colors.white,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
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
                'Sukses Diunggah',
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
              'Anda berhasil mengunggah produk baru',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 250,
                height: 50,
                child: Center(
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      letterSpacing: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xfffbbb5b),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        elevation: 10,
      );
    },
  );
}
