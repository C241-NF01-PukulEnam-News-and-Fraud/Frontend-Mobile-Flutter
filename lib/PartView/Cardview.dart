import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pukulenam/Models/Author.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/ProfileData.dart';
import 'package:pukulenam/Models/NewsSource.dart';
import 'package:pukulenam/UI/DescriptionAdapter.dart';
import 'package:pukulenam/UI/TrendingAdapter.dart';
import '../Json/Category.dart';
import '../Themes/MainThemes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class CardView extends StatefulWidget {
  const CardView({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late TabController _tabController;
  late Future<List<NewsData>> futureNewsList;
  late Future<List<AuthorData>> futureAuthorList;
  Object? get selectedCategory => null;

  @override
  void initState() {
    super.initState();
    futureNewsList = fetchNewsList();
    futureAuthorList = fetchAuthorList();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    _tabController = TabController(vsync: this, length: 2);
  }

  Future<List<NewsData>> fetchNewsList() async {
    final response = await http.get(
      Uri.parse('https://pukulenam.id/wp-json/wp/v2/posts?categories=1'),
      headers: {
        'Authorization': 'Basic cHVrdWxlbmFtOnB1a3VsZW5hbVBBUyE=',
      },
    );
    print("aaaaaaaaaaaaaaaaaaaaaaaaa");
    if (response.statusCode == 200) {
      List<NewsData> newsList = [];
      List<dynamic> data = json.decode(response.body);

      data.forEach((item) {
        try {
          NewsData news = NewsData.fromJson(item);
          newsList.add(news);
        } catch (e) {
          print('Error parsing item: $item');
          print(e);
        }
      });
      return newsList;
    } else {
      print("xxxxxxxxxxxxxxxxx");
      throw Exception('Failed to load news');
    }
  }

  Future<List<AuthorData>> fetchAuthorList() async {
    final response = await http.get(
      Uri.parse('https://pukulenam.id/wp-json/wp/v2/users'),
      headers: {
        'Authorization': 'Basic cHVrdWxlbmFtOnB1a3VsZW5hbVBBUyE=',
      },
    );
    print("aaaaaaaaaaaaaaaaaaaaaaaaa");
    if (response.statusCode == 200) {
      List<AuthorData> authorList = [];
      List<dynamic> data = json.decode(response.body);

      data.forEach((item) {
        try {
          AuthorData news = AuthorData.fromJson(item);
          authorList.add(news);
        } catch (e) {
          print('Error parsing item: $item');
          print(e);
        }
      });
      return authorList;
    } else {
      print("xxxxxxxxxxxxxxxxx");
      throw Exception('Failed to load news');
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    _tabController.dispose();
    super.dispose();
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
                                    image: AssetImage('assets/images/pukulenam.jpg'),
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
                                  ProfileData.tabIconsList.first.name,
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
            Tab(text: 'AI Consultant'),
          ],
          indicatorColor: Colors.purple,
          indicatorSize: TabBarIndicatorSize.label,
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
      void _launchURL(String url) async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
      final List<Menu> menu = (json.decode(menuJson)['menu'] as List)
          .map((data) => Menu.fromJson(data))
          .toList();
      List<Menu> subMenuItems = [];
      for (var item in menu) {
        subMenuItems.addAll(item.subMenu);
      }
      return Column(
        children: <Widget>[
          getAppBarUI('My Activity'), // AppBar with name and tabs
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
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      ...subMenuItems.map((subItem) => _buildCategoryButton(subItem.text, _isSelected(subItem.text))).toList(),
                                      SizedBox(width: 16),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Author',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                        FutureBuilder(
                                          future: futureAuthorList,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<AuthorData> authorList = snapshot.data!;
                                              return SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(authorList.length-1, (index) {
                                                    print(authorList[index].selfUrl);
                                                    return Authors(
                                                      authorData: authorList[index],
                                                      animationController: animationController,
                                                      animation: Tween<double>(
                                                        begin: 0.0,
                                                        end: 1.0,
                                                      ).animate(
                                                        CurvedAnimation(
                                                          parent: animationController,
                                                          curve: Interval(
                                                            (1 / authorList.length) * index,
                                                            1.0,
                                                            curve: Curves.fastOutSlowIn,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        print(authorList[index].selfUrl);
                                                        _launchURL(authorList[index].selfUrl);
                                                      },
                                                    );
                                                  }),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                              );
                                            }
                                            return Center(
                                            );
                                          },
                                        ),


                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Daily',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                                // News cards
                                FutureBuilder<List<NewsData>>(
                                  future: futureNewsList,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<NewsData> newsList = snapshot.data!;
                                      return Column(
                                        children: List.generate(5, (index) {
                                          final Animation<double> animation = Tween<double>(
                                            begin: 0.0,
                                            end: 1.0,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval((1 / newsList.length) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          );
                                          return ActivityCard(
                                            newsData: newsList[index],
                                            animationController: animationController,
                                            animation: animation,
                                            onPressed: () async {
                                              final response = await http.get(Uri.parse(newsList[index].selfUrl),
                                                headers: {
                                                  'Authorization': 'Basic cHVrdWxlbmFtOnB1a3VsZW5hbVBBUyE=', // Your authorization header
                                                },
                                              );
                                              print(response.statusCode);
                                              print(json.decode(response.body)['id']);
                                              if (response.statusCode == 200) {
                                                final dynamic data = json.decode(response.body);
                                                int lastEndpoint =data['id'];
                                                print(lastEndpoint);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DescriptionAdapter(index: lastEndpoint)),
                                                );
                                              } else {
                                                throw Exception('Failed to load endpoint');
                                              }


                                            },
                                          );
                                        }),

                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot);
                                      return Center(
                                        child: Text('Failed to load news'),
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                               SizedBox(height: 100,),
                              ],
                            ),
                          ),
                          // Content for Fraud tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () => _launchURL('https://calendly.com/alvinbuanaa/aineedconsultancy'),
                                        child:Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                offset: Offset(4, 4),
                                                blurRadius: 8,
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[
                                              Icon(
                                                  Icons.calendar_month
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                'Jadwalkan Konsultasi Gratis (Alvin)',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ) ,
                                      ),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: () => _launchURL('https://wa.me/6287877893100'),
                                        splashColor: Colors.purple.withOpacity(0.3),
                                        child : Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                offset: Offset(4, 4),
                                                blurRadius: 8,
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:[
                                                Icon(
                                                    Icons.message
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  'Hubungi Konsultan Kami (Alvin)',
                                                  textAlign: TextAlign.center,
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: () => _launchURL('https://iganarendra.my.id/booking'),
                                        child:  Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                offset: Offset(4, 4),
                                                blurRadius: 8,
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:[
                                                Icon(
                                                    Icons.calendar_month
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  'Jadwalkan Konsultasi Gratis (Iga)',
                                                  textAlign: TextAlign.center,
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        onTap: () => _launchURL('https://wa.me/6285339435369'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                offset: Offset(4, 4),
                                                blurRadius: 8,
                                              ),
                                            ],
                                            color: Colors.white,


                                          ),
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:[
                                                Icon(
                                                    Icons.message
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  'Hubungi Konsultasi Gratis (Iga)',
                                                  textAlign: TextAlign.center,
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: IconButton(
                                              icon: FaIcon(FontAwesomeIcons.github),
                                              onPressed: () => _launchURL('https://github.com/pukulenam/'),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: IconButton(
                                              icon: FaIcon(FontAwesomeIcons.linkedin),
                                              onPressed: () => _launchURL('https://www.linkedin.com/company/pukulenam'),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),

                                            child: IconButton(
                                              icon: FaIcon(FontAwesomeIcons.instagram),
                                              onPressed: () => _launchURL('https://www.instagram.com/pukulenam.id'),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
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
          ),
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

class Authors extends StatelessWidget {
  const Authors({
    Key? key,
    required this.authorData,
    required this.animationController,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  final AuthorData authorData;
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
            child: Row(
              children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipOval(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.network(
                          authorData.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



