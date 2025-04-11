import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ai_chat/views/Knowledge/widgets/load_data_knowledge.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:project_ai_chat/views/Knowledge/widgets/load_data_knowledge.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:provider/provider.dart';

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
  late ScrollController
      _scrollController; // variable for load more conversation

  // Text Form Field
  String _enteredName = ""; // name of knowledgbase
  String _enteredPrompt = ""; // description for knowledbase

  @override
  void initState() {
    super.initState();
    _enteredName = widget.knowledge.name;
    _enteredPrompt = widget.knowledge.description;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KnowledgeBaseProvider>(context, listen: false)
          .fetchUnitsOfKnowledge(false, widget.knowledge.id);
    });

    _scrollController = ScrollController()
      ..addListener(() {
        // Khi cuộn đến cuối danh sách
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<KnowledgeBaseProvider>(context, listen: false)
              .fetchUnitsOfKnowledge(true, widget.knowledge.id);
        }
      });
  }

  void _saveKnowledgeBase() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.editKnowledge(
        Knowledge(
          name: _enteredName,
          description: _enteredPrompt,
          id: widget.knowledge.id,
          imageUrl:
              "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
        ),
      );
      Navigator.pop(context);
    }
  }

  String getImageByUnitType(String unitType) {
    switch (unitType) {
      case "local_file":
        return 'https://icon-library.com/images/files-icon-png/files-icon-png-10.jpg';
      case "gg_drive":
        return 'https://static-00.iconduck.com/assets.00/google-drive-icon-1024x1024-h7igbgsr.png';
      case "web":
        return 'https://cdn-icons-png.flaticon.com/512/5339/5339181.png';
      case "slack":
        return 'https://static-00.iconduck.com/assets.00/slack-icon-2048x2048-vhdso1nk.png';
      case "confluence":
        return 'https://static.wixstatic.com/media/f9d4ea_637d021d0e444d07bead34effcb15df1~mv2.png/v1/fill/w_340,h_340,al_c,lg_1,q_85,enc_auto/Apt-website-icon-confluence.png';
      default:
        return "";
    }
  }

  // Add File
  void _addNewFile(String newData) {
    // setState(() {
    //   _listFiles.add(newData);
    // });
  }

  // Remove File
  void _removeFile(String newData) {
    // setState(() {
    //   _listFiles.remove(newData);
    // });
  }

  void _removeUnit(String unitId) async {
    bool isSuccess =
        await Provider.of<KnowledgeBaseProvider>(context, listen: false)
            .deleteUnit(unitId, widget.knowledge.id);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully deleted '),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fail deleted '),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleUnitStatus(String unitId, bool isActive) async {
    await Provider.of<KnowledgeBaseProvider>(context, listen: false)
        .updateStatusUnit(widget.knowledge.id, unitId, isActive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Knowledge Base",
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
                          'Edit name & descriptions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Text input for name of knowledgebase
                    TextFormField(
                      initialValue: _enteredName,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Input name',
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
                      initialValue: _enteredPrompt,
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
                    const SizedBox(height: 16),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Add Units',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    LoadDataKnowledge(
                      addNewData: _addNewFile,
                      removeData: _removeFile,
                      knowledgeId: widget.knowledge.id,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'List Units',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Consumer<KnowledgeBaseProvider>(
                      builder: (context, kbProvider, child) {
                        Knowledge kb =
                            kbProvider.getKnowledgeById(widget.knowledge.id);

                        if (kbProvider.isLoading && kb.listUnits.isEmpty) {
                          // Display loading indicator while fetching conversations
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (kbProvider.error != null && kb.listUnits.isEmpty) {
                          // Display error message if there's an error
                          return Center(
                            child: Text(
                              kbProvider.error ??
                                  'Server error, please try again',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 300,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: kb.listUnits.length + 1,
                            itemBuilder: (context, index) {
                              if (index == kb.listUnits.length) {
                                // Loader khi đang tải thêm
                                if (kbProvider.hasNextUnit) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink(); // Không còn dữ liệu
                                }
                              }
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: kbProvider.isLoading
                                          ? null
                                          : (context) {
                                              _removeUnit(
                                                  kb.listUnits[index].unitId);
                                            },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        // const Icon(Icons.storage,
                                        //     color: Colors.green, size: 30),
                                        Image.network(
                                          getImageByUnitType(
                                              kb.listUnits[index].unitType),
                                          width: 34,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons
                                                .storage); // Hiển thị icon lỗi nếu không load được hình
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            kb.listUnits[index].unitName,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Switch(
                                              value: kb.listUnits[index]
                                                  .isActived, // Giá trị trạng thái hiện tại của unit
                                              onChanged: (bool value) {
                                                _toggleUnitStatus(
                                                    kb.listUnits[index].unitId,
                                                    value);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: _saveKnowledgeBase,
              //         style: ElevatedButton.styleFrom(
              //           padding: EdgeInsets.symmetric(vertical: 16),
              //           backgroundColor: Colors.blue,
              //           shape: const RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //           ),
              //         ),
              //         child: const Text(
              //           "Chỉnh sửa",
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
