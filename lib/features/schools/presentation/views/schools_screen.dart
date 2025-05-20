import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/models/get_all_schools/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/school_service/school_service.dart';
import '../../../../features/schools/presentation/views/school_view_details.dart';

class SchoolsScreen extends StatefulWidget {
  static const String id = 'SchoolsScreen';
  final void Function(ResultForAllSchools school) onSchoolSelected;
  final String countryName;
  const SchoolsScreen({
    super.key,
    required this.onSchoolSelected,
    required this.countryName,
  });

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ResultForAllSchools> _allSchools = [];
  List<ResultForAllSchools> _filteredSchools = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final SchoolService _schoolService = SchoolService();

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
        _allSchools = [];
        _filteredSchools = [];
      });

      final schools =
          await _schoolService.getAllSchools(countryName: widget.countryName);
      log(schools!.toJson().toString());

      // If we get null or empty results from the API
      if (schools.result == null || schools.result!.isEmpty) {
        setState(() {
          _errorMessage = 'No schools found. Please try again later.';
          _isLoading = false;
        });
        return;
      }

      // Filter schools by country name
      final filteredByCountry = schools.result!
          .where((school) =>
              school.country?.trim().toLowerCase() ==
              widget.countryName.trim().toLowerCase())
          .toList();

      if (filteredByCountry.isEmpty) {
        setState(() {
          _errorMessage = 'No schools found in ${widget.countryName}';
          _isLoading = false;
        });
        return;
      }

      // Update schools data
      setState(() {
        _allSchools = filteredByCountry;
        _filteredSchools = filteredByCountry;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('Exception:')
            ? e.toString().split('Exception: ').last
            : e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterSchools(String query) {
    if (_allSchools.isEmpty) {
      return;
    }

    setState(() {
      if (query.isEmpty) {
        _filteredSchools = _allSchools;
      } else {
        _filteredSchools = _allSchools
            .where((school) =>
                (school.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ||
                (school.address?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : _errorMessage.isNotEmpty
                      ? _buildErrorView()
                      : _buildSchoolsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schools',
                style: AppStyles.styleSemiBold20().copyWith(
                  fontSize: 28,
                  color: const Color(0xFF1A0F91),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Find the best school for your child',
                style: AppStyles.styleRegular14().copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              splashRadius: 5,
              icon: const Icon(Icons.filter_list, color: Color(0xFF1A0F91)),
              onPressed: () {
                // Show filter options
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterSchools,
        decoration: InputDecoration(
          hintText: 'Search schools...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.hexagonDots(
            color: const Color(0xFF1A0F91),
            size: 30,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading schools...',
            style: AppStyles.styleRegular14(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Failed to load schools',
            style: AppStyles.styleSemiBold20(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              style: AppStyles.styleRegular14(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadSchools,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A0F91),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Try Again',
              style: AppStyles.styleRegular14().copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolsList() {
    if (_filteredSchools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No schools found',
              style: AppStyles.styleSemiBold20(),
            ),
            const SizedBox(height: 10),
            Text(
              'Try adjusting your search',
              style: AppStyles.styleRegular14(),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: const Color(0xff1A0F91),
      backgroundColor: Colors.white,
      onRefresh: () async {
        await _loadSchools();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredSchools.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final school = _filteredSchools[index];
          return _buildAnimatedSchoolCard(school, index);
        },
      ),
    );
  }

  Widget _buildAnimatedSchoolCard(ResultForAllSchools school, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _buildSchoolCard(school),
    );
  }

  Widget _buildSchoolCard(ResultForAllSchools school) {
    // Safety check for null school
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            // First navigate to the details view
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchoolViewDetails(school: school),
              ),
            );
            // Then handle the selection if needed
            widget.onSchoolSelected(school);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  "https://school-api.runasp.net/${school.schoolLogo}",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                        height: 150,
                        child: Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    );
                  },
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
                        Expanded(
                          child: Text(
                            school.name ?? 'Unknown School',
                            style: AppStyles.styleSemiBold20(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A0F91).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD700),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getSchoolAge(school.createdOn),
                                style: AppStyles.styleRegular14().copyWith(
                                  color: const Color(0xFF1A0F91),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            school.address ?? 'Unknown Location',
                            style: AppStyles.styleRegular14().copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.email_outlined,
                          school.email ?? 'No email',
                          Colors.blue[100]!,
                          Colors.blue[700]!,
                        ),
                        const SizedBox(width: 10),
                        _buildInfoChip(
                          Icons.school_outlined,
                          school.country ?? 'School',
                          Colors.green[100]!,
                          Colors.green[700]!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      IconData icon, String label, Color bgColor, Color fgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: fgColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.styleRegular14().copyWith(
              color: fgColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper method to safely get the school age
  String _getSchoolAge(DateTime? createdOn) {
    if (createdOn == null) {
      return 'New';
    }
    try {
      final days = DateTime.now().difference(createdOn).inDays;
      if (days < 0) {
        return 'New';
      } else if (days == 0) {
        return 'Today';
      } else if (days < 30) {
        return '$days days';
      } else if (days < 365) {
        final months = (days / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'}';
      } else {
        final years = (days / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'}';
      }
    } catch (e) {
      return 'New';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
