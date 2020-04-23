import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class StationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final suggestionsBloc = globalValues.suggestionsBloc;
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Helper.width(35, size),
            vertical: Helper.height(32, size)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                suggestionsBloc.focusNode.unfocus();
                globalValues.appNavigationBloc.goBack();
              },
              child: SizedBox(
                width: Helper.width(36, size),
                height: Helper.width(36, size),
                child: Container(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: MyColors.BACK_EL),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: Helper.width(18, size),
                      color: MyColors.TEXT_PR,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Helper.width(180, size),
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.BACK_EL,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Helper.width(20, size),
                        vertical: Helper.width(10, size))),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                enableSuggestions: false,
                style: Theme.of(context).textTheme.headline2,
                focusNode: suggestionsBloc.focusNode,
                autofocus: true,
                controller: suggestionsBloc.textfield,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => suggestionsBloc.clear(),
              child: StreamBuilder<bool>(
                  stream: suggestionsBloc.notEmptyQuery,
                  builder: (context, notEmptyQuery) {
                    final notEmpty = notEmptyQuery.data ?? false;
                    return SizedBox(
                      width: Helper.width(36, size),
                      height: Helper.width(36, size),
                      child: notEmpty
                          ? Container(
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: MyColors.BACK_EL),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: Helper.width(18, size),
                                  color: MyColors.TEXT_PR,
                                ),
                              ),
                            )
                          : SizedBox(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
