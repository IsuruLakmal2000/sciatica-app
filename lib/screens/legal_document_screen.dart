import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/legal_translations.dart';

enum LegalDocType {
  privacyPolicy,
  termsOfUse,
  medicalDisclaimer,
}

class LegalDocumentScreen extends StatelessWidget {
  final LegalDocType docType;

  const LegalDocumentScreen({
    super.key,
    required this.docType,
  });

  String _getTitle(Map<String, dynamic> trans) {
    switch (docType) {
      case LegalDocType.privacyPolicy:
        return trans['privacy_policy_title'] ?? 'Privacy Policy';
      case LegalDocType.termsOfUse:
        return trans['terms_of_use_title'] ?? 'Terms of Use';
      case LegalDocType.medicalDisclaimer:
        return trans['medical_disclaimer_title'] ?? 'Medical Disclaimer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final trans = legalTranslations[languageCode] ?? legalTranslations['en'] ?? {};

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getTitle(trans),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildContent(trans),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(Map<String, dynamic> trans) {
    switch (docType) {
      case LegalDocType.privacyPolicy:
        return _buildPrivacyPolicy(trans);
      case LegalDocType.termsOfUse:
        return _buildTermsOfUse(trans);
      case LegalDocType.medicalDisclaimer:
        return _buildMedicalDisclaimer(trans);
    }
  }

  List<Widget> _buildPrivacyPolicy(Map<String, dynamic> trans) {
    return [
      _buildHeading(trans['privacy_h1'] ?? '1. Data Privacy Commitment'),
      _buildParagraph(
          trans['privacy_p1'] ?? 'Sciatica Relief is built with a privacy-first architecture. We strongly believe that your personal health and recovery journey is private to you.'),
      _buildHeading(trans['privacy_h2'] ?? '2. No Remote Storage or Sharing'),
      _buildParagraph(
          trans['privacy_p2'] ?? 'We do NOT collect, transmit, store, or share any of your personal details, physical condition logs, pain entries, settings, or exercise progress on any external servers or databases.'),
      _buildHeading(trans['privacy_h3'] ?? '3. Complete Local Storage'),
      _buildParagraph(
          trans['privacy_p3'] ?? 'All data created or recorded within this app is saved exclusively locally on your physical device. The app operates fully offline, and your data never leaves your device. Please note that uninstalling the app or clearing the app data will permanently erase all your progress and logs.'),
      _buildHeading(trans['privacy_h4'] ?? '4. Analytics & Tracking'),
      _buildParagraph(
          trans['privacy_p4'] ?? 'We do not integrate any third-party tracking toolkits, advertising networks, or user behavior analytics SDKs. Your app usage is private and untracked.'),
      _buildHeading(trans['privacy_h5'] ?? '5. Updates to this Policy'),
      _buildParagraph(
          trans['privacy_p5'] ?? 'This Privacy Policy may be updated occasionally. Any changes will be posted here on this page inside the app. By continuing to use the app, you agree to these privacy practices.'),
      const SizedBox(height: 40),
    ];
  }

  List<Widget> _buildTermsOfUse(Map<String, dynamic> trans) {
    return [
      _buildHeading(trans['terms_h1'] ?? '1. Agreement to Terms'),
      _buildParagraph(
          trans['terms_p1'] ?? 'By downloading, installing, or using Sciatica Relief, you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please uninstall the app immediately.'),
      _buildHeading(trans['terms_h2'] ?? '2. App Usage & Safety Rules'),
      _buildParagraph(
          trans['terms_p2'] ?? '• Follow all exercise descriptions and instructions slowly and carefully.\n'
          '• Never push through sharp, sudden pain, or worsening symptoms. If you experience discomfort, stop the exercise immediately.\n'
          '• The app is designed for individuals with chronic/mild discomfort. It is not suitable for severe, acute neurological deficits.'),
      _buildHeading(trans['terms_h3'] ?? '3. Medical Advice Disclaimer'),
      _buildParagraph(
          trans['terms_p3'] ?? 'The exercises, tutorials, and trackers provided are strictly for educational and physical conditioning purposes. This application is not a substitute for professional physical therapy, diagnosis, or medical care.'),
      _buildHeading(trans['terms_h4'] ?? '4. Device & Data Maintenance'),
      _buildParagraph(
          trans['terms_p4'] ?? 'Your progress and preferences are saved only on your device. The developers are not responsible for any data loss occurring due to hardware failure, operating system updates, or app deletion.'),
      _buildHeading(trans['terms_h5'] ?? '5. Limitation of Liability'),
      _buildParagraph(
          trans['terms_p5'] ?? 'To the maximum extent permitted by law, the developers of Sciatica Relief shall not be held liable for any direct, indirect, incidental, or consequential damages, including personal injury, physical harm, or health complications resulting from the use or inability to use this app.'),
      const SizedBox(height: 40),
    ];
  }

  List<Widget> _buildMedicalDisclaimer(Map<String, dynamic> trans) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dangerRed.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.dangerRed.withAlpha(40)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.dangerRed, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                trans['disclaimer_warning'] ?? 'IMPORTANT MEDICAL DISCLAIMER',
                style: TextStyle(
                  color: AppColors.dangerRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _buildHeading(trans['disclaimer_h1'] ?? '1. Not a Substitute for Medical Advice'),
      _buildParagraph(
          trans['disclaimer_p1'] ?? 'The content, exercises, stretches, routines, and educational materials provided in Sciatica Relief are for informational and physical rehabilitation tracking purposes only.\n\n'
          'They do NOT constitute medical diagnosis, treatment recommendations, or professional clinical advice.'),
      _buildHeading(trans['disclaimer_h2'] ?? '2. Always Consult a Physician'),
      _buildParagraph(
          trans['disclaimer_p2'] ?? 'You MUST consult with a qualified doctor, physician, or physical therapist before starting this or any physical exercise program, especially if you have chronic back pain, shooting leg pain, or are pregnant.\n\n'
          'Do not ignore professional medical advice or delay seeking treatment because of information read in this app.'),
      _buildHeading(trans['disclaimer_h3'] ?? '3. Red Flags & Emergencies'),
      _buildParagraph(
          trans['disclaimer_p3'] ?? 'If you experience any of the following symptoms, STOP exercising immediately and seek emergency medical care:\n'
          '• Sudden loss of bowel or bladder control\n'
          '• Progressive weakness or numbness in one or both legs (e.g., foot drop)\n'
          '• Saddle anesthesia (numbness in your groin, buttocks, or inner thighs)\n'
          'These symptoms may indicate Cauda Equina Syndrome, a serious medical emergency requiring urgent attention.'),
      _buildHeading(trans['disclaimer_h4'] ?? '4. Accept at Your Own Risk'),
      _buildParagraph(
          trans['disclaimer_p4'] ?? 'By using the exercises in this app, you acknowledge that all physical activity carries inherent risk of injury. You agree to perform all exercises at your own risk and responsibility.'),
      const SizedBox(height: 40),
    ];
  }

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
