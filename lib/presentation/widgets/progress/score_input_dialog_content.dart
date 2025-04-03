import 'package:flutter/material.dart';

/// Dialog content for inputting test scores
class ScoreInputDialogContent extends StatelessWidget {
  final double currentScore;
  final TextEditingController controller;
  final ValueChanged<double> onScoreChanged;

  const ScoreInputDialogContent({
    super.key,
    required this.currentScore,
    required this.controller,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Enter the score from your test on Quizlet or another tool:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          '${currentScore.toInt()}%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),
        Slider(
          value: currentScore,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${currentScore.toInt()}%',
          onChanged: onScoreChanged,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Enter exact score: '),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: '%',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null && intValue >= 0 && intValue <= 100) {
                    onScoreChanged(intValue.toDouble());
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildScoreButtons(),
        ),
      ],
    );
  }

  List<Widget> _buildScoreButtons() {
    // Pre-defined score options
    const scoreOptions = [0, 25, 50, 75, 100];

    return scoreOptions.map((score) {
      final isSelected = currentScore.toInt() == score;
      return _ScoreButton(
        score: score,
        isSelected: isSelected,
        onTap: () => onScoreChanged(score.toDouble()),
      );
    }).toList();
  }
}

/// A button for quickly selecting predefined scores
class _ScoreButton extends StatelessWidget {
  final int score;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScoreButton({
    required this.score,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
          ),
        ),
        child: Text(
          '$score%',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
