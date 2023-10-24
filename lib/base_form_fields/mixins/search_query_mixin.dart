mixin SearchQueryMixin {
  String? _searchString;
  String? get searchString => _searchString;

  void prepareSearch(List<String> fields) {
    _searchString = fields.join('').toLowerCase();
  }

  bool isMatchingSearch(String? searchFor) {
    if (searchFor == null || searchFor.isEmpty) return true;
    var words = searchFor.toLowerCase().split(RegExp(r'\s+'));
    for (var w in words) {
      if (_searchString!.contains(w.trim()) == true) {
        return true;
      }
    }
    return false;
  }
}
