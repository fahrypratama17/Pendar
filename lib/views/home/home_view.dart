import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_state.dart';
import '../../utils/greeting_utils.dart';
import '../../models/mindcheck_result_model.dart';
import '../../services/network/mind_check_api.dart';
import '../../services/journal_bloc.dart';
import '../../services/journal_state.dart';
import '../../services/journal_event.dart';
import '../../services/schedule_bloc.dart';
import '../../services/schedule_state.dart';
import '../../services/schedule_event.dart';
import 'main_layout_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  MindCheckResultModel? _latestMindCheck;
  bool _isLoadingMindCheck = true;

  @override
  void initState() {
    super.initState();
    _fetchLatestMindCheck();
  }

  Future<void> _fetchLatestMindCheck() async {
    if (!mounted) return;
    setState(() {
      _isLoadingMindCheck = true;
    });
    try {
      final history = await MindCheckApi().getMindCheckHistory();
      if (mounted) {
        setState(() {
          _latestMindCheck = history.isNotEmpty ? history.first : null;
          _isLoadingMindCheck = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMindCheck = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    context.read<JournalBloc>().add(JournalLoadRequested());
    context.read<ScheduleBloc>().add(ScheduleLoadRequested());
    await _fetchLatestMindCheck();
  }

  String _formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    
    if (deadline.year == now.year && deadline.month == now.month && deadline.day == now.day) {
      return 'Today, ${_formatTime(deadline)}';
    }
    
    final tomorrow = now.add(const Duration(days: 1));
    if (deadline.year == tomorrow.year && deadline.month == tomorrow.month && deadline.day == tomorrow.day) {
      return 'Tomorrow, ${_formatTime(deadline)}';
    }
    
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[deadline.month - 1]} ${deadline.day}, ${_formatTime(deadline)}';
  }

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final String displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  Widget _buildMetricBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.palePurple50,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greeting = GreetingUtils.getGreeting();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'User';
        if (state is AuthAuthenticated) {
          userName = state.user.fullName;
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.secondary,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Greeting
                          Text(
                            '$greeting,',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              color: AppColors.palePurple400,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.palePurple50,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            '"The soul always knows what to do to heal itself. The challenge is to silence the mind."',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              color: AppColors.muted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 30.0),

                          // Check Your Mind Banner Card
                          Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/mindimages.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.palePurple400.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check Your Mind',
                                      style: TextStyle(
                                        color: AppColors.palePurple50,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const FractionallySizedBox(
                                      widthFactor: 0.7,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Measure your daily burnout level to maintain your mental harmony',
                                        style: TextStyle(
                                          color: AppColors.palePurple50,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 200,
                                      height: 56.0,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await context.push(AppRoutes.mindcheck);
                                          _fetchLatestMindCheck();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.purple100,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Start Daily Check-In',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.purple900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),

                          // Mood Journey Section
                          const Text(
                            'Mood journey this week',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // Dynamic Mood Journey Card
                          _buildMoodJourneyCard(),

                          const SizedBox(height: 30.0),

                          // Recent Journals Section
                          const Text(
                            'Recent Journals',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // Dynamic Journal Card
                          _buildRecentJournalCard(),

                          const SizedBox(height: 30.0),

                          // Upcoming Priorities Section
                          const Text(
                            'Upcoming Priorities',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // Dynamic Priorities List
                          _buildUpcomingPriorities(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodJourneyCard() {
    if (_isLoadingMindCheck) {
      return Center(
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.palePurple400.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
            color: AppColors.secondary.withValues(alpha: 0.5),
          ),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    String titleText = "Belum ada analisis hari ini";
    String descriptionText = "Lakukan Daily Check-In pertama kamu hari ini untuk mengukur tingkat kejenuhan (burnout).";
    
    if (_latestMindCheck != null) {
      final idx = _latestMindCheck!.mentalHealthIndex;
      if (idx == 2) {
        titleText = "Your mind is in a good state! ✨";
        descriptionText = "Tingkat burnout kamu rendah (${_latestMindCheck!.burnoutLevelPct}%) dengan fokus tinggi. Pertahankan ritme sehat ini!";
      } else if (idx == 1) {
        titleText = "Your mind is feeling okay. 💫";
        descriptionText = "Tingkat burnout kamu sedang (${_latestMindCheck!.burnoutLevelPct}%). Jangan lupa luangkan waktu sejenak untuk beristirahat.";
      } else {
        titleText = "Your mind is feeling low. 🌸";
        descriptionText = "Tingkat burnout kamu tergolong tinggi (${_latestMindCheck!.burnoutLevelPct}%). Prioritaskan relaksasi atau coba meditasi pernapasan.";
      }
    }

    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.palePurple400.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/images/moodimages.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: const TextStyle(
                  color: AppColors.palePurple50,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          descriptionText,
                          style: const TextStyle(
                            color: AppColors.palePurple200,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_latestMindCheck != null)
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _buildMetricBadge(
                                icon: Icons.flash_on,
                                label: 'Focus: ${_latestMindCheck!.focusLevelPct}%',
                              ),
                              _buildMetricBadge(
                                icon: Icons.king_bed_outlined,
                                label: '${_latestMindCheck!.sleepHours}j Tidur',
                              ),
                            ],
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              final layoutState = context.findAncestorStateOfType<MainLayoutViewState>();
                              if (layoutState != null) {
                                layoutState.setTab(2); // Check-in tab
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple100,
                              foregroundColor: AppColors.purple900,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Start Check-In',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/images/heart.png',
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              if (_latestMindCheck != null) ...[
                const SizedBox(height: 16),
                const Divider(color: Colors.white10),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.mindcheckResult, extra: _latestMindCheck);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analisis terakhir: ${_formatDate(_latestMindCheck!.createdAt)}',
                        style: const TextStyle(
                          color: AppColors.palePurple400,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Text(
                        'Lihat Detail ➔',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentJournalCard() {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalLoading) {
          return Center(
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                color: AppColors.secondary.withValues(alpha: 0.5),
              ),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is JournalLoadSuccess) {
          if (state.journals.isEmpty) {
            return Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.palePurple400.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.note_alt_outlined, size: 40, color: AppColors.palePurple400),
                    const SizedBox(height: 8),
                    const Text(
                      'Belum ada jurnal ditulis',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.palePurple50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mulai tulis jurnal untuk merekam perasaan harimu.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.palePurple400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final journalBloc = context.read<JournalBloc>();
                        await context.push(AppRoutes.newJournal);
                        journalBloc.add(JournalLoadRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple100,
                        foregroundColor: AppColors.purple900,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Tulis Jurnal Pertama',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final latestJournal = state.journals.first;

          return GestureDetector(
            onTap: () async {
              final journalBloc = context.read<JournalBloc>();
              await context.push(AppRoutes.editJournal, extra: latestJournal);
              journalBloc.add(JournalLoadRequested());
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(latestJournal.createdAt),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icon/Iconjournal.svg',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      latestJournal.title,
                      style: const TextStyle(
                        color: AppColors.palePurple50,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      latestJournal.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.palePurple200,
                        fontSize: 13,
                        height: 1.4,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Edit Jurnal ➔',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildUpcomingPriorities() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is ScheduleLoadSuccess) {
          final upcomingTasks = state.schedules.where((t) => !t.isCompleted).toList();
          upcomingTasks.sort((a, b) => a.deadline.compareTo(b.deadline));

          if (upcomingTasks.isEmpty) {
            return Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.palePurple400.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.playlist_add_check, size: 40, color: AppColors.palePurple400),
                    const SizedBox(height: 8),
                    const Text(
                      'Semua prioritas selesai!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.palePurple50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tidak ada jadwal atau tugas penting terdekat.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.palePurple400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        final layoutState = context.findAncestorStateOfType<MainLayoutViewState>();
                        if (layoutState != null) {
                          layoutState.setTab(3); // Schedule tab
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple100,
                        foregroundColor: AppColors.purple900,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Buat Prioritas',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final displayTasks = upcomingTasks.take(2).toList();

          return Column(
            children: displayTasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () async {
                    final scheduleBloc = context.read<ScheduleBloc>();
                    await context.push(AppRoutes.editSchedule, extra: task);
                    scheduleBloc.add(ScheduleLoadRequested());
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.palePurple400.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.secondary.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icon/Iconschedule.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.taskName,
                                  style: const TextStyle(
                                    color: AppColors.palePurple50,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDeadline(task.deadline),
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              context.read<ScheduleBloc>().add(
                                    ScheduleToggleCompleteRequested(
                                      id: task.id,
                                      isCompleted: true,
                                    ),
                                  );
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.palePurple400,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
