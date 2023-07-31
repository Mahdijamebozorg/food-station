import 'package:food_app/Controller/settings.dart';
import 'package:food_app/Model/category.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/View/widgets/Drawer.dart';
import 'package:food_app/View/widgets/edit_food.dart';
import 'package:food_app/View/widgets/food_item.dart';
import 'package:food_app/View/widgets/search_item.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxInt _currentPage = 0.obs;
RxList<Food> _foodsFound = RxList();
TextEditingController _searchtext = TextEditingController();
RxString _text = "".obs;

// change index
void _selectPage(int index) {
  _currentPage.value = index;
  _searchtext.clear();
}

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);
  // pages
  static const List<Map<String, Object>> _pages = [
    {'page': Categories(), 'title': 'Categories'},
    {'page': FavoriteFood(), 'title': "Your Favorite foods"}
  ];

  // simple search
  void _searchdFood(String text) {
    _foodsFound.value = Get.find<Settings>().simplefoodSearch(
      text: text,
      inFavs: _currentPage.value == 1,
    );
  }

  void _temporaryRemoveFood(Food food) {
    _foodsFound.remove(food);
  }

  @override
  Widget build(BuildContext context) {
    // add search listener
    _searchtext.addListener(() {
      _text.value = _searchtext.text;
      _searchdFood(_text.value);
      debugPrint("listen");
    });

    return SafeArea(
      child: Scaffold(
        // --------------------------------------------------------------
        appBar: const HomeAppBar(pages: _pages),
        // --------------------------------------------------------------
        bottomNavigationBar: const BottomNav(),
        // --------------------------------------------------------------
        body: Obx(
          () => _text.value.isEmpty

              // if not searching
              ? _pages[_currentPage.value]['page'] as Widget

              // if searching...
              : _foodsFound.isEmpty
                  ? const Center(
                      child: Text("No match found"),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) => SearchItem(
                        food: _foodsFound.elementAt(index),
                        remove: _temporaryRemoveFood,
                      ),
                      itemCount: _foodsFound.length,
                    ),
        ),
        // --------------------------------------------------------------
        drawer: const Drwer(),
        drawerEdgeDragWidth: 160,
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final List<Map<String, Object>> _pages;
  const HomeAppBar({Key? key, required List<Map<String, Object>> pages})
      : _pages = pages,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // apply gradient
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.black, Colors.blue]),
        ),
      ),
      title: Text(_pages[_currentPage.value]['title'] as String),
      centerTitle: true,
      actions: [
        AnimSearchBar(
          color: Theme.of(context).primaryColor,
          searchIconColor: Theme.of(context).colorScheme.onPrimary,
          helpText: "Enter food name",
          width: 400,
          textController: _searchtext,
          autoFocus: true,
          boxShadow: false,
          suffixIcon: const Icon(Icons.clear),
          onSuffixTap: () {
            _searchtext.clear();
          },
          onSubmitted: (str) {},
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("Add food"),
              onTap: () => showBottomSheet(
                context: context,
                builder: (context) => const EditFood(),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    // stateful
    return Obx(
      () => SizedBox(
        height: screenSize.height * 0.07,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          onTap: _selectPage,
          //chane selected item style
          selectedItemColor: Colors.yellow[400],
          unselectedItemColor: Colors.white,
          currentIndex: _currentPage.value,
          iconSize: screenSize.height * 0.07 * 0.5,
          selectedFontSize: screenSize.height * 0.07 * 0.2,
          unselectedFontSize: screenSize.height * 0.07 * 0.2,
          elevation: 8,
          type: BottomNavigationBarType.shifting,
          //bottombar items
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.category),
                label: 'Categories'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.star),
                label: 'Favorites'),
          ],
        ),
      ),
    );
  }
}

class FavoriteFood extends StatelessWidget {
  const FavoriteFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final islandscape = mediaQuery.orientation == Orientation.landscape;
    final screenheigh = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return GetBuilder<Settings>(
        id: "favs",
        builder: (settings) {
          return GridView.builder(
            //gridview options
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  islandscape ? screenwidth / 2 : screenheigh / 1,
              childAspectRatio: islandscape ? 7 / 5 : 1,
              mainAxisSpacing: screenheigh * 0.03,
              crossAxisSpacing: screenwidth * 0.01,
            ),
            //items
            itemBuilder: (ctx, index) =>
                FoodItem(food: settings.favoritefoods[index]),
            itemCount: settings.favoritefoods.length,
          );
        });
  }
}

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Settings>(
      id: "cats",
      builder: (settings) {
        final screenwidth = MediaQuery.sizeOf(context).width;
        final islandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) =>
              CategoryItem(settings.availableCategories[index]),
          itemCount: settings.availableCategories.length,
          //Gridview options
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //Width
            maxCrossAxisExtent: islandscape ? screenwidth / 4 : screenwidth / 2,
            //Width / Height
            childAspectRatio: 4 / 3,
            //فاصله عمودی
            mainAxisSpacing: 20,
            //فاصله افقی
            crossAxisSpacing: 20,
          ),
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category catData;

  const CategoryItem(this.catData, {Key? key}) : super(key: key);

//use routes
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      '/categoryScreen',
      arguments: {
        'id': catData.id,
        'title': catData.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      // splashColor: color,
      onTap: () => selectCategory(context),
      child: Container(
        decoration: BoxDecoration(
          //////gradient color
          gradient: LinearGradient(
            colors: [catData.color.withOpacity(0.3), catData.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: catData.color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
          elevation: 15,
          margin: const EdgeInsets.all(7),
          child: Center(
            child: Text(catData.title),
          ),
        ),
      ),
    );
  }
}
