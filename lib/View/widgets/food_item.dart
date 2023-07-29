import 'package:food_app/Model/meal.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final Meal meal;

  const FoodItem({Key? key, required this.meal}) : super(key: key);

//move inf to FoodScreen
  void selectmeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      '/foodScreen',
      arguments: {"meal": meal},
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, boxConstraints) => InkWell(
        onTap: () => selectmeal(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            children: [
              // image
              Avatar(meal: meal, boxConstraints: boxConstraints),
              // under Image
              Footage(meal: meal, boxConstraints: boxConstraints),
            ],
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.meal, required this.boxConstraints})
      : super(key: key);

  final Meal meal;
  final BoxConstraints boxConstraints;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Image shape
        Hero(
          tag: meal.id,
          child: SizedBox(
            width: boxConstraints.maxWidth * 1,
            height: boxConstraints.maxHeight * 0.88,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              //Image
              child: Image.asset(
                meal.imageUrl,
                height: boxConstraints.maxHeight * 1,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        //Text on Image
        Positioned(
          bottom: 15,
          right: 10,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            padding: const EdgeInsets.all(8.0),
            width: boxConstraints.maxWidth * 0.6,
            child: Text(
              meal.title,
              style: TextStyle(
                fontSize: boxConstraints.maxHeight * 0.08,
                color: Colors.white70,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        )
      ],
    );
  }
}

class Footage extends StatelessWidget {
  const Footage({Key? key, required this.meal, required this.boxConstraints})
      : super(key: key);

  final BoxConstraints boxConstraints;
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Duration
            FittedBox(
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text('${meal.duration} min'),
                ],
              ),
            ),
            //Complexity
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Icon(
                    Icons.square_foot_outlined,
                  ),
                  Text(meal.complexityText),
                ],
              ),
            ),
            //Price
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                  ),
                  Text(meal.affordabilityText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
