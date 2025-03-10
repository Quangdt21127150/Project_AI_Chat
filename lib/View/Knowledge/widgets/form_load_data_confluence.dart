import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormLoadDataConfluence extends StatefulWidget {
  const FormLoadDataConfluence({super.key, required this.addNewData});
  final void Function(String newData) addNewData;

  @override
  State<FormLoadDataConfluence> createState() => _FormLoadDataConfluenceState();
}

class _FormLoadDataConfluenceState extends State<FormLoadDataConfluence> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";

  void _saveFile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.addNewData(_enteredName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add Unit",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://static.wixstatic.com/media/f9d4ea_637d021d0e444d07bead34effcb15df1~mv2.png/v1/fill/w_340,h_340,al_c,lg_1,q_85,enc_auto/Apt-website-icon-confluence.png",
                  width: 34,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons
                        .storage); // Hiển thị icon lỗi nếu không load được hình
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  "Website",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      hintText: 'Nhập tên',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Wiki Page URL:',
                      hintText: 'Nhập Wiki Page URL:',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confluence Username:',
                      hintText: 'Nhập Confluence Username:',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confluence Access Token:',
                      hintText: 'Nhập Confluence Access Token:',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: _saveFile,
              child: const Text("Tạo Ngay"),
            ),
          ],
        ),
      ],
    );
  }
}
