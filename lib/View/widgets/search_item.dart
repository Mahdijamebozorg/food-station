// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/Model/food.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItem extends StatelessWidget {
  final Food food;
  final Function remove;
  const SearchItem({Key? key, required this.food, required this.remove})
      : super(key: key);

  void selectFood(BuildContext ctx) {
    Get.toNamed('/foodScreen', arguments: {"foodId": food.id});
  }

  @override
  Widget build(BuildContext context) {
    var screenheigh = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => selectFood(context),
      borderRadius: BorderRadius.circular(30),
      //for removing unwanted foods from search and comparing others
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        dragStartBehavior: DragStartBehavior.start,
        onDismissed: (DismissDirection dir) {
          remove(food);
        },
        background: Container(
          color: Get.theme.primaryColor,
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Icon(
              Icons.delete,
              color: Get.theme.colorScheme.background,
              size: MediaQuery.of(context).size.height * 0.075,
            ),
          ),
        ),
        child: Card(
          color: Get.theme.highlightColor,
          elevation: 7,
          margin: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //image
              SizedBox(
                height: screenheigh * 0.2,
                width: screenwidth * 0.2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: Hero(
                    tag: food.id,
                    // TODO: replace with these when data API is ready
                    // child: CachedNetworkImage(
                    //   imageUrl: food.imageUrl,
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(image: imageProvider),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => SpinKitFoldingCube(),
                    //   errorWidget: (context, url, error) => const Icon(
                    //     Icons.image_not_supported_outlined,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    child: Image.asset(
                      food.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: screenwidth * 0.08,
              ),
              //text
              Expanded(
                child: Text(
                  food.title,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
