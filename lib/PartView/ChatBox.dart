import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Themes/MainThemes.dart';
import 'package:pukulenam/Models/Chat.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

Future<ChatData> fetchChat(String chat) async {
  final response = await http.post(
    Uri.parse('https://app.gradient.ai/api/models/complete?id=07396fc3-64f1-43e7-b194-f10843e741f0_base_ml_model'),
    body: json.encode({
      'autoTemplate': true,
      'maxGeneratedTokenCount': 150,
      'query': chat,
      'rag': null,
      'temperature': 0.7,
      'topK': 50,
      'topP': 0.95
    }),
    headers: {
      'accept-language': 'en-US,en;q=0.9,id;q=0.8',
      'cookie': '_gcl_au=1.1.1160389685.1718334605; _ga=GA1.1.2013834010.1718334605; cb_user_id=null; cb_group_id=null; cb_anonymous_id=%22fc9b4c62-86c1-4d15-aec8-66b1880f934d%22; ory_kratos_session=MTcxODMzNDY4N3wxMkZ3U2pabmE5RUxRWmhjLXZoYm40ZTNadkdJYjhFc05wSWI1cGFpUmxJRGxRaE5mdFlFYWVWd19kOVE0NEZNeDIxeHRLUDRKb1B6Qkd4RDQ2NVkzTnpsSGJnSVdPUVc5MFRHTFBKUjdRa3dXRTkwbS01Y3NlODlLRWZMSVRrVm54M2NkNmQwWUJRV25tbWdwcHpYd1VBZ0w3X211RGJFejNudS1nWkFPRTZtSUtBVkY3R2d0UUYxYjNrMnVXdUxZRkpvaXpSVVFQWlNDd0lVZXFtU1JVeTM5MDk1eWhVeFZEQnNhdTdVTUlIQlZFVTFaa3Yzb1YyY0UzT0ppSUtLc2ZCa0NfZ1J2bE5xfAECP8L0baT56Aj1N3Y57zevEArfiGIn5JpXEmBUU2rx; _ga_JGQNQSNJTH=GS1.1.1718346536.2.0.1718346536.0.0.0',
      'origin': 'https://app.gradient.ai',
      'priority': 'u=1, i',
      'sec-ch-ua': '"Microsoft Edge";v="125", "Chromium";v="125", "Not.A/Brand";v="24"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'content-type': 'application/json',
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0',
      'x-gradient-browser-client': '1',
      'x-gradient-workspace-id': 'bc4cc873-90f8-4df1-ba68-bef0918e0095_workspace'

    },
  );
  print('a ${response.statusCode}');
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Assuming the response is a single object
    ChatData chatData = ChatData.fromJson(data);
    return chatData;
  } else {
    throw Exception('Failed to load chat. Status Code: ${response.body}');
  }
}


class _ChatBoxState extends State<ChatBox> with TickerProviderStateMixin {
  late AnimationController animationController;
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool isFirstMessage = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: animationController,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30 * (1.0 - animationController.value),
                  0.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1.0),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Assistant 6',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void sendMessage(String text) {
    setState(() {
      messages.insert(0, Message(text: text, isSentByMe: true));
      messageController.clear();
    });
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Determine the query for the chatbot
    String query = isFirstMessage ? "say greeting to user" : text;

    fetchChat(query).then((chatData) {
      setState(() {
        messages.insert(0, Message(text: chatData.Response, isSentByMe: false));
      });
    }).catchError((error) {
      log("Failed to fetch chat: $error");
    });

    isFirstMessage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          getAppBarUI(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                return Align(
                  alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: BoxDecoration(
                      gradient: message.isSentByMe
                          ? LinearGradient(
                        colors: [Colors.purple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: message.isSentByMe ? null : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!message.isSentByMe)
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/pukulenam.jpg'),
                            radius: 15,
                          ),
                        if (!message.isSentByMe) SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            message.text,
                            textAlign: message.isSentByMe? TextAlign.right : TextAlign.left,
                            style: TextStyle(color: message.isSentByMe ? Colors.white : Colors.black),

                          ),
                        ),
                        if (message.isSentByMe) SizedBox(width: 10),
                        if (message.isSentByMe)
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/sayang.jpg'),
                            radius: 15,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Aa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.purple,
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage(messageController.text);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  color: Colors.purple,
                  onPressed: () {
                    // Add functionality to send images
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 90), // Add padding below the text input
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}