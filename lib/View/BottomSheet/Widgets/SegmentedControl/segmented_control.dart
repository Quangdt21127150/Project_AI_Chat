import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  final Function(bool) onSelectionChanged;

  const SegmentedControl({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  _SegmentedControlState createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  bool isSelected = false; // Trạng thái của option (My Prompts / Public Prompts)

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOption(
          context,
          'My Prompts',
          isSelected == false,
              () {
            setState(() {
              isSelected = false;
            });
            widget.onSelectionChanged(false); // Truyền giá trị false khi chọn My Prompts
          },
        ),
        _buildOption(
          context,
          'Public Prompts',
          isSelected == true,
              () {
            setState(() {
              isSelected = true;
            });
            widget.onSelectionChanged(true); // Truyền giá trị true khi chọn Public Prompts
          },
        ),
      ],
    );
  }

  Widget _buildOption(
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
}
