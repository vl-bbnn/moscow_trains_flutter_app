import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/blocs/traincardbloc.dart';
import 'package:trains/ui/common/timetext.dart';
import 'package:trains/ui/schedulepage/stopstext.dart';
import 'package:trains/ui/schedulepage/trains/breaktext.dart';
import 'package:trains/ui/schedulepage/trains/trainclassicon.dart';
import 'package:trains/ui/schedulepage/trains/trainclasstext.dart';

class TrainCard extends StatelessWidget {
  final Sizes sizes;

  const TrainCard({Key key, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardBloc = TrainCardBloc.of(context);
    return StreamBuilder<TrainCardValues>(
        stream: cardBloc.values,
        builder: (context, valuesSnapshot) {
          if (!valuesSnapshot.hasData) return Container();

          final values = valuesSnapshot.data;

          return Padding(
            padding: values.outerPadding,
            child: ClipRRect(
              borderRadius: values.borderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: values.sigma, sigmaY: values.sigma),
                child: Container(
                  height: values.cardHeight,
                  width: values.cardWidth,
                  color: values.color,
                  padding: values.innerPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TrainClassIcon(
                            trainClass: values.trainClass,
                            angle: values.iconAngle,
                            frontHeight: values.iconFrontHeight,
                            frontWidth: values.iconFrontWidth,
                            frontOpacity: values.iconFrontOpacity,
                            backHeight: values.iconBackHeight,
                            backWidth: values.iconBackWidth,
                            backSigma: values.iconBackSigma,
                          ),
                          SizedBox(
                            height: values.regularIconTextPadding,
                          ),
                          SizedBox(
                            height: values.secondaryTextHeight,
                            child: values.secondaryTextValue > 0
                                ? Opacity(
                                    opacity: values.secondaryTextValue,
                                    child: BreakText(
                                      breakTime: values.breakTime,
                                    ),
                                  )
                                : SizedBox(),
                          )
                        ],
                      ),
                      SizedBox(
                        width: values.selectedIconTextPadding,
                      ),
                      SizedBox(
                        width: values.primaryTextWidth,
                        child: values.primaryTextValue > 0
                            ? Opacity(
                                opacity: values.primaryTextValue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TrainClassText(
                                        trainClass: values.trainClass,
                                        price: values.price),
                                    SizedBox(
                                      height: values.textPadding,
                                    ),
                                    StopsText(
                                      stops: values.stops,
                                    ),
                                    SizedBox(
                                      height: values.textPadding,
                                    ),
                                    TimeText(
                                      time: values.travelTime,
                                      animated: true,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
