import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_diary_date_provider.g.dart';

/// Which date the Diary screen is currently showing. Defaults to today and
/// is always kept day-only normalized.
@riverpod
class SelectedDiaryDate extends _$SelectedDiaryDate {
  @override
  DateTime build() => DateUtils.dateOnly(DateTime.now());

  void select(DateTime date) => state = DateUtils.dateOnly(date);
}
