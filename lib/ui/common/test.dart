import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageStateState createState() => _MyHomePageStateState();
}

class _MyHomePageStateState extends State<MyHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomSliverDelegate(
                  expandedHeight: 350.0,
                  child: Image.asset(
                    "img.jpg",
                    fit: BoxFit.cover,
                  ),
                  minHeight: 150,
                  color: Colors.green,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    20,
                    (int index) => ListTile(title: Text("Item $index")),
                  ),
                ),
              ),
            ],
          ),
          buildFab(),
        ],
      ),
    );
  }

  Positioned buildFab() {
    double top = 320.0; //default top margin, -4 for exact alignment
    if (_scrollController.hasClients) {
      print("_scrollController.offset ${_scrollController.offset}");
      if (_scrollController.offset < 200) {
        top -= _scrollController.offset;
      } else {
        top -= 200;
      }
    }
    return Positioned(
      top: top,
      right: 16,
      left: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 60,
            color: Colors.blueAccent,
          ),
          Container(
            width: 100,
            height: 60,
            color: Colors.blueAccent,
          ),
          Container(
            width: 100,
            height: 60,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double minHeight;
  final Color color;
  final Widget child;

  CustomSliverDelegate({
    required this.child,
    required this.minHeight,
    required this.color,
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: expandedHeight,
      color: color,
      child: child,
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
