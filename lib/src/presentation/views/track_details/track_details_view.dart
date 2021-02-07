import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarbus2021/src/model/database/database_helper.dart';
import 'package:tarbus2021/src/model/entity/departure.dart';
import 'package:tarbus2021/src/model/entity/track.dart';
import 'package:tarbus2021/src/presentation/custom_widgets/appbar_title.dart';
import 'package:tarbus2021/src/presentation/views/track_details/track_details_item.dart';

class TrackDetailsView extends StatelessWidget {
  final Track track;
  final int busStopId;

  const TrackDetailsView({Key key, this.track, this.busStopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentIndex = -2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [AppBarTitle(title: 'Trasa wybranego odjazdu')],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder<List<Departure>>(
          future: DatabaseHelper.instance.getDeparturesByTrackId(track.id),
          builder: (BuildContext context, AsyncSnapshot<List<Departure>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var departure = snapshot.data[index];
                  var parsedIndex = index;
                  if (busStopId == departure.busStop.id) {
                    currentIndex = index;
                  }
                  if (index == (snapshot.data.length - 1)) {
                    parsedIndex = -1;
                  }

                  return TrackDetailsItemView(departure: departure, index: parsedIndex, currentIndex: currentIndex);
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}