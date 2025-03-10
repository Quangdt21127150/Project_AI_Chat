# project_ai_chat - AMI

## Thông tin nhóm: 
- 21120543 - Nguyễn Đặng Quốc
- 21120560 - Nguyễn Đức Thiện (Nhóm trưởng)
- 21120561 - Bùi Đức Thịnh

## Link Youtube: 
- Link video demo UI: [https://youtu.be/fnXSZV_mmTc]()

## Các màn hình đã thực hiện

### 1. Splash
- Khi mở ứng dụng sẽ hiển thị màn hình này đầu tiên **(/lib/View/SplashScreen/splash_screen.dart)**
### 2. Welcome
- Màn hình khi mở Ứng dụng lần đầu **(/lib/View/Welcome/welcome_screen.dart)**
### 3. Login
- Màn hình đăng nhập, có thể đăng nhập bằng cách nhập thông tin (Email, PassWord) hoặc Google **(/lib/View/Login/login_screen.dart)**
### 4. Register
- Màn hình đăng ký, có thể đăng ký bằng cách nhập thông tin (Name, Email, PhoneNo, PassWord) hoặc Google **(/lib/View/Register/register_screen.dart)**
### 5. HomeChat
- Đây là màn hình khi đăng nhập thành công **(/lib/View/HomeChat/home.dart)**
- Các chức năng có trong màn hình này:
  - Chọn Menu
  - Chọn AI-Bot
  - Thêm đoạn chat mới
  - Giảm số lượng token khi chat
  - Xem lịch sử chat, mở lịch sử chat
  - Soạn, gửi tin nhắn
  - Up hình, chụp hình
  - Soạn email
### 6. Soạn Email
- Đây là màn hình có chức năng giúp người dùng soạn email nhanh chóng **(/lib/View/EmailChat/email.dart)**
### 7. Quản lý Prompt
- Đây là màn hình quản lý Prompt **(/lib/View/BottomSheet/custom_bottom_sheet.dart)**
  - Chia hai phần là My Prompt và Public Prompt
  - Tìm kiếm, lọc
  - Danh sách prompt
  - Thêm vào yêu thích
- Tạo prompt mới bằng cách điền thông tin theo từng loại prompt **(/lib/View/BottomSheet/Dialog/custom_dialog.dart)**
- Xem thông tin chi tiết của prompt
### 8. Tạo và quản lý AI Bots
Từ màn hình chính nhấn vào **biểu tượng Bot AI** trong thanh Bottom Navigation Bar để vào trang **Quản lý AI Bot**.
- **Trang Hiển thị, tìm kiếm AI Bots (/lib/View/Bot/page/bot_screen.dart)**
    - Trang này bao gồm các chức năng hiển thị, tìm kiếm AI Bot
    - Nhấn dấu cộng để tiến hành tạo AI Bot mới
    - Kéo các AI Bot sang trái để tiến hành các thao tác trên bot này bao gồm chỉnh sửa, xoá, publish ra slack, telegram, messenger.
- **Trang tạo bot (/lib/View/Bot/page/new_bot.dart)**
    - Tại đây người dùng có thể tạo tên, prompt cho AI bot
- **Trang chỉnh sửa bot (/lib/View/Bot/page/edit_bot.dart)**
    - Tại đây người dùng có thể chỉnh sửa tên bot, cập nhật lại prompt
    - Thêm xoá dữ liệu tri thức vào AI Bot

### 9. Tạo bộ dữ liệu tri thức
Từ màn hình chính nhấn vào biểu tượng **Hamburger Menu** rồi chọn mục **Knowledge Management** để vào trang quản lý Bộ dữ liệu tri thức.
- **Trang Hiển thị tìm kiếm bộ dữ liệu tri thức (/lib/View/Knowledge/page/knowledge_screen.dart)**
    - Trang này bao gồm các chức năng hiển thị, tìm kiếm các bộ dữ liệu tri thức
    - Nhấn dấu cộng để tiến hành tạo Bộ dữ liệu tri thức mới
    - Kéo các bộ dữ liệu sang trái để tiến hành các thao tác chỉnh sửa, xoá trên các bộ dữ liệu này.
- **Trang tạo bộ dữ liệu tri thức (/lib/View/Knowledge/page/new_knowledge.dart)**
    - Tại đây người dùng có thể tạo tên, mô tả cho Bộ dữ liệu tri thức
- **Trang chỉnh sửa bộ dữ liệu tri thức (/lib/View/Knowledge/page/edit_knowledge.dart)**
    - Tại đây người dùng có thể chỉnh sửa tên, mô tả cho bộ dữ liệu
    - Người dùng có thể nạp dữ liệu từ file, URL website, Google Drive, Slack, Confluence
    - Người dùng có thể xoá nguồn dữ liệu tương ứng

### 10. Thông tin tài khoản và cài đặt chung
Từ màn hình chính nhấn vào **biểu tượng Person (Information)** trong thanh Bottom Navigation Bar để vào trang xem Thông tin tài khoản và các cài đặt chung.

### 11. Upgrade
Màn hình nâng cấp tài khoản người dùng **(/lib/View/UpgradeVersion/upgrade-version.dart)**

### 12. Forgot Password
Màn hình gửi email xác nhận để reset mật khẩu **(/lib/View/ForgotPassword/forgot_password.dart)**