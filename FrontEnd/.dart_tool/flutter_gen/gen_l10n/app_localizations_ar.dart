// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get pleaseLogin => 'الرجاء تسجيل الدخول للمتابعة';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get enterPhone => 'يرجى إدخال رقم هاتفك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordDesc => 'أدخل رقم هاتفك وسنرسل لك رمز تحقق لإعادة تعيين كلمة المرور.';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get pleaseEnterPhoneNumber => 'من فضلك أدخل رقم الهاتف';

  @override
  String get pleaseEnterValidPhoneNumber => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String failedToResendOtp(Object error) {
    return 'فشل في إعادة إرسال رمز التحقق: $error';
  }

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String verificationDesc(Object phone) {
    return 'تم إرسال رمز تحقق مكون من 6 أرقام إلى\n$phone على واتساب.';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendCodeIn(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get verifyCode => 'تحقق من الرمز';

  @override
  String get otpVerified => 'تم التحقق من الرمز!';

  @override
  String otpVerificationFailed(Object error) {
    return 'فشل التحقق من الرمز: $error';
  }

  @override
  String get otpMustBeNumeric => 'يجب أن يكون الرمز أرقامًا فقط';

  @override
  String get pleaseEnterCompleteVerificationCode => 'يرجى إدخال رمز التحقق الكامل';

  @override
  String get otpResentSuccessfully => 'تمت إعادة إرسال الرمز بنجاح!';

  @override
  String get verificationCodeSent => 'تم إرسال رمز التحقق';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordDesc => 'يجب أن تكون كلمة المرور الجديدة مختلفة عن السابقة.';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordReset => 'إعادة تعيين كلمة المرور';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح!';

  @override
  String passwordResetFailed(Object error) {
    return 'فشل في إعادة تعيين كلمة المرور: $error';
  }

  @override
  String get allergies => 'الحساسية';

  @override
  String get searchAllergies => 'ابحث عن الحساسية...';

  @override
  String get filter => 'تصفية:';

  @override
  String get today => 'اليوم';

  @override
  String get month => 'شهر';

  @override
  String get threeMonths => '٣ أشهر';

  @override
  String get sixMonths => '٦ أشهر';

  @override
  String get custom => 'مخصص';

  @override
  String get addNewAllergy => 'إضافة حساسية جديدة';

  @override
  String get total => 'الإجمالي';

  @override
  String get noAllergiesFound => 'لا توجد حساسية';

  @override
  String get addFirstAllergy => 'أضف أول حساسية أو جرب بحثًا مختلفًا';

  @override
  String get editAllergy => 'تعديل الحساسية';

  @override
  String get deleteAllergy => 'حذف الحساسية';

  @override
  String get date => 'التاريخ';

  @override
  String get notes => 'ملاحظات';

  @override
  String get allergyName => 'اسم الحساسية';

  @override
  String get enterAllergyName => 'أدخل اسم الحساسية';

  @override
  String get enterDate => 'أدخل التاريخ';

  @override
  String get saveAllergy => 'حفظ الحساسية';

  @override
  String get updateAllergy => 'تحديث الحساسية';

  @override
  String get vaccines => 'اللقاحات';

  @override
  String get searchVaccines => 'ابحث عن اللقاحات...';

  @override
  String get addNewVaccine => 'إضافة لقاح جديد';

  @override
  String get noVaccinesFound => 'لا توجد لقاحات';

  @override
  String get addFirstVaccine => 'أضف أول لقاح أو جرب بحثًا مختلفًا';

  @override
  String get editVaccine => 'تعديل اللقاح';

  @override
  String get deleteVaccine => 'حذف اللقاح';

  @override
  String get vaccineName => 'اسم اللقاح';

  @override
  String get enterVaccineName => 'أدخل اسم اللقاح';

  @override
  String get saveVaccine => 'حفظ اللقاح';

  @override
  String get updateVaccine => 'تحديث اللقاح';

  @override
  String get chronics => 'الأمراض المزمنة';

  @override
  String get searchChronics => 'ابحث عن الأمراض المزمنة...';

  @override
  String get addNewChronic => 'إضافة مرض مزمن جديد';

  @override
  String get noChronicsFound => 'لا توجد أمراض مزمنة';

  @override
  String get addFirstChronic => 'أضف أول مرض مزمن أو جرب بحثًا مختلفًا';

  @override
  String get editChronic => 'تعديل المرض المزمن';

  @override
  String get deleteChronic => 'حذف المرض المزمن';

  @override
  String get chronicName => 'اسم المرض';

  @override
  String get enterChronicName => 'أدخل اسم المرض';

  @override
  String get saveChronic => 'حفظ المرض المزمن';

  @override
  String get updateChronic => 'تحديث المرض المزمن';

  @override
  String get medicalExaminations => 'الفحوصات الطبية';

  @override
  String get searchExaminations => 'ابحث عن الفحوصات...';

  @override
  String get addNewExamination => 'إضافة فحص جديد';

  @override
  String get saveExamination => 'حفظ الفحص';

  @override
  String get updateExamination => 'تحديث الفحص';

  @override
  String get editExamination => 'تعديل الفحص';

  @override
  String get deleteExamination => 'حذف الفحص';

  @override
  String get examinationName => 'اسم الفحص *';

  @override
  String get enterExaminationName => 'أدخل اسم الفحص';

  @override
  String get uploadPdf => 'رفع ملف PDF';

  @override
  String get uploadPdfFile => 'رفع ملف PDF';

  @override
  String get download => 'تنزيل';

  @override
  String get noExaminationsFound => 'لا توجد فحوصات';

  @override
  String get addFirstExamination => 'أضف أول فحص أو جرب بحثًا مختلفًا';

  @override
  String get all => 'الكل';

  @override
  String get pleaseSelectDate => 'يرجى اختيار التاريخ';

  @override
  String get pleaseUploadPdf => 'يرجى رفع ملف PDF';

  @override
  String get examinationUploaded => 'تم رفع الفحص بنجاح!';

  @override
  String get examinationUpdated => 'تم تحديث الفحص بنجاح!';

  @override
  String get failedToUploadExamination => 'فشل في رفع الفحص';

  @override
  String get failedToUpdateExamination => 'فشل في تحديث الفحص';

  @override
  String get failedToFetchExaminations => 'فشل في جلب الفحوصات';

  @override
  String get failedToDelete => 'فشل في الحذف';

  @override
  String get deleted => 'تم الحذف';

  @override
  String get undo => 'تراجع';

  @override
  String get authenticationError => 'خطأ في المصادقة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get open => 'فتح';

  @override
  String get medicine => 'الدواء';

  @override
  String get addNewMedicine => 'إضافة دواء جديد';

  @override
  String get yourMedications => 'أدويتك';

  @override
  String get noMedicationsFound => 'لا توجد أدوية';

  @override
  String get addFirstMedicine => 'أضف أول دواء أو جرب بحثًا مختلفًا';

  @override
  String get addMedicine => 'إضافة دواء';

  @override
  String get delete => 'حذف';

  @override
  String get restored => 'تم الاسترجاع';

  @override
  String get scanMedicine => 'مسح الدواء';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get fromGallery => 'من المعرض';

  @override
  String get errorOpeningCamera => 'خطأ في فتح الكاميرا';

  @override
  String get medicineAdded => 'تمت إضافة الدواء بنجاح!';

  @override
  String get ok => 'موافق';

  @override
  String get medicationCenter => 'مركز الأدوية';

  @override
  String get manageMedications => 'إدارة أدويتك أو استكشاف معلومات الأدوية';

  @override
  String get myMedications => 'أدويتي';

  @override
  String get trackMedications => 'تتبع أدويتك الحالية، واضبط التذكيرات، وأدر الجرعات';

  @override
  String get medicationAnalytics => 'تحليلات الأدوية';

  @override
  String get viewAnalytics => 'عرض الرسوم البيانية الديناميكية وتتبع الالتزام وتحليل أنماط الأدوية';

  @override
  String get drugInformation => 'معلومات الدواء';

  @override
  String get searchLearn => 'ابحث وتعرف على الأدوية، الآثار الجانبية، والتفاعلات';

  @override
  String get quickTip => 'نصيحة سريعة';

  @override
  String get consultProvider => 'استشر مقدم الرعاية الصحية قبل بدء أو إيقاف أو تغيير أي دواء.';

  @override
  String get dataSecure => 'جميع بيانات الأدوية مخزنة ومحفوظة بأمان';

  @override
  String get medicationDetails => 'تفاصيل الدواء';

  @override
  String get active => 'نشط';

  @override
  String get paused => 'موقوف';

  @override
  String get pause => 'إيقاف';

  @override
  String get activate => 'تفعيل';

  @override
  String get dosageInformation => 'معلومات الجرعة';

  @override
  String get dosage => 'الجرعة';

  @override
  String get frequency => 'التكرار';

  @override
  String get duration => 'المدة';

  @override
  String get timing => 'التوقيت';

  @override
  String get afterMeal => 'بعد الأكل';

  @override
  String get beforeMeal => 'قبل الأكل';

  @override
  String get schedule => 'الجدول';

  @override
  String get times => 'الأوقات';

  @override
  String get nextDose => 'الجرعة التالية';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get medicineInfo => 'معلومات الدواء';

  @override
  String get searchForMedicineName => 'ابحث عن اسم الدواء...';

  @override
  String get searchingMedicineInfo => 'جاري البحث عن معلومات الدواء...';

  @override
  String get searchForMedicineInformation => 'ابحث عن معلومات الدواء';

  @override
  String get enterMedicineNameInfo => 'أدخل اسم الدواء للحصول على معلومات مفصلة';

  @override
  String get examples => 'أمثلة: أسبرين، ميتفورمين، ليسينوبريل';

  @override
  String get medicineNotFound => 'لم يتم العثور على الدواء';

  @override
  String medicineNotFoundDesc(Object medicineName) {
    return 'لم نتمكن من العثور على معلومات لـ \"$medicineName\"\nجرب البحث باسم مختلف';
  }

  @override
  String get searchAgain => 'ابحث مرة أخرى';

  @override
  String get error => 'خطأ';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get description => 'الوصف';

  @override
  String get noDescription => 'لا يوجد وصف متاح';

  @override
  String get activeIngredient => 'المكون الفعال';

  @override
  String get dosageAdmin => 'الجرعة وطريقة الاستعمال';

  @override
  String get alternativeMedicines => 'بدائل الدواء';

  @override
  String get sideEffects => 'الآثار الجانبية';

  @override
  String get warnings => 'تحذيرات';

  @override
  String get medication => 'دواء';

  @override
  String get fetchMedicineError => 'فشل في جلب معلومات الدواء. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get saveMedicine => 'حفظ الدواء';

  @override
  String get medicineName => 'اسم الدواء';

  @override
  String get enterMedicineName => 'أدخل اسم الدواء';

  @override
  String get pleaseEnterMedicineName => 'يرجى إدخال اسم الدواء';

  @override
  String get dose => 'الجرعة';

  @override
  String get enterDoseAmount => 'أدخل كمية الجرعة';

  @override
  String get timesPerDay => 'عدد المرات في اليوم';

  @override
  String get whenToTake => 'متى يؤخذ';

  @override
  String get afterMealOption => 'بعد الأكل';

  @override
  String get afterMealDesc => 'تناول الدواء بعد الأكل';

  @override
  String get beforeMealOption => 'قبل الأكل';

  @override
  String get beforeMealDesc => 'تناول الدواء قبل الأكل';

  @override
  String get saveSchedule => 'حفظ الجدول';

  @override
  String get enterStartDate => 'أدخل تاريخ البدء';

  @override
  String get selectStartDate => 'اختر تاريخ البدء';

  @override
  String get enterStartTime => 'أدخل وقت البدء';

  @override
  String get selectStartTime => 'اختر وقت البدء';

  @override
  String get hoursPerDay => 'عدد الساعات في اليوم';

  @override
  String scheduleSaved(Object medicineName) {
    return 'تم حفظ الجدول لـ $medicineName';
  }

  @override
  String get pleaseSelectDateTime => 'يرجى اختيار كل من التاريخ والوقت';

  @override
  String get adminDashboard => 'لوحة تحكم المدير';

  @override
  String get doctorDashboard => 'لوحة تحكم الطبيب';

  @override
  String get patientDashboard => 'لوحة تحكم المريض';

  @override
  String welcome(Object name) {
    return 'مرحبًا، $name';
  }

  @override
  String get howCanWeHelp => 'كيف يمكننا مساعدتك اليوم؟';

  @override
  String get manageDoctors => 'إدارة الأطباء';

  @override
  String get managePatients => 'إدارة المرضى';

  @override
  String get verifyLicenses => 'التحقق من التراخيص';

  @override
  String get systemStatus => 'حالة النظام';

  @override
  String get allSystemsOperational => 'جميع الأنظمة تعمل.  تحقق من التراخيص قيد الانتظار.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get viewProfile => 'عرض الملف الشخصي';

  @override
  String get startSession => 'بدء جلسة';

  @override
  String get sessionRecords => 'سجلات الجلسات';

  @override
  String get professionalTip => 'نصيحة مهنية';

  @override
  String get verifyPatientIdentity => 'تحقق دائمًا من هوية المريض قبل بدء الاستشارة.';

  @override
  String get medicalHistory => 'التاريخ الطبي';

  @override
  String get findDoctors => 'البحث عن الأطباء';

  @override
  String get askChatbot => 'اسأل الروبوت';

  @override
  String get healthTips => 'نصائح صحية';

  @override
  String get stayHydrated => 'حافظ على رطوبتك';

  @override
  String get drinkWaterTip => 'اشرب 8 أكواب من الماء يوميًا للحفاظ على صحتك.';

  @override
  String get areYouSureSignOut => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get updatePassword => 'تحديث كلمة المرور';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get cancelChangePassword => 'إلغاء تغيير كلمة المرور';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get enterOldPassword => 'أدخل كلمة المرور القديمة';

  @override
  String get enterAtLeast6Chars => 'أدخل 6 أحرف على الأقل';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String failedToUpdateProfile(Object error) {
    return 'فشل في تحديث الملف الشخصي: $error';
  }

  @override
  String get showQrCode => 'عرض رمز الاستجابة السريعة';

  @override
  String get patientQrCode => 'رمز المريض';

  @override
  String get nationalId => 'الرقم القومي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الاخير';

  @override
  String get email => 'الأيميل';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get age => 'العمر';

  @override
  String get clinicAddress => 'عنوان العيادة';

  @override
  String get address => 'العنوان';

  @override
  String get specialization => 'التخصص';

  @override
  String get bloodPressure => 'ضغط الدم';

  @override
  String get bloodPressureReading => 'قراءة ضغط الدم';

  @override
  String get editBloodPressure => 'تعديل ضغط الدم';

  @override
  String get editReading => 'تعديل القراءة';

  @override
  String get deleteReading => 'حذف القراءة';

  @override
  String get deleteReadingConfirm => 'هل أنت متأكد أنك تريد حذف قراءة ضغط الدم هذه؟';

  @override
  String get addNewReading => 'إضافة قراءة جديدة';

  @override
  String get recordYourBloodPressure => 'سجل ضغط دمك';

  @override
  String get bloodPressureValues => 'قيم ضغط الدم';

  @override
  String get systolic => 'الانقباضي';

  @override
  String get diastolic => 'الانبساطي';

  @override
  String get pulse => 'النبض';

  @override
  String get upperNumber => 'الرقم العلوي';

  @override
  String get lowerNumber => 'الرقم السفلي';

  @override
  String get heartRateBpm => 'معدل ضربات القلب (نبضة/دقيقة)';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get time => 'الوقت';

  @override
  String get healthAnalysis => 'تحليل صحي';

  @override
  String get saveReading => 'حفظ القراءة';

  @override
  String get updateReading => 'تحديث القراءة';

  @override
  String get bloodPressureAdded => 'تمت إضافة ضغط الدم بنجاح';

  @override
  String get bloodPressureUpdated => 'تم تحديث ضغط الدم بنجاح';

  @override
  String get bloodPressureDeleted => 'تم حذف ضغط الدم بنجاح';

  @override
  String failedToUpdateBloodPressure(Object error) {
    return 'فشل في تحديث ضغط الدم: $error';
  }

  @override
  String failedToDeleteBloodPressure(Object error) {
    return 'فشل في حذف ضغط الدم: $error';
  }

  @override
  String get noReadingsFound => 'لا توجد قراءات';

  @override
  String get noReadingsFoundFilters => 'لا توجد قراءات للفلاتر المحددة';

  @override
  String get avgSys => 'متوسط الانقباضي';

  @override
  String get avgDia => 'متوسط الانبساطي';

  @override
  String get level => 'المستوى';

  @override
  String get normal => 'طبيعي';

  @override
  String get high => 'مرتفع';

  @override
  String get low => 'منخفض';

  @override
  String get pleaseEnterSystolic => 'يرجى إدخال قيمة الانقباضي';

  @override
  String get pleaseEnterDiastolic => 'يرجى إدخال قيمة الانبساطي';

  @override
  String get pleaseEnterPulse => 'يرجى إدخال قيمة النبض';

  @override
  String get pleaseEnterValidNumber => 'يرجى إدخال رقم صحيح';

  @override
  String get normalBpAdvice => 'رائع! حافظ على نمط حياة صحي من خلال ممارسة الرياضة بانتظام واتباع نظام غذائي متوازن.';

  @override
  String get lowBpAdvice => 'كر في استشارة طبيبك إذا كنت تعاني من أعراض مثل الدوخة أو التعب.';

  @override
  String get elevatedBpAdvice => 'خذ بعين الاعتبار تغييرات في نمط حياتك مثل تقليل تناول الصوديوم وزيادة النشاط البدني.';

  @override
  String get highBpAdvice => 'استشر مقدم الرعاية الصحية الخاص بك للحصول على التقييم المناسب وخيارات العلاج.';

  @override
  String get elevatedBloodPressure => 'ارتفاع ضغط الدم';

  @override
  String get prescriptions => 'الوصفات الطبية';

  @override
  String get medicalPrescriptions => 'الوصفات الطبية';

  @override
  String get addNewPrescription => 'إضافة وصفة جديدة';

  @override
  String get addPrescription => 'إضافة وصفة';

  @override
  String get doctorName => 'اسم الطبيب';

  @override
  String get enterDoctorName => 'أدخل اسم الطبيب';

  @override
  String get enterSpecialization => 'أدخل التخصص';

  @override
  String get enterClinicAddress => 'أدخل عنوان العيادة';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get medicines => 'الأدوية';

  @override
  String get examinations => 'الفحوصات';

  @override
  String get enterExamination => 'أدخل الفحص';

  @override
  String get diagnoses => 'التشخيصات';

  @override
  String get enterDiagnosis => 'أدخل تشخيص وحالة المريض الطبية';

  @override
  String get enterNotes => 'أدخل الملاحظات';

  @override
  String get savePrescription => 'حفظ الوصفة';

  @override
  String get downloadPdf => 'تحميل PDF';

  @override
  String get deletePrescription => 'حذف الوصفة';

  @override
  String deletePrescriptionConfirm(Object doctorName) {
    return 'هل أنت متأكد أنك تريد حذف هذه الوصفة من الدكتور $doctorName؟';
  }

  @override
  String get prescriptionDeleted => 'تم حذف الوصفة بنجاح';

  @override
  String get prescriptionCaptured => 'تم التقاط الوصفة بنجاح!';

  @override
  String prescriptionPdfSaved(Object path) {
    return 'تم حفظ PDF في: $path';
  }

  @override
  String get noPrescriptionsFound => 'لا توجد وصفات طبية';

  @override
  String get noPrescriptionsFoundRange => 'لا توجد وصفات طبية لنطاق التاريخ المحدد';

  @override
  String get range => 'النطاق';

  @override
  String get doctorNotes => 'ملاحظات الطبيب';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get scanPrescription => 'مسح الوصفة';

  @override
  String get pleaseEnterClinicAddress => 'من فضلك أدخل عنوان العيادة';

  @override
  String get pleaseEnterSpecialization => 'من فضلك أدخل التخصص';

  @override
  String get pleaseEnterDoctorName => 'من فضلك أدخل اسم الطبيب';

  @override
  String get uploadImageFile => 'قم برفع ملف الصورة';

  @override
  String get failedToUploadPdf => 'فشل في رفع ملف PDF';

  @override
  String get pdfUploadedSuccessfully => 'تم رفع ملف PDF بنجاح';

  @override
  String get optional => 'اختياري';

  @override
  String get pleaseEnterAtLeastOneMedicine => 'يرجى إدخال دواء واحد على الأقل';

  @override
  String get generatingPdf => 'جارٍ إنشاء ملف PDF';

  @override
  String get downloadingPrescription => 'جارٍ تحميل الوصفة الطبية';

  @override
  String get failedToDeletePrescription => 'فشل في حذف الوصفة الطبية';

  @override
  String get errorGeneratingPdf => 'حدث خطأ أثناء إنشاء ملف PDF';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get failedToFetchPrescriptions => 'فشل في جلب الوصفات الطبية';

  @override
  String get patientRegistration => 'تسجيل المريض';

  @override
  String get doctorRegistration => 'تسجيل الطبيب';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get required => 'مطلوب';

  @override
  String get enterNationalId => 'أدخل رقمك القومي';

  @override
  String get selectDateOfBirth => 'يرجى اختيار تاريخ الميلاد';

  @override
  String get pleaseEnterAddress => 'يرجى إدخال العنوان';

  @override
  String get confirmYourPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get termsAndConditions => 'بإنشائك حسابًا، أنت توافق على\nشروط الخدمة وسياسة الخصوصية';

  @override
  String get pleaseSelectSpecialization => 'يرجى اختيار التخصص';

  @override
  String get professionalInformation => 'المعلومات المهنية';

  @override
  String get medicalLicense => 'الترخيص الطبي (PDF)';

  @override
  String get uploadMedicalLicense => 'قم برفع الترخيص الطبي';

  @override
  String get browse => 'تصفح';

  @override
  String get fileUploadedSuccessfully => 'تم رفع الملف بنجاح';

  @override
  String get pleaseUploadMedicalLicense => 'يرجى رفع الترخيص الطبي';

  @override
  String get pleaseEnterNationalId => 'الرجاء إدخال الرقم القومي';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح!';

  @override
  String get errorPickingFile => 'خطأ اختيار الملف';

  @override
  String get registrationFailed => 'فشل التسجيل';

  @override
  String get doctorProfile => 'ملف الطبيب';

  @override
  String get available => 'متاح';

  @override
  String get experience => 'الخبرة';

  @override
  String get years => 'سنة';

  @override
  String get availableDoctors => 'الأطباء المتاحون';

  @override
  String get searchDoctorName => 'ابحث باسم الطبيب';

  @override
  String doctorsAvailable(Object count) {
    return '$count طبيب متاح';
  }

  @override
  String get noDoctorsFound => 'لم يتم العثور على أطباء';

  @override
  String get tryAdjustingSearch => 'حاول تعديل البحث أو الفلاتر';

  @override
  String get verifyDoctors => 'التحقق من الأطباء';

  @override
  String get pendingVerification => 'في انتظار التحقق';

  @override
  String get noDoctorsPendingVerification => 'لا يوجد أطباء في انتظار التحقق';

  @override
  String get allApplicationsProcessed => 'تمت معالجة جميع الطلبات';

  @override
  String get doctorVerification => 'التحقق من الطبيب';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get view => 'عرض';

  @override
  String get license => 'الترخيص';

  @override
  String get doctorRejectedSuccessfully => 'تم رفض الطبيب بنجاح';

  @override
  String get doctorAcceptedSuccessfully => 'تم قبول الطبيب ونقله إلى قائمة الأطباء النشطين';

  @override
  String get doctors => 'الأطباء';

  @override
  String get status => 'الحالة';

  @override
  String get inactive => 'غير نشط';

  @override
  String get suspend => 'تعليق';

  @override
  String get unsuspend => 'إلغاء التعليق';

  @override
  String patientStatusUpdated(Object status) {
    return 'تم تحديث حالة الطبيب إلى $status';
  }

  @override
  String get areYouSureYouWantTo => 'هل أنت متأكد أنك تريد';

  @override
  String get doctor => 'دكتور';

  @override
  String get failedToUpdateStatus => 'تعذّر تحديث الحالة';

  @override
  String get failedToLoadDoctors => 'فشل في تحميل قائمة الأطباء';

  @override
  String get suspendDoctor => 'تعليق الطبيب';

  @override
  String get unsuspendDoctor => 'إلغاء تعليق الطبيب';

  @override
  String areYouSureSuspend(Object name) {
    return 'هل أنت متأكد أنك تريد تعليق $name؟';
  }

  @override
  String areYouSureUnsuspend(Object name) {
    return 'هل أنت متأكد أنك تريد إلغاء تعليق $name؟';
  }

  @override
  String get doctorSuspendedSuccessfully => 'تم تعليق الطبيب بنجاح';

  @override
  String get doctorUnsuspendedSuccessfully => 'تم إلغاء تعليق الطبيب بنجاح';

  @override
  String get failedToLoadPatients => 'فشل في تحميل قائمة المرضى';

  @override
  String get selectPatient => 'اختر المريض';

  @override
  String get patientFound => 'تم العثور على المريض';

  @override
  String get confirmPatientIdentity => 'يرجى تأكيد هوية المريض للمتابعة';

  @override
  String get viewPatient => 'عرض المريض';

  @override
  String get patientIdentification => 'تحديد هوية المريض';

  @override
  String get searchByNationalId => 'البحث بالرقم القومي';

  @override
  String get enter14DigitNationalId => 'أدخل الرقم القومي المكون من 14 رقمًا';

  @override
  String get searchPatient => 'بحث عن مريض';

  @override
  String get or => 'أو';

  @override
  String get scanPatientQrCode => 'مسح رمز QR الخاص بالمريض';

  @override
  String get openQrScanner => 'فتح ماسح QR';

  @override
  String get typePrescription => 'كتابة وصفة';

  @override
  String get sessionOptions => 'خيارات الجلسة';

  @override
  String chooseSessionAction(Object name) {
    return 'اختر ما تريد القيام به مع $name';
  }

  @override
  String get viewHistory => 'عرض التاريخ الطبي';

  @override
  String reviewMedicalHistory(Object name) {
    return 'راجع التاريخ الطبي لـ$name';
  }

  @override
  String get endSession => 'إنهاء الجلسة';

  @override
  String areYouSureEndSession(Object name) {
    return 'هل أنت متأكد أنك تريد إنهاء الجلسة مع $name؟';
  }

  @override
  String get previous => 'السابق';

  @override
  String get nextStep => 'الخطوة التالية';

  @override
  String get preview => 'معاينة';

  @override
  String get diagnosis => 'التشخيص';

  @override
  String stepOf(Object current, Object total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get pleaseEnterDiagnosis => 'يرجى إدخال التشخيص';

  @override
  String get pleaseAddAtLeastOneMedication => 'يرجى إضافة دواء واحد على الأقل';

  @override
  String get edit => 'تعديل';

  @override
  String get publish => 'نشر';

  @override
  String get prescriptionCompleted => 'تم إكمال الوصفة';

  @override
  String get prescriptionGeneratedSaved => 'تم إنشاء الوصفة الطبية وحفظها في السجل الطبي للمريض بنجاح.';

  @override
  String get done => 'تم';

  @override
  String get patientInformation => 'معلومات المريض';

  @override
  String get name => 'الاسم';

  @override
  String get examinationsSection => 'الفحوصات';

  @override
  String get prescriptionSavedSuccessfully => 'تم حفظ الوصفة بنجاح!';

  @override
  String failedToSavePrescription(Object error) {
    return 'فشل في حفظ الوصفة: $error';
  }

  @override
  String createNewPrescriptionFor(Object name) {
    return 'إنشاء وصفة طبية جديدة لـ $name';
  }

  @override
  String get scanQrCode => 'مسح رمز QR';

  @override
  String get positionQrCode => 'ضع رمز QR داخل الإطار للمسح';

  @override
  String get flashOn => 'تشغيل الفلاش';

  @override
  String get flashOff => 'إيقاف الفلاش';

  @override
  String get capture => 'التقاط';

  @override
  String get manualEntry => 'إدخال يدوي';

  @override
  String get processingQrCode => 'جارٍ معالجة رمز QR...';

  @override
  String get invalidQrCode => 'رمز QR غير صالح';

  @override
  String get totalSessions => 'إجمالي الجلسات';

  @override
  String get patients => 'المرضى';

  @override
  String get filterSessions => 'تصفية الجلسات';

  @override
  String get searchByPatient => 'ابحث باسم المريض أو الرقم القومي...';

  @override
  String get noSessionsFound => 'لا توجد جلسات';

  @override
  String noSessionsFoundMatching(Object query) {
    return 'لا توجد جلسات مطابقة لـ \"$query\"';
  }

  @override
  String get noPatientSessionsFound => 'لا توجد جلسات للمرضى للفترة الزمنية المحددة.';

  @override
  String get sessionDate => 'تاريخ الجلسة';

  @override
  String get sessionNotes => 'ملاحظات الجلسة';

  @override
  String get noNotesAvailable => 'لا توجد ملاحظات';

  @override
  String get yesterday => 'أمس';

  @override
  String atTime(Object date, Object time) {
    return '$date في $time';
  }

  @override
  String get loginFailed => 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get cancel => 'إلغاء';

  @override
  String get searchForMedicine => 'البحث عن دواء';

  @override
  String get createDoctorAccount => 'أنشئ حساب طبيب لإدارة المرضى والجلسات';

  @override
  String get agreeToTerms => 'بالمتابعة، فإنك توافق على الشروط وسياسة الخصوصية الخاصة بنا';

  @override
  String get chooseYourRole => 'اختر دورك للبدء  ';

  @override
  String get patient => 'مريض';

  @override
  String get createPatientAccount => 'أنشئ حساب مريض للوصول إلى الخدمات الطبية';

  @override
  String get deleteMedication => 'حذف الدواء';

  @override
  String get deleteMedicationConfirm => 'هل أنت متأكد أنك تريد حذف هذا الدواء؟';

  @override
  String get chronicDisease => 'مرض مزمن';

  @override
  String get medications => 'الأدوية';

  @override
  String get generateHistorySummary => 'إنشاء ملخص التاريخ الطبي';

  @override
  String get patientHistory => 'تاريخ المريض';

  @override
  String get medicalAssistant => 'المساعد الطبي';

  @override
  String get medicalAssistantWelcome => 'مرحبًا! أنا مساعدك الطبي. كيف يمكنني مساعدتك اليوم؟ يمكنك سؤالي عن الأعراض أو الأدوية أو النصائح الصحية العامة.';

  @override
  String get medicalAssistantAskAnything => 'اسألني عن صحتك أو الأعراض أو النصائح الطبية.';

  @override
  String get medicalAssistantInfoTitle => 'معلومات المساعد الطبي';

  @override
  String get medicalAssistantInfoDesc => 'هذا الروبوت الطبي يوفر معلومات صحية عامة فقط.';

  @override
  String get medicalAssistantDisclaimer => 'تنويه هام:';

  @override
  String get medicalAssistantDisclaimerBullets => '• ليس بديلاً عن الاستشارة الطبية المهنية\n• في حالة الطوارئ، اتصل بخدمات الطوارئ\n• استشر دائمًا مقدمي الرعاية الصحية المؤهلين';

  @override
  String get close => 'إغلاق';

  @override
  String get typeYourHealthQuestion => 'اكتب سؤالك الصحي...';

  @override
  String get suggestionHeadache1 => 'هل هو صداع نصفي؟';

  @override
  String get suggestionHeadache2 => 'علاجات طبيعية للصداع';

  @override
  String get suggestionHeadache3 => 'متى تزور الطبيب؟';

  @override
  String get suggestionCold1 => 'الفرق بين البرد والإنفلونزا';

  @override
  String get suggestionCold2 => 'علاجات طبيعية للبرد';

  @override
  String get suggestionCold3 => 'كورونا أم برد؟';

  @override
  String get suggestionBloodPressure1 => 'تفاصيل حمية DASH';

  @override
  String get suggestionBloodPressure2 => 'قراءات ضغط الدم';

  @override
  String get suggestionBloodPressure3 => 'أطعمة مفيدة للقلب';

  @override
  String get suggestionWater1 => 'علامات الجفاف';

  @override
  String get suggestionWater2 => 'أفضل أوقات شرب الماء';

  @override
  String get suggestionWater3 => 'بدائل الماء';

  @override
  String get suggestionCommon1 => 'أعراض شائعة';

  @override
  String get suggestionCommon2 => 'الصحة الوقائية';

  @override
  String get suggestionCommon3 => 'نصائح غذائية';

  @override
  String get suggestionCommon4 => 'تمارين موصى بها';

  @override
  String get diagnosed => 'تم التشخيص';

  @override
  String get diagnosedUnknown => 'تم التشخيص: غير معروف';

  @override
  String get detailedDiagnosisHint => 'أدخل التشخيص التفصيلي...\n\nمثال:\n• التشخيص الأساسي\n• الحالات الثانوية\n• الأعراض الملحوظة';

  @override
  String get verify => 'تحقق';

  @override
  String get addExamination => 'إضافة فحص';

  @override
  String get examinationNameHint => 'مثال: الفحص السريري، فحص القلب';

  @override
  String get pleaseFillName => 'يرجى إدخال الاسم والملاحظات';

  @override
  String get recordPhysicalFindings => 'سجل نتائج الفحص السريري';

  @override
  String get noExaminationsRecorded => 'لا توجد فحوصات مسجلة';

  @override
  String get addPhysicalFindings => 'أضف نتائج الفحص السريري';

  @override
  String get noChronicDiseasesFound => 'لا توجد أمراض مزمنة';

  @override
  String get noBloodPressureReadingsFound => 'لا توجد قراءات لضغط الدم';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get pdfDownloaded => 'تم تنزيل ملف PDF إلى مجلد التنزيلات';

  @override
  String failedToDownloadPdf(Object error) {
    return 'فشل في تنزيل ملف PDF: $error';
  }

  @override
  String get chronicDiseases => 'الأمراض المزمنة';

  @override
  String get searchChronicDiseases => 'ابحث عن الأمراض المزمنة...';

  @override
  String get searchMedications => 'ابحث عن الأدوية...';

  @override
  String get search => 'بحث...';

  @override
  String get filterByDate => 'تصفية حسب التاريخ:';

  @override
  String get allTime => 'كل الوقت';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get last30Days => 'آخر 30 يومًا';

  @override
  String get customDate => 'تاريخ مخصص';

  @override
  String selected(Object date) {
    return 'المحدد: $date';
  }

  @override
  String get filterByLevel => 'تصفية حسب المستوى:';

  @override
  String get filterByStatus => 'تصفية حسب الحالة:';

  @override
  String get chronic => 'مزمن';

  @override
  String get addPrescribedMedications => 'أضف الأدوية الموصوفة مع الجرعة والتوقيت';

  @override
  String get noMedicationsAddedYet => 'لم تتم إضافة أدوية بعد';

  @override
  String get tapAddMedicineToStart => 'اضغط \"إضافة دواء\" لبدء الوصفة';

  @override
  String get timesDaily => 'مرات يومياً';

  @override
  String get medicineNameRequired => 'اسم الدواء *';

  @override
  String get medicineNameHint => 'مثال: باراسيتامول';

  @override
  String get dosageRequired => 'الجرعة *';

  @override
  String get dosageHint => 'مثال: 500 ملغ';

  @override
  String get pleaseFillRequiredFields => 'يرجى تعبئة الحقول المطلوبة';

  @override
  String next(Object time) {
    return 'التالي: $time';
  }

  @override
  String get tablet => 'قرص(أقراص)';

  @override
  String get days => 'يوم';

  @override
  String get previewPrescription => 'معاينة الوصفة';

  @override
  String get additionalNotes => 'ملاحظات إضافية';

  @override
  String get addFollowUpInstructions => 'أضف تعليمات المتابعة والتوصيات';

  @override
  String get notesHint => 'أدخل ملاحظات إضافية أو توصيات أو تعليمات للمتابعة...\n\nمثال:\n• تناول الدواء مع الطعام\n• تجنب الأنشطة المجهدة\n• العودة إذا ساءت الأعراض\n• متابعة بعد أسبوع';

  @override
  String get quickFollowUpOptions => 'خيارات متابعة سريعة';

  @override
  String get tapOptionToAdd => 'اضغط على أي خيار لإضافته إلى الملاحظات:';

  @override
  String get followUp1Week => 'متابعة بعد أسبوع';

  @override
  String get followUp2Weeks => 'متابعة بعد أسبوعين';

  @override
  String get followUp1Month => 'متابعة بعد شهر';

  @override
  String get labTestsRequired => 'مطلوب تحاليل مخبرية';

  @override
  String get specialistReferralNeeded => 'مطلوب تحويل إلى أخصائي';

  @override
  String get completeMedicationCourse => 'إكمال كورس الدواء';

  @override
  String get returnIfSymptomsWorsen => 'العودة إذا ساءت الأعراض';

  @override
  String get restAndHydration => 'الراحة وشرب السوائل';

  @override
  String get noFollowUpNeeded => 'لا حاجة للمتابعة';

  @override
  String get doctorPrefix => 'د.';

  @override
  String get unknown => 'غير معروف';

  @override
  String get stepPatient => 'المريض';

  @override
  String get stepHistory => 'التاريخ';

  @override
  String get stepExamination => 'الفحص';

  @override
  String get stepDiagnosis => 'التشخيص';

  @override
  String get stepMedications => 'الأدوية';

  @override
  String get stepNotes => 'ملاحظات';

  @override
  String get stepPreview => 'معاينة';

  @override
  String vaccineDate(Object date) {
    return 'التاريخ: $date';
  }

  @override
  String get vaccineDateNA => 'التاريخ: غير متوفر';

  @override
  String dateLabel(Object date) {
    return 'التاريخ: $date';
  }

  @override
  String get dateNotAvailable => 'التاريخ: غير متوفر';

  @override
  String get stepTitle1 => 'المعلومات الشخصية';

  @override
  String get stepTitle2 => 'التفاصيل';

  @override
  String get historySummaryTitle => 'ملخص التاريخ';

  @override
  String get generatingHistorySummary => 'جاري إنشاء ملخص التاريخ...';

  @override
  String get noAvailableHistory => 'لا يوجد تاريخ متاح';

  @override
  String get noHistorySummaryGenerated => 'لم نتمكن من إنشاء ملخص للتاريخ الخاص بك.';

  @override
  String get healthSummary => 'ملخص صحي';

  @override
  String get noHealthSummaryAvailable => 'لا يوجد ملخص صحي متاح';

  @override
  String get bloodPressureInsights => 'معلومات ضغط الدم';

  @override
  String get tipsAndGuides => 'نصائح وإرشادات';

  @override
  String get generalAdvicesAboutMedicines => 'نصائح عامة حول الأدوية';

  @override
  String get vaccineInformation => 'معلومات اللقاح';

  @override
  String get allergyInformation => 'معلومات الحساسية';

  @override
  String get medicinesInformation => 'معلومات الأدوية';

  @override
  String get failedToFetchHistorySummary => 'فشل في جلب ملخص التاريخ. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get downloading => 'جاري التحميل...';
}
