import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:project_ai_chat/models/prompt_model.dart';

class PromptDetails extends StatefulWidget {
  final String promptId;
  final String itemTitle;
  final String content;
  final String category;
  final String description;
  final String language;
  final bool isPublic;
  final bool isFavorite;

  const PromptDetails({
    super.key,
    required this.promptId,
    required this.itemTitle,
    this.content = '',
    this.category = 'other',
    this.description = '',
    this.language = 'English',
    this.isPublic = false,
    this.isFavorite = false,
  });

  static Future<Map<String, dynamic>?> show(
      BuildContext context, {
        required String promptId,
        required String itemTitle,
        String content = '',
        String category = 'other',
        String description = '',
        String language = 'English',
        bool isPublic = false,
        bool isFavorite = false,
      }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PromptDetails(
        promptId: promptId,
        itemTitle: itemTitle,
        content: content,
        category: category,
        description: description,
        language: language,
        isPublic: isPublic,
        isFavorite: isFavorite,
      ),
    );
  }

  @override
  State<PromptDetails> createState() => _PromptDetails();
}

class _PromptDetails extends State<PromptDetails> {
  bool isPromptVisible = false;
  late String selectedLanguage;
  late String selectedCategory;
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController descriptionController;
  late List<String> placeholders;
  late List<String> inputs;
  bool hasChanges = false;
  final viewModel = PromptListViewModel();
  final List<String> categoryItems = [
    'other',
    'business',
    'marketing',
    'seo',
    'writing',
    'coding',
    'career',
    'chatbot',
    'education',
    'fun',
    'productivity',
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
    selectedCategory = widget.category;
    titleController = TextEditingController(text: widget.itemTitle);
    contentController = TextEditingController(text: widget.content);
    descriptionController = TextEditingController(text: widget.description);
    placeholders = extractPlaceholders(widget.content);
    inputs = List.filled(placeholders.length, '');

    titleController.addListener(_checkForChanges);
    contentController.addListener(_checkForChanges);
    descriptionController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    titleController.removeListener(_checkForChanges);
    contentController.removeListener(_checkForChanges);
    descriptionController.removeListener(_checkForChanges);
    titleController.dispose();
    contentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      hasChanges = titleController.text != widget.itemTitle ||
          contentController.text != widget.content ||
          selectedCategory != widget.category ||
          descriptionController.text != widget.description ||
          selectedLanguage != widget.language;
    });
  }

  List<String> extractPlaceholders(String content) {
    final regex = RegExp(r'\[(.+?)\]');
    return regex.allMatches(content).map((match) => match.group(1) ?? '').toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dropdownItems = categoryItems.contains(widget.category)
        ? categoryItems
        : [...categoryItems, widget.category];

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.itemTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  label: 'Title',
                                  controller: titleController,
                                  readOnly: widget.isPublic,
                                  isRequired: true,
                                ),
                                const SizedBox(height: 16),
                                _buildDropdown(
                                  label: 'Category',
                                  value: selectedCategory,
                                  items: dropdownItems,
                                  onChanged: widget.isPublic
                                      ? null
                                      : (value) {
                                    setState(() {
                                      selectedCategory = value!;
                                      _checkForChanges();
                                    });
                                  },
                                  isRequired: true,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  label: 'Description',
                                  controller: descriptionController,
                                  readOnly: widget.isPublic,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => setState(() => isPromptVisible = !isPromptVisible),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isPromptVisible ? 'Hide Prompt' : 'View Prompt',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isPromptVisible) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            expands: true,
                            readOnly: widget.isPublic,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Output Language',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            DropdownButton<String>(
                              value: selectedLanguage,
                              items: ['English', 'Japanese', 'Spanish', 'French', 'German']
                                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                                  .toList(),
                              onChanged: widget.isPublic
                                  ? null
                                  : (value) {
                                setState(() {
                                  selectedLanguage = value!;
                                  _checkForChanges();
                                });
                              },
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (int i = 0; i < placeholders.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            onChanged: (value) => inputs[i] = value,
                            decoration: InputDecoration(
                              hintText: placeholders[i],
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue[600]!),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (!widget.isPublic && hasChanges) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (titleController.text.trim().isEmpty ||
                                  contentController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all required fields!')),
                                );
                                return;
                              }
                              if (widget.promptId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid prompt ID.')),
                                );
                                return;
                              }
                              final newPrompt = PromptRequest(
                                language: selectedLanguage,
                                title: titleController.text,
                                category: selectedCategory.toLowerCase(),
                                description: descriptionController.text,
                                content: contentController.text,
                                isPublic: widget.isPublic,
                              );
                              final success = await viewModel.updatePrompt(newPrompt, widget.promptId);
                              if (success) {
                                Navigator.pop(context, {'action': 'update'});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to update prompt.')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ElevatedButton(
                            onPressed: () {
                              String updatedContent = contentController.text;
                              final regex = RegExp(r'\[(.+?)\]');
                              int index = 0;
                              updatedContent = updatedContent.replaceAllMapped(regex, (match) {
                                if (index < inputs.length && inputs[index].isNotEmpty) {
                                  return inputs[index++];
                                }
                                return match.group(0)!;
                              });
                              updatedContent += "\nRespond in $selectedLanguage";
                              Navigator.pop(context, {'action': 'send', 'content': updatedContent});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Send',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(color: Colors.grey.shade800),
          dropdownColor: Colors.white,
        ),
      ],
    );
  }
}