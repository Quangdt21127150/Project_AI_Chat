import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormLoadData extends StatefulWidget {
  const FormLoadData({super.key, required this.addNewData});
  final void Function(String newData) addNewData;

  @override
  State<FormLoadData> createState() => _FormLoadDataState();
}

class _FormLoadDataState extends State<FormLoadData> {
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
        "Add new knowledge",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
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
                        Icons.cloud_upload,
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
