import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class TimeText extends StatefulWidget {
  final time;
  final textAlign;
  final align;
  final shouldWarn;
  final short;
  final width;
  final height;
  final animated;
  final curvedValue;

  const TimeText(
      {this.time,
      this.width: 100.0,
      this.height: 16.0,
      this.shouldWarn: false,
      this.textAlign: TextAlign.start,
      this.align: Alignment.centerLeft,
      this.curvedValue: 0.0,
      this.animated: false,
      this.short: false});

  @override
  _TimeTextState createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  var hours = 0;
  var hoursText = "";
  var minutes = 0;
  var minutesText = "";
  var hasData = false;

  init() {
    hasData = widget.time != null;
    final text = Helper.minutesToText(widget.time);
    if (hasData)
      try {
        hours = int.parse(text['hours']);
        minutes = int.parse(text['minutes']);
        hoursText =
            (widget.short ? " ч" : " " + text["hoursText"]).toUpperCase();
        minutesText =
            (widget.short ? " мин" : " " + text["minutesText"]).toUpperCase();
      } catch (err) {
        print(err.toString());
      }
  }

  _textStyle({primary, specialOneFeature, baseStyle}) {
    if (primary)
      return baseStyle.copyWith(
          fontSize: 12.0,
          color: widget.shouldWarn
              ? Color.lerp(
                  MyColors.WA, MyColors.TEXT_PR, widget.curvedValue)
              : MyColors.TEXT_PR,
          fontFeatures: specialOneFeature
              ? [FontFeature.disable('ss03')]
              : [FontFeature.enable('ss03')]);
    else
      return baseStyle.copyWith(
          fontSize: 10.0,
          color: widget.shouldWarn
              ? Color.lerp(MyColors.WA_B70, MyColors.TEXT_SE,
                  widget.curvedValue)
              : MyColors.TEXT_SE);
  }

  _body(text, context) {
    final specialOneMinutes = minutes == 1;
    final specialOneHours = hours == 1;
    final baseStyle = Theme.of(context).textTheme.headline1;
    final minutesToText = minutes.toString().toUpperCase();
    final hoursToText = hours.toString().toUpperCase();
    if (hours == 0) {
      return [
        TextSpan(
            text: minutesToText,
            style: _textStyle(
                primary: true,
                specialOneFeature: specialOneMinutes,
                baseStyle: baseStyle)),
        TextSpan(
            text: minutesText,
            style: _textStyle(
                primary: false,
                specialOneFeature: false,
                baseStyle: baseStyle)),
      ];
    } else if (minutes == 0)
      return [
        TextSpan(
            text: hoursToText,
            style: _textStyle(
                primary: true,
                specialOneFeature: specialOneHours,
                baseStyle: baseStyle)),
        TextSpan(
            text: hoursText,
            style: _textStyle(
                primary: false,
                specialOneFeature: false,
                baseStyle: baseStyle)),
      ];
    else
      return [
        TextSpan(
            text: hoursToText,
            style: _textStyle(
                primary: true,
                specialOneFeature: specialOneHours,
                baseStyle: baseStyle)),
        TextSpan(
            text: " ч",
            style: _textStyle(
                primary: false,
                specialOneFeature: false,
                baseStyle: baseStyle)),
        TextSpan(
            text: " " + minutesToText,
            style: _textStyle(
                primary: true,
                specialOneFeature: specialOneMinutes,
                baseStyle: baseStyle)),
        TextSpan(
            text: " мин",
            style: _textStyle(
                primary: false,
                specialOneFeature: false,
                baseStyle: baseStyle)),
      ];
  }

  @override
  Widget build(BuildContext context) {
    init();
    final textBloc = GlobalValues.of(context).textBloc;
    final hasData = widget.time != null;
    return Container(
      color: hasData ? null : Colors.lightBlue,
      width: widget.width,
      height: widget.height,
      child: hasData
          ? Align(
              alignment: widget.align,
              child: AutoSizeText.rich(
                TextSpan(children: _body(widget.time, context)),
                maxLines: (widget.animated && hours != 0) ? 2 : 1,
                textAlign: widget.textAlign,
                minFontSize: 8,
                group: widget.animated
                    ? AutoSizeGroup()
                    : widget.short
                        ? textBloc.smallTimeText
                        : textBloc.regularTimeText,
              ),
            )
          : Container(),
    );
  }
}
