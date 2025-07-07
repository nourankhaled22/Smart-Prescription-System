// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get pleaseLogin => 'Please login to continue';

  @override
  String get phone => 'Phone Number';

  @override
  String get enterPhone => 'Please enter your phone number';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc => 'Enter your phone number and we\'ll send you a verification code to reset your password.';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get sendVerificationCode => 'Send Verification Code';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String failedToResendOtp(Object error) {
    return 'Failed to resend OTP: $error';
  }

  @override
  String get enterVerificationCode => 'Enter Verification Code';

  @override
  String verificationDesc(Object phone) {
    return 'We sent a 6-digit verification code to\n$phone on WhatsApp.';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(Object seconds) {
    return 'Resend code in $seconds seconds';
  }

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get otpVerified => 'OTP verified!';

  @override
  String otpVerificationFailed(Object error) {
    return 'OTP verification failed: $error';
  }

  @override
  String get otpMustBeNumeric => 'OTP must be numeric';

  @override
  String get pleaseEnterCompleteVerificationCode => 'Please enter the complete verification code';

  @override
  String get otpResentSuccessfully => 'OTP resent successfully!';

  @override
  String get verificationCodeSent => 'Verification code sent';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordDesc => 'Your new password must be different from your previous password.';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get passwordReset => 'Reset Password';

  @override
  String get pleaseFillAllFields => 'Please fill in all required fields';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordResetSuccess => 'Password reset successfully!';

  @override
  String passwordResetFailed(Object error) {
    return 'Password reset failed: $error';
  }

  @override
  String get allergies => 'Allergies';

  @override
  String get searchAllergies => 'Search allergies...';

  @override
  String get filter => 'Filter:';

  @override
  String get today => 'Today';

  @override
  String get month => 'Month';

  @override
  String get threeMonths => '3M';

  @override
  String get sixMonths => '6M';

  @override
  String get custom => 'Custom';

  @override
  String get addNewAllergy => 'Add New Allergy';

  @override
  String get total => 'Total';

  @override
  String get noAllergiesFound => 'No allergies found';

  @override
  String get addFirstAllergy => 'Add your first allergy or try a different search';

  @override
  String get editAllergy => 'Edit Allergy';

  @override
  String get deleteAllergy => 'Delete Allergy';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes';

  @override
  String get allergyName => 'Allergy Name';

  @override
  String get enterAllergyName => 'Enter allergy name';

  @override
  String get enterDate => 'Enter Date';

  @override
  String get saveAllergy => 'Save Allergy';

  @override
  String get updateAllergy => 'Update Allergy';

  @override
  String get vaccines => 'Vaccines';

  @override
  String get searchVaccines => 'Search vaccines...';

  @override
  String get addNewVaccine => 'Add New Vaccine';

  @override
  String get noVaccinesFound => 'No vaccines found';

  @override
  String get addFirstVaccine => 'Add your first vaccine or try a different search';

  @override
  String get editVaccine => 'Edit Vaccine';

  @override
  String get deleteVaccine => 'Delete Vaccine';

  @override
  String get vaccineName => 'Vaccine Name';

  @override
  String get enterVaccineName => 'Enter vaccine name';

  @override
  String get saveVaccine => 'Save Vaccine';

  @override
  String get updateVaccine => 'Update Vaccine';

  @override
  String get chronics => 'Chronic Diseases';

  @override
  String get searchChronics => 'Search chronic diseases...';

  @override
  String get addNewChronic => 'Add New Chronic Disease';

  @override
  String get noChronicsFound => 'No chronic diseases found';

  @override
  String get addFirstChronic => 'Add your first chronic disease or try a different search';

  @override
  String get editChronic => 'Edit Chronic Disease';

  @override
  String get deleteChronic => 'Delete Chronic Disease';

  @override
  String get chronicName => 'Disease Name';

  @override
  String get enterChronicName => 'Enter disease name';

  @override
  String get saveChronic => 'Save Chronic Disease';

  @override
  String get updateChronic => 'Update Chronic Disease';

  @override
  String get medicalExaminations => 'Medical Examinations';

  @override
  String get searchExaminations => 'Search examinations...';

  @override
  String get addNewExamination => 'Add New Examination';

  @override
  String get saveExamination => 'Save Examination';

  @override
  String get updateExamination => 'Update Examination';

  @override
  String get editExamination => 'Edit Examination';

  @override
  String get deleteExamination => 'Delete Examination';

  @override
  String get examinationName => 'Examination Name *';

  @override
  String get enterExaminationName => 'Enter examination name';

  @override
  String get uploadPdf => 'Upload PDF';

  @override
  String get uploadPdfFile => 'Upload PDF file';

  @override
  String get download => 'Download';

  @override
  String get noExaminationsFound => 'No examinations found';

  @override
  String get addFirstExamination => 'Add your first examination or try a different search';

  @override
  String get all => 'All';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseUploadPdf => 'Please upload a PDF file';

  @override
  String get examinationUploaded => 'Examination uploaded successfully!';

  @override
  String get examinationUpdated => 'Examination updated successfully!';

  @override
  String get failedToUploadExamination => 'Failed to upload examination';

  @override
  String get failedToUpdateExamination => 'Failed to update examination';

  @override
  String get failedToFetchExaminations => 'Failed to fetch examinations';

  @override
  String get failedToDelete => 'Failed to delete';

  @override
  String get deleted => 'deleted';

  @override
  String get undo => 'Undo';

  @override
  String get authenticationError => 'Authentication error. Please login again.';

  @override
  String get open => 'Open';

  @override
  String get medicine => 'Medicine';

  @override
  String get addNewMedicine => 'Add New Medicine';

  @override
  String get yourMedications => 'Your Medications';

  @override
  String get noMedicationsFound => 'No medications found';

  @override
  String get addFirstMedicine => 'Add your first medicine or try a different search';

  @override
  String get addMedicine => 'Add Medicine';

  @override
  String get delete => 'Delete';

  @override
  String get restored => 'restored';

  @override
  String get scanMedicine => 'Scan Medicine';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get fromGallery => 'From Gallery';

  @override
  String get errorOpeningCamera => 'Error opening camera';

  @override
  String get medicineAdded => 'Medicine added successfully!';

  @override
  String get ok => 'OK';

  @override
  String get medicationCenter => 'Medication Center';

  @override
  String get manageMedications => 'Manage your medications or explore drug information';

  @override
  String get myMedications => 'My Medications';

  @override
  String get trackMedications => 'Track your current medications, set reminders, and manage dosages';

  @override
  String get medicationAnalytics => 'Medication Analytics';

  @override
  String get viewAnalytics => 'View dynamic charts, track adherence, and analyze medication patterns';

  @override
  String get drugInformation => 'Drug Information';

  @override
  String get searchLearn => 'Search and learn about medications, side effects, and interactions';

  @override
  String get quickTip => 'Quick Tip';

  @override
  String get consultProvider => 'Always consult with your healthcare provider before starting, stopping, or changing any medication.';

  @override
  String get dataSecure => 'All medication data is securely stored and protected';

  @override
  String get medicationDetails => 'Medication Details';

  @override
  String get active => 'Active';

  @override
  String get paused => 'Paused';

  @override
  String get pause => 'Pause';

  @override
  String get activate => 'Activate';

  @override
  String get dosageInformation => 'Dosage Information';

  @override
  String get dosage => 'Dosage';

  @override
  String get frequency => 'Frequency';

  @override
  String get duration => 'Duration';

  @override
  String get timing => 'Timing';

  @override
  String get afterMeal => 'After Meal';

  @override
  String get beforeMeal => 'Before Meal';

  @override
  String get schedule => 'Schedule';

  @override
  String get times => 'Times';

  @override
  String get nextDose => 'Next Dose';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get medicineInfo => 'Medicine Info';

  @override
  String get searchForMedicineName => 'Search for medicine name...';

  @override
  String get searchingMedicineInfo => 'Searching medicine information...';

  @override
  String get searchForMedicineInformation => 'Search for Medicine Information';

  @override
  String get enterMedicineNameInfo => 'Enter a medicine name to get detailed information';

  @override
  String get examples => 'Examples: Aspirin, Metformin, Lisinopril';

  @override
  String get medicineNotFound => 'Medicine Not Found';

  @override
  String medicineNotFoundDesc(Object medicineName) {
    return 'We couldn\'t find information for \"$medicineName\"\nTry searching with a different name';
  }

  @override
  String get searchAgain => 'Search Again';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description available';

  @override
  String get activeIngredient => 'Active Ingredient';

  @override
  String get dosageAdmin => 'Dosage & Administration';

  @override
  String get alternativeMedicines => 'Alternative Medicines';

  @override
  String get sideEffects => 'Side Effects';

  @override
  String get warnings => 'Warnings';

  @override
  String get medication => 'Medication';

  @override
  String get fetchMedicineError => 'Failed to fetch medicine information. Please check your internet connection and try again.';

  @override
  String get saveMedicine => 'Save Medicine';

  @override
  String get medicineName => 'Medicine Name';

  @override
  String get enterMedicineName => 'Enter medicine name';

  @override
  String get pleaseEnterMedicineName => 'Please enter medicine name';

  @override
  String get dose => 'Dose';

  @override
  String get enterDoseAmount => 'Enter dose amount';

  @override
  String get timesPerDay => 'Times per Day';

  @override
  String get whenToTake => 'When to Take';

  @override
  String get afterMealOption => 'After Meal';

  @override
  String get afterMealDesc => 'Take medicine after eating';

  @override
  String get beforeMealOption => 'Before Meal';

  @override
  String get beforeMealDesc => 'Take medicine before eating';

  @override
  String get saveSchedule => 'Save Schedule';

  @override
  String get enterStartDate => 'Enter Start Date';

  @override
  String get selectStartDate => 'Select start date';

  @override
  String get enterStartTime => 'Enter Start Time';

  @override
  String get selectStartTime => 'Select start time';

  @override
  String get hoursPerDay => 'Hours per day';

  @override
  String scheduleSaved(Object medicineName) {
    return 'Schedule saved for $medicineName';
  }

  @override
  String get pleaseSelectDateTime => 'Please select both date and time';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get doctorDashboard => 'Doctor Dashboard';

  @override
  String get patientDashboard => 'Patient Dashboard';

  @override
  String welcome(Object name) {
    return 'Welcome, $name';
  }

  @override
  String get howCanWeHelp => 'How can we help you today?';

  @override
  String get manageDoctors => 'Manage Doctors';

  @override
  String get managePatients => 'Manage Patients';

  @override
  String get verifyLicenses => 'Verify Licenses';

  @override
  String get systemStatus => 'System Status';

  @override
  String get allSystemsOperational => 'All systems operational. always check pending license verifications.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get startSession => 'Start Session';

  @override
  String get sessionRecords => 'Session Records';

  @override
  String get professionalTip => 'Professional Tip';

  @override
  String get verifyPatientIdentity => 'Always verify patient identity before starting consultation.';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get findDoctors => 'Find Doctors';

  @override
  String get askChatbot => 'Ask Chatbot';

  @override
  String get healthTips => 'Health Tips';

  @override
  String get stayHydrated => 'Stay Hydrated';

  @override
  String get drinkWaterTip => 'Drink at least 8 glasses of water daily to maintain good health.';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get cancelChangePassword => 'Cancel Change Password';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get enterOldPassword => 'Enter old password';

  @override
  String get enterAtLeast6Chars => 'Enter at least 6 characters';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String failedToUpdateProfile(Object error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get showQrCode => 'Show QR Code';

  @override
  String get patientQrCode => 'Patient QR Code';

  @override
  String get nationalId => 'National ID';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get dateOfBirth => 'Date Of Birth';

  @override
  String get age => 'Age';

  @override
  String get clinicAddress => 'Clinic Adress';

  @override
  String get address => 'Address';

  @override
  String get specialization => 'Specialization';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get bloodPressureReading => 'Blood Pressure Reading';

  @override
  String get editBloodPressure => 'Edit Blood Pressure';

  @override
  String get editReading => 'Edit Reading';

  @override
  String get deleteReading => 'Delete Reading';

  @override
  String get deleteReadingConfirm => 'Are you sure you want to delete this blood pressure reading?';

  @override
  String get addNewReading => 'Add New Reading';

  @override
  String get recordYourBloodPressure => 'Record your blood pressure';

  @override
  String get bloodPressureValues => 'Blood Pressure Values';

  @override
  String get systolic => 'Systolic';

  @override
  String get diastolic => 'Diastolic';

  @override
  String get pulse => 'Pulse';

  @override
  String get upperNumber => 'Upper number';

  @override
  String get lowerNumber => 'Lower number';

  @override
  String get heartRateBpm => 'Heart rate (bpm)';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get time => 'Time';

  @override
  String get healthAnalysis => 'Health Analysis';

  @override
  String get saveReading => 'Save Reading';

  @override
  String get updateReading => 'Update Reading';

  @override
  String get bloodPressureAdded => 'Blood pressure added successfully';

  @override
  String get bloodPressureUpdated => 'Blood pressure updated successfully';

  @override
  String get bloodPressureDeleted => 'Blood pressure deleted successfully';

  @override
  String failedToUpdateBloodPressure(Object error) {
    return 'Failed to update blood pressure: $error';
  }

  @override
  String failedToDeleteBloodPressure(Object error) {
    return 'Failed to delete blood pressure: $error';
  }

  @override
  String get noReadingsFound => 'No readings found';

  @override
  String get noReadingsFoundFilters => 'No readings found for the selected filters';

  @override
  String get avgSys => 'Avg Sys';

  @override
  String get avgDia => 'Avg Dia';

  @override
  String get level => 'Level';

  @override
  String get normal => 'Normal';

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get pleaseEnterSystolic => 'Please enter systolic value';

  @override
  String get pleaseEnterDiastolic => 'Please enter diastolic value';

  @override
  String get pleaseEnterPulse => 'Please enter pulse value';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get normalBpAdvice => 'Great! Maintain a healthy lifestyle with regular exercise and balanced diet.';

  @override
  String get lowBpAdvice => 'Consider consulting your doctor if you experience symptoms like dizziness or fatigue.';

  @override
  String get elevatedBpAdvice => 'Consider lifestyle changes like reducing sodium intake and increasing physical activity.';

  @override
  String get highBpAdvice => 'Consult your healthcare provider for proper evaluation and treatment options.';

  @override
  String get elevatedBloodPressure => 'Elevated Blood Pressure';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get medicalPrescriptions => 'Medical Prescriptions';

  @override
  String get addNewPrescription => 'Add New Prescription';

  @override
  String get addPrescription => 'Add Prescription';

  @override
  String get doctorName => 'Doctor Name';

  @override
  String get enterDoctorName => 'Enter doctor name';

  @override
  String get enterSpecialization => 'Enter specialization';

  @override
  String get enterClinicAddress => 'Enter clinic address';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get medicines => 'Medicines';

  @override
  String get examinations => 'Examinations';

  @override
  String get enterExamination => 'Enter examination';

  @override
  String get diagnoses => 'Diagnoses';

  @override
  String get enterDiagnosis => 'Enter the patient\'s diagnosis and medical condition';

  @override
  String get enterNotes => 'Enter notes';

  @override
  String get savePrescription => 'Save Prescription';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get deletePrescription => 'Delete Prescription';

  @override
  String deletePrescriptionConfirm(Object doctorName) {
    return 'Are you sure you want to delete this prescription from Dr. $doctorName?';
  }

  @override
  String get prescriptionDeleted => 'Prescription deleted successfully';

  @override
  String get prescriptionCaptured => 'Prescription captured successfully!';

  @override
  String prescriptionPdfSaved(Object path) {
    return 'PDF saved to: $path';
  }

  @override
  String get noPrescriptionsFound => 'No prescriptions found';

  @override
  String get noPrescriptionsFoundRange => 'No prescriptions found for the selected date range';

  @override
  String get range => 'Range';

  @override
  String get doctorNotes => 'Doctor\'s Notes';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get scanPrescription => 'Scan prescription';

  @override
  String get pleaseEnterClinicAddress => 'Please enter clinic address';

  @override
  String get pleaseEnterSpecialization => 'Please enter specialization';

  @override
  String get pleaseEnterDoctorName => 'Please enter doctor name';

  @override
  String get uploadImageFile => 'Upload image file';

  @override
  String get failedToUploadPdf => 'Failed to upload PDF';

  @override
  String get pdfUploadedSuccessfully => 'PDF uploaded successfully';

  @override
  String get optional => 'Optional';

  @override
  String get pleaseEnterAtLeastOneMedicine => 'Please enter at least one medicine';

  @override
  String get generatingPdf => 'Generating PDF';

  @override
  String get downloadingPrescription => 'Downloading prescription';

  @override
  String get failedToDeletePrescription => 'Failed to delete prescription';

  @override
  String get errorGeneratingPdf => 'Error generating PDF';

  @override
  String get noData => 'No data';

  @override
  String get failedToFetchPrescriptions => 'Failed to fetch prescriptions';

  @override
  String get patientRegistration => 'Patient Registration';

  @override
  String get doctorRegistration => 'Doctor Registration';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get required => 'Required';

  @override
  String get enterNationalId => 'Enter your national ID number';

  @override
  String get selectDateOfBirth => 'Please select your date of birth';

  @override
  String get pleaseEnterAddress => 'Please enter an address';

  @override
  String get confirmYourPassword => 'Please confirm your password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get termsAndConditions => 'By creating an account, you agree to our\nTerms of Service and Privacy Policy';

  @override
  String get pleaseSelectSpecialization => 'Please select your specialization';

  @override
  String get professionalInformation => 'Professional Information';

  @override
  String get medicalLicense => 'Medical License (PDF)';

  @override
  String get uploadMedicalLicense => 'Upload your medical license';

  @override
  String get browse => 'Browse';

  @override
  String get fileUploadedSuccessfully => 'File uploaded successfully';

  @override
  String get pleaseUploadMedicalLicense => 'Please upload your medical license';

  @override
  String get pleaseEnterNationalId => 'Please Enter National ID';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get errorPickingFile => 'Error picking file';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get doctorProfile => 'Doctor Profile';

  @override
  String get available => 'Available';

  @override
  String get experience => 'Experience';

  @override
  String get years => 'years';

  @override
  String get availableDoctors => 'Available Doctors';

  @override
  String get searchDoctorName => 'Search doctor name';

  @override
  String doctorsAvailable(Object count) {
    return '$count doctors available';
  }

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String get tryAdjustingSearch => 'Try adjusting your search or filters';

  @override
  String get verifyDoctors => 'Verify Doctors';

  @override
  String get pendingVerification => 'Pending verification';

  @override
  String get noDoctorsPendingVerification => 'No doctors pending verification';

  @override
  String get allApplicationsProcessed => 'All applications have been processed';

  @override
  String get doctorVerification => 'Doctor Verification';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get view => 'View';

  @override
  String get license => 'License';

  @override
  String get doctorRejectedSuccessfully => 'Doctor rejected successfully';

  @override
  String get doctorAcceptedSuccessfully => 'Doctor accepted and moved to active doctors list';

  @override
  String get doctors => 'Doctors';

  @override
  String get status => 'Status';

  @override
  String get inactive => 'Inactive';

  @override
  String get suspend => 'Suspend';

  @override
  String get unsuspend => 'Unsuspend';

  @override
  String patientStatusUpdated(Object status) {
    return 'Patient status updated to $status';
  }

  @override
  String get areYouSureYouWantTo => 'Are you sure you want to';

  @override
  String get doctor => 'Doctor';

  @override
  String get failedToUpdateStatus => 'Failed to update status';

  @override
  String get failedToLoadDoctors => 'Failed to load doctors';

  @override
  String get suspendDoctor => 'Suspend Doctor';

  @override
  String get unsuspendDoctor => 'Unsuspend Doctor';

  @override
  String areYouSureSuspend(Object name) {
    return 'Are you sure you want to suspend $name?';
  }

  @override
  String areYouSureUnsuspend(Object name) {
    return 'Are you sure you want to unsuspend $name?';
  }

  @override
  String get doctorSuspendedSuccessfully => 'Doctor suspended successfully';

  @override
  String get doctorUnsuspendedSuccessfully => 'Doctor unsuspended successfully';

  @override
  String get failedToLoadPatients => 'Failed to load patients';

  @override
  String get selectPatient => 'Select Patient';

  @override
  String get patientFound => 'Patient Found';

  @override
  String get confirmPatientIdentity => 'Please confirm the patient identity to continue';

  @override
  String get viewPatient => 'View Patient';

  @override
  String get patientIdentification => 'Patient Identification';

  @override
  String get searchByNationalId => 'Search by National ID';

  @override
  String get enter14DigitNationalId => 'Enter 14-digit National ID';

  @override
  String get searchPatient => 'Search Patient';

  @override
  String get or => 'OR';

  @override
  String get scanPatientQrCode => 'Scan Patient QR Code';

  @override
  String get openQrScanner => 'Open QR Scanner';

  @override
  String get typePrescription => 'Type Prescription';

  @override
  String get sessionOptions => 'Session Options';

  @override
  String chooseSessionAction(Object name) {
    return 'Choose what you would like to do with $name';
  }

  @override
  String get viewHistory => 'View History';

  @override
  String reviewMedicalHistory(Object name) {
    return 'Review $name\'s medical history';
  }

  @override
  String get endSession => 'End Session';

  @override
  String areYouSureEndSession(Object name) {
    return 'Are you sure you want to end session with $name?';
  }

  @override
  String get previous => 'Previous';

  @override
  String get nextStep => 'Next Step';

  @override
  String get preview => 'Preview';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String stepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get pleaseEnterDiagnosis => 'Please enter a diagnosis';

  @override
  String get pleaseAddAtLeastOneMedication => 'Please add at least one medication';

  @override
  String get edit => 'Edit';

  @override
  String get publish => 'Publish';

  @override
  String get prescriptionCompleted => 'Prescription Completed';

  @override
  String get prescriptionGeneratedSaved => 'The prescription has been successfully generated and saved to the patient\'s medical records.';

  @override
  String get done => 'Done';

  @override
  String get patientInformation => 'Patient Information';

  @override
  String get name => 'Name';

  @override
  String get examinationsSection => 'Examinations';

  @override
  String get prescriptionSavedSuccessfully => 'Prescription saved successfully!';

  @override
  String failedToSavePrescription(Object error) {
    return 'Failed to save prescription: $error';
  }

  @override
  String createNewPrescriptionFor(Object name) {
    return 'Create a new prescription for $name';
  }

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get positionQrCode => 'Position the QR code within the frame to scan';

  @override
  String get flashOn => 'Flash On';

  @override
  String get flashOff => 'Flash Off';

  @override
  String get capture => 'Capture';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get processingQrCode => 'Processing QR Code...';

  @override
  String get invalidQrCode => 'Invalid QR Code';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get patients => 'Patients';

  @override
  String get filterSessions => 'Filter Sessions';

  @override
  String get searchByPatient => 'Search by patient name or ID...';

  @override
  String get noSessionsFound => 'No Sessions Found';

  @override
  String noSessionsFoundMatching(Object query) {
    return 'No sessions found matching \"$query\"';
  }

  @override
  String get noPatientSessionsFound => 'No patient sessions found for the selected time period.';

  @override
  String get sessionDate => 'Session Date';

  @override
  String get sessionNotes => 'Session Notes';

  @override
  String get noNotesAvailable => 'No notes available';

  @override
  String get yesterday => 'Yesterday';

  @override
  String atTime(Object date, Object time) {
    return '$date at $time';
  }

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchForMedicine => 'Search for medicine';

  @override
  String get createDoctorAccount => 'Create a doctor account to manage patients and sessions';

  @override
  String get agreeToTerms => 'By continuing, you agree to our Terms & Privacy Policy';

  @override
  String get chooseYourRole => 'Choose your role to get started ';

  @override
  String get patient => 'Patient';

  @override
  String get createPatientAccount => 'Create a patient account to access medical services';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get deleteMedicationConfirm => 'Are you sure you want to delete this medication?';

  @override
  String get chronicDisease => 'Chronic Disease';

  @override
  String get medications => 'Medications';

  @override
  String get generateHistorySummary => 'Generate History Summary';

  @override
  String get patientHistory => 'Patient History';

  @override
  String get medicalAssistant => 'Medical Assistant';

  @override
  String get medicalAssistantWelcome => 'Hello! I\'m your medical assistant. How can I help you today? You can ask me about symptoms, medications, or general health advice.';

  @override
  String get medicalAssistantAskAnything => 'Ask me anything about your health, symptoms, or medical advice.';

  @override
  String get medicalAssistantInfoTitle => 'Medical Assistant Info';

  @override
  String get medicalAssistantInfoDesc => 'This medical chatbot provides general health information only.';

  @override
  String get medicalAssistantDisclaimer => 'Important Disclaimer:';

  @override
  String get medicalAssistantDisclaimerBullets => '• Not a substitute for professional medical advice\n• In case of emergency, call emergency services\n• Always consult with qualified healthcare providers';

  @override
  String get close => 'Close';

  @override
  String get typeYourHealthQuestion => 'Type your health question...';

  @override
  String get suggestionHeadache1 => 'Is it a migraine?';

  @override
  String get suggestionHeadache2 => 'Natural headache remedies';

  @override
  String get suggestionHeadache3 => 'When to see a doctor';

  @override
  String get suggestionCold1 => 'Cold vs. flu symptoms';

  @override
  String get suggestionCold2 => 'Natural cold remedies';

  @override
  String get suggestionCold3 => 'COVID vs. cold';

  @override
  String get suggestionBloodPressure1 => 'DASH diet details';

  @override
  String get suggestionBloodPressure2 => 'Blood pressure readings';

  @override
  String get suggestionBloodPressure3 => 'Heart-healthy foods';

  @override
  String get suggestionWater1 => 'Signs of dehydration';

  @override
  String get suggestionWater2 => 'Best times to drink water';

  @override
  String get suggestionWater3 => 'Water alternatives';

  @override
  String get suggestionCommon1 => 'Common symptoms';

  @override
  String get suggestionCommon2 => 'Preventive health';

  @override
  String get suggestionCommon3 => 'Nutrition advice';

  @override
  String get suggestionCommon4 => 'Exercise recommendations';

  @override
  String get diagnosed => 'Diagnosed';

  @override
  String get diagnosedUnknown => 'Diagnosed: Unknown';

  @override
  String get detailedDiagnosisHint => 'Enter detailed diagnosis...\n\nExample:\n• Primary diagnosis\n• Secondary conditions\n• Symptoms observed';

  @override
  String get verify => 'Verify';

  @override
  String get addExamination => 'Add Examination';

  @override
  String get examinationNameHint => 'e.g., Physical Examination, Heart Examination';

  @override
  String get pleaseFillName => 'Please fill in both name and notes';

  @override
  String get recordPhysicalFindings => 'Record physical examination findings';

  @override
  String get noExaminationsRecorded => 'No examinations recorded';

  @override
  String get addPhysicalFindings => 'Add physical examination findings';

  @override
  String get noChronicDiseasesFound => 'No chronic diseases found';

  @override
  String get noBloodPressureReadingsFound => 'No blood pressure readings found';

  @override
  String get noDataAvailable => 'No Data Available';

  @override
  String get pdfDownloaded => 'PDF downloaded to Downloads folder';

  @override
  String failedToDownloadPdf(Object error) {
    return 'Failed to download PDF: $error';
  }

  @override
  String get chronicDiseases => 'Chronic Diseases';

  @override
  String get searchChronicDiseases => 'Search chronic diseases...';

  @override
  String get searchMedications => 'Search medications...';

  @override
  String get search => 'Search...';

  @override
  String get filterByDate => 'Filter by Date:';

  @override
  String get allTime => 'All Time';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get customDate => 'Custom Date';

  @override
  String selected(Object date) {
    return 'Selected: $date';
  }

  @override
  String get filterByLevel => 'Filter by Level:';

  @override
  String get filterByStatus => 'Filter by Status:';

  @override
  String get chronic => 'Chronic';

  @override
  String get addPrescribedMedications => 'Add prescribed medications with dosage and timing';

  @override
  String get noMedicationsAddedYet => 'No medications added yet';

  @override
  String get tapAddMedicineToStart => 'Tap \"Add Medicine\" to start prescribing';

  @override
  String get timesDaily => 'times daily';

  @override
  String get medicineNameRequired => 'Medicine Name *';

  @override
  String get medicineNameHint => 'e.g., Paracetamol';

  @override
  String get dosageRequired => 'Dosage *';

  @override
  String get dosageHint => 'e.g. 500 mg';

  @override
  String get pleaseFillRequiredFields => 'Please fill in required fields';

  @override
  String next(Object time) {
    return 'Next: $time';
  }

  @override
  String get tablet => 'tablet(s)';

  @override
  String get days => 'days';

  @override
  String get previewPrescription => 'Preview Prescription';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get addFollowUpInstructions => 'Add follow-up instructions and recommendations';

  @override
  String get notesHint => 'Enter additional notes, recommendations, or follow-up instructions...\n\nExample:\n• Take medication with food\n• Avoid strenuous activities\n• Return if symptoms worsen\n• Follow-up in 1 week';

  @override
  String get quickFollowUpOptions => 'Quick Follow-up Options';

  @override
  String get tapOptionToAdd => 'Tap any option to add to notes:';

  @override
  String get followUp1Week => 'Follow-up in 1 week';

  @override
  String get followUp2Weeks => 'Follow-up in 2 weeks';

  @override
  String get followUp1Month => 'Follow-up in 1 month';

  @override
  String get labTestsRequired => 'Lab tests required';

  @override
  String get specialistReferralNeeded => 'Specialist referral needed';

  @override
  String get completeMedicationCourse => 'Complete medication course';

  @override
  String get returnIfSymptomsWorsen => 'Return if symptoms worsen';

  @override
  String get restAndHydration => 'Rest and hydration';

  @override
  String get noFollowUpNeeded => 'No follow-up needed';

  @override
  String get doctorPrefix => 'Dr.';

  @override
  String get unknown => 'Unknown';

  @override
  String get stepPatient => 'Patient';

  @override
  String get stepHistory => 'History';

  @override
  String get stepExamination => 'Examination';

  @override
  String get stepDiagnosis => 'Diagnosis';

  @override
  String get stepMedications => 'Medications';

  @override
  String get stepNotes => 'Notes';

  @override
  String get stepPreview => 'Preview';

  @override
  String vaccineDate(Object date) {
    return 'Date: $date';
  }

  @override
  String get vaccineDateNA => 'Date: N/A';

  @override
  String dateLabel(Object date) {
    return 'Date: $date';
  }

  @override
  String get dateNotAvailable => 'Date: N/A';

  @override
  String get stepTitle1 => 'Personal Info';

  @override
  String get stepTitle2 => 'Details';

  @override
  String get historySummaryTitle => 'History Summary';

  @override
  String get generatingHistorySummary => 'Generating History Summary...';

  @override
  String get noAvailableHistory => 'No Available History';

  @override
  String get noHistorySummaryGenerated => 'We couldn\'t generate a history summary for your history.';

  @override
  String get healthSummary => 'Health Summary';

  @override
  String get noHealthSummaryAvailable => 'No health_summary available';

  @override
  String get bloodPressureInsights => 'Blood Pressure Insights';

  @override
  String get tipsAndGuides => 'Tips & Guides';

  @override
  String get generalAdvicesAboutMedicines => 'General Advices About Medicines';

  @override
  String get vaccineInformation => 'Vaccine Information';

  @override
  String get allergyInformation => 'Allergy Information';

  @override
  String get medicinesInformation => 'Medicines Information';

  @override
  String get failedToFetchHistorySummary => 'Failed to fetch history summary. Please check your internet connection and try again.';

  @override
  String get login => 'Login';

  @override
  String get downloading => 'Downloading...';
}
