import 'package:flutter/material.dart';
import 'package:pukulenam/PartView/DescriptionView.dart';
import 'package:pukulenam/UI/MainView.dart';

import '../NavBar/BottomBar.dart';
import '../NavBar/TabIconData.dart';
import '../PartView/Cardview.dart';
import '../PartView/Profile.dart';
import '../Themes/MainThemes.dart';
import 'ChatAdapter.dart';
import 'FormAdapter.dart';
import 'TrendingAdapter.dart';

class DescriptionAdapter extends StatefulWidget {
  final int index;

  const DescriptionAdapter({Key? key, required this.index}) : super(key: key);

  @override
  _DescriptionAdapterState createState() => _DescriptionAdapterState();
}

class _DescriptionAdapterState extends State<DescriptionAdapter>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late int index;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: MainAppTheme.background,
  );

  @override
  void initState() {
    for(int i =0; i<4;i++){
      print("tab ${i} : ${tabIconsList[i].isSelected}");
    }
    super.initState();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    index = widget.index;
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    tabBody = DescriptionView(
      animationController: animationController,
      activityIndex: index,
    );

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF2F3F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return Stack(
                    children: <Widget>[
                      tabBody,
                      bottomBar(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {


            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormAdapter()),
            );
          },

          changeIndex: (int index) {
            print("mounted desc ${mounted}");
            if (index == 0 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      CardView(animationController: animationController);
                });
              });
            }
            else if (index == 1 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrendingAdapter();
                });
              });
            }
            else if (index == 2 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      ChatAdapter();
                });
              });
            }
            else if (index == 4 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      ProfileSettings();
                });
              });
            }
          },
        ),
      ],
    );
  }
}
