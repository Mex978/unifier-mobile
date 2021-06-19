import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/widgets/home_favorites_view/home_favorites_view_widget.dart';
import 'package:unifier_mobile/app/modules/home/widgets/home_mangas_view/home_mangas_view_widget.dart';

import 'home_controller.dart';
import 'widgets/home_drawer/home_drawer_widget.dart';
import 'widgets/home_novels_view/home_novels_view_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  final _pageController = PageController(keepPage: true, initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int selectedPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawerWidget(),
      appBar: AppBar(
        title: Text('Unifier'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => selectedPage = index);
        },
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          HomeMangasViewWidget(),
          HomeFavoritesViewWidget(),
          HomeNovelsViewWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
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
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Novels',
          ),
        ],
      ),
    );
  }
}
