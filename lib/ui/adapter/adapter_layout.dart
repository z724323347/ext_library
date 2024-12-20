// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

enum AdapterLayoutType {
  ROW,
  COLUMN,
}

/// A convenience wrapper for adapter [Row] and
/// [Column] switching with padding and spacing.
///
/// AdapterLayout combines adapter
/// behaviors for managing rows and columns into one
/// convenience widget. This widget requires all [children]
/// to be [AdapterLayoutItem] widgets.
/// Row vs column layout is controlled by passing a
/// [AdapterLayoutType] to [layoutType].
/// Add spacing between widgets with [rowSpacing] and
/// [columnSpacing]. Add padding around widgets with
/// [rowPadding] and [columnPadding].
///
/// See [AdapterLayoutItem] for [Flex] and
/// [FlexFit] options.
class AdapterLayout extends StatelessWidget {
  final List<AdapterLayoutItem> children;
  final AdapterLayoutType layoutType;
  final MainAxisAlignment rowMainAxisAlignment;
  final MainAxisSize rowMainAxisSize;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final TextDirection? rowTextDirection;
  final VerticalDirection rowVerticalDirection;
  final TextBaseline? rowTextBaseline;
  final MainAxisAlignment columnMainAxisAlignment;
  final MainAxisSize columnMainAxisSize;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final TextDirection? columnTextDirection;
  final VerticalDirection columnVerticalDirection;
  final TextBaseline? columnTextBaseline;
  final double? rowSpacing;
  final double? columnSpacing;
  final EdgeInsets rowPadding;
  final EdgeInsets columnPadding;
  get isRow => layoutType == AdapterLayoutType.ROW;
  get isColumn => layoutType == AdapterLayoutType.COLUMN;

  const AdapterLayout(
      {Key? key,
      this.children = const [],
      required this.layoutType,
      this.rowMainAxisAlignment = MainAxisAlignment.start,
      this.rowMainAxisSize = MainAxisSize.max,
      this.rowCrossAxisAlignment = CrossAxisAlignment.center,
      this.rowTextDirection,
      this.rowVerticalDirection = VerticalDirection.down,
      this.rowTextBaseline,
      this.columnMainAxisAlignment = MainAxisAlignment.start,
      this.columnMainAxisSize = MainAxisSize.max,
      this.columnCrossAxisAlignment = CrossAxisAlignment.center,
      this.columnTextDirection,
      this.columnVerticalDirection = VerticalDirection.down,
      this.columnTextBaseline,
      this.rowSpacing,
      this.columnSpacing,
      this.rowPadding = EdgeInsets.zero,
      this.columnPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (layoutType == AdapterLayoutType.ROW) {
      return Padding(
        padding: rowPadding,
        child: Row(
          mainAxisAlignment: rowMainAxisAlignment,
          mainAxisSize: rowMainAxisSize,
          crossAxisAlignment: rowCrossAxisAlignment,
          textDirection: rowTextDirection,
          verticalDirection: rowVerticalDirection,
          textBaseline: rowTextBaseline,
          children: [
            ...buildChildren(children, true, rowSpacing),
          ],
        ),
      );
    }

    return Padding(
      padding: columnPadding,
      child: Column(
        mainAxisAlignment: columnMainAxisAlignment,
        mainAxisSize: columnMainAxisSize,
        crossAxisAlignment: columnCrossAxisAlignment,
        textDirection: columnTextDirection,
        verticalDirection: columnVerticalDirection,
        textBaseline: columnTextBaseline,
        children: [
          ...buildChildren(children, false, columnSpacing),
        ],
      ),
    );
  }

  /// Logic to construct widget [children].
  List<Widget> buildChildren(
      List<AdapterLayoutItem> children, bool rowColumn, double? spacing) {
    // Sort AdapterLayoutItems by their order.
    List<AdapterLayoutItem> childrenHolder = [];
    childrenHolder.addAll(children);
    childrenHolder.sort((a, b) {
      if (rowColumn) {
        return a.rowOrder.compareTo(b.rowOrder);
      } else {
        return a.columnOrder.compareTo(b.columnOrder);
      }
    });
    // Add padding between widgets..
    List<Widget> widgetList = [];
    for (int i = 0; i < childrenHolder.length; i++) {
      widgetList.add(childrenHolder[i].copyWith(rowColumn: rowColumn));
      if (spacing != null && i != childrenHolder.length - 1) {
        widgetList.add(Padding(
            padding: rowColumn
                ? EdgeInsets.only(right: spacing)
                : EdgeInsets.only(bottom: spacing)));
      }
    }
    return widgetList;
  }
}

/// A wrapper for [AdapterLayout] children with
/// adapter.
///
/// Control the order of widgets within [AdapterLayout]
/// by assigning a [rowOrder] or [columnOrder] value.
/// Widgets without an order value are ranked behind
/// those with order values.
/// Set a widget's [Flex] value through [rowFlex] and
/// [columnFlex]. Set a widget's [FlexFit] through
/// [rowFit] and [columnFit].
class AdapterLayoutItem extends StatelessWidget {
  final Widget child;
  final int rowOrder;
  final int columnOrder;
  final bool rowColumn;
  final int? rowFlex;
  final int? columnFlex;
  final FlexFit? rowFit;
  final FlexFit? columnFit;

  const AdapterLayoutItem(
      {Key? key,
      required this.child,
      this.rowOrder = 1073741823,
      this.columnOrder = 1073741823,
      this.rowColumn = true,
      this.rowFlex,
      this.columnFlex,
      this.rowFit,
      this.columnFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rowColumn && (rowFlex != null || rowFit != null)) {
      return Flexible(
          flex: rowFlex ?? 1, fit: rowFit ?? FlexFit.loose, child: child);
    } else if (!rowColumn && (columnFlex != null || columnFit != null)) {
      return Flexible(
          flex: columnFlex ?? 1, fit: columnFit ?? FlexFit.loose, child: child);
    }

    return child;
  }

  AdapterLayoutItem copyWith({
    int? rowOrder,
    int? columnOrder,
    bool? rowColumn,
    int? rowFlex,
    int? columnFlex,
    FlexFit? rowFlexFit,
    FlexFit? columnFlexFit,
    Widget? child,
  }) =>
      AdapterLayoutItem(
        rowOrder: rowOrder ?? this.rowOrder,
        columnOrder: columnOrder ?? this.columnOrder,
        rowColumn: rowColumn ?? this.rowColumn,
        rowFlex: rowFlex ?? this.rowFlex,
        columnFlex: columnFlex ?? this.columnFlex,
        rowFit: rowFlexFit ?? rowFit,
        columnFit: columnFlexFit ?? columnFit,
        child: child ?? this.child,
      );
}
