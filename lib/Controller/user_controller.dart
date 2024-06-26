import 'dart:developer';

import 'package:food_app/Controller/auth_controller.dart';
import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Model/food.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/user.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  final RxMap<String, bool> filters = RxMap();
  final RxList<String> _favoritefoods = RxList();
  final RxList<String> selectedCategories = RxList();

  final Rx<User> user;

  UserController(this.user) {
    filters.value = {
      'isGlutenFree': false,
      'isVegan': false,
      'isLactoseFree': false,
    };
  }

  // logout on delete
  @override
  InternalFinalCallback<void> get onDelete {
    Get.find<AuthController>().isAuth.value = false;
    return super.onDelete;
  }

  //___________________________________________________________________________filters
  void setfilters(Map<String, bool> filterdata, BuildContext context) {
    filters.value = filterdata;
    log("filters updated");
    update(["filters"]);
  }

  void addCatergory(String cat) {
    selectedCategories.add(cat);
    update(["userCats"]);
  }

  void removeCatergory(String cat) {
    selectedCategories.remove(cat);
    update(["userCats"]);
  }

  //_______________________________________________________________________________ favorites
  List<String> get favoritefoods {
    return _favoritefoods;
  }

  bool isFavorite(Food food) {
    return _favoritefoods.contains(food.id);
  }

  void addFavoriteFood(String id) {
    _favoritefoods.add(id);
    log("favs updated");
    update(["favs"]);
  }

  void removeFavoriteFood(String id) {
    _favoritefoods.remove(id);
    log("favs updated");
    update(["favs"]);
  }

  void toggleFav(String id) {
    if (_favoritefoods.contains(id)) {
      removeFavoriteFood(id);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Removed from favorites: ",
          message: Get.find<FoodController>().getFood(id)!.title,
        ),
      );
    } else {
      addFavoriteFood(id);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Added to favorites: ",
          message: Get.find<FoodController>().getFood(id)!.title,
        ),
      );
    }
  }
}
