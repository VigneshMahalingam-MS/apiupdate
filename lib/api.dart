import 'package:apiupdate/Update_Method.dart';
import 'package:apiupdate/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCall extends StatefulWidget {
  const ApiCall({super.key});

  @override
  State<ApiCall> createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {
  List<User> data = [];

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse("http://192.168.31.93:5000/get"));

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['data'] != null && jsonData['data'] is List) {
          final List<dynamic> productList = jsonData['data'];
          setState(() {
            data = productList.map((item) => User.fromJson(item)).toList();
          });
        } else {
          print('No products found or products is not a list');
          setState(() {
            data = [];
          });
        }
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Method'),
        backgroundColor: Colors.blue,
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                User user = data[index];
                return ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        data.removeWhere((entry) => entry == user);
                      });
                    },
                    icon: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateMethod(
                                    data: user,
                                    onUpdate: (updatedUser) {
                                      setState(() {
                                        int index = data.indexOf(user);
                                        if (index != -1) {
                                          data[index] = updatedUser;
                                        }
                                      });
                                    }),
                              ));
                        },
                        child: Icon(Icons.arrow_forward_ios)),
                    color: Colors.blue,
                  ),
                  title: Text(data[index].fname),
                  subtitle: Text(data[index].lname),
                );
              },
            ),
    );
  }
}
