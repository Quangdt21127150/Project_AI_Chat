import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ai_chat/models/ai_logo.dart';
import 'package:project_ai_chat/views/Knowledge/page/knowledge_screen.dart';
import 'package:project_ai_chat/viewmodels/bot_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/text_strings.dart';
import '../../../viewmodels/homechat_view_model.dart';
import '../../../viewmodels/aichat_list_view_model.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = -1;
  late final AIChatList aiChatList;
  late AIItem currentAI;
  late ScrollController
      _scrollController; // variable for load more conversation

  @override
  void initState() {
    super.initState();
    aiChatList = Provider.of<AIChatList>(context, listen: false);
    currentAI = aiChatList.selectedAIItem;

    _scrollController = ScrollController()
      ..addListener(() {
        // Khi cuộn đến cuối danh sách
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<MessageModel>(context, listen: false)
              .fetchAllConversations(
            currentAI.id,
            'dify',
            isLoadMore: true,
          ); // Gọi Load More
        }
      });
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logoAI.png",
                        height: 60,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Ami Assistant",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildWidgetItem(Icons.play_lesson, "Knowledge Management", 1),
          _buildWidgetItem(Icons.verified_sharp, "Upgrade Version", 2),
          const Divider(
            height: 0.5,
            color: Color.fromRGBO(2, 13, 82, 1.0),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'All conversations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.search,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MessageModel>(
              builder: (context, messageModel, child) {
                if (messageModel.isLoading &&
                    messageModel.conversations.isEmpty) {
                  // Display loading indicator while fetching conversations
                  return const Center(child: CircularProgressIndicator());
                }
                if (messageModel.errorMessage != null &&
                    messageModel.conversations.isEmpty) {
                  // Display error message if there's an error
                  return Center(
                    child: Text(
                      messageModel.errorMessage ??
                          'Server error, please try again',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: messageModel.conversations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messageModel.conversations.length) {
                      // Loader khi đang tải thêm
                      if (messageModel.hasMoreConversation) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return const SizedBox.shrink(); // Không còn dữ liệu
                      }
                    }
                    final conversation = messageModel.conversations[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _formatTimestamp(conversation.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () async {
                        // Lấy assistantId từ currentAI
                        final assistantId = currentAI.id;

                        // Gọi loadConversationHistory
                        await Provider.of<MessageModel>(context, listen: false)
                            .loadConversationHistory(
                                assistantId, conversation.id);
                        Provider.of<BotViewModel>(context, listen: false).isChatWithMyBot = false;

                        Navigator.pop(context); // Đóng drawer
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetItem(IconData icon, String title, int index) {
    return InkWell(
      onTap: () async {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 2){
          final Uri url = Uri.parse(linkUpgrade);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
            content: Text('Cannot open link!')),
           );
        }
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KnowledgeScreen()),
          );
        }
      },
      child: Container(
        color: (index == (_selectedIndex)) ? Colors.grey[400] : null,
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
