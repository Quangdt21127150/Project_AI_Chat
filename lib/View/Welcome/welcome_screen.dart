import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Login/login_screen.dart';
import 'package:project_ai_chat/View/Register/register_screen.dart';
import 'package:project_ai_chat/constants/colors.dart';
import 'package:project_ai_chat/constants/image_strings.dart';
import 'package:project_ai_chat/constants/sizes.dart';
import 'package:project_ai_chat/constants/text_strings.dart';
import 'package:project_ai_chat/core/Widget/elevated_button.dart';
import 'package:project_ai_chat/core/Widget/outlined_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    var isDarkMode = brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
        body: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                  image: AssetImage(tWelcomeScreenImage), height: height * 0.5),
              Column(
                children: [
                  Text(tWelcomeTitle,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(tWelcomeSubTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButtonCustom(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    label: tLogin.toUpperCase(),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButtonCustom(
                    text: tRegister.toUpperCase(),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                  )),
                ],
              )
            ],
          ),
        ));
  }
}
