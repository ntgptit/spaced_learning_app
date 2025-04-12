// lib/presentation/mixins/view_model_refresher.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/navigation/route_observer.dart';

mixin ViewModelRefresher<T extends StatefulWidget> on State<T>
    implements RouteAware {
  final AppRouteObserver _routeObserver = AppRouteObserver();
  bool _isInitialized = false;

  // Có thể override để thực hiện refresh dữ liệu
  void refreshData() {
    // Được implement trong các class con
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
      // Registering with route observer when dependencies change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final route = ModalRoute.of(context);
        if (route != null) {
          _routeObserver.subscribe(this, route);
        }
      });
    }
  }

  @override
  void didPopNext() {
    // Được gọi khi quay lại màn hình này từ một màn hình khác
    refreshData();
  }

  @override
  void didPush() {
    // Được gọi khi màn hình được push vào stack
  }

  @override
  void didPop() {
    // Được gọi khi màn hình được pop khỏi stack
  }

  @override
  void didPushNext() {
    // Được gọi khi màn hình khác được push lên trên màn hình này
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }
}
