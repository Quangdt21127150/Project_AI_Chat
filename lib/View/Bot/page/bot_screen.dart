import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_ai_chat/View/Bot/data/bots_data.dart';
import 'package:project_ai_chat/View/Bot/page/edit_bot.dart';
import 'package:project_ai_chat/View/Bot/page/new_bot.dart';
import 'package:project_ai_chat/View/Bot/page/public_bot.dart';
import 'package:project_ai_chat/View/Bot/widgets/bot_card.dart';
import 'package:project_ai_chat/View/Bot/widgets/filter_button.dart';
import 'package:project_ai_chat/View/Bot/model/bot.dart';
import 'package:project_ai_chat/View/HomeChat/Widgets/BottomNavigatorBarCustom/bottom_navigation.dart';
import 'package:project_ai_chat/View/HomeChat/home.dart';

import '../../Account/pages/account_screent.dart';
import '../../BottomSheet/custom_bottom_sheet.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  final List<Bot> _listBots = bots;
  void _addBot(Bot newBot) {
    setState(() {
      _listBots.add(newBot);
    });
  }

  void _editBot(Bot newEditBot, indexEditBox) {
    setState(() {
      _listBots[indexEditBox] = newEditBot;
    });
  }

  void _removeBot(Bot bot) {
    final botDeleteIndex = _listBots.indexOf(bot);

    setState(() {
      _listBots.remove(bot);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Bot has been Deleted!"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _listBots.insert(botDeleteIndex, bot);
            });
          },
        ),
      ),
    );
  }

  void _openAddBotDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => NewBot(
              addBot: (newBot) {
                _addBot(newBot);
              },
            ));
  }

  void _openEditBotDialog(BuildContext context, Bot bot, int index) {
    // showDialog(
    //     context: context,
    //     builder: (context) => EditBot(
    //           editBot: (bot) {
    //             _editBot(bot, index);
    //           },
    //           bot: bot,
    //         ));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBot(
          editBot: (bot) {
            _editBot(bot, index);
          },
          bot: bot,
        ),
      ),
    );
  }

  void _openPublishBotDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const PublicBot(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bots",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openAddBotDialog(context);
            },
            icon: const Icon(Icons.add),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 60, 56, 56),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(label: "Celebrity", isSelected: true),
                FilterButton(label: "My bots", isSelected: false),
                FilterButton(label: "Top", isSelected: false),
                FilterButton(label: "Models", isSelected: false),
              ],
            ),
            // const SizedBox(
            //   height: 36,
            //   child: FilterButtonList(),
            // ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _listBots.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _openEditBotDialog(
                                context, _listBots[index], index);
                          },
                          icon: Icons.edit,
                          backgroundColor: Colors.green,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _removeBot(_listBots[index]);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _openPublishBotDialog(context);
                          },
                          icon: Icons.publish,
                          backgroundColor: Colors.blue,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeChat(),
                          ),
                        );
                      },
                      child: BotCard(
                        bot: bots[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
