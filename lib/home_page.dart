import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk mengelola JSON
import 'package:http/http.dart' as http;
import 'product_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.137.36:3000/products'));

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          "Daftar Produk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 8.0,
            margin:
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                    border: Border(
                      right:
                      BorderSide(width: 1.0, color: Colors.white70),
                    ),
                  ),
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
                title: Text(
                  product['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Rp ${product['price']}",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 30.0,
                ),
                onTap: () {
                  // Navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        productId: product['id'],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
