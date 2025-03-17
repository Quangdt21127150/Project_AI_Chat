import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/model/knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/load_data_knowledge.dart';

class EditKnowledge extends StatefulWidget {
  const EditKnowledge(
      {super.key, required this.editKnowledge, required this.knowledge});
  final void Function(Knowledge newKnowledge) editKnowledge;
  final Knowledge knowledge;

  @override
  State<EditKnowledge> createState() => _NewKnowledgeState();
}

class _NewKnowledgeState extends State<EditKnowledge> {
  final _formKey = GlobalKey<FormState>();

  // Text Form Field
  String _enteredName = ""; // name of knowledgbase
  String _enteredPrompt = ""; // description for knowledbase
  List<String> _listFiles = [];
  List<String> _listGGDrives = [];
  List<String> _listUrlWebsite = [];
  List<String> _listSlackFiles = [];
  List<String> _listConfluenceFiles = [];

  @override
  void initState() {
    super.initState();
    _enteredName = widget.knowledge.name;
    _enteredPrompt = widget.knowledge.description;
    _listFiles = List.from(widget.knowledge.listFiles);
    _listGGDrives = List.from(widget.knowledge.listGGDrives);
    _listUrlWebsite = List.from(widget.knowledge.listUrlWebsite);
    _listSlackFiles = List.from(widget.knowledge.listSlackFiles);
    _listConfluenceFiles = List.from(widget.knowledge.listConfluenceFiles);
  }

  void _saveKnowledgeBase() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.editKnowledge(
        Knowledge(
          name: _enteredName,
          description: _enteredPrompt,
          imageUrl:
              "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
          listFiles: _listFiles,
          listGGDrives: _listGGDrives,
          listUrlWebsite: _listUrlWebsite,
          listSlackFiles: _listSlackFiles,
          listConfluenceFiles: _listConfluenceFiles,
        ),
      );
      Navigator.pop(context);
    }
  }

  // Add File
  void _addNewFile(String newData) {
    setState(() {
      _listFiles.add(newData);
    });
  }

  void _addGGDrive(String newData) {
    setState(() {
      _listGGDrives.add(newData);
    });
  }

  void _addUrlWebsite(String newData) {
    setState(() {
      _listUrlWebsite.add(newData);
    });
  }

  void _addSlackFiles(String newData) {
    setState(() {
      _listSlackFiles.add(newData);
    });
  }

  void _addConfluenceFiles(String newData) {
    setState(() {
      _listConfluenceFiles.add(newData);
    });
  }

  // Remove File
  void _removeFile(String newData) {
    setState(() {
      _listFiles.remove(newData);
    });
  }

  void _removeGGDrive(String newData) {
    setState(() {
      _listGGDrives.remove(newData);
    });
  }

  void _removeUrlWebsite(String newData) {
    setState(() {
      _listUrlWebsite.remove(newData);
    });
  }

  void _removeSlackFiles(String newData) {
    setState(() {
      _listSlackFiles.remove(newData);
    });
  }

  void _removeConfluenceFiles(String newData) {
    setState(() {
      _listConfluenceFiles.remove(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa Bộ dữ liệu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tạo Bộ Tri Thức',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Text input for name of knowledgebase
                    TextFormField(
                      initialValue: _enteredName,
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
                      initialValue: _enteredPrompt,
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
                    const SizedBox(height: 16),

                    // Load data for knowledge from file
                    LoadDataKnowledge(
                      type: 1,
                      arrFile: _listFiles,
                      nameTypeData: "Nạp dữ liệu từ File",
                      imageAddress:
                          'https://i0.wp.com/static.vecteezy.com/system/resources/previews/022/086/609/non_2x/file-type-icons-format-and-extension-of-documents-pdf-icon-free-vector.jpg?ssl=1',
                      addNewData: _addNewFile,
                      removeData: _removeFile,
                    ),
                    const SizedBox(height: 16),

                    // Load data for knowledge from google Drive
                    LoadDataKnowledge(
                      type: 2,
                      arrFile: _listGGDrives,
                      nameTypeData: "Nạp dữ liệu từ Google Drive",
                      imageAddress:
                          "https://static-00.iconduck.com/assets.00/google-drive-icon-1024x1024-h7igbgsr.png",
                      addNewData: _addGGDrive,
                      removeData: _removeGGDrive,
                    ),
                    const SizedBox(height: 16),

                    // Load data for knowledge from url website
                    LoadDataKnowledge(
                      type: 3,
                      arrFile: _listUrlWebsite,
                      nameTypeData: "Nạp dữ liệu từ Website",
                      imageAddress:
                          "https://cdn-icons-png.flaticon.com/512/5339/5339181.png",
                      addNewData: _addUrlWebsite,
                      removeData: _removeUrlWebsite,
                    ),
                    const SizedBox(height: 16),

                    // Load data for knowledge from slack files
                    LoadDataKnowledge(
                      type: 4,
                      arrFile: _listSlackFiles,
                      nameTypeData: "Nạp dữ liệu từ Slack",
                      imageAddress:
                          "https://static-00.iconduck.com/assets.00/slack-icon-2048x2048-vhdso1nk.png",
                      addNewData: _addSlackFiles,
                      removeData: _removeSlackFiles,
                    ),
                    const SizedBox(height: 16),

                    // Load data for knowledge from Confluence file
                    LoadDataKnowledge(
                      type: 5,
                      arrFile: _listConfluenceFiles,
                      nameTypeData: "Nạp dữ liệu từ Confluence",
                      imageAddress:
                          "https://static.wixstatic.com/media/f9d4ea_637d021d0e444d07bead34effcb15df1~mv2.png/v1/fill/w_340,h_340,al_c,lg_1,q_85,enc_auto/Apt-website-icon-confluence.png",
                      addNewData: _addConfluenceFiles,
                      removeData: _removeConfluenceFiles,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveKnowledgeBase,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: const Text(
                        "Chỉnh sửa",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
