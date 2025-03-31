import 'package:flutter/material.dart';

/// Screen providing information about spaced repetition learning method
class SpacedRepetitionInfoScreen extends StatelessWidget {
  const SpacedRepetitionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Phương pháp học ngắt quãng')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            theme,
            'Hiểu về chu kỳ học ngắt quãng',
            isMainTitle: true,
          ),
          _buildSection(
            theme,
            'Phương pháp học ngắt quãng là gì?',
            'Phương pháp học ngắt quãng (Spaced Repetition) là một kỹ thuật học tập dựa trên nghiên cứu khoa học, '
                'giúp tối ưu hóa quá trình ghi nhớ thông qua việc ôn tập theo chu kỳ với khoảng thời gian tăng dần.',
          ),
          _buildSection(
            theme,
            'Chu kỳ học là gì?',
            'Trong ứng dụng này, mỗi chu kỳ học bao gồm 5 lần ôn tập. Bạn cần hoàn thành tất cả 5 lần ôn tập '
                'trước khi chuyển sang chu kỳ học tiếp theo. Mỗi chu kỳ sẽ giúp kiến thức được củng cố sâu hơn '
                'trong trí nhớ dài hạn.',
          ),
          _buildCyclesSection(theme),
          _buildSection(
            theme,
            'Thuật toán học ngắt quãng',
            'Ứng dụng sử dụng thuật toán học ngắt quãng nâng cao, tính đến nhiều yếu tố như: '
                'số từ trong module, tiến độ học tập, chu kỳ học hiện tại và số lần ôn tập đã hoàn thành '
                'để tính toán khoảng thời gian tối ưu giữa các lần ôn tập.',
          ),
          _buildFormulaSection(theme),
        ],
      ),
    );
  }

  // UI Components
  Widget _buildSectionHeader(
    ThemeData theme,
    String title, {
    bool isMainTitle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              isMainTitle
                  ? theme.textTheme.headlineSmall
                  : theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(content, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCyclesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Các chu kỳ học', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        _buildCycleItem(
          theme,
          'Chu kỳ đầu tiên',
          'Đây là lần đầu tiên bạn học module này. Hoàn thành 5 lần ôn tập đầu tiên.',
        ),
        _buildCycleItem(
          theme,
          'Chu kỳ ôn tập thứ nhất',
          'Sau khi hoàn thành chu kỳ đầu tiên, bạn sẽ chuyển sang chu kỳ ôn tập thứ nhất với 5 lần ôn tập mới.',
        ),
        _buildCycleItem(
          theme,
          'Chu kỳ ôn tập thứ hai',
          'Khoảng cách giữa các lần ôn tập sẽ xa hơn để thử thách trí nhớ của bạn.',
        ),
        _buildCycleItem(
          theme,
          'Chu kỳ ôn tập thứ ba',
          'Đến giai đoạn này, kiến thức đã được củng cố khá tốt trong trí nhớ dài hạn.',
        ),
        _buildCycleItem(
          theme,
          'Chu kỳ hơn 3 lần ôn tập',
          'Bạn đã thuộc bài rất tốt! Các lần ôn tập tiếp theo chỉ để duy trì kiến thức.',
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCycleItem(ThemeData theme, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 12, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Công thức tính toán', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Khoảng cách giữa các lần ôn tập được tính dựa trên công thức:\n\n'
            '- Khoảng cách cơ bản = Hệ số từ × Min(31, Số chu kỳ × Hệ số lần ôn tập) × Hệ số tiến độ\n\n'
            'Và các hệ số được tính dựa trên:\n'
            '- Hệ số từ: phụ thuộc vào số lượng từ của module\n'
            '- Số chu kỳ: dựa trên chu kỳ học hiện tại\n'
            '- Hệ số lần ôn tập: tăng dần theo thứ tự lần ôn tập\n'
            '- Hệ số tiến độ: phụ thuộc vào phần trăm hoàn thành',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
