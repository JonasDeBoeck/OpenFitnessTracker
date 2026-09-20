// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_diary_date_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which date the Diary screen is currently showing. Defaults to today and
/// is always kept day-only normalized.

@ProviderFor(SelectedDiaryDate)
final selectedDiaryDateProvider = SelectedDiaryDateProvider._();

/// Which date the Diary screen is currently showing. Defaults to today and
/// is always kept day-only normalized.
final class SelectedDiaryDateProvider
    extends $NotifierProvider<SelectedDiaryDate, DateTime> {
  /// Which date the Diary screen is currently showing. Defaults to today and
  /// is always kept day-only normalized.
  SelectedDiaryDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDiaryDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDiaryDateHash();

  @$internal
  @override
  SelectedDiaryDate create() => SelectedDiaryDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedDiaryDateHash() => r'6bd3a4e11095b53911d299047eba6f40a2b9e141';

/// Which date the Diary screen is currently showing. Defaults to today and
/// is always kept day-only normalized.

abstract class _$SelectedDiaryDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
