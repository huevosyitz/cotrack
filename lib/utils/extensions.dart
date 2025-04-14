import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

extension QueryStateUtil<T> on QueryState<T> {
  bool get isLoading => status == QueryStatus.loading;
  bool get isError => status == QueryStatus.error;
  bool get isSuccess => status == QueryStatus.success;
  bool get isInitial => status == QueryStatus.initial;
}

extension MutationStateUtil<T> on MutationState<T> {
  bool get isLoading => status == QueryStatus.loading;
  bool get isError => status == QueryStatus.error;
  bool get isSuccess => status == QueryStatus.success;
  bool get isInitial => status == QueryStatus.initial;
}

String generateUuid() {
  return _uuid.v4();
}

bool isValidUuid(String uuid) {
  final regex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
  return regex.hasMatch(uuid);
}
