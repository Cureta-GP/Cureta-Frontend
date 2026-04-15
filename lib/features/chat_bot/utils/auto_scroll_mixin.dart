import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin AutoScrollMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  bool _autoScroll = true;
  bool _scheduled = false;
  bool _smoothing = false;
  bool _scrolledAway = false;

  bool get isUserScrolledAway => _scrolledAway;

  void disposeAutoScroll() => scrollController.dispose();

  void onIncomingContent() => scheduleScrollToBottom();

  void enableAutoScroll() {
    _autoScroll = true;
    _setScrolledAway(false);
  }

  bool handleScrollNotification(ScrollNotification notification) {
    final atBottom = _isNearBottom(notification.metrics);

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) {
        if (atBottom) {
          _autoScroll = true;
          _setScrolledAway(false);
        }
      } else {
        _autoScroll = atBottom;
        _setScrolledAway(!atBottom);
      }
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.dragDetails != null) {
        _autoScroll = atBottom;
        _setScrolledAway(!atBottom);
      }

      if (atBottom) {
        _autoScroll = true;
        _setScrolledAway(false);
      }
    }

    if (notification is ScrollEndNotification && atBottom) {
      _autoScroll = true;
      _setScrolledAway(false);
    }

    return false;
  }

  void jumpToBottom() {
    if (!scrollController.hasClients) {
      return;
    }

    _autoScroll = true;
    _setScrolledAway(false);
    unawaited(_doScroll(smooth: true));
  }

  void scheduleScrollToBottom({bool smooth = false}) {
    if (!_autoScroll || _scheduled) {
      return;
    }

    if (smooth && _smoothing) {
      return;
    }

    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) {
        return;
      }

      if (!smooth && _smoothing) {
        return;
      }

      unawaited(_doScroll(smooth: smooth));
    });
  }

  void _setScrolledAway(bool value) {
    if (_scrolledAway == value) {
      return;
    }

    _scrolledAway = value;
    if (mounted) {
      setState(() {});
    }
  }

  bool _isNearBottom(ScrollMetrics metrics) {
    final bottom = metrics.axisDirection == AxisDirection.down
        ? metrics.maxScrollExtent
        : metrics.minScrollExtent;
    return (metrics.pixels - bottom).abs() <= 20.0;
  }

  Future<void> _doScroll({bool smooth = false}) async {
    if (!_autoScroll || !scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;
    final target =
        (position.axisDirection == AxisDirection.down
                ? position.maxScrollExtent
                : position.minScrollExtent)
            .clamp(position.minScrollExtent, position.maxScrollExtent);
    final distance = (position.pixels - target).abs();

    if (distance <= 0.5) {
      return;
    }

    if (smooth) {
      if (_smoothing) {
        return;
      }

      _smoothing = true;
      try {
        final milliseconds = (distance / 1.2).round().clamp(260, 2200);
        await scrollController.animateTo(
          target,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.easeOutCubic,
        );
      } finally {
        _smoothing = false;
      }
      return;
    }

    scrollController.jumpTo(target);
  }
}
