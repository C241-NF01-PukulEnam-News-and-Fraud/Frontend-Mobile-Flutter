import 'package:flutter/material.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';
import 'package:pukulenam/Models/NewsData.dart';

import '../Themes/MainThemes.dart';
import '../UI/DescriptionAdapter.dart';


class TrendingView extends StatefulWidget {
  const TrendingView({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _TrendingViewState createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late List<NewsListData> activityListData;
  late List<NewsListData> filteredNewsListData;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    activityListData = NewsListData.tabIconsList;
    filteredNewsListData = activityListData;
    searchController.addListener(() {
      filterActivities(searchController.text);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void filterActivities(String query) {
    setState(() {
      filteredNewsListData = activityListData.where((activity) {
        final titleLower = activity.descTxt.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
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
                        children: List.generate(filteredNewsListData.length, (index) {
                          final Animation<double> animation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / filteredNewsListData.length) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          return ActivityCard(
                            activityListData: filteredNewsListData[index],
                            animation: animation,
                            animationController: animationController,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DescriptionAdapter(index: index)),
                              );
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
    required this.onPressed, // Tambahkan onPressed
  }) : super(key: key);

  final NewsListData activityListData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback onPressed; // Deklarasikan onPressed

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Gunakan onPressed ketika card ditekan
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
                            activityListData.descTxt,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height:10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activityListData.source,
                                style: const TextStyle(
                                  color: Colors.purple,
                                ),
                              ),
                              activityListData?.status!="Hoax"
                                  ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child :Text(
                                  activityListData.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ):
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child :Text(
                                  activityListData.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        height: 100,
                        image: activityListData.photo ?? AssetImage(''),
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




