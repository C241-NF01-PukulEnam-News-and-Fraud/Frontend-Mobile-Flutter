import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pukulenam/PartView/Profile.dart';

import '../NavBar/BottomBar.dart';
import '../NavBar/TabIconData.dart';
import '../PartView/Cardview.dart';
import '../PartView/FormView.dart';
import '../Themes/MainThemes.dart';
import 'ChatAdapter.dart';
import 'TrendingAdapter.dart';

class FormAdapter extends StatefulWidget {
  @override
  _FormAdapterState createState() => _FormAdapterState();
}

class _FormAdapterState extends State<FormAdapter>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: MainAppTheme.background,
  );

  @override
  void initState() {
    for(int i =0; i<4;i++){
      print("tab ${i} : ${tabIconsList[i].isSelected}");
    }
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = FormView(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF2F3F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
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
            print("mounted form ${mounted}");
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

