import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/widgets/home_mangas_view/home_mangas_view_widget.dart';
import 'package:unifier_mobile/app/modules/home/widgets/home_novels_view/home_novels_view_widget.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final _pageController = PageController(keepPage: false);

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        onTap: (page) => _pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        currentIndex: selectedPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Mangás',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Novels',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => selectedPage = index);
        },
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          HomeMangasViewWidget(
            controller: store,
          ),
          HomeNovelsViewWidget(
            controller: store,
          ),
        ],
      ),
    );
  }
}
