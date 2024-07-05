import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainView.dart';
import '../NavBar/BottomBar.dart';
import '../NavBar/TabIconData.dart';
import '../PartView/Cardview.dart';
import '../PartView/Profile.dart';
import '../PartView/TrendingView.dart';
import '../Themes/MainThemes.dart';
import 'ChatAdapter.dart';
import 'FormAdapter.dart';


class TrendingAdapter extends StatefulWidget {
  @override
  _TrendingAdapterState createState() => _TrendingAdapterState();
}

class _TrendingAdapterState extends State<TrendingAdapter>
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
    tabBody = TrendingView(animationController: animationController);
    tabIconsList[1].isSelected = true;
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

            if (index == 0 ) {
              animationController?.reverse().then<dynamic>((data) {
                print("mounted card ${mounted}");
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      CardList();
                });
              });
            }
            else if (index == 1 ) {
              animationController?.reverse().then<dynamic>((data) {
                print("mounted trending ${mounted}");
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrendingView(animationController: animationController,);
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

