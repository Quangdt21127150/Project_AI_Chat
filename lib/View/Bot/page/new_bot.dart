import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Bot/model/bot.dart';

class NewBot extends StatefulWidget {
  const NewBot({super.key, required this.addBot});
  final void Function(Bot newBot) addBot;

  @override
  State<NewBot> createState() => _NewBotState();
}

class _NewBotState extends State<NewBot> {
  final _formKey = GlobalKey<FormState>();
  int _accessOption = 1;

  //TextFormField
  String _enteredName = "";
  String _enteredPrompt = "";

  void _saveBot() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.addBot(
        Bot(
            name: _enteredName,
            prompt: _enteredPrompt,
            team: "Ami Team",
            imageUrl:
                "https://cdn-icons-png.flaticon.com/512/13330/13330989.png",
            isPublish: _accessOption == 1 ? true : false,
            listKnowledge: []),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tạo Bot',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.add, size: 30),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                // controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  hintText: 'Nhập tên',
                  suffixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Dịch giả chuyên nghiệp | Chuyên gia viết lách | Trợ lý mã',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  // labelText: 'Prompt',
                  hintText: 'Nhập nội dung prompt...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập prompt';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPrompt = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Bạn là một dịch giả có kinh nghiệm với kỹ năng trong nhiều ngôn ngữ trên thế giới.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _accessOption,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Publish'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Private'),
                  ),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _accessOption = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Quyền truy cập',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: const BorderSide(width: 1, color: Colors.orange)),
              child: const Text(
                "Huỷ",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveBot,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                "Tạo ngay",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
