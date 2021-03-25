import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(App());
}

class App extends HookWidget {
  Color getRandomColor() {
    final Random random = Random();
    return Colors.primaries[random.nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = useState(getRandomColor());
    final visible = useState(true);
    final timeOut = Future.delayed(const Duration(milliseconds: 1000));
    void clickHandler() {
      activeColor.value = getRandomColor();
      visible.value = false;
    }

    useEffect(() {
      final resetOpacity = timeOut.asStream().listen((_) {
        visible.value = true;
      });

      return resetOpacity.cancel;
    }, [visible.value]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solid App',
      home: Scaffold(
        body: GestureDetector(
          onTap: () => clickHandler(),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 2500,
            ),
            decoration: BoxDecoration(
              color: activeColor.value,
            ),
            curve: Curves.fastOutSlowIn,
            child: Center(
              child: AnimatedOpacity(
                curve: Curves.fastOutSlowIn,
                opacity: visible.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Hey there',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
