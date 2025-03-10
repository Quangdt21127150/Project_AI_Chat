import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_confluence.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_ggdrive.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_slack.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_web.dart';

class LoadDataKnowledge extends StatefulWidget {
  const LoadDataKnowledge(
      {super.key,
      required this.type,
      required this.arrFile,
      required this.nameTypeData,
      required this.imageAddress,
      required this.addNewData,
      required this.removeData});
  final int type;
  final List<String> arrFile;
  final String nameTypeData;
  final String imageAddress;
  final void Function(String newData) addNewData;
  final void Function(String newData) removeData;

  @override
  State<LoadDataKnowledge> createState() => _LoadDataKnowledgeState();
}

class _LoadDataKnowledgeState extends State<LoadDataKnowledge> {
  void _openDialogAddFile(BuildContext context) {
    if (widget.type == 1) {
      showDialog(
          context: context,
          builder: (context) => FormLoadData(
                addNewData: _addNewFile,
              ));
    } else if (widget.type == 2) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataGGDrive(
                addNewData: _addNewFile,
              ));
    } else if (widget.type == 3) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataWeb(
                addNewData: _addNewFile,
              ));
    } else if (widget.type == 4) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataSlack(
                addNewData: _addNewFile,
              ));
    } else if (widget.type == 5) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataConfluence(
                addNewData: _addNewFile,
              ));
    }
  }

  void _addNewFile(String name) {
    widget.addNewData(name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft, // Align to the left
          child: Text(widget.nameTypeData),
        ),
        Column(
          children: widget.arrFile
              .map(
                (knowledge) => Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // const Icon(Icons.storage,
                        //     color: Colors.green, size: 30),
                        Image.network(
                          widget.imageAddress,
                          width: 34,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons
                                .storage); // Hiển thị icon lỗi nếu không load được hình
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            knowledge,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                widget.removeData(knowledge);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 6,
        ),
        OutlinedButton(
          onPressed: () {
            _openDialogAddFile(context);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: const Row(
            mainAxisSize:
                MainAxisSize.min, // Đảm bảo nút không chiếm toàn bộ chiều ngang
            children: [
              Icon(
                Icons.add,
                color: Colors.blue,
              ),
              SizedBox(width: 8), // Khoảng cách giữa icon và text
              Text(
                'Upload',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
