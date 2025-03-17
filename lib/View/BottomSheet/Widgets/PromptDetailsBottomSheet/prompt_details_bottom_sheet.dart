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

class PromptDetailsBottomSheet extends StatefulWidget {
  final Prompt prompt;

  const PromptDetailsBottomSheet({
    Key? key,
    required this.prompt,
  }) : super(key: key);

  /// Hàm tĩnh để show modal bottom sheet
  static void show(BuildContext context, Prompt prompt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => PromptDetailsBottomSheet(prompt: prompt),
    );
  }

  @override
  _PromptDetailsBottomSheetState createState() =>
      _PromptDetailsBottomSheetState();
}

class _PromptDetailsBottomSheetState extends State<PromptDetailsBottomSheet> {
  late TextEditingController contentController;
  late Language selectedLanguage;
  late List<String> placeholders;
  late List<String> inputs;
  bool isLoading = false;
  final viewModel = PromptListViewModel();

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.prompt.content);
    selectedLanguage = Language.values.firstWhere(
      (lang) => lang.value == widget.prompt.language,
      orElse: () => Language.English,
    );
    placeholders = extractPlaceholders(widget.prompt.content);
    inputs = List.filled(placeholders.length, '');
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String input) {
    return input
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  List<String> extractPlaceholders(String content) {
    final regex = RegExp(r'\[(.+?)\]');
    return regex
        .allMatches(content)
        .map((match) => match.group(1) ?? '')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height *
              0.8, // Chiều cao tối đa 80% màn hình
        ),
        child: SingleChildScrollView(
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
                      widget.prompt.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        widget.prompt.isFavorite
                            ? Icons.star
                            : Icons.star_border,
                        color: widget.prompt.isFavorite
                            ? Colors.yellow
                            : Colors.grey,
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
                        "${widget.prompt.category} - ${widget.prompt.userName}"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Row 3: Description
              Row(
                children: [
                  Expanded(
                    child: Text(
                        widget.prompt.description), // Thay thế bằng mô tả thật
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
                      if (!widget.prompt.isPublic)
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
                                      title: widget.prompt.title,
                                      category: widget.prompt.category,
                                      description: widget.prompt.description,
                                      content: contentController.text,
                                      isPublic: false,
                                    );

                                    await viewModel.updatePrompt(
                                        newPrompt, widget.prompt.id);

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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  String content = widget.prompt.content;
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
        ),
      ),
    );
  }
}
