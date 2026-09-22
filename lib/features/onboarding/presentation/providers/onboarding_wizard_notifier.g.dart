// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_wizard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingWizardNotifier)
final onboardingWizardProvider = OnboardingWizardNotifierProvider._();

final class OnboardingWizardNotifierProvider
    extends $NotifierProvider<OnboardingWizardNotifier, OnboardingWizardState> {
  OnboardingWizardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingWizardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingWizardNotifierHash();

  @$internal
  @override
  OnboardingWizardNotifier create() => OnboardingWizardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingWizardState>(value),
    );
  }
}

String _$onboardingWizardNotifierHash() =>
    r'ea87b45c0fc8451a61808ff9e4c12a88390ce05c';

abstract class _$OnboardingWizardNotifier
    extends $Notifier<OnboardingWizardState> {
  OnboardingWizardState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingWizardState, OnboardingWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingWizardState, OnboardingWizardState>,
              OnboardingWizardState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
