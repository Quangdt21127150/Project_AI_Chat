import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:provider/provider.dart';

class SegmentedControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PromptListViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOption(
          context,
          'My Prompts',
          viewModel.isPublic == false,
              () => viewModel.isPublic = false,
        ),
        _buildOption(
          context,
          'Public Prompts',
          viewModel.isPublic == true,
              () => viewModel.isPublic = true,
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
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
}
