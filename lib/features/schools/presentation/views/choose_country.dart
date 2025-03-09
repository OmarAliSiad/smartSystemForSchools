import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/school_service.dart';
import 'package:smartsystemforschools/features/schools/presentation/views/schools_screen.dart';

class PickCountry extends StatefulWidget {
  static const String id = 'PickCountry';
  const PickCountry({super.key});

  @override
  State<PickCountry> createState() => _PickCountryState();
}

class _PickCountryState extends State<PickCountry> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _allCountries = {};
  Set<String> _filteredCountries = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final schoolService = SchoolService();
      final schools = await schoolService.getAllSchools();

      if (schools?.result == null || schools!.result!.isEmpty) {
        setState(() {
          _errorMessage = 'No schools found. Please try again later.';
          _isLoading = false;
        });
        return;
      }

      // Extract unique countries from schools
      final uniqueCountries = schools.result!
          .where(
              (school) => school.country != null && school.country!.isNotEmpty)
          .map((school) => school.country!.trim().toLowerCase())
          .toSet();
      //egypt or EGypt or EGYPT =>egypt

      // Convert to sorted list and back to set to maintain order
      final sortedCountries = uniqueCountries.toList()..sort();

      // Capitalize first letter of each word for display
      final formattedCountries = sortedCountries.map((country) {
        //sadui arabic
        //Sadui Arabic
        return country.split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
      }).toSet();

      setState(() {
        _allCountries.clear();
        _allCountries.addAll(formattedCountries);
        _filteredCountries = Set.from(_allCountries);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = Set.from(_allCountries);
      } else {
        _filteredCountries = _allCountries
            .where((country) =>
                country.toLowerCase().contains(query.toLowerCase()))
            .toSet();
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
                      : _buildCountriesList(),
            ),
          ],
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
            size: 50,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading countries...',
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
            'Error Loading Countries',
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
            onPressed: loadCountries,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0F91)),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Country',
                style: AppStyles.styleSemiBold20().copyWith(
                  fontSize: 28,
                  color: const Color(0xFF1A0F91),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Choose your country to find schools',
                style: AppStyles.styleRegular14().copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
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
        onChanged: _filterCountries,
        decoration: InputDecoration(
          hintText: 'Search countries...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCountriesList() {
    if (_filteredCountries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No Countries Found',
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredCountries.length,
      itemBuilder: (context, index) {
        final country = _filteredCountries.elementAt(index);
        return _buildCountryCard(country);
      },
    );
  }

  Widget _buildCountryCard(String country) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchoolsScreen(
                  countryName: country,
                  onSchoolSelected: (school) {
                    Navigator.pop(context); // Pop SchoolsScreen
                    Navigator.pop(
                        context, school); // Pop PickCountry with result
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    country,
                    style: AppStyles.styleSemiBold20(),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
