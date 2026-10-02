import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/instructor_model.dart';

class InstructorDetailsScreen extends StatelessWidget {
  final InstructorModel instructor;

  const InstructorDetailsScreen({
    super.key,
    required this.instructor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final hasExperience = instructor.experience != null &&
        instructor.experience!.trim().isNotEmpty;
    final hasSpecialization = instructor.specialization != null &&
        instructor.specialization!.trim().isNotEmpty;
    final hasProfProfile = instructor.professionalProfile != null &&
        instructor.professionalProfile!.trim().isNotEmpty;
    final hasCareerJourney = instructor.careerJourney.isNotEmpty;
    final hasQualifications = instructor.qualifications.isNotEmpty;
    final hasBio =
        instructor.bio != null && instructor.bio!.trim().isNotEmpty;
    final hasContact = _hasContactInfo(instructor);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Instructor Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Profile Header Card
            _buildProfileHeaderCard(
              context,
              instructor,
              primaryColor,
              hasExperience: hasExperience,
              hasSpecialization: hasSpecialization,
            ),
            const SizedBox(height: 18),

            // 2. Professional Profile Section
            if (hasProfProfile) ...[
              _buildSectionCard(
                context: context,
                icon: Icons.badge_outlined,
                title: 'Professional Profile',
                child: Text(
                  instructor.professionalProfile!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMedium,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 3. Career Journey Section
            if (hasCareerJourney) ...[
              _buildSectionCard(
                context: context,
                icon: Icons.timeline_rounded,
                title: 'Career Journey',
                child: _buildCareerTimeline(instructor.careerJourney, primaryColor),
              ),
              const SizedBox(height: 18),
            ],

            // 4. Qualifications Section
            if (hasQualifications) ...[
              _buildSectionCard(
                context: context,
                icon: Icons.school_outlined,
                title: 'Qualifications',
                child: _buildQualificationsList(
                  instructor.qualifications,
                  primaryColor,
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 5. About the Instructor (Bio) Section
            if (hasBio) ...[
              _buildSectionCard(
                context: context,
                icon: Icons.person_outline_rounded,
                title: 'About the Instructor',
                child: Text(
                  instructor.bio!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMedium,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 6. Optional Contact Info (Rendered only if non-null and not empty)
            if (hasContact) ...[
              _buildContactSection(context, instructor, primaryColor),
              const SizedBox(height: 18),
            ],

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  bool _hasContactInfo(InstructorModel instructor) {
    final hasEmail =
        instructor.email != null && instructor.email!.trim().isNotEmpty;
    final hasLinkedIn =
        instructor.linkedin != null && instructor.linkedin!.trim().isNotEmpty;
    return hasEmail || hasLinkedIn;
  }

  /// 1. Profile Header Card
  Widget _buildProfileHeaderCard(
    BuildContext context,
    InstructorModel data,
    Color primaryColor, {
    required bool hasExperience,
    required bool hasSpecialization,
  }) {
    final effectiveDesignation = data.displayDesignation;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.25),
                width: 3.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarImage(data.photo, primaryColor),
            ),
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            data.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Designation
          Text(
            effectiveDesignation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),

          if (hasExperience || hasSpecialization) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppTheme.borderLight),
            const SizedBox(height: 14),

            // Experience Highlight
            if (hasExperience) ...[
              _buildHighlightItem(
                icon: Icons.workspace_premium_outlined,
                iconColor: const Color(0xFFE65100),
                iconBgColor: const Color(0xFFFFF3E0),
                label: 'Experience',
                value: data.experience!,
              ),
              if (hasSpecialization) const SizedBox(height: 10),
            ],

            // Specialization Highlight
            if (hasSpecialization) ...[
              _buildHighlightItem(
                icon: Icons.psychology_outlined,
                iconColor: primaryColor,
                iconBgColor: primaryColor.withValues(alpha: 0.1),
                label: 'Specialization',
                value: data.specialization!,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Card Wrapper
  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 14),

          // Section Content
          child,
        ],
      ),
    );
  }

  /// Career Timeline Widget
  Widget _buildCareerTimeline(
    List<CareerMilestoneItem> milestones,
    Color primaryColor,
  ) {
    return Column(
      children: List.generate(milestones.length, (index) {
        final item = milestones[index];
        final isLast = index == milestones.length - 1;
        final hasPeriod = item.period != null && item.period!.isNotEmpty;
        final isCurrent = hasPeriod &&
            item.period!.toLowerCase().contains('current');

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Period Badge (if period exists)
              if (hasPeriod)
                SizedBox(
                  width: 76,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFFE8F5E9)
                              : primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF81C784)
                                : primaryColor.withValues(alpha: 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          item.period!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? const Color(0xFF2E7D32)
                                : primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Bullet & Line
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? const Color(0xFF2E7D32) : primaryColor,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: (isCurrent
                                  ? const Color(0xFF2E7D32)
                                  : primaryColor)
                              .withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: AppTheme.borderLight,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Description
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
                  child: Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Qualifications List
  Widget _buildQualificationsList(
    List<QualificationModelItem> qualifications,
    Color primaryColor,
  ) {
    return Column(
      children: List.generate(qualifications.length, (index) {
        final item = qualifications[index];
        final isLast = index == qualifications.length - 1;
        final hasSubtitle =
            item.subtitle != null && item.subtitle!.trim().isNotEmpty;

        return Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderLight, width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              if (hasSubtitle) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  /// Optional Contact Section
  Widget _buildContactSection(
    BuildContext context,
    InstructorModel data,
    Color primaryColor,
  ) {
    return _buildSectionCard(
      context: context,
      icon: Icons.contact_mail_outlined,
      title: 'Contact Information',
      child: Column(
        children: [
          if (data.email != null && data.email!.trim().isNotEmpty)
            _buildContactTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: data.email!.trim(),
              primaryColor: primaryColor,
            ),
          if (data.linkedin != null && data.linkedin!.trim().isNotEmpty) ...[
            if (data.email != null && data.email!.trim().isNotEmpty)
              const SizedBox(height: 10),
            _buildContactTile(
              icon: Icons.link_rounded,
              label: 'LinkedIn',
              value: data.linkedin!.trim(),
              primaryColor: primaryColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Avatar Image Builder
  Widget _buildAvatarImage(String? photo, Color primaryColor) {
    if (photo != null && photo.trim().isNotEmpty) {
      final trimmed = photo.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return Image.network(
          trimmed,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderAvatar(primaryColor),
        );
      } else {
        return Image.asset(
          trimmed,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderAvatar(primaryColor),
        );
      }
    }
    return _buildPlaceholderAvatar(primaryColor);
  }

  Widget _buildPlaceholderAvatar(Color primaryColor) {
    return Container(
      color: primaryColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline_rounded,
        size: 52,
        color: primaryColor,
      ),
    );
  }
}
