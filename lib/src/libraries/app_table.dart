import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// List table backed by a module API endpoint.
/// Parses standard Perfex JSON response: {data: [...]} or plain List.
///
/// Usage:
/// ```dart
/// AppTable<Map>(
///   fetch: (page) => api<InspectionsApiService>((s) => s.list(page: page)),
///   row: (item) => InspectionCard(item),
/// )
/// ```
class AppTable<T> extends StatelessWidget {
  final Future<dynamic> Function(int page) fetch;
  final Widget Function(T item) row;
  final Widget empty;
  final Widget? header;
  final IndexedWidgetBuilder? separator;

  const AppTable({
    super.key,
    required this.fetch,
    required this.row,
    this.empty = const Center(child: Text('No records found')),
    this.header,
    this.separator,
  });

  List<T> _parse(dynamic response) {
    if (response == null) return [];
    if (response is List) return List<T>.from(response);
    if (response is Map) {
      final data = response['data'] ?? response['records'] ?? [];
      if (data is List) return List<T>.from(data);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (separator != null) {
      return CollectionView<T>.pullableSeparated(
        data: (page) async => _parse(await fetch(page)),
        builder: (_, item) => row(item.data),
        separatorBuilder: separator!,
        header: header,
        empty: empty,
      );
    }

    return CollectionView<T>.pullable(
      data: (page) async => _parse(await fetch(page)),
      builder: (_, item) => row(item.data),
      header: header,
      empty: empty,
    );
  }
}

/// Grid variant — for equipment, cards layout.
class AppTableGrid<T> extends StatelessWidget {
  final Future<dynamic> Function(int page) fetch;
  final Widget Function(T item) row;
  final Widget empty;
  final Widget? header;
  final int crossAxisCount;
  final double spacing;

  const AppTableGrid({
    super.key,
    required this.fetch,
    required this.row,
    this.empty = const Center(child: Text('No records found')),
    this.header,
    this.crossAxisCount = 2,
    this.spacing = 12,
  });

  List<T> _parse(dynamic response) {
    if (response == null) return [];
    if (response is List) return List<T>.from(response);
    if (response is Map) {
      final data = response['data'] ?? response['records'] ?? [];
      if (data is List) return List<T>.from(data);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return CollectionView<T>.pullableGrid(
      data: (page) async => _parse(await fetch(page)),
      builder: (_, item) => row(item.data),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      header: header,
      empty: empty,
    );
  }
}
