import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/journal_bloc.dart';
import '../../services/journal_event.dart';
import '../../services/journal_state.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final List<String> _moodEmojis = const ['😞', '🙁', '😐', '🙂', '😄'];

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(JournalLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkPurple900,
              AppColors.purple900,
            ],
          ),
        ),
        child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<JournalBloc, JournalState>(
                buildWhen: (previous, current) =>
                    current is JournalLoadSuccess ||
                    current is JournalLoading ||
                    current is JournalFailure,
                builder: (context, state) {
                  if (state is JournalLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (state is JournalFailure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 48.0,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple300,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                context.read<JournalBloc>().add(JournalLoadRequested());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is JournalLoadSuccess) {
                    if (state.journals.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<JournalBloc>().add(JournalLoadRequested());
                        },
                        color: AppColors.primary,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/Iconjournal.svg',
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primary.withValues(alpha: 0.3),
                                    BlendMode.srcIn,
                                  ),
                                  width: 80.0,
                                  height: 80.0,
                                ),
                                const SizedBox(height: 24.0),
                                const Text(
                                  'No journal entries yet',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.palePurple50,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Tap the + button to write your first journal entry.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    color: AppColors.palePurple400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<JournalBloc>().add(JournalLoadRequested());
                      },
                      color: AppColors.primary,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        itemCount: state.journals.length,
                        itemBuilder: (context, index) {
                          final journal = state.journals[index];
                          final int moodIdx = (journal.mood - 1).clamp(0, 4);
                          return GestureDetector(
                            onTap: () {
                              context.push(AppRoutes.editJournal, extra: journal);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDate(journal.createdAt),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.palePurple400,
                                        ),
                                      ),
                                      Text(
                                        _moodEmojis[moodIdx],
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    journal.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.palePurple50,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    journal.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      color: AppColors.palePurple400,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.newJournal);
        },
        backgroundColor: AppColors.purple100,
        foregroundColor: AppColors.neutral900,
        shape: const CircleBorder(),
        elevation: 4.0,
        child: const Icon(
          Icons.add,
          size: 28.0,
        ),
      ),
    );
  }
}
