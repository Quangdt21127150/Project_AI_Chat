import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UpgradeVersion extends StatefulWidget {
  @override
  _UpgradeVersionState createState() => _UpgradeVersionState();
}

class _UpgradeVersionState extends State<UpgradeVersion> {
  String _selectedOption = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.upgrade,
              size: 100,
              color: Colors.blue,
            ),
            _buildText("Unlock the full power and ", 24, FontWeight.bold),
            _buildText("capabilities for Ami", 24, FontWeight.bold),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUpgradeOption('Weekly', '\$4.99'),
                _buildUpgradeOption('Monthly', '\$14.99'),
                _buildUpgradeOption('Yearly', '\$99.99'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue[50],

              ),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Benefits of Pro:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildWidget('Unlock all chat features', 15),
                  SizedBox(height: 8),
                  _buildWidget('Unlimited access to all features', 15),
                  SizedBox(height: 8),
                  _buildWidget('Higher Word Limit', 15),
                  SizedBox(height: 8),
                  _buildWidget('Priority customer support', 15),
                  SizedBox(height: 8),
                  _buildWidget('Regular updates and new features', 15),
                  SizedBox(height: 8),
                  _buildWidget('All Personalities', 15),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Handle purchase
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UPGRADE VERSION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 10),
            Text(
              '3 day free trial, cancel anytime',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildText(String text, double size, FontWeight weight) {
    return Center(
      child: Text(
        '$text',
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
        ),
      ),
    );
  }
  Widget _buildWidget(String text,double size){
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.green,
          size: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: size,
          ),
        ),
      ],
    );
  }
  Widget _buildUpgradeOption(String title, String price){
    bool isSelected = _selectedOption == title;
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 247, 250, 1.0),
        border: Border.all(color: isSelected ? Colors.blue : Colors.black, width: 4.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<String>(
            activeColor: Colors.blue,
            value: title,
            groupValue: _selectedOption,
            onChanged: (String? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black
            ),
          ),
          SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.blue : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}