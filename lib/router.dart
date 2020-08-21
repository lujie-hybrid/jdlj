/*
 * @author: lujie
 * @Date: 2020-07-28 15:21:10
 * @LastEditTime: 2020-08-21 16:43:27
 * @FilePath: \jdlj\lib\router.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/pages/address/address_add.dart';
import 'package:jdlj/pages/address/address_list.dart';
import 'package:jdlj/pages/balance.dart';
import 'package:jdlj/pages/login.dart';
import 'package:jdlj/pages/order.dart';
import 'package:jdlj/pages/pay.dart';
import 'package:jdlj/pages/product_detail.dart';
import 'package:jdlj/pages/product_list.dart';
import 'package:jdlj/pages/register_first.dart';
import 'package:jdlj/pages/register_over.dart';
import 'package:jdlj/pages/register_second.dart';
import 'package:jdlj/pages/search.dart';
import 'tabs/tab.dart';

var routers = {
  "/": (context, {Map arg}) => JdTab(arg: arg),
  "/prolist": (context, {Map arg}) => JdProductList(
        arg: arg,
      ),
  "/search": (context) => JdSearch(),
  "/prodetail": (context, {Map arg}) => JdProDetail(arg: arg),
  "/login": (context) => JdLogin(),
  "/registerfirst": (context) => RegisterFirst(),
  "/registersecond": (context, {Map arg}) => JdRegisterSecond(arg: arg),
  "/registerover": (context, {Map arg}) => JdRegisterOver(arg: arg),
  "/balance": (context) => JdBalance(),
  "/addresslist": (context) => JdAddressList(),
  "/addressadd": (context, {Map arg}) => JdAddressAdd(arg: arg),
  "/pay": (context) => JdPay(),
  "/order": (context, {Map arg}) => JdOrder(arg: arg),
};

Route onGenerateRoute(RouteSettings settings) {
  final String name = settings.name;
  final Function pageBuilder = routers[name];
  Route route;
  if (pageBuilder != null) {
    if (settings.arguments != null) {
      route = MaterialPageRoute(
          builder: (context) => pageBuilder(context, arg: settings.arguments));
    } else {
      route = MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
  }
  return route;
}
