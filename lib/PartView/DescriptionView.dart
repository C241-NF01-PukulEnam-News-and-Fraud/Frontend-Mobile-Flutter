import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pukulenam/Models/NewsData.dart';
import '../Themes/MainThemes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';

class DescriptionView extends StatefulWidget {
  const DescriptionView({
    Key? key,
    required this.animationController,
    required this.activityIndex,
  }) : super(key: key);

  final AnimationController? animationController;
  final int activityIndex;

  @override
  _DescriptionViewState createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Future<NewsData> selectedActivity;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    selectedActivity = fetchNews(widget.activityIndex);
  }

  Future<NewsData> fetchNews(int activityIndex) async {
    final response = await http.get(
      Uri.parse('https://pukulenam.id/wp-json/wp/v2/posts/$activityIndex'),
      headers: {
        'Authorization': 'Basic cHVrdWxlbmFtOnB1a3VsZW5hbVBBUyE=',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      print('activity indexnya padahal $activityIndex');

      final data = json.decode(response.body);

      // Assuming the response is a single object
      NewsData news = NewsData.fromJson(data);

      return news;
    } else {
      throw Exception('Failed to load news. Status Code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget getAppBarUI(String name, String author, String newsLink) {
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
                    color: MainAppTheme.white.withOpacity(1.0),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: MainAppTheme.grey.withOpacity(0.4),
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
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey,
                                  child: Image(
                                    image: NetworkImage('$author'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Spacer
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle share button press
                                Share.share('Check out this hottest news: $newsLink');
                              },
                              icon: Icon(Icons.share),
                              color: Colors.black,
                            ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder<NewsData>(
              future: selectedActivity,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()]);
                } else if (snapshot.hasError) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Failed to load news')]);
                } else if (snapshot.hasData) {
                  final newsData = snapshot.data!;
                  var document = HtmlWidget(newsData.content!);

                  return Column(
                    children: [
                      getAppBarUI(newsData.author ?? 'Unknown Author', newsData.authorpp ?? '',newsData.link ?? ''),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (newsData.imageUrl != null)
                              Container(
                                height: 200, // Adjust height as needed
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(newsData.imageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            SizedBox(height: 10),
                            if (newsData.title != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  newsData.title!,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            SizedBox(height: 30),
                            if (newsData.content != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: document,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}
