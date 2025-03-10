import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tool extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ToolState();

}

class _ToolState extends State<Tool>{
  int _selectedTabItem = -1;
  Widget _buildTabItem({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabItem = index;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: (index == (_selectedTabItem)) ? Colors.blue : null,
          ),
          Text(
            title,
            style: TextStyle(
              color: (index == (_selectedTabItem)) ? Colors.blue : null,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55, // Chiều rộng cố định cho thanh công cụ
      color: Color.fromRGBO(246, 247, 250, 1.0), // Màu nền xám
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5,top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTabItem(
                icon: Icons.chat,
                title: 'Chat',
                onPressed: () {},
                index: 0),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.edit,
                title: 'White',
                onPressed: () {},
                index: 1),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.search,
                title: 'Search',
                onPressed: () {},
                index: 2),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.translate,
                title: 'Translate',
                onPressed: () {},
                index: 3),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.settings,
                title: 'Settings',
                onPressed: () {},
                index: 4),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.qr_code,
                title: 'OCR',
                onPressed: () {},
                index: 5),
            SizedBox(height: 20),
            _buildTabItem(
                icon: Icons.play_lesson,
                title: 'Grammar',
                onPressed: () {},
                index: 6),
          ],
        ),
      ),
    );
  }
}