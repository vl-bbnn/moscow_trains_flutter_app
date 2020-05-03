import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/stationdetails.dart';

class StationCardForSelector extends StatelessWidget {
  final Station station;

  const StationCardForSelector({Key key, this.station}) : super(key: key);

  _fontWeight() {
    if (station.code == "s2006004") return FontWeight.w700;
    return FontWeight.w500;
  }

  Future<Image> loadImage({width, height}) async {
    final path = "assets/maps/${station.code}.png";
    return rootBundle.load(path).then((value) {
      return Image.memory(
        value.buffer.asUint8List(),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }).catchError((_) {
      return Image.asset(
        "assets/maps/s2006004.png",
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textBloc = GlobalBloc.of(context).textBloc;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: <Widget>[
          Image.asset(
            "assets/maps/s2006004.png",
            width: size.width * 0.733,
            height: size.height * 0.138,
            fit: BoxFit.cover,
          ),
          // FutureBuilder(
          //   future: loadImage(
          //     width: size.width * 0.733,
          //     height: size.height * 0.138,
          //   ),
          //   builder: (context, imageSnapshot) {
          //     if (imageSnapshot.connectionState != ConnectionState.done)
          //       return Image.asset(
          //         "assets/maps/s2006004.png",
          //         width: size.width * 0.733,
          //         height: size.height * 0.138,
          //         fit: BoxFit.cover,
          //       );
          //     return imageSnapshot.data;
          //   },
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Helper.width(20, size),
                vertical: Helper.height(20, size)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StationDetails(
                  transitList: station.transitList,
                ),
                SizedBox(
                  height: Helper.height(10, size),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.4,
                      color: textBloc.showTextBorders ? Colors.red : null,
                      child: AutoSizeText(
                        station.title,
                        maxLines: 2,
                        group: textBloc.stationTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontWeight: _fontWeight()),
                      ),
                    ),
                    station.subtitle.isNotEmpty
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: Helper.height(5, size),
                              ),
                              Container(
                                width: size.width * 0.4,
                                color: textBloc.showTextBorders
                                    ? Colors.red
                                    : null,
                                child: AutoSizeText(
                                  station.subtitle,
                                  maxLines: 1,
                                  group: textBloc.stationSubtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: 14,
                                          color: MyColors.TEXT_SE),
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
