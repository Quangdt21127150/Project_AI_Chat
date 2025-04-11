import 'package:flutter/material.dart';
import 'package:project_ai_chat/views/BottomSheet/Widgets/SegmentedControl/segmented_control.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:provider/provider.dart';
import 'Dialog/custom_dialog.dart';
import 'Widgets/PromptCategorySelector/prompt_category_selector.dart';
import 'Widgets/PromptList/prompt_list.dart';
import 'Widgets/SearchBar/search_bar.dart';

class CustomBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(

      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // Chiếm 8/10 chiều cao màn hình
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Consumer<PromptListViewModel>( // Sử dụng Consumer
              builder: (context, viewModel, child) {
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
                            if (!viewModel.isPublic)
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
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
                                        viewModel.fetchPrompts();
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.close),
                              iconSize: 24,
                              onPressed: () {
                                Navigator.pop(context); // Đóng Bottom Sheet
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    // Row 2: My Prompts and Public Prompts (Segmented Control with Radio)
                    SegmentedControl(),

                    SizedBox(height: 10),

                    // Row 3: Search bar with Icon + Star Icon
                    PromptSearchBar(),

                    SizedBox(height: 10),

                    // Row 4: PromptCategorySelector
                    PromptCategorySelector(),

                    SizedBox(height: 10),

                    // Row 5: Prompt List
                    Expanded(
                      child: PromptListWidget(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
