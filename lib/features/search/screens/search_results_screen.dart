import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/search/bloc/search_event.dart';
import 'package:jibon_Bachan_app/features/search/bloc/search_state.dart';
import 'package:jibon_Bachan_app/features/search/widgets/donor_card.dart';
import 'package:jibon_Bachan_app/features/search/widgets/search_filter_chip.dart';
import 'package:jibon_Bachan_app/features/search/widgets/search_input_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';

import '../bloc/search_bloc.dart';

class SearchResultsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const SearchResultsScreen({super.key, this.onBackPressed});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // Available filter options
  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  static const List<String> _cities = [
    'Dhaka',
    'Chittagong',
    'Sylhet',
    'Rajshahi',
  ];

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(const SearchInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, SearchState state) {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: widget.onBackPressed ?? () {},
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Jibon Daian', style: AppTextStyles.navTitle),
          Text(
            'Search Results',
            style: AppTextStyles.hospitalSub.copyWith(fontSize: 11),
          ),
        ],
      ),
      actions: [
        // Filter icon
        IconButton(
          onPressed: () => _showSortBottomSheet(context, state),
          icon: const Icon(Icons.tune, color: AppColors.primary, size: 22),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is SearchLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePaddingH,
              AppDimens.spaceMD,
              AppDimens.pagePaddingH,
              0,
            ),
            child: SearchInputField(
              initialValue: state.query,
              onChanged: (q) =>
                  context.read<SearchBloc>().add(SearchQueryChanged(q)),
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePaddingH,
              ),
              children: [
                // Blood group chips
                ...state.selectedBloodGroups.map(
                  (g) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SearchFilterChip(
                      label: '$g Group',
                      isSelected: true,
                      showRemove: true,
                      onTap: () => context.read<SearchBloc>().add(
                        SearchBloodGroupToggled(g),
                      ),
                    ),
                  ),
                ),

                // City chips
                ...state.selectedCities.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SearchFilterChip(
                      label: c,
                      isSelected: true,
                      showDropdown: true,
                      onTap: () =>
                          context.read<SearchBloc>().add(SearchCityToggled(c)),
                    ),
                  ),
                ),

                // Available filter chip
                SearchFilterChip(
                  label: 'Available',
                  isSelected: state.availableOnly,
                  onTap: () => context.read<SearchBloc>().add(
                    const SearchAvailabilityToggled(),
                  ),
                ),

                const SizedBox(width: 8),

                // Add more filters button
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context, state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FOUND ${state.totalFound} DONORS',
                  style: AppTextStyles.notifSectionHeader,
                ),
                GestureDetector(
                  onTap: () => _showSortBottomSheet(context, state),
                  child: Row(
                    children: [
                      Text('Sort by: ', style: AppTextStyles.hospitalSub),
                      Text(
                        _sortLabel(state.sortBy),
                        style: AppTextStyles.hospitalSub.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceSM),

          Expanded(
            child: state.results.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pagePaddingH,
                      vertical: AppDimens.spaceXS,
                    ),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final donor = state.results[index];
                      return DonorCard(
                        donor: donor,
                        onCall: () => _onCall(context, donor.phone),
                        onMessage: () => _onMessage(context, donor.id),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 60, color: AppColors.inputIcon),
          const SizedBox(height: 16),
          Text(
            'No donors found',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text('Try changing your filters', style: AppTextStyles.hospitalSub),
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, SearchState state) {
    final loaded = state is SearchLoaded ? state : null;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppDimens.pagePaddingH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),
            Text('Sort by', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimens.spaceMD),
            ...SearchSort.values.map((sort) {
              final isSelected = loaded?.sortBy == sort;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _sortLabel(sort),
                  style: AppTextStyles.hospitalName,
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<SearchBloc>().add(SearchSortChanged(sort));
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: AppDimens.spaceMD),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, SearchLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<SearchBloc>(),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Padding(
            padding: const EdgeInsets.all(AppDimens.pagePaddingH),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMD),
                Text('Blood Group', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _bloodGroups.map((g) {
                    final isSelected = state.selectedBloodGroups.contains(g);
                    return SearchFilterChip(
                      label: g,
                      isSelected: isSelected,
                      onTap: () => context.read<SearchBloc>().add(
                        SearchBloodGroupToggled(g),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimens.spaceLG),
                Text('City', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppDimens.spaceSM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _cities.map((c) {
                    final isSelected = state.selectedCities.contains(c);
                    return SearchFilterChip(
                      label: c,
                      isSelected: isSelected,
                      onTap: () =>
                          context.read<SearchBloc>().add(SearchCityToggled(c)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimens.spaceLG),
                // Clear all
                GestureDetector(
                  onTap: () {
                    context.read<SearchBloc>().add(
                      const SearchFiltersCleared(),
                    );
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'Clear All Filters',
                      style: AppTextStyles.authLinkBold,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sortLabel(SearchSort sort) {
    switch (sort) {
      case SearchSort.nearest:
        return 'Nearest';
      case SearchSort.latest:
        return 'Latest';
      case SearchSort.available:
        return 'Available';
    }
  }

  void _onCall(BuildContext context, String? phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${phone ?? '...'}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onMessage(BuildContext context, String donorId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening message...'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
