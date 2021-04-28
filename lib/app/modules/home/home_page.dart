import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';
import 'widgets/home_drawer/home_drawer_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    if (mounted) Modular.to.navigate('mangas');
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawerWidget(),
      appBar: AppBar(
        title: Text('Unifier'),
        centerTitle: true,
      ),
      body: RouterOutlet(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        onTap: (page) {
          if (page == 0)
            Modular.to.navigate('mangas');
          else if (page == 1) Modular.to.navigate('novels');

          setState(() {
            selectedPage = page;
          });
        },
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
    );
  }
}
