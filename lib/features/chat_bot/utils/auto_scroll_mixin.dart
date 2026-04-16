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

  void onIncomingContent() => scheduleScrollToBottom(smooth: true);

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
    unawaited(smoothScrollToBottom());
  }

  Future<void> smoothScrollToBottom() async {
    if (_smoothing || !_autoScroll || !scrollController.hasClients) {
      return;
    }

    _smoothing = true;
    try {
      final position = scrollController.position;
      final target = _bottomTarget(position);
      final distance = (position.pixels - target).abs();
      if (distance <= 0.5) {
        return;
      }

      final milliseconds = (distance / 2.6).round().clamp(220, 900);
      await scrollController.animateTo(
        target,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.easeOutCubic,
      );
    } finally {
      _smoothing = false;
    }
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
    final bottom = _bottomTargetFromMetrics(metrics);
    return (metrics.pixels - bottom).abs() <= 20.0;
  }

  Future<void> _doScroll({bool smooth = false}) async {
    if (!_autoScroll || !scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;
    final target = _bottomTarget(position);
    final distance = (position.pixels - target).abs();

    if (distance <= 0.5) {
      return;
    }

    if (smooth) {
      await smoothScrollToBottom();
      return;
    }

    scrollController.jumpTo(target);
  }

  double _bottomTarget(ScrollPosition position) {
    return 0.0
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
  }

  double _bottomTargetFromMetrics(ScrollMetrics metrics) {
    return 0.0
        .clamp(metrics.minScrollExtent, metrics.maxScrollExtent)
        .toDouble();
  }
}
