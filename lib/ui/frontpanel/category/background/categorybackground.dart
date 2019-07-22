import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/frontpanel/category/background/buybutton.dart';
import 'package:trains/ui/frontpanel/category/background/title/categorysubtitle.dart';
import 'package:trains/ui/frontpanel/category/background/title/categorytitle.dart';

class CategoryBackground extends StatelessWidget {
  CategoryBackground(
      {@required this.type, @required this.sublist, this.scrollController});
  final List<Train> sublist;
  final TrainType type;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Future.delayed(const Duration(milliseconds: 20), () {}).then((s) {
            scrollController.animateTo(0.0,
                duration: Duration(milliseconds: 400), curve: Curves.easeIn);
          });
        },
        child: Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Constants.whiteDisabled, width: 2.0),
                  borderRadius: BorderRadius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryTitle(
                      type: type,
                    ),
                    BuyButton(
                      sublist: sublist,
                    ),
                  ],
                ),
                CategorySubTitle(
                  sublist: sublist,
                ),
                Container(
                  height: Constants.CATEGORY_TRAIN_SIZE +
                      Constants.CATEGORY_TRAIN_PADDING * 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
