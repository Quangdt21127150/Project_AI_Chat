import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:project_ai_chat/views/Knowledge/page/edit_knowledge.dart';
import 'package:project_ai_chat/views/Knowledge/page/new_knowledge.dart';
import 'package:project_ai_chat/views/Knowledge/widgets/knowledge_card.dart';
import 'package:project_ai_chat/services/analytics_service.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:provider/provider.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  late ScrollController
      _scrollController; // variable for load more conversation
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        // Khi cuộn đến cuối danh sách
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<KnowledgeBaseProvider>(context, listen: false)
              .fetchAllKnowledgeBases(isLoadMore: true);
        }
      });
  }

  void _addKnowledge(String knowledgeName, String description) async {
    bool isSuccess =
        await Provider.of<KnowledgeBaseProvider>(context, listen: false)
            .addKnowledgeBase(knowledgeName, description);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully created '),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fail created '),
          backgroundColor: Colors.red,
        ),
      );
    }

    AnalyticsService().logEvent(
      "new_knowledge",
      {
        "name": knowledgeName,
        "description": description,
      },
    );
  }

  void _editKnowledge(
      String id, int index, String knowledgeName, String description) async {
    bool isSuccess =
        await Provider.of<KnowledgeBaseProvider>(context, listen: false)
            .editKnowledgeBase(id, index, knowledgeName, description);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully edited '),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fail edited '),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openAddBotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NewKnowledge(
        addNewKnowledge: (String knowledgeName, String description) {
          _addKnowledge(knowledgeName, description);
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
          editKnowledge: (Knowledge knowledge) {
            _editKnowledge(
                knowledge.id, index, knowledge.name, knowledge.description);
          },
          knowledge: knowledge,
        ),
      ),
    );
  }

  void _removeKnowledge(String id, int index) async {
    bool isSuccess =
        await Provider.of<KnowledgeBaseProvider>(context, listen: false)
            .deleteKnowledgeBase(id, index);

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

    // Undo remove knowledge
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     duration: const Duration(seconds: 3),
    //     content: const Text("Knowledge Base has been Deleted!"),
    //     action: SnackBarAction(
    //       label: 'Undo',
    //       onPressed: () {
    //         setState(() {
    //           _listKnowledge.insert(knowledgeDeleteIndex, knowledge);
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    Provider.of<KnowledgeBaseProvider>(context, listen: false).query(query);
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
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch, // Nhấn icon tìm kiếm để gọi API
                ),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<KnowledgeBaseProvider>(
                builder: (context, kbProvider, child) {
                  if (kbProvider.isLoading &&
                      kbProvider.knowledgeBases.isEmpty) {
                    // Display loading indicator while fetching conversations
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (kbProvider.error != null &&
                      kbProvider.knowledgeBases.isEmpty) {
                    // Display error message if there's an error
                    return Center(
                      child: Text(
                        kbProvider.error ?? 'Server error, please try again',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: kbProvider.knowledgeBases.length + 1,
                    itemBuilder: (context, index) {
                      if (index == kbProvider.knowledgeBases.length) {
                        // Loader khi đang tải thêm
                        if (kbProvider.hasNext &&
                            kbProvider.knowledgeBases.length >= 8) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox.shrink(); // Không còn dữ liệu
                        }
                      }

                      final _listKnowledges = kbProvider.knowledgeBases;
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _openEditKnowledgeDialog(
                                    context, _listKnowledges[index], index);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.green,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _removeKnowledge(
                                    _listKnowledges[index].id, index);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: KnowledgeCard(
                          knowledge: _listKnowledges[index],
                        ),
                      );
                    },
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
