import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ai_chat/View/Knowledge/data/knowledges_data.dart';
import 'package:project_ai_chat/View/Knowledge/model/knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/page/edit_knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/page/new_knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/knowledge_card.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final _listKnowledge = knowledges;

  void _addKnowledge(Knowledge newKnowledge) {
    setState(() {
      _listKnowledge.add(newKnowledge);
    });
  }

  void _editKnowledge(Knowledge newEditKnowledge, indexEdit) {
    setState(() {
      _listKnowledge[indexEdit] = newEditKnowledge;
    });
  }

  void _openAddBotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NewKnowledge(
        addNewKnowledge: (newKnowledge) {
          _addKnowledge(newKnowledge);
        },
      ),
    );
  }

  void _openEditKnowledgeDialog(
      BuildContext context, Knowledge knowledge, int index) {
    // showDialog(
    //   context: context,
    //   builder: (context) => EditKnowledge(
    //     editKnowledge: (knowledge) {
    //       _editKnowledge(knowledge, index);
    //     },
    //     knowledge: knowledge,
    //   ),
    // );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditKnowledge(
          editKnowledge: (knowledge) {
            _editKnowledge(knowledge, index);
          },
          knowledge: knowledge,
        ),
      ),
    );
  }

  void _removeKnowledge(Knowledge knowledge) {
    final knowledgeDeleteIndex = _listKnowledge.indexOf(knowledge);

    setState(() {
      _listKnowledge.remove(knowledge);
    });

    // Undo remove knowledge
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Knowledge Base has been Deleted!"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _listKnowledge.insert(knowledgeDeleteIndex, knowledge);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Knowledges",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openAddBotDialog(context);
            },
            icon: const Icon(Icons.add),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 60, 56, 56),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _listKnowledge.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _openEditKnowledgeDialog(
                                context, _listKnowledge[index], index);
                          },
                          icon: Icons.edit,
                          backgroundColor: Colors.green,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _removeKnowledge(_listKnowledge[index]);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: KnowledgeCard(
                      knowledge: knowledges[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
