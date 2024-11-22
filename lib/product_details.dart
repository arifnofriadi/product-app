import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Map<String, dynamic> productData;
  bool isLoading = true;
  bool isSoldOut = false;
  List<dynamic> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    final response = await http.get(Uri.parse('http://192.168.137.36:3005/product/${widget.productId}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var product = data[0];
      var cart = data[1];
      var reviewList = data[2];

      setState(() {
        productData = product;
        isSoldOut = cart['quantity'] == 0;
        reviews = reviewList;
        isLoading = false;
      });
    } else {
      print('Failed to load product data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/product.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 0.8)),
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  productData['name'] ?? 'Product Name',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Rp ${productData['price'] ?? '0'}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          top: 40.0,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );

    final bottomContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productData['description'] ?? 'Product Description',
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        if (isSoldOut)
          Text(
            'Sold Out',
            style: TextStyle(color: Colors.red, fontSize: 18.0),
          )
        else
          ElevatedButton(
            onPressed: () {
              // Add to Cart action
            },
            child: Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0), // Ganti 'primary' dengan 'backgroundColor'
              foregroundColor: Colors.white, // Ganti 'onPrimary' dengan 'foregroundColor'
              minimumSize: Size(double.infinity, 48),
            ),

          ),
        SizedBox(height: 16.0),
        Text(
          'Reviews:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        reviews.isEmpty
            ? Text('No reviews available.')
            : Column(
          children: reviews.map((review) {
            return ListTile(
              title: Text(review['reviews']),
            );
          }).toList(),
        ),
      ],
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: bottomContentText,
    );

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[topContent, Expanded(child: bottomContent)],
      ),
    );
  }
}

