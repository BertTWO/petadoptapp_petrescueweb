import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petadoptapp/core/theme/app_theme.dart';
import 'package:petadoptapp/features/adopters/presentation/pages/view_pet.dart';
import 'package:petadoptapp/features/pet/domain/entity/pet.dart';
import 'package:petadoptapp/features/pet/presentation/cubit/pet_cubit.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Pet> _filteredPets = [];

  final List<Map<String, String>> _categories = [
    {'label': 'All', 'value': 'All'},
    {'label': 'Dogs', 'value': 'Dog'},
    {'label': 'Cats', 'value': 'Cat'},
    {'label': 'Birds', 'value': 'Bird'},
    {'label': 'Rabbits', 'value': 'Rabbit'},
    {'label': 'Other', 'value': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Fetch pets when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().fetchAvailablePets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final state = context.read<PetCubit>().state;
    if (state is! PetLoaded) return;

    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPets = _applyCategoryFilter(state.pets);
      } else {
        _filteredPets = _applyCategoryFilter(
          state.pets.where((pet) {
            return pet.name.toLowerCase().contains(query) ||
                pet.breed.toLowerCase().contains(query) ||
                pet.location.toLowerCase().contains(query) ||
                pet.description?.toLowerCase().contains(query) == true;
          }).toList(),
        );
      }
    });
  }

  List<Pet> _applyCategoryFilter(List<Pet> pets) {
    if (_selectedCategory == 'All') {
      return pets;
    }
    return pets.where((pet) => pet.type == _selectedCategory).toList();
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      final state = context.read<PetCubit>().state;
      if (state is PetLoaded) {
        _filteredPets = _applyCategoryFilter(state.pets);
      }
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryOrange),
          const SizedBox(height: 16),
          Text(
            'Loading pets...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load pets',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<PetCubit>().fetchAvailablePets(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text(
            'No pets available',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new rescue pets',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PetCubit, PetState>(
      listener: (context, state) {
        if (state is PetLoaded) {
          // Update filtered pets when data loads
          setState(() {
            _filteredPets = _applyCategoryFilter(state.pets);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Pet Rescue',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              // Add user avatar if needed
              // IconButton(
              //   icon: Icon(Icons.refresh),
              //   onPressed: () => context.read<PetCubit>().fetchAvailablePets(),
              // ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PetState state) {
    if (state is PetLoading) {
      return _buildLoadingState();
    }

    if (state is PetError) {
      return _buildErrorState(state.message);
    }

    if (state is PetLoaded && state.pets.isEmpty) {
      return _buildEmptyState();
    }

    if (state is PetLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<PetCubit>().fetchAvailablePets();
        },
        color: AppTheme.primaryOrange,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome to Pet Rescue!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your perfect companion',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 20),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search pets by name, breed, or location...',
                      hintStyle: GoogleFonts.poppins(color: AppTheme.textLight),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.textMedium,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Categories
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category['value'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category['label']!),
                          selected: isSelected,
                          onSelected: (_) =>
                              _filterByCategory(category['value']!),
                          selectedColor: AppTheme.primaryOrange,
                          labelStyle: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : AppTheme.textLight,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Pets count
                Text(
                  '${_filteredPets.length} pets available',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 12),

                // Pets list
                Column(
                  children: _filteredPets.map((pet) {
                    return _buildPetCard(pet, context);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Initial state
    return _buildLoadingState();
  }

  Widget _buildPetCard(Pet pet, BuildContext context) {
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
          // Pet image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.surfaceLight,
              child: pet.displayImage.isNotEmpty
                  ? Image.network(
                      pet.displayImage,
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
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryOrange,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: pet.isAvailable
                            ? AppTheme.success.withOpacity(0.1)
                            : pet.isPending
                            ? AppTheme.warning.withOpacity(0.1)
                            : AppTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pet.status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: pet.isAvailable
                              ? AppTheme.success
                              : pet.isPending
                              ? AppTheme.warning
                              : AppTheme.error,
                        ),
                      ),
                    ),
                    Icon(
                      pet.type == 'Dog'
                          ? Icons.pets
                          : pet.type == 'Cat'
                          ? Icons.catching_pokemon
                          : Icons.forest,
                      size: 16,
                      color: AppTheme.textMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Pet name
                Text(
                  pet.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),

                // Breed and age
                Text(
                  '${pet.breed} • ${pet.age} years old',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                if (pet.description != null && pet.description!.isNotEmpty)
                  Text(
                    pet.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),

                // Location and button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.textMedium,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet.location,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.textMedium,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetDetailPage(pet: pet),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
