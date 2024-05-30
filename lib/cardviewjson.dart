import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pukulenam/Models/NewsSource.dart';
import 'package:pukulenam/UI/DescriptionAdapter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Json/Category.dart';
import '../Models/NewsData.dart';
import '../Models/ProfileData.dart';
import '../Themes/MainThemes.dart';
import '../UI/TrendingAdapter.dart';


class CardView extends StatefulWidget {
  const CardView({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late TabController _tabController;
  late Future<List<NewsListData>> futureNews;

  Object? get selectedCategory => null;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<List<NewsListData>> fetchNews() async {
    final response = await http.get(Uri.parse('https://pukulenam.id/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((article) => NewsListData.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey, // Warna latar belakang foto
                                  child: Image(
                                    image: AssetImage(''), // Placeholder
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Hello, ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'User Name', // Placeholder for user name
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
        TabBar(
          controller: _tabController,
          labelColor: Colors.purple,
          tabs: [
            Tab(text: 'News'),
            Tab(text: 'Fraud'),
          ],
          indicatorColor: Colors.purple,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              SizedBox(width: 16),
              // Add your category buttons here
              SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSelected(String category) {
    return category == selectedCategory;
  }

  Widget _buildCategoryButton(String category, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        // Handle category button press
        print('Selected category: $category');
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.purple;
            }
            return isSelected ? Colors.purple : Colors.white;
          },
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.white : Colors.purple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        getAppBarUI('My Activity'), // AppBar with name and tabs
        Expanded(
          child: FutureBuilder<List<NewsListData>>(
            future: futureNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load news'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No news available'));
              } else {
                List<NewsListData> articles = snapshot.data!;
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final Animation<double> animation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: Interval(
                          (1 / articles.length) * index, 1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    );

                    return ActivityCard(
                      activityListData: articles[index],
                      animation: animation,
                      animationController: animationController,
                      onPressed: () {
                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionAdapter(index: index),
                          ),
                        );

                         */
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activityListData,
    required this.animationController,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  final NewsListData activityListData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Memanggil onPressed ketika card ditekan
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
                      child: CachedNetworkImage(
                        height: 100,
                        imageUrl: activityListData.imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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

  final NewsListData activityListData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Memanggil onPressed ketika card ditekan
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
                      child: CachedNetworkImage(
                        height: 100,
                        imageUrl: activityListData.imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
