import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/common/helper.dart';

class DateText extends StatelessWidget {
  final DateTime date;

  const DateText({Key key, this.date}) : assert(date != null);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textBloc = GlobalBloc.of(context).textBloc;
    return Container(
      color: textBloc.showTextBorders ? Colors.red : null,
      width: size.width * 0.3,
      child: AutoSizeText(
        Helper.dateText(date).toUpperCase(),
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 14),
        maxLines: 1,
        group: textBloc.trainDetailsText,
        textAlign: TextAlign.start,
      ),
    );
  }
}
