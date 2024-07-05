import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Themes/MainThemes.dart';
import 'package:pukulenam/UI/DescriptionAdapter.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _TrendingViewState createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late List<NewsData> newsList;
  late List<NewsData> filteredNewsList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    newsList = [];
    filteredNewsList = [];
    fetchNewsList(); // Fetch news list on init
    searchController.addListener(() {
      filterNews(searchController.text);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchNewsList() async {
    final response = await http.get(
      Uri.parse('https://pukulenam.id/wp-json/wp/v2/posts?categories=1'),
      headers: {
        'Authorization': 'Basic cHVrdWxlbmFtOnB1a3VsZW5hbVBBUyE=', // Your authorization header
      },
    );

    if (response.statusCode == 200) {
      List<NewsData> loadedNews = [];
      List<dynamic> data = json.decode(response.body);

      data.forEach((item) {
        NewsData news = NewsData.fromJson(item);
        loadedNews.add(news);
      });

      setState(() {
        newsList = loadedNews;
        filteredNewsList = newsList;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  void filterNews(String query) {
    setState(() {
      filteredNewsList = newsList.where((news) {
        final titleLower = news.title.toLowerCase();
        final contentLower = news.content.toLowerCase();
        final excerptLower = news.excerpt.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            contentLower.contains(searchLower) ||
            excerptLower.contains(searchLower);
      }).toList();
    });
  }

  Future<String> fetchLastEndpoint(String selfUrl) async {
    final response = await http.get(Uri.parse(selfUrl));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return data['_links']['self'][0]['href'];
    } else {
      throw Exception('Failed to load endpoint');
    }
  }

  Widget getAppBarUI(String name) {
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ',
                      border: OutlineInputBorder(),
                    ),
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
    return Column(
      children: <Widget>[
        getAppBarUI('My Activity'), // AppBar with name
        Expanded(
          child: AnimatedBuilder(
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
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(filteredNewsList.length, (index) {
                          final Animation<double> animation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                (1 / filteredNewsList.length) * index,
                                1.0,
                                curve: Curves.fastOutSlowIn,
                              ),
                            ),
                          );
                          return ActivityCard(
                            newsData: filteredNewsList[index],
                            animation: animation,
                            animationController: animationController,
                            onPressed: () async {
                              try {
                                String lastEndpoint =
                                await fetchLastEndpoint(filteredNewsList[index].selfUrl);
                                int lastIndex = int.parse(lastEndpoint);
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (context) => DescriptionAdapter(
                                      index: lastIndex ,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Error fetching last endpoint: $e');
                                // Handle error, show toast, etc.
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 80,)
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.newsData,
    required this.animationController,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  final NewsData newsData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FadeTransition(
        opacity: animation,
        child: Transform(
          transform: Matrix4.translationValues(
            100 * (1.0 - animation.value),
            0.0,
            0.0,
          ),
          child: SizedBox(
            height: 155,
            child: Card(
              color: Color(0xFFF2F3F8),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsData.title,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            newsData.author,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        newsData.imageUrl,
                        height: 100,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FraudCard extends StatelessWidget {
  const FraudCard({
    Key? key,
    required this.activityListData,
    required this.animationController,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  final NewsData activityListData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FadeTransition(
        opacity: animation,
        child: Transform(
          transform: Matrix4.translationValues(
            100 * (1.0 - animation.value),
            0.0,
            0.0,
          ),
          child: SizedBox(
            height: 155,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activityListData.title,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            activityListData.author,
                            style: const TextStyle(
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        activityListData.imageUrl,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
