import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../methods/appBar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(), // Replace with your app bar widget
      ),
      body: Container(
        child: WebView(
          initialUrl: 'https://chat.google.com/room/AAAAYR14Mbg?cls=7',
          // Replace with the URL you want to show
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
