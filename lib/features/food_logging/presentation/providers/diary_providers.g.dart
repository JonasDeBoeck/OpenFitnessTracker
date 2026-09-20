// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryEntriesForDate)
final diaryEntriesForDateProvider = DiaryEntriesForDateFamily._();

final class DiaryEntriesForDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiaryEntry>>,
          List<DiaryEntry>,
          FutureOr<List<DiaryEntry>>
        >
    with $FutureModifier<List<DiaryEntry>>, $FutureProvider<List<DiaryEntry>> {
  DiaryEntriesForDateProvider._({
    required DiaryEntriesForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'diaryEntriesForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryEntriesForDateHash();

  @override
  String toString() {
    return r'diaryEntriesForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DiaryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiaryEntry>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return diaryEntriesForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiaryEntriesForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryEntriesForDateHash() =>
    r'8c207a53b2c66f5162e9d6a0d63f5ebacaab4993';

final class DiaryEntriesForDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DiaryEntry>>, DateTime> {
  DiaryEntriesForDateFamily._()
    : super(
        retry: null,
        name: r'diaryEntriesForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiaryEntriesForDateProvider call(DateTime date) =>
      DiaryEntriesForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'diaryEntriesForDateProvider';
}

/// Logs a food (with its snapshotted nutrition at the given quantity) to a
/// meal for today. This is the one place a diary entry gets written from
/// the Food Detail screen — Add Product writes its own via
/// [AddProductNotifier] when "log to a meal" is on.

@ProviderFor(LogFoodNotifier)
final logFoodProvider = LogFoodNotifierProvider._();

/// Logs a food (with its snapshotted nutrition at the given quantity) to a
/// meal for today. This is the one place a diary entry gets written from
/// the Food Detail screen — Add Product writes its own via
/// [AddProductNotifier] when "log to a meal" is on.
final class LogFoodNotifierProvider
    extends $AsyncNotifierProvider<LogFoodNotifier, void> {
  /// Logs a food (with its snapshotted nutrition at the given quantity) to a
  /// meal for today. This is the one place a diary entry gets written from
  /// the Food Detail screen — Add Product writes its own via
  /// [AddProductNotifier] when "log to a meal" is on.
  LogFoodNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logFoodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logFoodNotifierHash();

  @$internal
  @override
  LogFoodNotifier create() => LogFoodNotifier();
}

String _$logFoodNotifierHash() => r'5fdf28d4e3b967f77774257615a9f7c5ab7abd24';

/// Logs a food (with its snapshotted nutrition at the given quantity) to a
/// meal for today. This is the one place a diary entry gets written from
/// the Food Detail screen — Add Product writes its own via
/// [AddProductNotifier] when "log to a meal" is on.

abstract class _$LogFoodNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// [LogFoodNotifier]'s recipe counterpart — the one place a diary entry
/// gets written from the Recipe Detail screen.

@ProviderFor(LogRecipeNotifier)
final logRecipeProvider = LogRecipeNotifierProvider._();

/// [LogFoodNotifier]'s recipe counterpart — the one place a diary entry
/// gets written from the Recipe Detail screen.
final class LogRecipeNotifierProvider
    extends $AsyncNotifierProvider<LogRecipeNotifier, void> {
  /// [LogFoodNotifier]'s recipe counterpart — the one place a diary entry
  /// gets written from the Recipe Detail screen.
  LogRecipeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logRecipeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logRecipeNotifierHash();

  @$internal
  @override
  LogRecipeNotifier create() => LogRecipeNotifier();
}

String _$logRecipeNotifierHash() => r'e982de6d2849cad7b499eae0b536ed4a9d51376f';

/// [LogFoodNotifier]'s recipe counterpart — the one place a diary entry
/// gets written from the Recipe Detail screen.

abstract class _$LogRecipeNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Deletes and edits already-logged diary entries (the Goals/Diary screens'
/// swipe-to-delete and tap-to-edit-quantity flows). `keepAlive` because
/// nothing watches this provider's own state — an autoDispose notifier with
/// no listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.

@ProviderFor(DiaryEntryController)
final diaryEntryControllerProvider = DiaryEntryControllerProvider._();

/// Deletes and edits already-logged diary entries (the Goals/Diary screens'
/// swipe-to-delete and tap-to-edit-quantity flows). `keepAlive` because
/// nothing watches this provider's own state — an autoDispose notifier with
/// no listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.
final class DiaryEntryControllerProvider
    extends $AsyncNotifierProvider<DiaryEntryController, void> {
  /// Deletes and edits already-logged diary entries (the Goals/Diary screens'
  /// swipe-to-delete and tap-to-edit-quantity flows). `keepAlive` because
  /// nothing watches this provider's own state — an autoDispose notifier with
  /// no listener can be torn down mid-`await` here, silently dropping the
  /// invalidation that follows.
  DiaryEntryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryEntryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryEntryControllerHash();

  @$internal
  @override
  DiaryEntryController create() => DiaryEntryController();
}

String _$diaryEntryControllerHash() =>
    r'b3b7d5e76f4dfd333d2b890311d0921afa415eaf';

/// Deletes and edits already-logged diary entries (the Goals/Diary screens'
/// swipe-to-delete and tap-to-edit-quantity flows). `keepAlive` because
/// nothing watches this provider's own state — an autoDispose notifier with
/// no listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.

abstract class _$DiaryEntryController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
