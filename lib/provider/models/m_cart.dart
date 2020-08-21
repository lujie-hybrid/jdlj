import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdlj/components/storage.dart';
import 'package:jdlj/model/detail_entity.dart';

class MCart with ChangeNotifier {
  List<DetailResult> _cartList = [];

  List<DetailResult> _selectedList = [];

  List<DetailResult> get cartList => _cartList;

  List<DetailResult> get selectedList => _selectedList;

  int _count = 0;

  int get count => _count;

  double _allPrice = 0;

  double get allPrice => _allPrice;

  init() async {
    String value = await JdStorage.getStorage("cartList");
    if (value.isNotEmpty) {
      List list = json.decode(value);
      _cartList = list.map((e) {
        DetailResult dr = new DetailResult();
        dr.fromJson(e);
        dr.selected = false;
        return dr;
      }).toList();
    } else {
      _cartList = [];
    }
    _count = _cartList.length;
    notifyListeners();
  }

  MCart() {
    this.init();
  }

  clearCart() {
    JdStorage.remove("cartList").then((value) {
      _cartList = [];
      _count = _cartList.length;
      notifyListeners();
    });
  }

  addToCart(DetailResult val, int c, String selectMsg) {
    DetailResult value = new DetailResult();
    value.fromJson(val.toJson());
    value.count = value.count ?? 0;
    print("_cartList.length${value.price}");
    if (_cartList.length == 0) {
      value.selectedAttr = selectMsg;
      value.selected = false;
      value.count += c;
      _cartList.add(value);
    } else {
      DetailResult dr = _cartList.firstWhere(
        (element) => value.sId == element.sId,
        orElse: () => null,
      );
      if (dr == null || dr != null && dr.selectedAttr != selectMsg) {
        value.selectedAttr = selectMsg;
        value.selected = false;
        value.count += c;
        _cartList.add(value);
      } else {
        dr.count += c;
      }
    }
    _count = _cartList.length;
    JdStorage.setStorage("cartList", json.encode(_cartList));

    notifyListeners();
  }

  computeAllPrice() {
    double allPrice = 0;
    if (_cartList.length > 0) {
      _cartList.forEach((element) {
        if (element.selected) {
          allPrice += double.parse(element.price) * element.count;
        }
      });
    }
    _allPrice = allPrice;
    JdStorage.setStorage("allPrice", _allPrice.toString());
    notifyListeners();
  }

  void getSelectedCart() {
    List<DetailResult> l = [];
    if (_cartList.length > 0) {
      l = _cartList.where((element) => element.selected).toList();
    }
    _selectedList = l;
    notifyListeners();
  }

  deleteSelectCart() {
    List<DetailResult> l = [];
    if (_cartList.length > 0) {
      l = _cartList.where((element) => !element.selected).toList();
    }
    _cartList = l;
    _count = _cartList.length;
    JdStorage.setStorage("cartList", json.encode(l));
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
