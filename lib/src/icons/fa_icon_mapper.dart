import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Maps Perfex Font Awesome class strings to Flutter FaIcon widgets.
///
/// Usage:
/// ```dart
/// final icon = FaIconMapper.fromClass('fa-solid fa-file-invoice');
/// ```
class FaIconMapper {
  FaIconMapper._();

  /// Convert a Perfex FA class string to a [FaIcon] widget.
  static Widget fromClass(String faClass, {double size = 20, Color? color}) {
    final name = _extract(faClass);
    switch (name) {
      case 'fa-file-invoice':         return FaIcon(FontAwesomeIcons.fileInvoice, size: size, color: color);
      case 'fa-file-lines':           return FaIcon(FontAwesomeIcons.fileLines, size: size, color: color);
      case 'fa-file-invoice-dollar':  return FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: size, color: color);
      case 'fa-money-bill-transfer':  return FaIcon(FontAwesomeIcons.moneyBillTransfer, size: size, color: color);
      case 'fa-diagram-project':      return FaIcon(FontAwesomeIcons.diagramProject, size: size, color: color);
      case 'fa-toolbox':              return FaIcon(FontAwesomeIcons.toolbox, size: size, color: color);
      case 'fa-hard-hat':             return FaIcon(FontAwesomeIcons.helmetSafety, size: size, color: color);
      case 'fa-building':             return FaIcon(FontAwesomeIcons.building, size: size, color: color);
      case 'fa-magnifying-glass':     return FaIcon(FontAwesomeIcons.magnifyingGlass, size: size, color: color);
      case 'fa-search':               return FaIcon(FontAwesomeIcons.magnifyingGlass, size: size, color: color);
      case 'fa-receipt':              return FaIcon(FontAwesomeIcons.receipt, size: size, color: color);
      case 'fa-file-circle-question': return FaIcon(FontAwesomeIcons.fileCircleQuestion, size: size, color: color);
      case 'fa-shopping-cart':        return FaIcon(FontAwesomeIcons.cartShopping, size: size, color: color);
      case 'fa-users':                return FaIcon(FontAwesomeIcons.users, size: size, color: color);
      case 'fa-user':                 return FaIcon(FontAwesomeIcons.user, size: size, color: color);
      case 'fa-chart-bar':            return FaIcon(FontAwesomeIcons.chartBar, size: size, color: color);
      case 'fa-gear':                 return FaIcon(FontAwesomeIcons.gear, size: size, color: color);
      case 'fa-bell':                 return FaIcon(FontAwesomeIcons.bell, size: size, color: color);
      case 'fa-file-text':            return FaIcon(FontAwesomeIcons.fileLines, size: size, color: color);
      case 'fa-wrench':               return FaIcon(FontAwesomeIcons.wrench, size: size, color: color);
      default:                        return FaIcon(FontAwesomeIcons.circle, size: size, color: color);
    }
  }

  static String _extract(String faClass) {
    return faClass
        .split(' ')
        .where((p) =>
            p.startsWith('fa-') &&
            p != 'fa-solid' &&
            p != 'fa-regular' &&
            p != 'fa-brands' &&
            p != 'fa-light')
        .lastOrNull ?? '';
  }
}
