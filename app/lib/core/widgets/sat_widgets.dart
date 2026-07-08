import 'package:flutter/material.dart';

class SatLogo extends StatelessWidget {
  const SatLogo({super.key, this.size = 120, this.showTitle = false});

  final double size;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.2),
          child: Image.asset(
            'assets/logo/logo.jpg',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.eco, size: size, color: Colors.green),
          ),
        ),
        if (showTitle) ...[
          const SizedBox(height: 12),
          Text(
            'SAT-PlantScan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class ScoreBar extends StatelessWidget {
  const ScoreBar({super.key, required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label)),
              Text('${(value * 100).toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: value.clamp(0, 1)),
        ],
      ),
    );
  }
}
