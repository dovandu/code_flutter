```dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

class JumpIndex extends StatefulWidget {
  @override
  _JumpIndexState createState() => _JumpIndexState();
}

class _JumpIndexState extends State<JumpIndex> {
  final dynamic _keys = <dynamic, dynamic>{};

  @override
  Widget build(BuildContext context) {
    final GlobalKey listViewKey = RectGetter.createGlobalKey();
    final ScrollController _ctl = ScrollController();

    final RectGetter listView = RectGetter(
      key: listViewKey,
      child: ListView.builder(
        controller: _ctl,
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          _keys[index] = RectGetter.createGlobalKey();
          return RectGetter(
            key: _keys[index],
            child: Container(
              color: Colors.primaries[index % Colors.primaries.length],
              child: SizedBox(
                width: 100.0,
                height: 50.0 + ((27 * index) % 15) * 3.14,
                child: Center(
                  child: Text('$index'),
                ),
              ),
            ),
          );
        },
      ),
    );

    List<int> getVisible() {
      final Rect rect = RectGetter.getRectFromKey(listViewKey);
      final List<int> _items = <int>[];
      _keys.forEach((dynamic index, dynamic key) {
        final Rect itemRect = RectGetter.getRectFromKey(key);
        if (itemRect != null &&
            !(itemRect.top > rect.bottom || itemRect.bottom < rect.top))
          _items.add(index);
      });

      return _items;
    }

    void scrollLoop(int target, Rect listRect) {
      final int first = getVisible().first;
      final bool direction = first < target;
      Rect _rect;
      if (_keys.containsKey(target))
        _rect = RectGetter.getRectFromKey(_keys[target]);
      if (_rect == null ||
          (direction
              ? _rect.bottom < listRect.top
              : _rect.top > listRect.bottom)) {
        double offset = _ctl.offset +
            (direction ? listRect.height / 2 : -listRect.height / 2);
        offset = offset < 0.0 ? 0.0 : offset;
        offset = offset > _ctl.position.maxScrollExtent
            ? _ctl.position.maxScrollExtent
            : offset;
        _ctl.jumpTo(offset);
        Timer(Duration.zero, () {
          scrollLoop(target, listRect);
        });
        return;
      }

      _ctl.jumpTo(_ctl.offset + _rect.top - listRect.top);
    }

    void jumpTo(int target) {
      final List<int> visible = getVisible();
      if (visible.contains(target)) {
        return;
      }

      final Rect listRect = RectGetter.getRectFromKey(listViewKey);
      scrollLoop(target, listRect);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification notification) {
          getVisible();
          return true;
        },
        child: listView,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          /// ...
          final Random _random = Random();
          final int randNum = 1 + _random.nextInt(999 - 1);
          print('Jump to $randNum');
          jumpTo(randNum);
        },
      ),
    );
  }
}
````
