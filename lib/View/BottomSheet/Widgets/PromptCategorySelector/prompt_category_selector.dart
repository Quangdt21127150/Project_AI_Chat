import 'package:flutter/material.dart';

class PromptCategorySelector extends StatefulWidget {
  final Function(String) onCategorySelected; // Hàm callback để gửi giá trị category đã chọn
  final String initialCategory; // Category mặc định ban đầu

  const PromptCategorySelector({
    Key? key,
    required this.onCategorySelected,
    this.initialCategory = 'all', // Mặc định là 'all'
  }) : super(key: key);

  @override
  _PromptCategorySelectorState createState() => _PromptCategorySelectorState();
}

class _PromptCategorySelectorState extends State<PromptCategorySelector> {
  late String _selectedCategory;
  bool _isExpanded = false; // Biến để theo dõi trạng thái mở rộng

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory; // Gán giá trị mặc định
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các category
    final categories = {
      'all': 'All',
      'marketing': 'Marketing',
      'business': 'Business',
      'seo': 'SEO',
      'writing': 'Writing',
      'coding': 'Coding',
      'career': 'Career',
      'chatbot': 'Chatbot',
      'education': 'Education',
      'fun': 'Fun',
      'productivity': 'Productivity',
      'other': 'Other',
    };

    // Lấy các category cần hiển thị
    List<MapEntry<String, String>> displayCategories;
    if (_isExpanded) {
      // Nếu mở rộng, hiển thị tất cả các category
      displayCategories = categories.entries.toList();
    } else {
      // Nếu chưa mở rộng, chỉ hiển thị một dòng
      displayCategories = categories.entries.take(3).toList(); // Hiển thị 5 categories đầu tiên
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column chứa các category bên trái
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: displayCategories.map((entry) {
                  final category = entry.key;
                  final label = entry.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category; // Cập nhật category đã chọn
                      });
                      widget.onCategorySelected(category); // Gọi hàm callback
                    },
                    child: Chip(
                      label: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedCategory == category
                              ? Colors.white
                              : Colors.blue.shade900,
                        ),
                      ),
                      backgroundColor: _selectedCategory == category
                          ? Colors.blue
                          : Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // Nút mũi tên để mở rộng/thu gọn danh sách
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Đổi trạng thái mở rộng/thu gọn
              });
            },
            child: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0, // Xoay 180 độ khi mở rộng
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
