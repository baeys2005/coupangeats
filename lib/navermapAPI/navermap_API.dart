import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NavermapApi extends StatelessWidget {
  const NavermapApi({super.key});

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController>mapControllerCompleter = Completer();

    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller)async{
            mapControllerCompleter.complete(controller);
            log("onMapReady", name: "onMapReady");
          },
        ),
      ),
    );
  }
}
