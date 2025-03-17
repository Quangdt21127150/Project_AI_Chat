import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/BottomSheet/Widgets/SegmentedControl/segmented_control.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:project_ai_chat/models/prompt_list.dart';
import 'package:provider/provider.dart';

import '../../services/prompt_service.dart';
import '../../models/prompt.dart';
import 'Dialog/custom_dialog.dart';
import 'Widgets/PromptCategorySelector/prompt_category_selector.dart';
import 'Widgets/PromptList/prompt_list.dart';
import 'Widgets/SearchBar/search_bar.dart';

class CustomBottomSheet {
  static void show(BuildContext context) {
    String selectedCategory = 'all'; // Giá trị category mặc định
    String query = ''; // Giá trị query từ SearchBar
    bool isFavorite = false; // Trạng thái starred
    bool isPublic = false;
    bool isCreated = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Cho phép kiểm soát kích thước của Bottom Sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // Chiếm 8/10 chiều cao màn hình
          child: Padding(
            padding: EdgeInsets.all(16),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Title + Icons (Plus and X)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prompt Library',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          if (!isPublic)
                            Container(
                              width: 35,
                              // Đảm bảo kích thước bằng với IconButton khác
                              height: 35,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                  // Màu gradient
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(width: 0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  CustomDialog.show(
                                    context,
                                    onPromptCreated: () {
                                      // Cập nhật trạng thái sau khi prompt được tạo
                                      setState(() {
                                        isCreated = true;

                                      });
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24, // Kích thước icon
                                ),
                              ),
                            ),
                          SizedBox(width: 10), // Khoảng cách giữa các nút
                          IconButton(
                            icon: Icon(Icons.close),
                            iconSize: 24,
                            // Đảm bảo icon close có kích thước tương tự
                            onPressed: () {
                              Navigator.pop(context); // Đóng Bottom Sheet
                            },
                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 10),
                  // Khoảng cách giữa các row

                  // Row 2: My Prompts and Public Prompts (Segmented Control with Radio)
                  SegmentedControl(
                    onSelectionChanged: (bool isPublicChanged) {
                      setState(() {
                        isPublic = isPublicChanged;
                      });
                    },
                  ),

                  SizedBox(height: 10),

                  // Row 3: Search bar with Icon + Star Icon
                  PromptSearchBar(
                    onQueryChanged: (value) {
                      setState(() {
                        query = value; // Cập nhật query từ SearchBar
                      });
                    },
                    isFavorite: isFavorite,
                    onStarToggled: (value) {
                      setState(() {
                        isFavorite = value; // Cập nhật trạng thái starred
                      });
                    },
                    isPublic: isPublic,
                  ),

                  SizedBox(height: 10),

                  if (isPublic)
                    // Row 4: PromptCategorySelector
                    _buildPromptType((newCategory) {
                      setState(() {
                        selectedCategory =
                            newCategory; // Cập nhật category đã chọn
                      });
                    }),

                  SizedBox(height: 10),

                  // Row 5: Prompt List
                  Expanded(
                    child: PromptListWidget(
                        category: selectedCategory,
                        isFavorite: isFavorite,
                        query: query,
                        isPublic: isPublic,
                        isCreated: isCreated),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  // Segment Control with Radio button-like selection
  static Widget _buildSegmentedControl() {
    bool selectedIndex = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOption(
              context,
              'My Prompts',
              selectedIndex == false,
              () => setState(() => selectedIndex = false),
            ),
            _buildOption(
              context,
              'Public Prompts',
              selectedIndex == true,
              () => setState(() => selectedIndex = true),
            ),
          ],
        );
      },
    );
  }

  // Widget cho từng option với radio-like selection
  static Widget _buildOption(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  static Widget _buildPromptType(Function(String) onCategorySelected) {
    return PromptCategorySelector(
      initialCategory: 'all', // Category mặc định
      onCategorySelected: (selectedCategory) {
        onCategorySelected(
            selectedCategory); // Truyền giá trị đã chọn qua callback
      },
    );
  }

  static void _showPromptDetailsBottomSheet(
      BuildContext context, String itemTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Để bottom sheet có thể chiếm toàn bộ màn hình nếu cần
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: Icon "<", Title, Star, and Close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back), // Icon "<"
                        onPressed: () {
                          Navigator.pop(context); // Quay lại BottomSheet cũ
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        itemTitle, // Tên của phần tử được nhấn
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_border), // Icon ngôi sao chỉ có outline
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.close),
                        // Icon "X" để đóng bottom sheet
                        onPressed: () {
                          Navigator.pop(context); // Thoát khỏi BottomSheet
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
                  Text("Category: Example Category"),
                  // Thay thế bằng giá trị category thật
                ],
              ),
              SizedBox(height: 16),

              // Row 3: Description
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Description: This is a sample description for the selected item."), // Thay thế bằng mô tả thật
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Row 4: View Prompt (toggle khi nhấn)
              StatefulBuilder(
                builder: (context, setState) {
                  bool isPromptVisible =
                      false; // Biến để theo dõi trạng thái ViewPrompt
                  return Column(
                    children: [
                      if (!isPromptVisible)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPromptVisible = true;
                            });
                          },
                          child: Text(
                            "View Prompt",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      if (isPromptVisible)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prompt:"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Your prompt here...',
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),

              // Row 5: Output Language Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Output Language"),
                  DropdownButton<String>(
                    value: "Auto", // Giá trị mặc định
                    items: <String>['Auto', 'English', 'Spanish']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // Xử lý khi thay đổi giá trị
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Row 6: Input Field
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter text here...',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),

              // Row 7: Send Button
              ElevatedButton.icon(
                onPressed: () {
                  // Xử lý khi nhấn Send
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
      },
    );
  }
}
