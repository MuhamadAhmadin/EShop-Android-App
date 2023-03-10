import 'dart:convert';

import 'package:eshop/screens/edit_product.dart';
import 'package:eshop/screens/product_detail.dart';
import 'package:eshop/screens/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'https://baristawan.com/eshop_ahmadin/api/products';

  Future getProducts() async {
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async {
    String url =
        "https://baristawan.com/eshop_ahmadin/api/products/" + productId;
    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text('MA Store - Flutter'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black, Colors.red]),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/umc.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Text("Muhamad Ahmadin - 190511024 - K1"),
                ),
              ),
              Container(
                child: Text("Tugas Pemrograman Bergerak"),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  FutureBuilder(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...");
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data['data'].length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 240,
                                child: Card(
                                  elevation: 5,
                                  child: Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                      product: snapshot
                                                          .data['data'][index],
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        padding: EdgeInsets.all(5),
                                        height: 120,
                                        width: 120,
                                        child: Image.network(
                                            snapshot.data['data'][index]
                                                ['image_url'],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data['data'][index]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(snapshot.data['data']
                                                  [index]['formatted_desc']),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditProduct(
                                                                            product:
                                                                                snapshot.data['data'][index],
                                                                          )));
                                                        },
                                                        child:
                                                            Icon(Icons.edit)),
                                                    GestureDetector(
                                                        onTap: () {
                                                          deleteProduct(snapshot
                                                                  .data['data']
                                                                      [index]
                                                                      ['id']
                                                                  .toString())
                                                              .then((value) {
                                                            setState(() {});
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Data berhasil dihapus')));
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.delete)),
                                                  ],
                                                ),
                                                Text(snapshot.data['data']
                                                        [index]
                                                        ['formatted_price']
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                              return Text(snapshot.data['data'][index]['name']);
                            });
                      }

                      if (snapshot.hasError) {
                        return Text(
                            "Terjadi error " + snapshot.error.toString());
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
