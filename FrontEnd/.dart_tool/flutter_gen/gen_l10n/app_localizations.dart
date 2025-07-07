import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get pleaseLogin;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you a verification code to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @failedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP: {error}'**
  String failedToResendOtp(Object error);

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @verificationDesc.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to\n{phone} on WhatsApp.'**
  String verificationDesc(Object phone);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds} seconds'**
  String resendCodeIn(Object seconds);

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP verified!'**
  String get otpVerified;

  /// No description provided for @otpVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'OTP verification failed: {error}'**
  String otpVerificationFailed(Object error);

  /// No description provided for @otpMustBeNumeric.
  ///
  /// In en, this message translates to:
  /// **'OTP must be numeric'**
  String get otpMustBeNumeric;

  /// No description provided for @pleaseEnterCompleteVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete verification code'**
  String get pleaseEnterCompleteVerificationCode;

  /// No description provided for @otpResentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully!'**
  String get otpResentSuccessfully;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get verificationCodeSent;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordDesc.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from your previous password.'**
  String get passwordDesc;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get passwordReset;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillAllFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed: {error}'**
  String passwordResetFailed(Object error);

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @searchAllergies.
  ///
  /// In en, this message translates to:
  /// **'Search allergies...'**
  String get searchAllergies;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get filter;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @threeMonths.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get threeMonths;

  /// No description provided for @sixMonths.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get sixMonths;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @addNewAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add New Allergy'**
  String get addNewAllergy;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noAllergiesFound.
  ///
  /// In en, this message translates to:
  /// **'No allergies found'**
  String get noAllergiesFound;

  /// No description provided for @addFirstAllergy.
  ///
  /// In en, this message translates to:
  /// **'Add your first allergy or try a different search'**
  String get addFirstAllergy;

  /// No description provided for @editAllergy.
  ///
  /// In en, this message translates to:
  /// **'Edit Allergy'**
  String get editAllergy;

  /// No description provided for @deleteAllergy.
  ///
  /// In en, this message translates to:
  /// **'Delete Allergy'**
  String get deleteAllergy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @allergyName.
  ///
  /// In en, this message translates to:
  /// **'Allergy Name'**
  String get allergyName;

  /// No description provided for @enterAllergyName.
  ///
  /// In en, this message translates to:
  /// **'Enter allergy name'**
  String get enterAllergyName;

  /// No description provided for @enterDate.
  ///
  /// In en, this message translates to:
  /// **'Enter Date'**
  String get enterDate;

  /// No description provided for @saveAllergy.
  ///
  /// In en, this message translates to:
  /// **'Save Allergy'**
  String get saveAllergy;

  /// No description provided for @updateAllergy.
  ///
  /// In en, this message translates to:
  /// **'Update Allergy'**
  String get updateAllergy;

  /// No description provided for @vaccines.
  ///
  /// In en, this message translates to:
  /// **'Vaccines'**
  String get vaccines;

  /// No description provided for @searchVaccines.
  ///
  /// In en, this message translates to:
  /// **'Search vaccines...'**
  String get searchVaccines;

  /// No description provided for @addNewVaccine.
  ///
  /// In en, this message translates to:
  /// **'Add New Vaccine'**
  String get addNewVaccine;

  /// No description provided for @noVaccinesFound.
  ///
  /// In en, this message translates to:
  /// **'No vaccines found'**
  String get noVaccinesFound;

  /// No description provided for @addFirstVaccine.
  ///
  /// In en, this message translates to:
  /// **'Add your first vaccine or try a different search'**
  String get addFirstVaccine;

  /// No description provided for @editVaccine.
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccine'**
  String get editVaccine;

  /// No description provided for @deleteVaccine.
  ///
  /// In en, this message translates to:
  /// **'Delete Vaccine'**
  String get deleteVaccine;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name'**
  String get vaccineName;

  /// No description provided for @enterVaccineName.
  ///
  /// In en, this message translates to:
  /// **'Enter vaccine name'**
  String get enterVaccineName;

  /// No description provided for @saveVaccine.
  ///
  /// In en, this message translates to:
  /// **'Save Vaccine'**
  String get saveVaccine;

  /// No description provided for @updateVaccine.
  ///
  /// In en, this message translates to:
  /// **'Update Vaccine'**
  String get updateVaccine;

  /// No description provided for @chronics.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronics;

  /// No description provided for @searchChronics.
  ///
  /// In en, this message translates to:
  /// **'Search chronic diseases...'**
  String get searchChronics;

  /// No description provided for @addNewChronic.
  ///
  /// In en, this message translates to:
  /// **'Add New Chronic Disease'**
  String get addNewChronic;

  /// No description provided for @noChronicsFound.
  ///
  /// In en, this message translates to:
  /// **'No chronic diseases found'**
  String get noChronicsFound;

  /// No description provided for @addFirstChronic.
  ///
  /// In en, this message translates to:
  /// **'Add your first chronic disease or try a different search'**
  String get addFirstChronic;

  /// No description provided for @editChronic.
  ///
  /// In en, this message translates to:
  /// **'Edit Chronic Disease'**
  String get editChronic;

  /// No description provided for @deleteChronic.
  ///
  /// In en, this message translates to:
  /// **'Delete Chronic Disease'**
  String get deleteChronic;

  /// No description provided for @chronicName.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get chronicName;

  /// No description provided for @enterChronicName.
  ///
  /// In en, this message translates to:
  /// **'Enter disease name'**
  String get enterChronicName;

  /// No description provided for @saveChronic.
  ///
  /// In en, this message translates to:
  /// **'Save Chronic Disease'**
  String get saveChronic;

  /// No description provided for @updateChronic.
  ///
  /// In en, this message translates to:
  /// **'Update Chronic Disease'**
  String get updateChronic;

  /// No description provided for @medicalExaminations.
  ///
  /// In en, this message translates to:
  /// **'Medical Examinations'**
  String get medicalExaminations;

  /// No description provided for @searchExaminations.
  ///
  /// In en, this message translates to:
  /// **'Search examinations...'**
  String get searchExaminations;

  /// No description provided for @addNewExamination.
  ///
  /// In en, this message translates to:
  /// **'Add New Examination'**
  String get addNewExamination;

  /// No description provided for @saveExamination.
  ///
  /// In en, this message translates to:
  /// **'Save Examination'**
  String get saveExamination;

  /// No description provided for @updateExamination.
  ///
  /// In en, this message translates to:
  /// **'Update Examination'**
  String get updateExamination;

  /// No description provided for @editExamination.
  ///
  /// In en, this message translates to:
  /// **'Edit Examination'**
  String get editExamination;

  /// No description provided for @deleteExamination.
  ///
  /// In en, this message translates to:
  /// **'Delete Examination'**
  String get deleteExamination;

  /// No description provided for @examinationName.
  ///
  /// In en, this message translates to:
  /// **'Examination Name *'**
  String get examinationName;

  /// No description provided for @enterExaminationName.
  ///
  /// In en, this message translates to:
  /// **'Enter examination name'**
  String get enterExaminationName;

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get uploadPdf;

  /// No description provided for @uploadPdfFile.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF file'**
  String get uploadPdfFile;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @noExaminationsFound.
  ///
  /// In en, this message translates to:
  /// **'No examinations found'**
  String get noExaminationsFound;

  /// No description provided for @addFirstExamination.
  ///
  /// In en, this message translates to:
  /// **'Add your first examination or try a different search'**
  String get addFirstExamination;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseUploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Please upload a PDF file'**
  String get pleaseUploadPdf;

  /// No description provided for @examinationUploaded.
  ///
  /// In en, this message translates to:
  /// **'Examination uploaded successfully!'**
  String get examinationUploaded;

  /// No description provided for @examinationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Examination updated successfully!'**
  String get examinationUpdated;

  /// No description provided for @failedToUploadExamination.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload examination'**
  String get failedToUploadExamination;

  /// No description provided for @failedToUpdateExamination.
  ///
  /// In en, this message translates to:
  /// **'Failed to update examination'**
  String get failedToUpdateExamination;

  /// No description provided for @failedToFetchExaminations.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch examinations'**
  String get failedToFetchExaminations;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get failedToDelete;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get deleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please login again.'**
  String get authenticationError;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @addNewMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add New Medicine'**
  String get addNewMedicine;

  /// No description provided for @yourMedications.
  ///
  /// In en, this message translates to:
  /// **'Your Medications'**
  String get yourMedications;

  /// No description provided for @noMedicationsFound.
  ///
  /// In en, this message translates to:
  /// **'No medications found'**
  String get noMedicationsFound;

  /// No description provided for @addFirstMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add your first medicine or try a different search'**
  String get addFirstMedicine;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'restored'**
  String get restored;

  /// No description provided for @scanMedicine.
  ///
  /// In en, this message translates to:
  /// **'Scan Medicine'**
  String get scanMedicine;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get fromGallery;

  /// No description provided for @errorOpeningCamera.
  ///
  /// In en, this message translates to:
  /// **'Error opening camera'**
  String get errorOpeningCamera;

  /// No description provided for @medicineAdded.
  ///
  /// In en, this message translates to:
  /// **'Medicine added successfully!'**
  String get medicineAdded;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @medicationCenter.
  ///
  /// In en, this message translates to:
  /// **'Medication Center'**
  String get medicationCenter;

  /// No description provided for @manageMedications.
  ///
  /// In en, this message translates to:
  /// **'Manage your medications or explore drug information'**
  String get manageMedications;

  /// No description provided for @myMedications.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get myMedications;

  /// No description provided for @trackMedications.
  ///
  /// In en, this message translates to:
  /// **'Track your current medications, set reminders, and manage dosages'**
  String get trackMedications;

  /// No description provided for @medicationAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Medication Analytics'**
  String get medicationAnalytics;

  /// No description provided for @viewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View dynamic charts, track adherence, and analyze medication patterns'**
  String get viewAnalytics;

  /// No description provided for @drugInformation.
  ///
  /// In en, this message translates to:
  /// **'Drug Information'**
  String get drugInformation;

  /// No description provided for @searchLearn.
  ///
  /// In en, this message translates to:
  /// **'Search and learn about medications, side effects, and interactions'**
  String get searchLearn;

  /// No description provided for @quickTip.
  ///
  /// In en, this message translates to:
  /// **'Quick Tip'**
  String get quickTip;

  /// No description provided for @consultProvider.
  ///
  /// In en, this message translates to:
  /// **'Always consult with your healthcare provider before starting, stopping, or changing any medication.'**
  String get consultProvider;

  /// No description provided for @dataSecure.
  ///
  /// In en, this message translates to:
  /// **'All medication data is securely stored and protected'**
  String get dataSecure;

  /// No description provided for @medicationDetails.
  ///
  /// In en, this message translates to:
  /// **'Medication Details'**
  String get medicationDetails;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @dosageInformation.
  ///
  /// In en, this message translates to:
  /// **'Dosage Information'**
  String get dosageInformation;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @afterMeal.
  ///
  /// In en, this message translates to:
  /// **'After Meal'**
  String get afterMeal;

  /// No description provided for @beforeMeal.
  ///
  /// In en, this message translates to:
  /// **'Before Meal'**
  String get beforeMeal;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// No description provided for @nextDose.
  ///
  /// In en, this message translates to:
  /// **'Next Dose'**
  String get nextDose;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @medicineInfo.
  ///
  /// In en, this message translates to:
  /// **'Medicine Info'**
  String get medicineInfo;

  /// No description provided for @searchForMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Search for medicine name...'**
  String get searchForMedicineName;

  /// No description provided for @searchingMedicineInfo.
  ///
  /// In en, this message translates to:
  /// **'Searching medicine information...'**
  String get searchingMedicineInfo;

  /// No description provided for @searchForMedicineInformation.
  ///
  /// In en, this message translates to:
  /// **'Search for Medicine Information'**
  String get searchForMedicineInformation;

  /// No description provided for @enterMedicineNameInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter a medicine name to get detailed information'**
  String get enterMedicineNameInfo;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples: Aspirin, Metformin, Lisinopril'**
  String get examples;

  /// No description provided for @medicineNotFound.
  ///
  /// In en, this message translates to:
  /// **'Medicine Not Found'**
  String get medicineNotFound;

  /// No description provided for @medicineNotFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find information for \"{medicineName}\"\nTry searching with a different name'**
  String medicineNotFoundDesc(Object medicineName);

  /// No description provided for @searchAgain.
  ///
  /// In en, this message translates to:
  /// **'Search Again'**
  String get searchAgain;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @activeIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active Ingredient'**
  String get activeIngredient;

  /// No description provided for @dosageAdmin.
  ///
  /// In en, this message translates to:
  /// **'Dosage & Administration'**
  String get dosageAdmin;

  /// No description provided for @alternativeMedicines.
  ///
  /// In en, this message translates to:
  /// **'Alternative Medicines'**
  String get alternativeMedicines;

  /// No description provided for @sideEffects.
  ///
  /// In en, this message translates to:
  /// **'Side Effects'**
  String get sideEffects;

  /// No description provided for @warnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get warnings;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @fetchMedicineError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch medicine information. Please check your internet connection and try again.'**
  String get fetchMedicineError;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save Medicine'**
  String get saveMedicine;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @enterMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Enter medicine name'**
  String get enterMedicineName;

  /// No description provided for @pleaseEnterMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter medicine name'**
  String get pleaseEnterMedicineName;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @enterDoseAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter dose amount'**
  String get enterDoseAmount;

  /// No description provided for @timesPerDay.
  ///
  /// In en, this message translates to:
  /// **'Times per Day'**
  String get timesPerDay;

  /// No description provided for @whenToTake.
  ///
  /// In en, this message translates to:
  /// **'When to Take'**
  String get whenToTake;

  /// No description provided for @afterMealOption.
  ///
  /// In en, this message translates to:
  /// **'After Meal'**
  String get afterMealOption;

  /// No description provided for @afterMealDesc.
  ///
  /// In en, this message translates to:
  /// **'Take medicine after eating'**
  String get afterMealDesc;

  /// No description provided for @beforeMealOption.
  ///
  /// In en, this message translates to:
  /// **'Before Meal'**
  String get beforeMealOption;

  /// No description provided for @beforeMealDesc.
  ///
  /// In en, this message translates to:
  /// **'Take medicine before eating'**
  String get beforeMealDesc;

  /// No description provided for @saveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get saveSchedule;

  /// No description provided for @enterStartDate.
  ///
  /// In en, this message translates to:
  /// **'Enter Start Date'**
  String get enterStartDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @enterStartTime.
  ///
  /// In en, this message translates to:
  /// **'Enter Start Time'**
  String get enterStartTime;

  /// No description provided for @selectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get selectStartTime;

  /// No description provided for @hoursPerDay.
  ///
  /// In en, this message translates to:
  /// **'Hours per day'**
  String get hoursPerDay;

  /// No description provided for @scheduleSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved for {medicineName}'**
  String scheduleSaved(Object medicineName);

  /// No description provided for @pleaseSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select both date and time'**
  String get pleaseSelectDateTime;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @doctorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Doctor Dashboard'**
  String get doctorDashboard;

  /// No description provided for @patientDashboard.
  ///
  /// In en, this message translates to:
  /// **'Patient Dashboard'**
  String get patientDashboard;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcome(Object name);

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelp;

  /// No description provided for @manageDoctors.
  ///
  /// In en, this message translates to:
  /// **'Manage Doctors'**
  String get manageDoctors;

  /// No description provided for @managePatients.
  ///
  /// In en, this message translates to:
  /// **'Manage Patients'**
  String get managePatients;

  /// No description provided for @verifyLicenses.
  ///
  /// In en, this message translates to:
  /// **'Verify Licenses'**
  String get verifyLicenses;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// No description provided for @allSystemsOperational.
  ///
  /// In en, this message translates to:
  /// **'All systems operational. always check pending license verifications.'**
  String get allSystemsOperational;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @sessionRecords.
  ///
  /// In en, this message translates to:
  /// **'Session Records'**
  String get sessionRecords;

  /// No description provided for @professionalTip.
  ///
  /// In en, this message translates to:
  /// **'Professional Tip'**
  String get professionalTip;

  /// No description provided for @verifyPatientIdentity.
  ///
  /// In en, this message translates to:
  /// **'Always verify patient identity before starting consultation.'**
  String get verifyPatientIdentity;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @findDoctors.
  ///
  /// In en, this message translates to:
  /// **'Find Doctors'**
  String get findDoctors;

  /// No description provided for @askChatbot.
  ///
  /// In en, this message translates to:
  /// **'Ask Chatbot'**
  String get askChatbot;

  /// No description provided for @healthTips.
  ///
  /// In en, this message translates to:
  /// **'Health Tips'**
  String get healthTips;

  /// No description provided for @stayHydrated.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated'**
  String get stayHydrated;

  /// No description provided for @drinkWaterTip.
  ///
  /// In en, this message translates to:
  /// **'Drink at least 8 glasses of water daily to maintain good health.'**
  String get drinkWaterTip;

  /// No description provided for @areYouSureSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @cancelChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Cancel Change Password'**
  String get cancelChangePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get enterOldPassword;

  /// No description provided for @enterAtLeast6Chars.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 6 characters'**
  String get enterAtLeast6Chars;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String failedToUpdateProfile(Object error);

  /// No description provided for @showQrCode.
  ///
  /// In en, this message translates to:
  /// **'Show QR Code'**
  String get showQrCode;

  /// No description provided for @patientQrCode.
  ///
  /// In en, this message translates to:
  /// **'Patient QR Code'**
  String get patientQrCode;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @clinicAddress.
  ///
  /// In en, this message translates to:
  /// **'Clinic Adress'**
  String get clinicAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @bloodPressureReading.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Reading'**
  String get bloodPressureReading;

  /// No description provided for @editBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Edit Blood Pressure'**
  String get editBloodPressure;

  /// No description provided for @editReading.
  ///
  /// In en, this message translates to:
  /// **'Edit Reading'**
  String get editReading;

  /// No description provided for @deleteReading.
  ///
  /// In en, this message translates to:
  /// **'Delete Reading'**
  String get deleteReading;

  /// No description provided for @deleteReadingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this blood pressure reading?'**
  String get deleteReadingConfirm;

  /// No description provided for @addNewReading.
  ///
  /// In en, this message translates to:
  /// **'Add New Reading'**
  String get addNewReading;

  /// No description provided for @recordYourBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Record your blood pressure'**
  String get recordYourBloodPressure;

  /// No description provided for @bloodPressureValues.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Values'**
  String get bloodPressureValues;

  /// No description provided for @systolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get systolic;

  /// No description provided for @diastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get diastolic;

  /// No description provided for @pulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulse;

  /// No description provided for @upperNumber.
  ///
  /// In en, this message translates to:
  /// **'Upper number'**
  String get upperNumber;

  /// No description provided for @lowerNumber.
  ///
  /// In en, this message translates to:
  /// **'Lower number'**
  String get lowerNumber;

  /// No description provided for @heartRateBpm.
  ///
  /// In en, this message translates to:
  /// **'Heart rate (bpm)'**
  String get heartRateBpm;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @healthAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Health Analysis'**
  String get healthAnalysis;

  /// No description provided for @saveReading.
  ///
  /// In en, this message translates to:
  /// **'Save Reading'**
  String get saveReading;

  /// No description provided for @updateReading.
  ///
  /// In en, this message translates to:
  /// **'Update Reading'**
  String get updateReading;

  /// No description provided for @bloodPressureAdded.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure added successfully'**
  String get bloodPressureAdded;

  /// No description provided for @bloodPressureUpdated.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure updated successfully'**
  String get bloodPressureUpdated;

  /// No description provided for @bloodPressureDeleted.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure deleted successfully'**
  String get bloodPressureDeleted;

  /// No description provided for @failedToUpdateBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Failed to update blood pressure: {error}'**
  String failedToUpdateBloodPressure(Object error);

  /// No description provided for @failedToDeleteBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete blood pressure: {error}'**
  String failedToDeleteBloodPressure(Object error);

  /// No description provided for @noReadingsFound.
  ///
  /// In en, this message translates to:
  /// **'No readings found'**
  String get noReadingsFound;

  /// No description provided for @noReadingsFoundFilters.
  ///
  /// In en, this message translates to:
  /// **'No readings found for the selected filters'**
  String get noReadingsFoundFilters;

  /// No description provided for @avgSys.
  ///
  /// In en, this message translates to:
  /// **'Avg Sys'**
  String get avgSys;

  /// No description provided for @avgDia.
  ///
  /// In en, this message translates to:
  /// **'Avg Dia'**
  String get avgDia;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @pleaseEnterSystolic.
  ///
  /// In en, this message translates to:
  /// **'Please enter systolic value'**
  String get pleaseEnterSystolic;

  /// No description provided for @pleaseEnterDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Please enter diastolic value'**
  String get pleaseEnterDiastolic;

  /// No description provided for @pleaseEnterPulse.
  ///
  /// In en, this message translates to:
  /// **'Please enter pulse value'**
  String get pleaseEnterPulse;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @normalBpAdvice.
  ///
  /// In en, this message translates to:
  /// **'Great! Maintain a healthy lifestyle with regular exercise and balanced diet.'**
  String get normalBpAdvice;

  /// No description provided for @lowBpAdvice.
  ///
  /// In en, this message translates to:
  /// **'Consider consulting your doctor if you experience symptoms like dizziness or fatigue.'**
  String get lowBpAdvice;

  /// No description provided for @elevatedBpAdvice.
  ///
  /// In en, this message translates to:
  /// **'Consider lifestyle changes like reducing sodium intake and increasing physical activity.'**
  String get elevatedBpAdvice;

  /// No description provided for @highBpAdvice.
  ///
  /// In en, this message translates to:
  /// **'Consult your healthcare provider for proper evaluation and treatment options.'**
  String get highBpAdvice;

  /// No description provided for @elevatedBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Elevated Blood Pressure'**
  String get elevatedBloodPressure;

  /// No description provided for @prescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// No description provided for @medicalPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'Medical Prescriptions'**
  String get medicalPrescriptions;

  /// No description provided for @addNewPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add New Prescription'**
  String get addNewPrescription;

  /// No description provided for @addPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add Prescription'**
  String get addPrescription;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @enterDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Enter doctor name'**
  String get enterDoctorName;

  /// No description provided for @enterSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Enter specialization'**
  String get enterSpecialization;

  /// No description provided for @enterClinicAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter clinic address'**
  String get enterClinicAddress;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @examinations.
  ///
  /// In en, this message translates to:
  /// **'Examinations'**
  String get examinations;

  /// No description provided for @enterExamination.
  ///
  /// In en, this message translates to:
  /// **'Enter examination'**
  String get enterExamination;

  /// No description provided for @diagnoses.
  ///
  /// In en, this message translates to:
  /// **'Diagnoses'**
  String get diagnoses;

  /// No description provided for @enterDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Enter the patient\'s diagnosis and medical condition'**
  String get enterDiagnosis;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter notes'**
  String get enterNotes;

  /// No description provided for @savePrescription.
  ///
  /// In en, this message translates to:
  /// **'Save Prescription'**
  String get savePrescription;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @deletePrescription.
  ///
  /// In en, this message translates to:
  /// **'Delete Prescription'**
  String get deletePrescription;

  /// No description provided for @deletePrescriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this prescription from Dr. {doctorName}?'**
  String deletePrescriptionConfirm(Object doctorName);

  /// No description provided for @prescriptionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Prescription deleted successfully'**
  String get prescriptionDeleted;

  /// No description provided for @prescriptionCaptured.
  ///
  /// In en, this message translates to:
  /// **'Prescription captured successfully!'**
  String get prescriptionCaptured;

  /// No description provided for @prescriptionPdfSaved.
  ///
  /// In en, this message translates to:
  /// **'PDF saved to: {path}'**
  String prescriptionPdfSaved(Object path);

  /// No description provided for @noPrescriptionsFound.
  ///
  /// In en, this message translates to:
  /// **'No prescriptions found'**
  String get noPrescriptionsFound;

  /// No description provided for @noPrescriptionsFoundRange.
  ///
  /// In en, this message translates to:
  /// **'No prescriptions found for the selected date range'**
  String get noPrescriptionsFoundRange;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @doctorNotes.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s Notes'**
  String get doctorNotes;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @scanPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan prescription'**
  String get scanPrescription;

  /// No description provided for @pleaseEnterClinicAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter clinic address'**
  String get pleaseEnterClinicAddress;

  /// No description provided for @pleaseEnterSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Please enter specialization'**
  String get pleaseEnterSpecialization;

  /// No description provided for @pleaseEnterDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter doctor name'**
  String get pleaseEnterDoctorName;

  /// No description provided for @uploadImageFile.
  ///
  /// In en, this message translates to:
  /// **'Upload image file'**
  String get uploadImageFile;

  /// No description provided for @failedToUploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload PDF'**
  String get failedToUploadPdf;

  /// No description provided for @pdfUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF uploaded successfully'**
  String get pdfUploadedSuccessfully;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @pleaseEnterAtLeastOneMedicine.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one medicine'**
  String get pleaseEnterAtLeastOneMedicine;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF'**
  String get generatingPdf;

  /// No description provided for @downloadingPrescription.
  ///
  /// In en, this message translates to:
  /// **'Downloading prescription'**
  String get downloadingPrescription;

  /// No description provided for @failedToDeletePrescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete prescription'**
  String get failedToDeletePrescription;

  /// No description provided for @errorGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF'**
  String get errorGeneratingPdf;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @failedToFetchPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch prescriptions'**
  String get failedToFetchPrescriptions;

  /// No description provided for @patientRegistration.
  ///
  /// In en, this message translates to:
  /// **'Patient Registration'**
  String get patientRegistration;

  /// No description provided for @doctorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Doctor Registration'**
  String get doctorRegistration;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @enterNationalId.
  ///
  /// In en, this message translates to:
  /// **'Enter your national ID number'**
  String get enterNationalId;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address'**
  String get pleaseEnterAddress;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our\nTerms of Service and Privacy Policy'**
  String get termsAndConditions;

  /// No description provided for @pleaseSelectSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Please select your specialization'**
  String get pleaseSelectSpecialization;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @medicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Medical License (PDF)'**
  String get medicalLicense;

  /// No description provided for @uploadMedicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload your medical license'**
  String get uploadMedicalLicense;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @fileUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File uploaded successfully'**
  String get fileUploadedSuccessfully;

  /// No description provided for @pleaseUploadMedicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Please upload your medical license'**
  String get pleaseUploadMedicalLicense;

  /// No description provided for @pleaseEnterNationalId.
  ///
  /// In en, this message translates to:
  /// **'Please Enter National ID'**
  String get pleaseEnterNationalId;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @errorPickingFile.
  ///
  /// In en, this message translates to:
  /// **'Error picking file'**
  String get errorPickingFile;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @doctorProfile.
  ///
  /// In en, this message translates to:
  /// **'Doctor Profile'**
  String get doctorProfile;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @availableDoctors.
  ///
  /// In en, this message translates to:
  /// **'Available Doctors'**
  String get availableDoctors;

  /// No description provided for @searchDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Search doctor name'**
  String get searchDoctorName;

  /// No description provided for @doctorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} doctors available'**
  String doctorsAvailable(Object count);

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingSearch;

  /// No description provided for @verifyDoctors.
  ///
  /// In en, this message translates to:
  /// **'Verify Doctors'**
  String get verifyDoctors;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending verification'**
  String get pendingVerification;

  /// No description provided for @noDoctorsPendingVerification.
  ///
  /// In en, this message translates to:
  /// **'No doctors pending verification'**
  String get noDoctorsPendingVerification;

  /// No description provided for @allApplicationsProcessed.
  ///
  /// In en, this message translates to:
  /// **'All applications have been processed'**
  String get allApplicationsProcessed;

  /// No description provided for @doctorVerification.
  ///
  /// In en, this message translates to:
  /// **'Doctor Verification'**
  String get doctorVerification;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @doctorRejectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doctor rejected successfully'**
  String get doctorRejectedSuccessfully;

  /// No description provided for @doctorAcceptedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doctor accepted and moved to active doctors list'**
  String get doctorAcceptedSuccessfully;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// No description provided for @unsuspend.
  ///
  /// In en, this message translates to:
  /// **'Unsuspend'**
  String get unsuspend;

  /// No description provided for @patientStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Patient status updated to {status}'**
  String patientStatusUpdated(Object status);

  /// No description provided for @areYouSureYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to'**
  String get areYouSureYouWantTo;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get failedToUpdateStatus;

  /// No description provided for @failedToLoadDoctors.
  ///
  /// In en, this message translates to:
  /// **'Failed to load doctors'**
  String get failedToLoadDoctors;

  /// No description provided for @suspendDoctor.
  ///
  /// In en, this message translates to:
  /// **'Suspend Doctor'**
  String get suspendDoctor;

  /// No description provided for @unsuspendDoctor.
  ///
  /// In en, this message translates to:
  /// **'Unsuspend Doctor'**
  String get unsuspendDoctor;

  /// No description provided for @areYouSureSuspend.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to suspend {name}?'**
  String areYouSureSuspend(Object name);

  /// No description provided for @areYouSureUnsuspend.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unsuspend {name}?'**
  String areYouSureUnsuspend(Object name);

  /// No description provided for @doctorSuspendedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doctor suspended successfully'**
  String get doctorSuspendedSuccessfully;

  /// No description provided for @doctorUnsuspendedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Doctor unsuspended successfully'**
  String get doctorUnsuspendedSuccessfully;

  /// No description provided for @failedToLoadPatients.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patients'**
  String get failedToLoadPatients;

  /// No description provided for @selectPatient.
  ///
  /// In en, this message translates to:
  /// **'Select Patient'**
  String get selectPatient;

  /// No description provided for @patientFound.
  ///
  /// In en, this message translates to:
  /// **'Patient Found'**
  String get patientFound;

  /// No description provided for @confirmPatientIdentity.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the patient identity to continue'**
  String get confirmPatientIdentity;

  /// No description provided for @viewPatient.
  ///
  /// In en, this message translates to:
  /// **'View Patient'**
  String get viewPatient;

  /// No description provided for @patientIdentification.
  ///
  /// In en, this message translates to:
  /// **'Patient Identification'**
  String get patientIdentification;

  /// No description provided for @searchByNationalId.
  ///
  /// In en, this message translates to:
  /// **'Search by National ID'**
  String get searchByNationalId;

  /// No description provided for @enter14DigitNationalId.
  ///
  /// In en, this message translates to:
  /// **'Enter 14-digit National ID'**
  String get enter14DigitNationalId;

  /// No description provided for @searchPatient.
  ///
  /// In en, this message translates to:
  /// **'Search Patient'**
  String get searchPatient;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @scanPatientQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan Patient QR Code'**
  String get scanPatientQrCode;

  /// No description provided for @openQrScanner.
  ///
  /// In en, this message translates to:
  /// **'Open QR Scanner'**
  String get openQrScanner;

  /// No description provided for @typePrescription.
  ///
  /// In en, this message translates to:
  /// **'Type Prescription'**
  String get typePrescription;

  /// No description provided for @sessionOptions.
  ///
  /// In en, this message translates to:
  /// **'Session Options'**
  String get sessionOptions;

  /// No description provided for @chooseSessionAction.
  ///
  /// In en, this message translates to:
  /// **'Choose what you would like to do with {name}'**
  String chooseSessionAction(Object name);

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @reviewMedicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Review {name}\'s medical history'**
  String reviewMedicalHistory(Object name);

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endSession;

  /// No description provided for @areYouSureEndSession.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end session with {name}?'**
  String areYouSureEndSession(Object name);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(Object current, Object total);

  /// No description provided for @pleaseEnterDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Please enter a diagnosis'**
  String get pleaseEnterDiagnosis;

  /// No description provided for @pleaseAddAtLeastOneMedication.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one medication'**
  String get pleaseAddAtLeastOneMedication;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @prescriptionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Prescription Completed'**
  String get prescriptionCompleted;

  /// No description provided for @prescriptionGeneratedSaved.
  ///
  /// In en, this message translates to:
  /// **'The prescription has been successfully generated and saved to the patient\'s medical records.'**
  String get prescriptionGeneratedSaved;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @patientInformation.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @examinationsSection.
  ///
  /// In en, this message translates to:
  /// **'Examinations'**
  String get examinationsSection;

  /// No description provided for @prescriptionSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Prescription saved successfully!'**
  String get prescriptionSavedSuccessfully;

  /// No description provided for @failedToSavePrescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to save prescription: {error}'**
  String failedToSavePrescription(Object error);

  /// No description provided for @createNewPrescriptionFor.
  ///
  /// In en, this message translates to:
  /// **'Create a new prescription for {name}'**
  String createNewPrescriptionFor(Object name);

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @positionQrCode.
  ///
  /// In en, this message translates to:
  /// **'Position the QR code within the frame to scan'**
  String get positionQrCode;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash On'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash Off'**
  String get flashOff;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @processingQrCode.
  ///
  /// In en, this message translates to:
  /// **'Processing QR Code...'**
  String get processingQrCode;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code'**
  String get invalidQrCode;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @filterSessions.
  ///
  /// In en, this message translates to:
  /// **'Filter Sessions'**
  String get filterSessions;

  /// No description provided for @searchByPatient.
  ///
  /// In en, this message translates to:
  /// **'Search by patient name or ID...'**
  String get searchByPatient;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Sessions Found'**
  String get noSessionsFound;

  /// No description provided for @noSessionsFoundMatching.
  ///
  /// In en, this message translates to:
  /// **'No sessions found matching \"{query}\"'**
  String noSessionsFoundMatching(Object query);

  /// No description provided for @noPatientSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No patient sessions found for the selected time period.'**
  String get noPatientSessionsFound;

  /// No description provided for @sessionDate.
  ///
  /// In en, this message translates to:
  /// **'Session Date'**
  String get sessionDate;

  /// No description provided for @sessionNotes.
  ///
  /// In en, this message translates to:
  /// **'Session Notes'**
  String get sessionNotes;

  /// No description provided for @noNotesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No notes available'**
  String get noNotesAvailable;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @atTime.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String atTime(Object date, Object time);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @searchForMedicine.
  ///
  /// In en, this message translates to:
  /// **'Search for medicine'**
  String get searchForMedicine;

  /// No description provided for @createDoctorAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a doctor account to manage patients and sessions'**
  String get createDoctorAccount;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy Policy'**
  String get agreeToTerms;

  /// No description provided for @chooseYourRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your role to get started '**
  String get chooseYourRole;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @createPatientAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a patient account to access medical services'**
  String get createPatientAccount;

  /// No description provided for @deleteMedication.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// No description provided for @deleteMedicationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication?'**
  String get deleteMedicationConfirm;

  /// No description provided for @chronicDisease.
  ///
  /// In en, this message translates to:
  /// **'Chronic Disease'**
  String get chronicDisease;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @generateHistorySummary.
  ///
  /// In en, this message translates to:
  /// **'Generate History Summary'**
  String get generateHistorySummary;

  /// No description provided for @patientHistory.
  ///
  /// In en, this message translates to:
  /// **'Patient History'**
  String get patientHistory;

  /// No description provided for @medicalAssistant.
  ///
  /// In en, this message translates to:
  /// **'Medical Assistant'**
  String get medicalAssistant;

  /// No description provided for @medicalAssistantWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your medical assistant. How can I help you today? You can ask me about symptoms, medications, or general health advice.'**
  String get medicalAssistantWelcome;

  /// No description provided for @medicalAssistantAskAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your health, symptoms, or medical advice.'**
  String get medicalAssistantAskAnything;

  /// No description provided for @medicalAssistantInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Assistant Info'**
  String get medicalAssistantInfoTitle;

  /// No description provided for @medicalAssistantInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'This medical chatbot provides general health information only.'**
  String get medicalAssistantInfoDesc;

  /// No description provided for @medicalAssistantDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Important Disclaimer:'**
  String get medicalAssistantDisclaimer;

  /// No description provided for @medicalAssistantDisclaimerBullets.
  ///
  /// In en, this message translates to:
  /// **'• Not a substitute for professional medical advice\n• In case of emergency, call emergency services\n• Always consult with qualified healthcare providers'**
  String get medicalAssistantDisclaimerBullets;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @typeYourHealthQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your health question...'**
  String get typeYourHealthQuestion;

  /// No description provided for @suggestionHeadache1.
  ///
  /// In en, this message translates to:
  /// **'Is it a migraine?'**
  String get suggestionHeadache1;

  /// No description provided for @suggestionHeadache2.
  ///
  /// In en, this message translates to:
  /// **'Natural headache remedies'**
  String get suggestionHeadache2;

  /// No description provided for @suggestionHeadache3.
  ///
  /// In en, this message translates to:
  /// **'When to see a doctor'**
  String get suggestionHeadache3;

  /// No description provided for @suggestionCold1.
  ///
  /// In en, this message translates to:
  /// **'Cold vs. flu symptoms'**
  String get suggestionCold1;

  /// No description provided for @suggestionCold2.
  ///
  /// In en, this message translates to:
  /// **'Natural cold remedies'**
  String get suggestionCold2;

  /// No description provided for @suggestionCold3.
  ///
  /// In en, this message translates to:
  /// **'COVID vs. cold'**
  String get suggestionCold3;

  /// No description provided for @suggestionBloodPressure1.
  ///
  /// In en, this message translates to:
  /// **'DASH diet details'**
  String get suggestionBloodPressure1;

  /// No description provided for @suggestionBloodPressure2.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure readings'**
  String get suggestionBloodPressure2;

  /// No description provided for @suggestionBloodPressure3.
  ///
  /// In en, this message translates to:
  /// **'Heart-healthy foods'**
  String get suggestionBloodPressure3;

  /// No description provided for @suggestionWater1.
  ///
  /// In en, this message translates to:
  /// **'Signs of dehydration'**
  String get suggestionWater1;

  /// No description provided for @suggestionWater2.
  ///
  /// In en, this message translates to:
  /// **'Best times to drink water'**
  String get suggestionWater2;

  /// No description provided for @suggestionWater3.
  ///
  /// In en, this message translates to:
  /// **'Water alternatives'**
  String get suggestionWater3;

  /// No description provided for @suggestionCommon1.
  ///
  /// In en, this message translates to:
  /// **'Common symptoms'**
  String get suggestionCommon1;

  /// No description provided for @suggestionCommon2.
  ///
  /// In en, this message translates to:
  /// **'Preventive health'**
  String get suggestionCommon2;

  /// No description provided for @suggestionCommon3.
  ///
  /// In en, this message translates to:
  /// **'Nutrition advice'**
  String get suggestionCommon3;

  /// No description provided for @suggestionCommon4.
  ///
  /// In en, this message translates to:
  /// **'Exercise recommendations'**
  String get suggestionCommon4;

  /// No description provided for @diagnosed.
  ///
  /// In en, this message translates to:
  /// **'Diagnosed'**
  String get diagnosed;

  /// No description provided for @diagnosedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Diagnosed: Unknown'**
  String get diagnosedUnknown;

  /// No description provided for @detailedDiagnosisHint.
  ///
  /// In en, this message translates to:
  /// **'Enter detailed diagnosis...\n\nExample:\n• Primary diagnosis\n• Secondary conditions\n• Symptoms observed'**
  String get detailedDiagnosisHint;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @addExamination.
  ///
  /// In en, this message translates to:
  /// **'Add Examination'**
  String get addExamination;

  /// No description provided for @examinationNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Physical Examination, Heart Examination'**
  String get examinationNameHint;

  /// No description provided for @pleaseFillName.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both name and notes'**
  String get pleaseFillName;

  /// No description provided for @recordPhysicalFindings.
  ///
  /// In en, this message translates to:
  /// **'Record physical examination findings'**
  String get recordPhysicalFindings;

  /// No description provided for @noExaminationsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No examinations recorded'**
  String get noExaminationsRecorded;

  /// No description provided for @addPhysicalFindings.
  ///
  /// In en, this message translates to:
  /// **'Add physical examination findings'**
  String get addPhysicalFindings;

  /// No description provided for @noChronicDiseasesFound.
  ///
  /// In en, this message translates to:
  /// **'No chronic diseases found'**
  String get noChronicDiseasesFound;

  /// No description provided for @noBloodPressureReadingsFound.
  ///
  /// In en, this message translates to:
  /// **'No blood pressure readings found'**
  String get noBloodPressureReadingsFound;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get noDataAvailable;

  /// No description provided for @pdfDownloaded.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded to Downloads folder'**
  String get pdfDownloaded;

  /// No description provided for @failedToDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to download PDF: {error}'**
  String failedToDownloadPdf(Object error);

  /// No description provided for @chronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// No description provided for @searchChronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Search chronic diseases...'**
  String get searchChronicDiseases;

  /// No description provided for @searchMedications.
  ///
  /// In en, this message translates to:
  /// **'Search medications...'**
  String get searchMedications;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date:'**
  String get filterByDate;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom Date'**
  String get customDate;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected: {date}'**
  String selected(Object date);

  /// No description provided for @filterByLevel.
  ///
  /// In en, this message translates to:
  /// **'Filter by Level:'**
  String get filterByLevel;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status:'**
  String get filterByStatus;

  /// No description provided for @chronic.
  ///
  /// In en, this message translates to:
  /// **'Chronic'**
  String get chronic;

  /// No description provided for @addPrescribedMedications.
  ///
  /// In en, this message translates to:
  /// **'Add prescribed medications with dosage and timing'**
  String get addPrescribedMedications;

  /// No description provided for @noMedicationsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No medications added yet'**
  String get noMedicationsAddedYet;

  /// No description provided for @tapAddMedicineToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Medicine\" to start prescribing'**
  String get tapAddMedicineToStart;

  /// No description provided for @timesDaily.
  ///
  /// In en, this message translates to:
  /// **'times daily'**
  String get timesDaily;

  /// No description provided for @medicineNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name *'**
  String get medicineNameRequired;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Paracetamol'**
  String get medicineNameHint;

  /// No description provided for @dosageRequired.
  ///
  /// In en, this message translates to:
  /// **'Dosage *'**
  String get dosageRequired;

  /// No description provided for @dosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500 mg'**
  String get dosageHint;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next: {time}'**
  String next(Object time);

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'tablet(s)'**
  String get tablet;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @previewPrescription.
  ///
  /// In en, this message translates to:
  /// **'Preview Prescription'**
  String get previewPrescription;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @addFollowUpInstructions.
  ///
  /// In en, this message translates to:
  /// **'Add follow-up instructions and recommendations'**
  String get addFollowUpInstructions;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter additional notes, recommendations, or follow-up instructions...\n\nExample:\n• Take medication with food\n• Avoid strenuous activities\n• Return if symptoms worsen\n• Follow-up in 1 week'**
  String get notesHint;

  /// No description provided for @quickFollowUpOptions.
  ///
  /// In en, this message translates to:
  /// **'Quick Follow-up Options'**
  String get quickFollowUpOptions;

  /// No description provided for @tapOptionToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap any option to add to notes:'**
  String get tapOptionToAdd;

  /// No description provided for @followUp1Week.
  ///
  /// In en, this message translates to:
  /// **'Follow-up in 1 week'**
  String get followUp1Week;

  /// No description provided for @followUp2Weeks.
  ///
  /// In en, this message translates to:
  /// **'Follow-up in 2 weeks'**
  String get followUp2Weeks;

  /// No description provided for @followUp1Month.
  ///
  /// In en, this message translates to:
  /// **'Follow-up in 1 month'**
  String get followUp1Month;

  /// No description provided for @labTestsRequired.
  ///
  /// In en, this message translates to:
  /// **'Lab tests required'**
  String get labTestsRequired;

  /// No description provided for @specialistReferralNeeded.
  ///
  /// In en, this message translates to:
  /// **'Specialist referral needed'**
  String get specialistReferralNeeded;

  /// No description provided for @completeMedicationCourse.
  ///
  /// In en, this message translates to:
  /// **'Complete medication course'**
  String get completeMedicationCourse;

  /// No description provided for @returnIfSymptomsWorsen.
  ///
  /// In en, this message translates to:
  /// **'Return if symptoms worsen'**
  String get returnIfSymptomsWorsen;

  /// No description provided for @restAndHydration.
  ///
  /// In en, this message translates to:
  /// **'Rest and hydration'**
  String get restAndHydration;

  /// No description provided for @noFollowUpNeeded.
  ///
  /// In en, this message translates to:
  /// **'No follow-up needed'**
  String get noFollowUpNeeded;

  /// No description provided for @doctorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dr.'**
  String get doctorPrefix;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @stepPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get stepPatient;

  /// No description provided for @stepHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get stepHistory;

  /// No description provided for @stepExamination.
  ///
  /// In en, this message translates to:
  /// **'Examination'**
  String get stepExamination;

  /// No description provided for @stepDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get stepDiagnosis;

  /// No description provided for @stepMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get stepMedications;

  /// No description provided for @stepNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get stepNotes;

  /// No description provided for @stepPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get stepPreview;

  /// No description provided for @vaccineDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String vaccineDate(Object date);

  /// No description provided for @vaccineDateNA.
  ///
  /// In en, this message translates to:
  /// **'Date: N/A'**
  String get vaccineDateNA;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(Object date);

  /// No description provided for @dateNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Date: N/A'**
  String get dateNotAvailable;

  /// No description provided for @stepTitle1.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get stepTitle1;

  /// No description provided for @stepTitle2.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepTitle2;

  /// No description provided for @historySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'History Summary'**
  String get historySummaryTitle;

  /// No description provided for @generatingHistorySummary.
  ///
  /// In en, this message translates to:
  /// **'Generating History Summary...'**
  String get generatingHistorySummary;

  /// No description provided for @noAvailableHistory.
  ///
  /// In en, this message translates to:
  /// **'No Available History'**
  String get noAvailableHistory;

  /// No description provided for @noHistorySummaryGenerated.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t generate a history summary for your history.'**
  String get noHistorySummaryGenerated;

  /// No description provided for @healthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health Summary'**
  String get healthSummary;

  /// No description provided for @noHealthSummaryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No health_summary available'**
  String get noHealthSummaryAvailable;

  /// No description provided for @bloodPressureInsights.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Insights'**
  String get bloodPressureInsights;

  /// No description provided for @tipsAndGuides.
  ///
  /// In en, this message translates to:
  /// **'Tips & Guides'**
  String get tipsAndGuides;

  /// No description provided for @generalAdvicesAboutMedicines.
  ///
  /// In en, this message translates to:
  /// **'General Advices About Medicines'**
  String get generalAdvicesAboutMedicines;

  /// No description provided for @vaccineInformation.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Information'**
  String get vaccineInformation;

  /// No description provided for @allergyInformation.
  ///
  /// In en, this message translates to:
  /// **'Allergy Information'**
  String get allergyInformation;

  /// No description provided for @medicinesInformation.
  ///
  /// In en, this message translates to:
  /// **'Medicines Information'**
  String get medicinesInformation;

  /// No description provided for @failedToFetchHistorySummary.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch history summary. Please check your internet connection and try again.'**
  String get failedToFetchHistorySummary;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
