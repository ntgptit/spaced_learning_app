// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:spaced_learning_app/domain/models/progress.dart';
// import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
// import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
// import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
// import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
// import 'package:spaced_learning_app/presentation/viewmodels/enhanced_learning_stats_viewmodel.dart';
// import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
// import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
// import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
// import 'package:spaced_learning_app/presentation/widgets/learning/enhanced_learning_stats_card.dart';
// import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

// /// Enhanced dashboard screen with comprehensive learning statistics
// class EnhancedDashboardScreen extends StatefulWidget {
//   const EnhancedDashboardScreen({super.key});

//   @override
//   State<EnhancedDashboardScreen> createState() =>
//       _EnhancedDashboardScreenState();
// }

// class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> {
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//     });
//   }

//   Future<void> _loadData() async {
//     final authViewModel = context.read<AuthViewModel>();
//     final progressViewModel = context.read<ProgressViewModel>();
//     final learningStatsViewModel =
//         context.read<EnhancedLearningStatsViewModel>();

//     if (authViewModel.currentUser != null) {
//       if (!learningStatsViewModel.isInitialized) {
//         await learningStatsViewModel.loadLearningStats(
//           authViewModel.currentUser!.id,
//         );
//       }
//       await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
//       setState(() {
//         _isInitialized = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final authViewModel = context.watch<AuthViewModel>();
//     final progressViewModel = context.watch<ProgressViewModel>();
//     final learningStatsViewModel =
//         context.watch<EnhancedLearningStatsViewModel>();

//     if (authViewModel.currentUser == null) {
//       return const Center(child: Text('Please log in to view your dashboard'));
//     }

//     final bool isLoading =
//         progressViewModel.isLoading ||
//         learningStatsViewModel.isLoading ||
//         !_isInitialized;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               theme.brightness == Brightness.dark
//                   ? Icons.light_mode
//                   : Icons.dark_mode,
//             ),
//             onPressed: () {},
//             tooltip: 'Toggle theme',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child:
//             isLoading
//                 ? const Center(child: AppLoadingIndicator())
//                 : CustomScrollView(
//                   slivers: [
//                     SliverPadding(
//                       padding: const EdgeInsets.all(16.0),
//                       sliver: SliverList(
//                         delegate: SliverChildListDelegate([
//                           // Welcome message
//                           Text(
//                             'Welcome, ${authViewModel.currentUser!.displayName ?? authViewModel.currentUser!.email}!',
//                             style: theme.textTheme.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: theme.colorScheme.primary,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Your enhanced learning dashboard',
//                             style: theme.textTheme.titleMedium,
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 24),

//                           // Enhanced Learning Stats Card
//                           if (learningStatsViewModel.errorMessage != null)
//                             ErrorDisplay(
//                               message: learningStatsViewModel.errorMessage!,
//                               onRetry: () {
//                                 if (authViewModel.currentUser != null) {
//                                   learningStatsViewModel.refreshStats(
//                                     authViewModel.currentUser!.id,
//                                   );
//                                 }
//                               },
//                               compact: true,
//                             )
//                           else
//                             EnhancedLearningStatsCard(
//                               totalModules: learningStatsViewModel.totalModules,
//                               completedModules:
//                                   learningStatsViewModel.completedModules,
//                               inProgressModules:
//                                   learningStatsViewModel.inProgressModules,
//                               dueToday: learningStatsViewModel.dueToday,
//                               dueThisWeek: learningStatsViewModel.dueThisWeek,
//                               dueThisMonth: learningStatsViewModel.dueThisMonth,
//                               wordsDueToday:
//                                   learningStatsViewModel.wordsDueToday,
//                               wordsDueThisWeek:
//                                   learningStatsViewModel.wordsDueThisWeek,
//                               wordsDueThisMonth:
//                                   learningStatsViewModel.wordsDueThisMonth,
//                               completedToday:
//                                   learningStatsViewModel.completedToday,
//                               completedThisWeek:
//                                   learningStatsViewModel.completedThisWeek,
//                               completedThisMonth:
//                                   learningStatsViewModel.completedThisMonth,
//                               wordsCompletedToday:
//                                   learningStatsViewModel.wordsCompletedToday,
//                               wordsCompletedThisWeek:
//                                   learningStatsViewModel.wordsCompletedThisWeek,
//                               wordsCompletedThisMonth:
//                                   learningStatsViewModel
//                                       .wordsCompletedThisMonth,
//                               streakDays: learningStatsViewModel.streakDays,
//                               streakWeeks: learningStatsViewModel.streakWeeks,
//                               totalWords: learningStatsViewModel.totalWords,
//                               learnedWords: learningStatsViewModel.learnedWords,
//                               pendingWords: learningStatsViewModel.pendingWords,
//                               vocabularyCompletionRate:
//                                   learningStatsViewModel
//                                       .vocabularyCompletionRate,
//                               weeklyNewWordsRate:
//                                   learningStatsViewModel.weeklyNewWordsRate,
//                               onViewProgress: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) =>
//                                             const LearningProgressScreen(),
//                                   ),
//                                 );
//                               },
//                             ),

