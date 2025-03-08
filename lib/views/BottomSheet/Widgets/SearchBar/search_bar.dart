import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:provider/provider.dart';

class PromptSearchBar extends StatefulWidget {

  const PromptSearchBar({
    Key? key
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<PromptSearchBar> {
  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PromptListViewModel>();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              viewModel.query = value; // Gửi query qua callback
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        // if (isPublic)
          GestureDetector(
            onTap: () {
              viewModel.isFavorite = !viewModel.isFavorite; // Gửi trạng thái starred qua callback
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                viewModel.isFavorite ? Icons.star : Icons.star_border,
                color: viewModel.isFavorite ? Colors.yellow : Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }
}
