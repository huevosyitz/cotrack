import 'package:cached_query_flutter/cached_query_flutter.dart';

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
