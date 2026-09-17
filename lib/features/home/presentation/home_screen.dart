import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/onboarding.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Open Fitness Tracker')),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Could not load your profile: $error')),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('No profile yet.'));
            }
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${profile.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  Text('Target calories: ${profile.targetCalories.toStringAsFixed(0)} kcal'),
                  Text('Protein: ${profile.proteinGrams.toStringAsFixed(1)} g'),
                  Text('Fat: ${profile.fatGrams.toStringAsFixed(1)} g'),
                  Text('Carbs: ${profile.carbGrams.toStringAsFixed(1)} g'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