//                           const SizedBox(height: 24),

//                           // Due today section
//                           Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             margin: EdgeInsets.zero,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.calendar_today,
//                                         color: theme.colorScheme.primary,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         'Due Today',
//                                         style: theme.textTheme.titleLarge,
//                                       ),
//                                       const Spacer(),
//                                       Chip(
//                                         label: Text(
//                                           '${progressViewModel.progressRecords.length} items',
//                                           style: TextStyle(
//                                             color: theme.colorScheme.onPrimary,
//                                           ),
//                                         ),
//                                         backgroundColor:
//                                             theme.colorScheme.primary,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Divider(),
//                                   if (progressViewModel.errorMessage != null)
//                                     ErrorDisplay(
//                                       message: progressViewModel.errorMessage!,
//                                       onRetry: _loadData,
//                                       compact: true,
//                                     )
//                                   else if (progressViewModel
//                                       .progressRecords
//                                       .isEmpty)
//                                     const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 24.0,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'No repetitions due today. Great job!',
//                                         ),
//                                       ),
//                                     )
//                                   else
//                                     _buildDueProgressList(
//                                       progressViewModel.progressRecords,
//                                     ),
//                                   const SizedBox(height: 8),
//                                   if (progressViewModel
//                                       .progressRecords
//                                       .isNotEmpty)
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) =>
//                                                       const DueProgressScreen(),
//                                             ),
//                                           );
//                                         },
//                                         child: const Text('View all'),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Learning stats insights section
//                           Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             margin: EdgeInsets.zero,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.insights,
//                                         color: theme.colorScheme.tertiary,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         'Learning Insights',
//                                         style: theme.textTheme.titleLarge,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Divider(),
//                                   _buildInsightItem(
//                                     context,
//                                     'You learn ${learningStatsViewModel.weeklyNewWordsRate.toStringAsFixed(1)}% new vocabulary each week',
//                                     Icons.trending_up,
//                                     Colors.blue,
//                                   ),
//                                   _buildInsightItem(
//                                     context,
//                                     'Your current streak is ${learningStatsViewModel.streakDays} days - keep going!',
//                                     Icons.local_fire_department,
//                                     Colors.orange,
//                                   ),
//                                   _buildInsightItem(
//                                     context,
//                                     'You have ${learningStatsViewModel.pendingWords} words pending to learn',
//                                     Icons.menu_book,
//                                     Colors.teal,
//                                   ),
//                                   _buildInsightItem(
//                                     context,
//                                     'Complete today\'s ${learningStatsViewModel.dueToday} sessions to maintain your streak',
//                                     Icons.today,
//                                     Colors.red,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Quick actions
//                           Text(
//                             'Quick Actions',
//                             style: theme.textTheme.titleLarge,
//                           ),
//                           const SizedBox(height: 16),
//                           GridView.count(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 16,
//                             mainAxisSpacing: 16,
//                             children: [
//                               _buildActionCard(
//                                 context,
//                                 'Browse Books',
//                                 Icons.book,
//                                 () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) => const BooksScreen(),
//                                     ),
//                                   );
//                                 },
//                                 color: Colors.blueAccent,
//                               ),
//                               _buildActionCard(
//                                 context,
//                                 'Today\'s Learning',
//                                 Icons.assignment,
//                                 () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (context) =>
//                                               const DueProgressScreen(),
//                                     ),
//                                   );
//                                 },
//                                 color: Colors.green,
//                               ),
//                               _buildActionCard(
//                                 context,
//                                 'Progress Report',
//                                 Icons.bar_chart,
//                                 () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (context) =>
//                                               const LearningProgressScreen(),
//                                     ),
//                                   );
//                                 },
//                                 color: Colors.orange,
//                               ),
//                               _buildActionCard(
//                                 context,
//                                 'Vocabulary Stats',
//                                 Icons.menu_book,
//                                 () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                         'Vocabulary Statistics coming soon',
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 color: Colors.purple,
//                               ),
//                             ],
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }

//   Widget _buildDueProgressList(List<ProgressSummary> progressList) {
//     final limitedList =
//         progressList.length > 3 ? progressList.sublist(0, 3) : progressList;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: limitedList.length,
//       itemBuilder: (context, index) {
//         final progress = limitedList[index];
//         const moduleTitle = 'Module';
//         return ProgressCard(
//           progress: progress,
//           moduleTitle: moduleTitle,
//           isDue: true,
//           onTap: () {
//             Navigator.of(
//               context,
//             ).pushNamed('/progress/detail', arguments: progress.id);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildActionCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     VoidCallback onTap, {
//     Color? color,
//   }) {
//     final theme = Theme.of(context);
//     return Card(
//       elevation: 2,
//       color: color?.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 32, color: color ?? theme.colorScheme.primary),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: theme.textTheme.titleMedium,
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInsightItem(
//     BuildContext context,
//     String message,
//     IconData icon,
//     Color color,
//   ) {
//     return AnimatedOpacity(
//       opacity: _isInitialized ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 500),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
