import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/ai_logo.dart';
import 'package:project_ai_chat/services/prompt_service.dart';
import 'package:project_ai_chat/viewmodels/aichat_list_view_model.dart';
import 'package:project_ai_chat/viewmodels/homechat_view_model.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:project_ai_chat/models/prompt_list.dart';
import 'package:project_ai_chat/models/prompt.dart';
import 'package:provider/provider.dart';

import '../../../../models/prompt_model.dart';
import '../../enums.dart';
import '../PromptDetailsBottomSheet/prompt_details_bottom_sheet.dart';

class PromptListWidget extends StatefulWidget {
  final String category;
  final String query;
  final bool isFavorite;
  final bool isPublic;
  final bool isCreated;

  const PromptListWidget({
    Key? key,
    required this.category,
    this.query = '',
    this.isFavorite = false,
    this.isCreated = false,
    required this.isPublic,
  }) : super(key: key);

  @override
  _PromptListWidgetState createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  late Future<PromptList> _prompts;
  final Map<String, bool> _favoriteStates = {}; // Theo dõi trạng thái yêu thích
  bool isDeleting = false;
  final viewModel = PromptListViewModel();

  @override
  void didUpdateWidget(PromptListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.category != widget.category ||
        oldWidget.query != widget.query ||
        oldWidget.isFavorite != widget.isFavorite ||
        oldWidget.isPublic != widget.isPublic ||
        widget.isCreated == true) {
      setState(() {
        _prompts = _fetchPrompts(
          category: widget.category,
          query: widget.query,
          isFavorite: widget.isFavorite,
          isPublic: widget.isPublic,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _prompts = viewModel.fetchPrompts(
      category: widget.category,
      query: widget.query,
      isFavorite: widget.isFavorite,
      isPublic: widget.isPublic,
    );
  }

  Future<PromptList> _fetchPrompts({
    required String category,
    String query = '',
    bool isFavorite = false,
    required bool isPublic,
  }) {
    return viewModel.fetchPrompts(
      category: category,
      query: query,
      isFavorite: isFavorite,
      isPublic: isPublic,
    );
  }

  Future<bool> _toggleFavorite(String promptId, bool isFavorite) {
    return viewModel.toggleFavorite(promptId, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder<PromptList>(
        future: _prompts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text('No prompts found.'));
          } else {
            final prompts = snapshot.data!;

            // Lưu trạng thái yêu thích ban đầu vào _favoriteStates
            for (var prompt in prompts.items) {
              _favoriteStates[prompt.id] ??= prompt.isFavorite ?? false;
            }

            return Expanded(
              child: ListView.builder(
                itemCount: prompts.items.length,
                itemBuilder: (context, index) {
                  final prompt = prompts.items[index];
                  final isFavorite = _favoriteStates[prompt.id] ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      //_showPromptDetailsBottomSheet(context, prompt);
                      PromptDetailsBottomSheet.show(context, prompt);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    //_showPromptDetailsBottomSheet(context, prompt);
                                    PromptDetailsBottomSheet.show(
                                        context, prompt);
                                  },
                                  child: Text(
                                    prompt.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final success = await _toggleFavorite(
                                          prompt.id, isFavorite);

                                      if (success) {
                                        setState(() {
                                          _favoriteStates[prompt.id] =
                                              !isFavorite;
                                          prompt.isFavorite =
                                              !prompt.isFavorite;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      isFavorite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: isFavorite
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  if (!widget
                                      .isPublic) // Hiển thị thùng rác nếu isPublic = false
                                    Row(children: [
                                      GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            isDeleting =
                                                true; // Bắt đầu quá trình xóa
                                          });
                                          final success = await viewModel
                                              .deletePrompt(prompt.id);
                                          if (success) {
                                            setState(() {
                                              _prompts = _fetchPrompts(
                                                category: widget.category,
                                                query: widget.query,
                                                isFavorite: widget.isFavorite,
                                                isPublic: widget.isPublic,
                                              );
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to delete prompt.')),
                                            );
                                          }
                                          setState(() {
                                            isDeleting =
                                                false; // Bắt đầu quá trình xóa
                                          });
                                        },
                                        child: Icon(Icons.delete_outline,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(width: 10),
                                    ]),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      //_showPromptDetailsBottomSheet(context, prompt);
                                      PromptDetailsBottomSheet.show(
                                          context, prompt);
                                    },
                                    child: Icon(Icons.arrow_right,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(prompt.description),
                          Divider(thickness: 1.2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      if (isDeleting)
        Positioned.fill(
          child: Container(
            //color: Colors.black.withOpacity(0.5), // Lớp màu mờ
            child: Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            ),
          ),
        ),
    ]);
  }

  static void _showPromptDetailsBottomSheet(
      BuildContext context, Prompt prompt) {
    TextEditingController contentController =
        TextEditingController(text: prompt.content);
    Language selectedLanguage = Language.values.firstWhere(
      (lang) => lang.value == prompt.language,
      orElse: () => Language.English,
    );
    bool isLoading = false;
    final viewModel = PromptListViewModel();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Để bottom sheet có thể chiếm toàn bộ màn hình nếu cần
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Hàm viết hoa chữ cái đầu
        String capitalizeFirstLetter(String input) {
          return input
              .split(' ')
              .map((word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '')
              .join(' ');
        }

        // Tìm các từ trong cặp dấu []
        List<String> extractPlaceholders(String content) {
          final regex = RegExp(r'\[(.+?)\]');
          return regex
              .allMatches(content)
              .map((match) => match.group(1) ?? '')
              .toList();
        }

        List<String> placeholders = extractPlaceholders(prompt.content);
        List<String> inputs = List.filled(placeholders.length, '');

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Icon "<", Title, Star, and Close icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prompt.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          prompt.isFavorite ? Icons.star : Icons.star_border,
                          color:
                              prompt.isFavorite ? Colors.yellow : Colors.grey,
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Row 2: Category
                Row(
                  children: [
                    Text(
                      capitalizeFirstLetter(
                          "${prompt.category} - ${prompt.userName}"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Row 3: Description
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(prompt.description), // Thay thế bằng mô tả thật
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Row 4: View Prompt
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Prompt",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (!prompt.isPublic)
                          TextButton.icon(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      PromptRequest newPrompt = PromptRequest(
                                        language: selectedLanguage.value,
                                        title: prompt.title,
                                        category: prompt.category,
                                        description: prompt.description,
                                        content: contentController.text,
                                        isPublic: false,
                                      );

                                      await viewModel.updatePrompt(
                                          newPrompt, prompt.id);

                                      //Navigator.pop(context);
                                    } catch (error) {
                                      print("Error: $error");
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                            icon: isLoading
                                ? SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Colors.blue,
                                    ),
                                  )
                                : null,
                            label: Text(
                              "Save",
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              minimumSize: Size(0, 0),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Khoảng cách giữa Row và TextField
                    Container(
                      height: 120,
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey[50],
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                // Row 5: Output Language Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Output Language",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<Language>(
                      value: selectedLanguage,
                      items: Language.values.map((Language lang) {
                        return DropdownMenuItem<Language>(
                          value: lang,
                          child: Text(lang.label), // Hiển thị nhãn từ enum
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedLanguage = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16),
                // Row 6: Input Field
                for (int i = 0; i < placeholders.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      onChanged: (value) {
                        // Cập nhật giá trị khi người dùng nhập
                        inputs[i] = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        hintText: placeholders[i],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 16),

                // Row 7: Send Button
                ElevatedButton.icon(
                  onPressed: () async {
                    String content = prompt.content;
                    // Thay thế các placeholder bằng input người dùng
                    final regex = RegExp(r'\[(.+?)\]');
                    int index = 0;
                    String updatedContent =
                        content.replaceAllMapped(regex, (match) {
                      // Nếu người dùng đã nhập giá trị thay thế, sử dụng giá trị đó
                      if (index < inputs.length && inputs[index].isNotEmpty) {
                        return inputs[index++];
                      }
                      // Nếu không có giá trị thay thế, giữ nguyên placeholder
                      return match.group(0)!;
                    });
                    updatedContent += "\nRespond in " + selectedLanguage.value;
                    AIItem ai =
                        await Provider.of<AIChatList>(context, listen: false)
                            .selectedAIItem;
                    await Provider.of<MessageModel>(context, listen: false)
                        .sendMessage(updatedContent, ai);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background màu xanh
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
