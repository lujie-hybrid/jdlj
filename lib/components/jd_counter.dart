import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void CounterChangeCallback(num value);

class JdCounter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  JdCounter({
    Key key,
    @required num initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.decimalPlaces,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  final num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  final Color color;

  /// text syle
  final TextStyle textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: GestureDetector(
              child: Container(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: buttonSize * 2 / 3,
                ),
                decoration: BoxDecoration(
                    color: color ?? Color.fromRGBO(0, 0, 0, 0.15)),
              ),
              onTap: _decrementCounter,
            ),
          ),
          new Container(
            padding: EdgeInsets.all(4.0),
            child: new Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle),
          ),
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: GestureDetector(
              child: Container(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: buttonSize * 2 / 3,
                ),
                decoration: BoxDecoration(
                    color: color ?? Color.fromRGBO(0, 0, 0, 0.15)),
              ),
              onTap: _incrementCounter,
            ),
          ),
        ],
      ),
    );
  }
}
