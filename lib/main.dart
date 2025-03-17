import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Login/login_screen.dart';
import 'package:project_ai_chat/View/SplashScreen/splash_screen.dart';
import 'package:project_ai_chat/services/chat_service.dart';
import 'package:project_ai_chat/utils/theme/theme.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:project_ai_chat/viewmodels/aichat_list_view_model.dart';
import 'package:project_ai_chat/viewmodels/auth_view_model.dart';
import 'package:project_ai_chat/viewmodels/homechat_view_model.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_ai_chat/services/prompt_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider<ChatService>(
          create: (_) => ChatService(
            prefs: prefs,
          ),
        ),
        Provider<PromptService>(
          create: (_) => PromptService(
              // dio: dio,
              // prefs: prefs,
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageModel(
            context.read<ChatService>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => PromptListViewModel()),
        ChangeNotifierProvider(create: (context) => KnowledgeBaseProvider()),
        ChangeNotifierProvider(create: (context) => AIChatList()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ami Assistant',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      navigatorKey: navigatorKey,
      routes: {'/login': (context) => const LoginScreen()},
      home: SplashScreen(),
    );
  }
}
