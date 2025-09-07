enum ListType { watching, completed, pending }

extension ListTypeExtension on ListType {
  int toInt() {
    switch (this) {
      case ListType.watching:
        return 0;
      case ListType.completed:
        return 1;
      case ListType.pending:
        return 2;
    }
  }

  static ListType fromInt(int value) {
    switch (value) {
      case 0:
        return ListType.watching;
      case 1:
        return ListType.completed;
      case 2:
      default:
        return ListType.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ListType.watching:
        return "watching";
      case ListType.completed:
        return "completed";
      case ListType.pending:
        return "pending";
    }
  }
}