import 'package:flutter/material.dart';

class PromptSearchBar extends StatefulWidget {
  final Function(String)
      onQueryChanged; // Hàm callback nhận query từ người dùng
  final bool isFavorite; // Trạng thái starred mặc định
  final Function(bool) onStarToggled; // Hàm callback khi toggle starred
  final bool isPublic;

  const PromptSearchBar({
    Key? key,
    required this.onQueryChanged,
    this.isFavorite = false,
    required this.onStarToggled,
    required this.isPublic,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<PromptSearchBar> {
  late bool _isStarred;
  late TextEditingController _controller;

  get isPublic => widget.isPublic;

  @override
  void initState() {
    super.initState();
    _isStarred = widget.isFavorite;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onQueryChanged(value); // Gửi query qua callback
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
              setState(() {
                _isStarred = !_isStarred; // Toggle trạng thái
              });
              widget.onStarToggled(
                  _isStarred); // Gửi trạng thái starred qua callback
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _isStarred ? Icons.star : Icons.star_border,
                color: _isStarred ? Colors.yellow : Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }
}
