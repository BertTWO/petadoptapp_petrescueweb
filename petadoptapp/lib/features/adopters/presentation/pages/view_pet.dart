// lib/presentation/pages/pet_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petadoptapp/core/theme/app_theme.dart';
import 'package:petadoptapp/features/pet/domain/entity/pet.dart';
import 'package:petadoptapp/features/pet/presentation/cubit/pet_cubit.dart';
import 'package:petadoptapp/features/adoptpet/presentation/cubit/adoption_cubit.dart';
import 'package:petadoptapp/features/auth/presentation/cubit/auth_cubit.dart';

class PetDetailPage extends StatefulWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  bool _hasApplied = false;
  bool _isSubmitting = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.text =
        'I would love to adopt ${widget.pet.name}! I have a loving home ready.';
    _checkIfApplied();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _checkIfApplied() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      try {
        // Check if user has already applied for this pet
        // This would need to check your adoption records
        // For now, we'll assume false and update based on API response
        if (mounted) {
          setState(() {
            _hasApplied = false; // Default to false, update from API
          });
        }
      } catch (e) {
        // Ignore error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textDark),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(background: _buildPetImage()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.pet.name,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.pet.isAvailable
                              ? AppTheme.success.withOpacity(0.1)
                              : widget.pet.isPending
                              ? AppTheme.warning.withOpacity(0.1)
                              : AppTheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.pet.status.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.pet.isAvailable
                                ? AppTheme.success
                                : widget.pet.isPending
                                ? AppTheme.warning
                                : AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.pet.breed} • ${widget.pet.type} • ${widget.pet.age} years old',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.pet.location,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'About',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.pet.description ?? 'No description available',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppTheme.textDark,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // ADOPT BUTTON WITH BLOC LISTENER
                  BlocConsumer<AdoptionCubit, AdoptionState>(
                    listener: (context, state) {
                      if (state is AdoptionSuccess) {
                        setState(() {
                          _hasApplied = true;
                          _isSubmitting = false;
                        });

                        // Show success dialog
                        _showSuccessDialog(context);

                        // Update pet status locally
                        context.read<PetCubit>().fetchAvailablePets();
                      }
                      if (state is AdoptionError) {
                        setState(() {
                          _isSubmitting = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          if (authState is AuthAuthenticated) {
                            final user = authState.user;

                            // Check if pet is available
                            if (!widget.pet.isAvailable) {
                              return SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: null,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                    side: const BorderSide(color: Colors.grey),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    widget.pet.isPending
                                        ? 'Adoption Pending'
                                        : 'Already Adopted',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Check if already applied
                            if (_hasApplied) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to My Applications page
                                    Navigator.pushNamed(
                                      context,
                                      '/my-applications',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.info,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'View Application Status',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Normal adopt button
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _showAdoptionDialog(context, user),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isSubmitting
                                      ? Colors.grey
                                      : AppTheme.primaryOrange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Adopt ${widget.pet.name}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          }

                          // Not logged in
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please login to adopt a pet',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                // Navigate to login
                                Navigator.pushNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryOrange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Login to Adopt ${widget.pet.name}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetImage() {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Use imageUrl from your Pet entity
          widget.pet.displayImage.isNotEmpty
              ? Image.network(
                  widget.pet.displayImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.surfaceLight,
                      child: Center(
                        child: Icon(
                          Icons.pets,
                          size: 80,
                          color: AppTheme.textLight,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: AppTheme.surfaceLight,
                  child: Center(
                    child: Icon(
                      Icons.pets,
                      size: 80,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.3), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdoptionDialog(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Adopt ${widget.pet.name}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us why you would be a great home for ${widget.pet.name}:',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your message here...',
                  hintStyle: GoogleFonts.poppins(color: AppTheme.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.textLight.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryOrange,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Information:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Name: ${user.name}'),
                    Text('Email: ${user.email}'),
                    if (user.phone != null) Text('Phone: ${user.phone}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This will send an adoption request to the shelter.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppTheme.textMedium),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_messageController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please write a message'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _submitAdoptionRequest(context, user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Submit Application', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _submitAdoptionRequest(BuildContext context, dynamic user) async {
    setState(() {
      _isSubmitting = true;
    });

    final adoptionCubit = context.read<AdoptionCubit>();

    // Call the API through your repository
    await adoptionCubit.submitAdoption(
      petId: widget.pet.id,
      userId: user.id,
      message: _messageController.text.trim(),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Application Submitted!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your adoption request for ${widget.pet.name} has been submitted successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              'You can track the status in "My Applications"',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue Browsing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-applications');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
            ),
            child: Text('View My Applications'),
          ),
        ],
      ),
    );
  }
}
