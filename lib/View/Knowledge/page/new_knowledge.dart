import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/ViewModel/KnowledgeBaseProvider.dart';
import 'package:project_ai_chat/View/Knowledge/model/knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/load_data_knowledge.dart';
import 'package:provider/provider.dart';

class NewKnowledge extends StatefulWidget {
  const NewKnowledge({super.key, required this.addNewKnowledge});
  final void Function(Knowledge newKnowledge) addNewKnowledge;

  @override
  State<NewKnowledge> createState() => _NewKnowledgeState();
}

class _NewKnowledgeState extends State<NewKnowledge> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = ""; // name of knowledgbase
  String _enteredPrompt = ""; // description for knowledbase

  void _saveKnowledgeBase() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.addNewKnowledge(
        Knowledge(
            name: _enteredName,
            description: _enteredPrompt,
            imageUrl:
                "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
            listFiles: [],
            listGGDrives: [],
            listUrlWebsite: [],
            listConfluenceFiles: [],
            listSlackFiles: []),
      );

      Provider.of<KnowledgeBaseProvider>(context, listen: false)
          .addKnowledgeBase(_enteredName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tạo Bộ Tri Thức',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Text input for name of knowledgebase
              TextFormField(
                // controller: nameController,
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
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Dịch giả chuyên nghiệp | Chuyên gia viết lách | Trợ lý mã',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),

              // Text input for description of knowledgebase
              TextFormField(
                // controller: promptController,
                maxLines: 4,
                decoration: const InputDecoration(
                  // labelText: 'Prompt',
                  hintText: 'Nhập mô tả bộ tri thức...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPrompt = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Bạn là một dịch giả có kinh nghiệm với kỹ năng trong nhiều ngôn ngữ trên thế giới.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              // const SizedBox(height: 16),

              // // Load data for knowledge from file
              // const LoadDataKnowledge(
              //   arrFile: ["file1.pdf", "file2.pdf"],
              //   nameTypeData: "Nạp dữ liệu từ File",
              //   imageAddress:
              //       'https://i0.wp.com/static.vecteezy.com/system/resources/previews/022/086/609/non_2x/file-type-icons-format-and-extension-of-documents-pdf-icon-free-vector.jpg?ssl=1',
              // ),
              // const SizedBox(height: 16),
              // const LoadDataKnowledge(
              //   arrFile: ["drive1.com", "drive2.com"],
              //   nameTypeData: "Nạp dữ liệu từ Google Drive",
              //   imageAddress:
              //       "https://static-00.iconduck.com/assets.00/google-drive-icon-1024x1024-h7igbgsr.png",
              // ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: const BorderSide(width: 1, color: Colors.orange)),
              child: const Text(
                "Huỷ",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveKnowledgeBase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                "Tạo ngay",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
