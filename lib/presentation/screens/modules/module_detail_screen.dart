import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Screen for detailed module information
class ModuleDetailScreen extends StatefulWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final moduleViewModel = context.read<ModuleViewModel>();
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    // Lưu trữ moduleId để sử dụng sau các thao tác bất đồng bộ
    final String moduleId = widget.moduleId;

    await moduleViewModel.loadModuleDetails(moduleId);

    // Kiểm tra mounted trước khi tiếp tục
    if (!mounted) return;

    // Kiểm tra xác thực và lấy tiến trình học tập
    if (authViewModel.isAuthenticated) {
      await progressViewModel.loadCurrentUserProgressByModule(moduleId);
    }
  }

  Future<void> _startLearning() async {
    final authViewModel = context.read<AuthViewModel>();
    final moduleViewModel = context.read<ModuleViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    // Lưu trữ các giá trị cần thiết
    final String moduleId = widget.moduleId;

    // Kiểm tra xác thực
    if (!authViewModel.isAuthenticated || authViewModel.currentUser == null) {
      // Kiểm tra mounted trước khi sử dụng BuildContext
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to start learning')),
        );
      }
      return;
    }

    final module = moduleViewModel.selectedModule;
    if (module == null) return;

    // Kiểm tra tiến trình hiện có
    final existingProgress = progressViewModel.selectedProgress;

    if (existingProgress != null) {
      // Kiểm tra mounted trước khi sử dụng BuildContext
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ProgressDetailScreen(progressId: existingProgress.id),
          ),
        ).then((_) {
          // Kiểm tra mounted trước khi gọi _loadData()
          if (mounted) {
            _loadData();
          }
        });
      }
      return;
    }

    // Tạo tiến trình mới
    final newProgress = await progressViewModel.createProgress(
      moduleId: module.id,
      userId: authViewModel.currentUser!.id,
      firstLearningDate: DateTime.now(),
      nextStudyDate: DateTime.now(),
    );

    // Kiểm tra mounted trước khi sử dụng BuildContext
    if (newProgress != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProgressDetailScreen(progressId: newProgress.id),
        ),
      ).then((_) {
        // Kiểm tra mounted trước khi gọi _loadData()
        if (mounted) {
          _loadData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moduleViewModel = context.watch<ModuleViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final module = moduleViewModel.selectedModule;
    final userProgress = progressViewModel.selectedProgress;

    return Scaffold(
      appBar: AppBar(title: Text(module?.title ?? 'Module Details')),
      body: _buildBody(
        theme,
        module,
        moduleViewModel.isLoading,
        moduleViewModel.errorMessage,
      ),
      // Chỉ hiển thị nút "Start Learning" khi chưa có tiến trình học tập
      floatingActionButton:
          module != null && progressViewModel.selectedProgress == null
              ? FloatingActionButton.extended(
                onPressed: _startLearning,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Learning'),
              )
              : null,
    );
  }

  /// Build the screen body based on loading state
  Widget _buildBody(
    ThemeData theme,
    ModuleDetail? module,
    bool isLoading,
    String? errorMessage,
  ) {
    final progressViewModel = context.watch<ProgressViewModel>();
    final userProgress = progressViewModel.selectedProgress;

    if (isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: ErrorDisplay(message: errorMessage, onRetry: _loadData),
      );
    }

    if (module == null) {
      return const Center(child: Text('Module not found'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Module header
          _buildModuleHeader(theme, module),
          const SizedBox(height: 24),

          // User progress section (if available)
          if (userProgress != null) ...[
            Text('Your Progress', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),

            ProgressCard(
              progress: ProgressSummary(
                id: userProgress.id,
                moduleId: userProgress.moduleId,
                userId: userProgress.userId,
                firstLearningDate: userProgress.firstLearningDate,
                cyclesStudied: userProgress.cyclesStudied,
                nextStudyDate: userProgress.nextStudyDate,
                percentComplete: userProgress.percentComplete,
                createdAt: userProgress.createdAt,
                updatedAt: userProgress.updatedAt,
                repetitionCount: userProgress.repetitions.length,
              ),
              moduleTitle: module.title,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProgressDetailScreen(progressId: userProgress.id),
                  ),
                ).then((_) {
                  // Kiểm tra mounted trước khi gọi _loadData()
                  if (mounted) {
                    _loadData();
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Chỉ hiển thị nút "View Detailed Progress" khi có tiến trình
            Center(
              child: AppButton(
                text: 'View Detailed Progress',
                type: AppButtonType.outline,
                prefixIcon: Icons.visibility,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ProgressDetailScreen(progressId: userProgress.id),
                    ),
                  ).then((_) {
                    // Kiểm tra mounted trước khi gọi _loadData()
                    if (mounted) {
                      _loadData();
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Module content section
          Text('Content Overview', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (module.wordCount != null && module.wordCount! > 0) ...[
                    Row(
                      children: [
                        const Icon(Icons.format_size),
                        const SizedBox(width: 8),
                        Text(
                          'Word Count: ${module.wordCount}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Placeholder for module content
                  // In a real app, this would display actual module content
                  const Text(
                    'This is where the module content would be displayed. '
                    'In a complete application, this would include text, '
                    'images, videos, and other learning materials.',
                  ),
                  const SizedBox(height: 16),

                  // Study tips
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Study Tips',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Review this module regularly using the spaced repetition schedule\n'
                          '• Take notes while studying\n'
                          '• Try to recall the material before checking your answers\n'
                          '• Connect new information to things you already know',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Space at the bottom for the FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// Build the module header with metadata
  Widget _buildModuleHeader(ThemeData theme, ModuleDetail module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module title
        Text(module.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),

        // Module number and book
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Module ${module.moduleNo}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Book: ${module.bookName ?? "Unknown"}',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Module details card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  theme,
                  module.progress.length.toString(),
                  'Students',
                ),
                _buildDivider(),
                _buildStatItem(
                  theme,
                  module.wordCount != null ? '${module.wordCount}' : 'N/A',
                  'Words',
                ),
                _buildDivider(),
                _buildStatItem(
                  theme,
                  _estimateReadingTime(module.wordCount),
                  'Reading Time',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build a vertical divider
  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  /// Build a statistics item
  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  /// Estimate reading time based on word count
  String _estimateReadingTime(int? wordCount) {
    if (wordCount == null || wordCount <= 0) {
      return 'N/A';
    }

    // Average reading speed: ~200-250 words per minute
    // We'll use 200 for a conservative estimate
    final readingTimeMinutes = (wordCount / 200).ceil();

    if (readingTimeMinutes < 1) {
      return '<1 min';
    } else if (readingTimeMinutes == 1) {
      return '1 min';
    } else {
      return '$readingTimeMinutes mins';
    }
  }
}
