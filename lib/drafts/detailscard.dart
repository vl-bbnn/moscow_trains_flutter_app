//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:trains/data/train.dart';
//import 'package:trains/drafts/trainSmallCard.dart';
//
//class DetailsCard extends StatelessWidget {
//  DetailsCard(this.train);
//
//  final Train train;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          TrainSmallCard(train),
//          Expanded(
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Text(
//                        train.thread.stops.first.station.name,
//                        style: TextStyle(
//                            fontWeight: FontWeight.w700, fontSize: 18.0),
//                      ),
//                      Text(
//                        (DateFormat('kk:mm')
//                            .format(train.thread.stops.first.departure)),
//                        style: TextStyle(
//                            fontWeight: FontWeight.w700, fontSize: 18.0),
//                      ),
//                    ],
//                  ),
//                ),
//                Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  child: Text(
//                    "-",
//                    style:
//                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
//                  ),
//                ),
//                Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Text(
//                        train.thread.stops.last.station.name,
//                        style: TextStyle(
//                            fontWeight: FontWeight.w700, fontSize: 18.0),
//                      ),
//                      Text(
//                        (DateFormat('kk:mm')
//                            .format(train.thread.stops.last.arrival)),
//                        style: TextStyle(
//                            fontWeight: FontWeight.w700, fontSize: 18.0),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
