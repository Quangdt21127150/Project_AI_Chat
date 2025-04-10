import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Login/login_screen.dart';
import 'package:project_ai_chat/models/response/api_response.dart';
import 'package:project_ai_chat/models/user_model.dart';
import 'package:project_ai_chat/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreent extends StatefulWidget {
  const AccountScreent({super.key});

  @override
  State<AccountScreent> createState() => _AccountScreentState();
}

class _AccountScreentState extends State<AccountScreent> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _loadUserInfo();
  //   });
  //   log("account screen render");
  // }

  // Future<void> _loadUserInfo() async {
  //   try {
  //     await Provider.of<AuthViewModel>(context, listen: false).fetchUserInfo();
  //   } catch (e) {
  //     if (e is ApiResponse<dynamic>) {
  //       if (e.statusCode == 401) {
  //         // await _logout();
  //       }
  //     }
  //   }
  // }

  Future<void> _logout() async {
    await Provider.of<AuthViewModel>(context, listen: false).logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.person, // Thay thế bằng bất kỳ icon nào bạn muốn
                      size: 40, // Kích thước của icon
                      color: Colors.white, // Màu của icon
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<AuthViewModel>(
                    builder: (context, authViewModel, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authViewModel.user?.username ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authViewModel.user?.email ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.freepik.com/512/330/330710.png', // URL ảnh từ mạng
                      width: 70, // chiều rộng ảnh
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons
                            .error); // Nếu tải ảnh không thành công, hiển thị icon lỗi
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Miễn phí',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Basic version',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Nâng cấp'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Account Section
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<AuthViewModel>(
                      builder: (context, authViewModel, child) {
                        return Card(
                          color: Colors.white, // Màu nền sáng
                          child: ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text(authViewModel.user?.username ?? ''),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.red[100], // Màu nền nút đăng xuất
                      child: ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title: Text('Log out'),
                          onTap: _logout),
                    ),
                    const SizedBox(height: 20),
                    // Support Section
                    const Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          // Mở Settings
                        },
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.chat_bubble_outline),
                        title: Text('Cài đặt trò chuyện'),
                        onTap: () {
                          // Mở Jarvis Playground
                        },
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.brightness_2_outlined),
                        title: Text('Chế độ màu sắc'),
                        subtitle: Text('Theo Hệ thống'),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Ngôn ngữ'),
                        subtitle: Text('Tiếng Việt'),
                        onTap: () {
                          // Mở Jarvis Playground
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // About Section
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.privacy_tip),
                        title: Text('Privacy Policy'),
                        onTap: () {
                          // Mở Privacy Policy
                        },
                      ),
                    ),
                    const Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Version'),
                        trailing: Text('3.1.0'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
