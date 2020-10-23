import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:money_tap_avadhesh/api_service.dart';
import 'package:money_tap_avadhesh/bloc_provider.dart';
import 'package:money_tap_avadhesh/data.dart';

class LiveListBloc implements BlocBase {
  ApiService apiService = ApiService();

  // ignore: close_sinks
  StreamController<DataModel> confirmListData =
      StreamController<DataModel>.broadcast();

  Stream<DataModel> get allList => confirmListData.stream;
  int loadCard = 0;
  DataModel dataModel = DataModel();

  fetchListData(BuildContext context, String text) async {

    this.apiService.getData(text).then((response) {
      try {
        if (response.statusCode == 200) {
          // print(list);
          dynamic rest = json.decode(response.body)["query"];
          List<dynamic> all = rest["pages"] as List;

          List<Data> notificationData;
          notificationData =
              all.map<Data>((json) => Data.fromJson(json)).toList();

          dataModel.list = notificationData;
          loadCard = 1;
        } else {
          loadCard = 2;
        }

        confirmListData.sink.add(dataModel);
      } catch (error) {
        print(error);
      }
    });
  }

  @override
  void dispose() {
    //Close the weather fetcher

    confirmListData.close();
  }
}
