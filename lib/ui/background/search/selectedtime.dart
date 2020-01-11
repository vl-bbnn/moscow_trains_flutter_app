import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';

class SelectedTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return Container(
      height: 125,
      child: StreamBuilder<DateTime>(
          stream: trainsBloc.targetDateTime,
          builder: (context, snapshot) {
            final time = snapshot.data ?? DateTime.now();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: DateFormat("H").format(time),
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "LexendDeca",
                          fontWeight: FontWeight.w500,
                          color: Constants.PRIMARY),
                    ),
                    TextSpan(
                      text: ":" + DateFormat("mm").format(time),
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "LexendDeca",
                          fontWeight: FontWeight.w500,
                          color: Constants.PRIMARY),
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}
