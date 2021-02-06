import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarbus2021/src/app/app_dimens.dart';
import 'package:tarbus2021/src/app/app_string.dart';
import 'package:tarbus2021/src/model/entity/bus_stop.dart';
import 'package:tarbus2021/src/presentation/custom_widgets/appbar_title.dart';
import 'package:tarbus2021/src/presentation/custom_widgets/snackbar_button.dart';
import 'package:tarbus2021/src/presentation/views/search/search_item.dart';

import 'controller/search_view_controller.dart';

class SearchView extends StatefulWidget {
  static const route = '/search';
  @override
  _SearchBusStopViewState createState() => _SearchBusStopViewState();
}

class _SearchBusStopViewState extends State<SearchView> {
  final SearchViewController viewController = SearchViewController();

  @override
  void dispose() {
    viewController.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            SnackbarButton(action: () {
              Scaffold.of(context).openDrawer();
            }),
            AppBarTitle(title: AppString.labelSearch)
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (viewController.searchStatus) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.margin_view_horizontally),
          child: FutureBuilder<List<BusStop>>(
            future: viewController.getSearchedBusStops(viewController.searchValue),
            builder: (BuildContext context, AsyncSnapshot<List<BusStop>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var busStop = snapshot.data[index];
                    return SearchItem(busStop: busStop);
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          AppString.labelStartWriteToSearch,
          maxLines: 2,
        ),
      );
    }
  }
}
