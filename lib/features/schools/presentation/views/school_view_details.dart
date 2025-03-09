import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/models/get_all_schools/result.dart';
import 'package:smartsystemforschools/core/models/get_school_details_by_id/get_school_details_by_id.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/utils/school_service.dart';
import 'package:smartsystemforschools/features/login/presenation/views/sign_up_screen.dart';

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

class _SchoolViewDetailsState extends State<SchoolViewDetails> {
  bool _isLoading = true;
  String _errorMessage = '';
  SchoolDetails? _schoolDetails;
  final SchoolService _schoolService = SchoolService();

  @override
  void initState() {
    super.initState();
    _loadSchoolDetails();
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
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0F91)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.school.name ?? 'School Details',
          style: AppStyles.styleSemiBold20().copyWith(
            color: const Color(0xFF1A0F91),
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: const Color(0xff1A0F91),
        onRefresh: _loadSchoolDetails,
        child: _isLoading
            ? _buildLoadingView()
            : _errorMessage.isNotEmpty
                ? _buildErrorView()
                : _buildSchoolDetailsView(),
      ),
    );
  }

  Widget _buildLoadingView() {
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
            'Loading school details...',
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
            'Error Loading Details',
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
            onPressed: _loadSchoolDetails,
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

  Widget _buildSchoolDetailsView() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(),
          _buildSchoolInfo(),
          _buildContactInfo(),
          _buildAdditionalInfo(),
          const SizedBox(height: 20),
          _buildButton(
            context,
            showButton: widget.showButton ?? true,
            schoolSelected: widget.school.name!,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
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

  Widget _buildSchoolInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            style: AppStyles.styleSemiBold20(),
          ),
          const SizedBox(height: 10),
          Text(
            widget.school.description ?? 'No description available',
            style: AppStyles.styleRegular14().copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            style: AppStyles.styleSemiBold20(),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email_outlined, widget.school.email ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow(
              Icons.phone_outlined, widget.school.phoneNumber ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow(
              Icons.location_on_outlined, widget.school.address ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            style: AppStyles.styleSemiBold20(),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today_outlined,
              'Established: ${_getFormattedDate(widget.school.createdOn)}'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_city_outlined,
              'Country: ${widget.school.country ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1A0F91),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppStyles.styleRegular14().copyWith(
              color: Colors.grey[700],
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
}

Widget _buildButton(BuildContext context,
    {required bool showButton, required String schoolSelected}) {
  return Padding(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
    child: showButton
        ? CustomButton(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            text: 'confirm',
            textStyle: AppStyles.styleMedium16(),
            onPressed: () {
              Navigator.of(context).pop();
            },
            borderRadius: 16,
          )
        : const SizedBox(),
  );
}
