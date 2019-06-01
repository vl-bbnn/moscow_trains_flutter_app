//  Widget _segmentSquare(dynamic segment) {
//    DateTime _departure = DateTime.parse(segment['departure']).toLocal();
//    DateTime _arrival = DateTime.parse(segment['arrival']).toLocal();
//    Color _color = _colorSwitch(segment['thread']['transport_subtype']);
//    return Container(
//      padding: const EdgeInsets.all(4.0),
//      child: Opacity(
//        opacity: _howSoon(segment).isNegative ? 1.0 : 0.5,
//        child: Stack(
//          children: <Widget>[
//            Positioned(
//              top: 5.0,
//              child: Card(
//                elevation: 2.0,
//                color: _color,
//                child: Container(
//                  padding: EdgeInsets.symmetric(horizontal: 8.0),
//                  alignment: Alignment.centerLeft,
//                  height: _cardHeight * 0.8,
//                  width: _cardWidth,
//                  child: RotatedBox(
//                    quarterTurns: 3,
//                    child: Text(
//                      "115 ₽",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w800,
//                          fontSize: 24.0,
//                          color: Colors.white),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            ClipPath(
//              clipper: ClipTrain(0.4, 0.3),
//              child: Card(
//                elevation: 4.0,
//                child: Container(
//                  height: _cardHeight,
//                  width: _cardWidth,
//                  padding: const EdgeInsets.all(8.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.end,
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Container(
////                        alignment: Alignment.centerLeft,
////                              width: MediaQuery.of(context).size.width * 0.25,
//                        child: Text(
//                          DateFormat('kk:mm').format(_departure),
//                          style: TextStyle(
//                              fontSize: 26.0,
//                              fontWeight: FontWeight.w900,
//                              color: !_howSoon(segment).isNegative &&
//                                  _howSoon(segment).abs().inMinutes < 10
//                                  ? Colors.red
//                                  : Colors.black),
//                        ),
//                      ),
//                      Container(
//                        padding: EdgeInsets.symmetric(horizontal: 8.0),
//                        alignment: Alignment.centerRight,
////                    width: MediaQuery.of(context).size.width * 0.25,
//                        child: _indicator(segment),
//                      ),
//                      Container(
////                        alignment: Alignment.centerRight,
////                              width: MediaQuery.of(context).size.width * 0.25,
//                        child: Text(DateFormat('kk:mm').format(_arrival),
//                            style: TextStyle(
//                                fontSize: 26.0, fontWeight: FontWeight.w900)),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }