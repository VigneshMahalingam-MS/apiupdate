import 'package:apiupdate/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateMethod extends StatefulWidget {
  final User data;
  final Function(User) onUpdate;
  const UpdateMethod({super.key, required this.data, required this.onUpdate});

  @override
  State<UpdateMethod> createState() => _UpdateMethodState();
}

class _UpdateMethodState extends State<UpdateMethod> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnameController.text = widget.data.fname;
    lnameController.text = widget.data.lname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                User updatedData = User(
                  fname: fnameController.text,
                  lname: lnameController.text,
                  email: widget.data.email,
                );
                updateUser(updatedData).then((_) {
                  widget.onUpdate(updatedData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User Update Successfully')),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error updating user: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update user.')),
                  );
                });
              },
              child: const Text('Update User'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateUser(User data) async {
    const String url =
        'http://192.168.31.93:5000/update?email=vignesh51268@gmail.com';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('User  updated successfully: ${response.body}');
      } else {
        print('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
    }
  }
}
