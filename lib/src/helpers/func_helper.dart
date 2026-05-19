
/// PHP: app_sort_by_position($array)
List<Map<String, dynamic>> appSortByPosition(
    List<Map<String, dynamic>> items) {
  final copy = List<Map<String, dynamic>>.from(items);
  copy.sort((a, b) {
    final pa = (a['position'] as num?) ?? 99;
    final pb = (b['position'] as num?) ?? 99;
    return pa.compareTo(pb);
  });
  return copy;
}

/// PHP: strip_html_tags($str)
String stripHtmlTags(String str) =>
    str.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
