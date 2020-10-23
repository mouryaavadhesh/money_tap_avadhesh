import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:money_tap_avadhesh/api_service.dart';
import 'package:money_tap_avadhesh/data.dart';
import 'package:money_tap_avadhesh/list_bloc.dart';

class LiveMarket extends StatefulWidget {
  LiveMarket();

  @override
  _LiveMarketState createState() => _LiveMarketState();
}

class _LiveMarketState extends State<LiveMarket> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  List<Data> listData = List<Data>();
  LiveListBloc liveListBloc = new LiveListBloc();
  TextEditingController editingController = TextEditingController();
  ApiService apiService = ApiService();

  @override
  void initState() {

    super.initState();
    liveListBloc.loadCard=3;
  }

  @override
  void dispose() {
    liveListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: 1.0, style: BorderStyle.solid),
            )),
            child: Text(
              'Money Tap Test',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: apiService.connectionStatus == true
          ? StreamBuilder(
              stream: liveListBloc.allList,
              builder:
                  (BuildContext context, AsyncSnapshot<DataModel> snapshot) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          liveListBloc.loadCard = 0;
                          if (value.length == 0) {
                            liveListBloc.fetchListData(context, 'A');
                          } else {
                            liveListBloc.fetchListData(
                                context, editingController.text);
                          }
                        },
                        controller: editingController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                    Expanded(child: getLoadList(snapshot)),
                  ],
                );
              },
            )
          : Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        color: Colors.white,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          'Oops! Something went wrong!',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 0,
                              color: Colors.blue),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Aw snap!Looks like system are slow \nat this time or something may be wrong\nwith your internet connection.Please try\nagain later 😞',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 0,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    if (apiService.connectionStatus == true) {
                      liveListBloc.fetchListData(context, 'A');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: width - 40,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        'Try again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, letterSpacing: 0, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget getLoadList(AsyncSnapshot<DataModel> snapshot) {
    if (snapshot.data != null) {
      listData = snapshot.data.list;
    }
    if (liveListBloc.loadCard == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 3,
            ),
          ),
          Text(
            "Please wait...",
            textAlign: TextAlign.center,
            softWrap: true,
          )
        ],
      );
    } else if (liveListBloc.loadCard == 1) {
      return ListView.builder(
          // padding: const EdgeInsets.all(5.0),
          // The itemBuilder callback is called once per suggested word pairing,
          // and places each suggestion into a ListTile row.
          // For even rows, the function adds a ListTile row for the word pairing.
          // For odd rows, the function adds a Divider widget to visually
          // separate the entries. Note that the divider may be difficult
          // to see on smaller devices.

          shrinkWrap: true,
          itemCount: listData.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            // Add a one-pixel-high divider widget before each row in theListView.
            return InkWell(
              onTap: () {
                FlutterWebBrowser.openWebPage(
                    url: 'https://en.wikipedia.org/wiki?curid=' +
                        listData[i].pageid.toString(),
                    androidToolbarColor: Colors.blue);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                      color: Colors.grey, width: 0.5, style: BorderStyle.solid),
                )),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      listData[i].thumbnail != null
                          ? Image.network(
                              listData[i].thumbnail.source,
                              width: 50,
                              height: 50,
                            )
                          : Image.asset(
                              'assets/picture.png',
                              width: 50,
                              height: 50,
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          listData[i].title,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: Colors.blue, size: 25),
                        onPressed: () {
                          FlutterWebBrowser.openWebPage(
                              url: 'https://en.wikipedia.org/wiki?curid=' +
                                  listData[i].pageid.toString(),
                              androidToolbarColor: Colors.blue);
                        },
                      )
                    ]),
              ),
            );
          });
    } else if (liveListBloc.loadCard == 2) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //         <--- border radius here
              ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Text(
                  "No Search Result.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 16, height: 1.5, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (liveListBloc.loadCard == 3) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //         <--- border radius here
              ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Text(
                  "Search query to see result from wikipedia.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 16, height: 1.5, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      );
    } else
      return Container();
  }
}
