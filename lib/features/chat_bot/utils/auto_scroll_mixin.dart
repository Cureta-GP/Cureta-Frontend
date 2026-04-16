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
    final target = _bottomTarget(position);
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
        // Keep following the bottom while content grows (e.g. animated text).
        var attempts = 0;
        while (_autoScroll && scrollController.hasClients && attempts < 6) {
          final currentPosition = scrollController.position;
          final currentTarget = _bottomTarget(currentPosition);
          final currentDistance = (currentPosition.pixels - currentTarget)
              .abs();

          if (currentDistance <= 0.5) {
            break;
          }

          final milliseconds = (currentDistance / 1.2).round().clamp(220, 1500);
          await scrollController.animateTo(
            currentTarget,
            duration: Duration(milliseconds: milliseconds),
            curve: Curves.easeOutCubic,
          );

          attempts++;
          await WidgetsBinding.instance.endOfFrame;
        }

        // Final settle to the latest available bottom after all relayouts.
        if (_autoScroll && scrollController.hasClients) {
          final latestPosition = scrollController.position;
          final latestTarget = _bottomTarget(latestPosition);
          final latestDistance = (latestPosition.pixels - latestTarget).abs();
          if (latestDistance > 0.5) {
            await scrollController.animateTo(
              latestTarget,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
            );
          }
        }
      } finally {
        _smoothing = false;
      }
      return;
    }

    scrollController.jumpTo(target);
  }

  double _bottomTarget(ScrollPosition position) {
    return (position.axisDirection == AxisDirection.down
            ? position.maxScrollExtent
            : position.minScrollExtent)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
  }
}
