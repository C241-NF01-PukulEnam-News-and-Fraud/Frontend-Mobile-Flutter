import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pukulenam/Models/NewsSource.dart';
import 'package:pukulenam/UI/DescriptionAdapter.dart';

import '../Json/Category.dart';
import '../Models/NewsData.dart';
import '../Models/ProfileData.dart';
import '../Themes/MainThemes.dart';
import '../UI/TrendingAdapter.dart';
import 'DescriptionView.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late TabController _tabController;
  late List<NewsListData> activityListData;
  late List<NewsListData> filteredActivityListData;
  late List<NewsSource> newsSource;

  Object? get selectedCategory => null;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
    activityListData = NewsListData.tabIconsList;
    filteredActivityListData = activityListData;
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget getAppBarUI(String name) {
    final List<Menu> menu = (json.decode(menuJson)['menu'] as List)
        .map((data) => Menu.fromJson(data))
        .toList();
    List<Menu> subMenuItems = [];
    for (var item in menu) {
      subMenuItems.addAll(item.subMenu);
    }
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
                                    image: ProfileData.tabIconsList.first.photo ?? AssetImage(''),
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
              SizedBox(width: 10),
              ...subMenuItems.map((subItem) => _buildCategoryButton(subItem.text, _isSelected(subItem.text))).toList(),
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
                        // Content for News tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Popular Redaction',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          NewsSource.tabIconsList.length,
                                              (index) {
                                            final NewsSource source = NewsSource.tabIconsList[index];
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color : Colors.grey,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image(
                                                    image: source.photo ?? AssetImage(''),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Trending',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => TrendingAdapter()),
                                            );
                                          },
                                          child: Text(
                                            'View All',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                  ],
                                ),
                              ),


                              // Activity cards
                              ...List.generate(filteredActivityListData.length, (index) {
                                final Animation<double> animation = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / filteredActivityListData.length) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );

                                return ActivityCard(
                                  activityListData: filteredActivityListData[index],
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
                            ],
                          ),
                        ),
                        // Content for Fraud tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Paste URL',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              // Fraud card list
                              ...List.generate(filteredActivityListData.length, (index) {
                                final Animation<double> animation = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / filteredActivityListData.length) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );

                                return FraudCard(
                                  activityListData: filteredActivityListData[index],
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
                            activityListData.descTxt,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            activityListData.source,
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



class FraudCard extends StatelessWidget {
  const FraudCard({
    Key? key,
    required this.activityListData,
    required this.animationController,
    required this.animation,
    required this.onPressed, // Menambahkan properti onPressed
  }) : super(key: key);

  final NewsListData activityListData;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? onPressed; // Mendeklarasikan onPressed sebagai VoidCallback

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
                            activityListData.descTxt,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          activityListData?.status != "Hoax"
                              ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activityListData.status,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                              : Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activityListData.status,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
