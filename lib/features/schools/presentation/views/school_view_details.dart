import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/models/get_all_schools/result.dart';
import '../../../../core/models/get_school_details_by_id/get_school_details_by_id.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/services/school_service/school_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SchoolViewDetails extends StatefulWidget {
  static const String id = 'SchoolViewDetails';
  final ResultForAllSchools school;
  final bool? showButton;
  const SchoolViewDetails({
    super.key,
    required this.school,
    this.showButton,
  });

  @override
  State<SchoolViewDetails> createState() => _SchoolViewDetailsState();
}

class _SchoolViewDetailsState extends State<SchoolViewDetails>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String _errorMessage = '';
  SchoolDetails? _schoolDetails;
  final SchoolService _schoolService = SchoolService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadSchoolDetails();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSchoolDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final details =
          await _schoolService.getSchoolById(widget.school.schoolTenantId!);
      setState(() {
        _schoolDetails = details;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? const Color(0xFF536DFE) : const Color(0xFF1A0F91);
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor),
          titleTextStyle:
              AppStyles.styleSemiBold20().copyWith(color: primaryColor),
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.school.name ?? 'School Details',
            style: AppStyles.styleSemiBold20(),
          ),
        ),
        body: RefreshIndicator(
          backgroundColor: cardColor,
          color: primaryColor,
          onRefresh: _loadSchoolDetails,
          child: _isLoading
              ? _buildLoadingView(primaryColor)
              : _errorMessage.isNotEmpty
                  ? _buildErrorView(primaryColor, textColor, secondaryTextColor)
                  : _buildSchoolDetailsView(
                      primaryColor, cardColor, textColor, secondaryTextColor),
        ),
      ),
    );
  }

  Widget _buildLoadingView(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.hexagonDots(
            color: primaryColor,
            size: 50,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading school details...',
            style: AppStyles.styleRegular14(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
      Color primaryColor, Color textColor, Color? secondaryTextColor) {
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
            'Error Loading Details',
            style: AppStyles.styleSemiBold20().copyWith(color: textColor),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              style: AppStyles.styleRegular14()
                  .copyWith(color: secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadSchoolDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Try Again',
              style: AppStyles.styleRegular14().copyWith(color: Colors.white),
            ),
          )
              .animate()
              .fade(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        ],
      ),
    );
  }

  Widget _buildSchoolDetailsView(Color primaryColor, Color cardColor,
      Color textColor, Color? secondaryTextColor) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'school-logo-${widget.school.schoolTenantId}',
              child: _buildHeaderImage(cardColor),
            ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0),
            _buildSchoolInfo(cardColor, textColor, secondaryTextColor)
                .animate()
                .fade(duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
            _buildContactInfo(
                    primaryColor, cardColor, textColor, secondaryTextColor)
                .animate()
                .fade(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0),
            _buildAdditionalInfo(
                    primaryColor, cardColor, textColor, secondaryTextColor)
                .animate()
                .fade(duration: 600.ms, delay: 600.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            _buildButton(
              context,
              showButton: widget.showButton ?? true,
              schoolSelected: widget.school.name!,
              primaryColor: primaryColor,
            )
                .animate()
                .fade(duration: 600.ms, delay: 800.ms)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(Color cardColor) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          "https://school-api.runasp.net/${widget.school.schoolLogo}",
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
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.school_outlined,
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSchoolInfo(
      Color cardColor, Color textColor, Color? secondaryTextColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About School',
            style: AppStyles.styleSemiBold20().copyWith(color: textColor),
          ),
          const SizedBox(height: 10),
          Text(
            widget.school.description ?? 'No description available',
            style: AppStyles.styleRegular14().copyWith(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(Color primaryColor, Color cardColor, Color textColor,
      Color? secondaryTextColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: AppStyles.styleSemiBold20().copyWith(color: textColor),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email_outlined, widget.school.email ?? 'N/A',
              primaryColor, secondaryTextColor),
          const SizedBox(height: 12),
          _buildInfoRow(
              Icons.phone_outlined,
              widget.school.phoneNumber ?? 'N/A',
              primaryColor,
              secondaryTextColor),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined,
              widget.school.address ?? 'N/A', primaryColor, secondaryTextColor),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(Color primaryColor, Color cardColor,
      Color textColor, Color? secondaryTextColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: AppStyles.styleSemiBold20().copyWith(color: textColor),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Established: ${_getFormattedDate(widget.school.createdOn)}',
            primaryColor,
            secondaryTextColor,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_city_outlined,
            'Country: ${widget.school.country ?? 'N/A'}',
            primaryColor,
            secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String text, Color iconColor, Color? textColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppStyles.styleRegular14().copyWith(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  String _getFormattedDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildButton(
    BuildContext context, {
    required bool showButton,
    required String schoolSelected,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: showButton
          ? CustomButton(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              text: 'Confirm',
              textStyle: AppStyles.styleMedium16(),
              onPressed: () {
                Navigator.of(context).pop();
              },
              borderRadius: 16,
            )
          : const SizedBox(),
    );
  }
}
