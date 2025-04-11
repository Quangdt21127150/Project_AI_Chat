import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_ai_chat/views/Account/pages/account_screent.dart';
import 'package:project_ai_chat/views/Bot/page/bot_screen.dart';
import 'package:project_ai_chat/core/Widget/chat_widget.dart';
import 'package:project_ai_chat/utils/exceptions/chat_exception.dart';
import 'package:project_ai_chat/viewmodels/auth_view_model.dart';
import 'package:project_ai_chat/viewmodels/bot_view_model.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import '../../constants/text_strings.dart';
import '../../core/Widget/dropdown_button.dart';
import '../../utils/helpers/ads/ads_helper.dart';
import '../../viewmodels/aichat_list_view_model.dart';
import '../../viewmodels/homechat_view_model.dart';
import '../BottomSheet/Widgets/PromptDetailsBottomSheet/prompt_details_bottom_sheet.dart';
import '../BottomSheet/custom_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../EmailChat/email.dart';
import 'Widgets/bottom_navigation.dart';
import 'Widgets/menu.dart';
import '../../models/ai_logo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:screenshot/screenshot.dart';
import 'Widgets/build_message.dart';
import 'Widgets/input_message.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  //Admob
  InterstitialAd? _interstitialAd;

  //Controller
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ScreenshotController _screenshotController = ScreenshotController();
  final FocusNode _focusNode = FocusNode();

  bool _isOpenDeviceWidget = false;
  bool _hasText = false;
  bool _showSlash = false;
  int _selectedBottomItemIndex = 0;
  List<String>? _imagePaths;
  late List<AIItem> _listAIItem;
  late String _selectedAIItem;

  //Link upgrade


  @override
  void initState() {
    super.initState();
    //Load interstitial ad when open app
    _loadInterstitialAd();

    //Bắt sự kiện thay đổi text trong ô nhập dữ liệu
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });

    //Bắt sự lắng nghe khi focus vào ô nhập dữ liệu
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isOpenDeviceWidget = false;
        });
      }
    });

    // lấy thông tin user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
      _loadConversation();
      _loadAllPrompt();
    });

    // Lấy danh sách AI
    final aiChatList = Provider.of<AIChatList>(context, listen: false);
    _listAIItem = aiChatList.aiItems;
    _selectedAIItem = aiChatList.selectedAIItem.name;

    //Hiển thị token
    Provider.of<MessageModel>(context, listen: false).updateRemainingUsage();

    // Load all Knowledgebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KnowledgeBaseProvider>(context, listen: false)
          .fetchAllKnowledgeBases(isLoadMore: false);
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });
          _interstitialAd?.show();
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              print("Interstitial Ad dismissed.");
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
              print("Failed to show Interstitial Ad: ${error.message}");
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> _loadUserInfo() async {
    try {
      await Provider.of<AuthViewModel>(context, listen: false).fetchUserInfo();
    } catch (e) {
      return;
    }
  }

  Future<void> _loadConversation() async {
    final aiItem =
        _listAIItem.firstWhere((aiItem) => aiItem.name == _selectedAIItem);
    try {
      Provider.of<MessageModel>(context, listen: false)
          .fetchAllConversations(aiItem.id, 'dify')
          .then((_) async {
        await Provider.of<MessageModel>(context, listen: false)
            .checkCurrentConversation(aiItem.id);
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _loadAllPrompt() async {
    try {
      // Lấy danh sách prompts
      Provider.of<PromptListViewModel>(context, listen: false)
          .fetchAllPrompts()
          .then((_) {
        Provider.of<PromptListViewModel>(context, listen: false).allprompts;
      });
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _onTappedBottomItem(int index) {
    setState(() {
      _selectedBottomItemIndex = index;
    });
    if (index == 1) {
      CustomBottomSheet.show(context);
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BotScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailComposer()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreent()),
      );
    }
  }

  void _toggleDeviceVisibility() {
    setState(() {
      _isOpenDeviceWidget = !_isOpenDeviceWidget;
    });
  }

  void _sendMessage() async {
    if (_imagePaths == null && _controller.text.isEmpty) return;

    try {
      final aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == _selectedAIItem);

      await Provider.of<MessageModel>(context, listen: false).sendMessage(
        _controller.text.isEmpty ? '' : _controller.text,
        aiItem,
        imagePaths: _imagePaths ?? null,
      );

      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is ChatException ? e.message : 'Có lỗi xảy ra khi gửi tin nhắn',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateSelectedAIItem(String newValue) {
    setState(() {
      _selectedAIItem = newValue;
      AIItem aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == newValue);

      // Cập nhật selectedAIItem trong AIChatList
      Provider.of<AIChatList>(context, listen: false).setSelectedAIItem(aiItem);

      // Di chuyển item được chọn lên đầu danh sách
      _listAIItem.removeWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.insert(0, aiItem);
    });
  }

  void _onTextChanged(String input) {
    if (input.isNotEmpty) {
      _showSlash = input.startsWith('/');
    } else {
      _showSlash = false; // Đặt lại _showSlash khi không có input
    }
  }

  @override
  Widget build(BuildContext context) {
    final botModel = context.watch<BotViewModel>();
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        body: Consumer<MessageModel>(
          builder: (context, messageModel, child) {
            return Column(
              children: [
                SafeArea(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            //Open menu
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu)),
                      !botModel.isChatWithMyBot
                          ? AIDropdown(
                              listAIItems: _listAIItem,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _updateSelectedAIItem(newValue);
                                }
                              },
                            )
                          : Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 238, 240, 243),
                                ),
                                height: 30,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    botModel.currentChatBot.assistantName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                      //const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(linkUpgrade);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cannot open link!')),
                            );
                          }
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Upgrade',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                            Icon(
                              Icons.rocket,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                      ),
                      if (!botModel.isChatWithMyBot)
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 238, 240, 243),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flash_on,
                                color: Colors.blueAccent,
                              ),
                              messageModel.maxTokens == 99999 &&
                                      messageModel.maxTokens != null
                                  ? const Text(
                                      "Unlimited",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blueAccent,
                                      ),
                                    )
                                  : Text(
                                      '${messageModel.remainingUsage}',
                                      style: const TextStyle(
                                          color: Color.fromRGBO(
                                              119, 117, 117, 1.0)),
                                    ),
                            ],
                          ),
                        ),
                      IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            Provider.of<MessageModel>(context, listen: false)
                                .clearMessage();
                            botModel.isChatWithMyBot = false;
                          }),
                    ],
                  ),
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (_isOpenDeviceWidget) {
                        _toggleDeviceVisibility();
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: !botModel.isChatWithMyBot
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            itemCount:
                                                messageModel.messages.length,
                                            itemBuilder: (context, index) {
                                              final message =
                                                  messageModel.messages[index];
                                              return BuildMessage(
                                                  message: message);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        if (_showSlash)
                                          Consumer<PromptListViewModel>(
                                            builder:
                                                (context, promptList, child) {
                                              if (promptList.isLoading) {
                                                return const CircularProgressIndicator(); // Hoặc một widget khác để hiển thị khi đang tải
                                              } else if (promptList.hasError) {
                                                return Text(
                                                    'Có lỗi xảy ra: ${promptList.error}'); // Hiển thị lỗi
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3 *
                                                            2,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color
                                                            .fromARGB(
                                                            255,
                                                            158,
                                                            198,
                                                            232), // Color of the border
                                                        width:
                                                            1.0, // Width of the border
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0), // Border radius
                                                    ),
                                                    constraints: BoxConstraints(
                                                        maxHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                3),
                                                    child: ListView.builder(
                                                      itemCount: promptList
                                                          .allprompts
                                                          .items
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Text(promptList
                                                              .allprompts
                                                              .items[index]
                                                              .title),
                                                          onTap: () {
                                                            _controller.text =
                                                                ""; // Chọn prompt
                                                            _showSlash = false;
                                                            PromptDetailsBottomSheet.show(
                                                                context,
                                                                promptList
                                                                    .allprompts
                                                                    .items[index]);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        InputWidget(
                                          focusNode: _focusNode,
                                          controller: _controller,
                                          onTextChanged: _onTextChanged,
                                          sendMessage: _sendMessage,
                                          isOpenDeviceWidget:
                                              _isOpenDeviceWidget,
                                          toggleDeviceVisibility:
                                              _toggleDeviceVisibility,
                                          hasText: _hasText,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  : ChatWidget()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedBottomItemIndex,
          onTap: _onTappedBottomItem,
        ),
      ),
    );
  }
}
