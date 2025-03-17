import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormLoadDataGGDrive extends StatefulWidget {
  const FormLoadDataGGDrive({super.key, required this.addNewData});
  final void Function(String newData) addNewData;

  @override
  State<FormLoadDataGGDrive> createState() => _FormLoadDataGGDriveState();
}

class _FormLoadDataGGDriveState extends State<FormLoadDataGGDrive> {
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
                  "https://static-00.iconduck.com/assets.00/google-drive-icon-1024x1024-h7igbgsr.png",
                  width: 34,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons
                        .storage); // Hiển thị icon lỗi nếu không load được hình
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  "Google Drive",
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
                    height: 16,
                  ),
                  const Text("* Google Drive Credential:"),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.outbox,
                              size: 80,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Click or drag file to this area to upload',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Url',
                      hintText: 'Nhập Url',
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
