import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/sat_widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SatLogo(size: 140),
            const SizedBox(height: 24),
            Text(
              'SAT-PlantScan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'SolAgriTech',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
