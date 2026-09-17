// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derives the home dashboard's view-model from the persisted [UserProfile].
/// Returns null while there is no profile yet (the router redirects to
/// onboarding in that case, so this is mostly defensive).

@ProviderFor(homeDashboard)
final homeDashboardProvider = HomeDashboardProvider._();

/// Derives the home dashboard's view-model from the persisted [UserProfile].
/// Returns null while there is no profile yet (the router redirects to
/// onboarding in that case, so this is mostly defensive).

final class HomeDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeDashboardView?>,
          HomeDashboardView?,
          FutureOr<HomeDashboardView?>
        >
    with
        $FutureModifier<HomeDashboardView?>,
        $FutureProvider<HomeDashboardView?> {
  /// Derives the home dashboard's view-model from the persisted [UserProfile].
  /// Returns null while there is no profile yet (the router redirects to
  /// onboarding in that case, so this is mostly defensive).
  HomeDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardHash();

  @$internal
  @override
  $FutureProviderElement<HomeDashboardView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeDashboardView?> create(Ref ref) {
    return homeDashboard(ref);
  }
}

String _$homeDashboardHash() => r'b73a7acaf0c773e0f1ac71baa5f5e55eb2537c2b';
