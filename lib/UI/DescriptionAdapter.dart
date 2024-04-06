import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pukulenam/PartView/DescriptionView.dart';

import '../NavBar/BottomBar.dart';
import '../NavBar/TabIconData.dart';
import '../Themes/MainThemes.dart';

class DescriptionAdapter extends StatefulWidget {
  final int index;

  const DescriptionAdapter({Key? key, required this.index}) : super(key: key);

  @override
  _DescriptionAdapterState createState() => _DescriptionAdapterState();
}

class _DescriptionAdapterState extends State<DescriptionAdapter>
    with TickerProviderStateMixin{
  late AnimationController animationController;
  late int index;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: MainAppTheme.background,
  );


  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    index = widget.index;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DescriptionView(animationController: animationController, activityIndex: index,);
    super.initState();
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
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  DescriptionView(
                    animationController: animationController,
                    activityIndex: index,
                  ),
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

          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                Navigator.of(context).pop();
              });
            } else if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return setState(() {});
                }
                setState(() {});
              });
            }
          },
        ),
      ],
    );
  }
}
