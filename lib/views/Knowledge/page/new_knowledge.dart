import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:project_ai_chat/views/Knowledge/widgets/load_data_knowledge.dart';
import 'package:provider/provider.dart';

class NewKnowledge extends StatefulWidget {
  const NewKnowledge({super.key, required this.addNewKnowledge});
  final void Function(String knowledgeName, String description) addNewKnowledge;

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
        _enteredName,
        _enteredPrompt,
      );

      // Provider.of<KnowledgeBaseProvider>(context, listen: false)
      //     .addKnowledgeBase(_enteredName);
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
                    'Create Knowledge Base',
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
                  labelText: 'Name',
                  hintText: 'Input Name',
                  suffixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ex: Professional Translator | Writing Specialist | Code Assistant',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),

              // Text input for description of knowledgebase
              TextFormField(
                // controller: promptController,
                maxLines: 4,
                decoration: const InputDecoration(
                  // labelText: 'Prompt',
                  hintText: 'Enter the knowledge base description...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input the description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPrompt = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'For example: "You are an experienced translator with skills in multiple languages around the world."',
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
            Expanded(
              child: SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    //padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.blue, width: 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Consumer<KnowledgeBaseProvider>(
                  builder: (context, kbProvider, child) {
                    return ElevatedButton(
                      onPressed: kbProvider.isLoading ? null : _saveKnowledgeBase,
                      style: ElevatedButton.styleFrom(
                        //padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            Colors.transparent, // Quan trọng để giữ gradient
                        shadowColor: Colors.transparent, // Loại bỏ bóng
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: kbProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
