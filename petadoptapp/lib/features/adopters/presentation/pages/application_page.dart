// lib/features/adopters/presentation/pages/my_applications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petadoptapp/core/theme/app_theme.dart';
import 'package:petadoptapp/features/adoptpet/domain/entity/adoptpet.dart';
import 'package:petadoptapp/features/adoptpet/presentation/cubit/adoption_cubit.dart';
import 'package:petadoptapp/features/auth/presentation/cubit/auth_cubit.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  String _selectedFilter = 'all';
  final List<String> _filters = [
    'all',
    'pending',
    'approved',
    'rejected',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      context.read<AdoptionCubit>().loadMyApplications(user.id);
    }
  }

  List<AdoptionApplication> _filterApplications(
    List<AdoptionApplication> apps,
  ) {
    if (_selectedFilter == 'all') return apps;

    return apps.where((app) {
      switch (_selectedFilter) {
        case 'pending':
          return app.status == ApplicationStatus.pending;
        case 'approved':
          return app.status == ApplicationStatus.approved;
        case 'rejected':
          return app.status == ApplicationStatus.rejected;
        case 'cancelled':
          return app.status == ApplicationStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Applications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadApplications,
          ),
        ],
      ),
      body: BlocBuilder<AdoptionCubit, AdoptionState>(
        builder: (context, state) {
          if (state is ApplicationsLoaded) {
            final filteredApps = _filterApplications(state.applications);

            return Column(
              children: [
                // Filter Chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _filters.length - 1 ? 8 : 0,
                        ),
                        child: _buildFilterChip(_filters[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Applications Count
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Applications',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        '${filteredApps.length} found',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Applications List
                Expanded(
                  child: filteredApps.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            _loadApplications();
                            return Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredApps.length,
                            itemBuilder: (context, index) {
                              return _buildApplicationCard(filteredApps[index]);
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          if (state is AdoptionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            );
          }

          if (state is AdoptionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppTheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading applications',
                    style: GoogleFonts.poppins(color: AppTheme.textDark),
                  ),
                  Text(
                    state.message,
                    style: GoogleFonts.poppins(color: AppTheme.textMedium),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadApplications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryOrange),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    final filterText = filter == 'all'
        ? 'All'
        : filter == 'pending'
        ? 'Pending'
        : filter == 'approved'
        ? 'Approved'
        : filter == 'rejected'
        ? 'Rejected'
        : 'Cancelled';

    return Container(
      constraints: const BoxConstraints(minWidth: 60),
      child: FilterChip(
        label: Text(
          filterText,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textDark,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppTheme.primaryOrange
                : AppTheme.textLight.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(AdoptionApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.surfaceLight,
                    child: application.petImageUrl.isNotEmpty
                        ? Image.network(
                            application.petImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 40,
                                  color: AppTheme.textLight,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.pets,
                              size: 40,
                              color: AppTheme.textLight,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              application.petName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Icon(
                            application.status == ApplicationStatus.pending
                                ? Icons.hourglass_empty
                                : application.status ==
                                      ApplicationStatus.approved
                                ? Icons.check_circle
                                : application.status ==
                                      ApplicationStatus.rejected
                                ? Icons.cancel
                                : Icons.arrow_back,
                            color: application.statusColor,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        application.pet?['breed'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textMedium,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: application.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          application.statusText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: application.statusColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: AppTheme.textLight.withOpacity(0.2),
            thickness: 1,
          ),

          // Application Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Applied Date',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.textMedium,
                      ),
                    ),
                    Text(
                      '${application.appliedAt.day}/${application.appliedAt.month}/${application.appliedAt.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Message
                if (application.message.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.textLight.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.message,
                              size: 16,
                              color: AppTheme.textMedium,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              application.status == ApplicationStatus.rejected
                                  ? 'Response'
                                  : 'Your Message',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          application.message,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.textDark,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Action Buttons based on status
                if (application.status == ApplicationStatus.pending)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showWithdrawDialog(context, application);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.error,
                            side: BorderSide(color: AppTheme.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Withdraw',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                if (application.status == ApplicationStatus.approved)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show contact info or next steps
                        _showApprovedDialog(context, application);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Next Steps',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt,
                size: 80,
                color: AppTheme.textLight.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'No Applications Found',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _selectedFilter == 'all'
                    ? 'Browse pets and submit adoption requests to see them here'
                    : 'No ${_selectedFilter} applications found',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to pets list
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Browse Pets',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog(
    BuildContext context,
    AdoptionApplication application,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Withdraw Application',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to withdraw your application for ${application.petName}?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final adoptionCubit = context.read<AdoptionCubit>();
                await adoptionCubit.cancelAdoption(application.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Application for ${application.petName} withdrawn',
                    ),
                    backgroundColor: AppTheme.info,
                  ),
                );
                _loadApplications();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to withdraw: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Withdraw', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _showApprovedDialog(
    BuildContext context,
    AdoptionApplication application,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Adoption Approved!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppTheme.success,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations! Your adoption request for ${application.petName} has been approved.',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              'Next steps:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('1. Contact the shelter to arrange pickup'),
            Text('2. Bring identification and proof of address'),
            Text('3. Complete adoption paperwork'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
