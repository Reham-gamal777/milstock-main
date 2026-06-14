import 'package:flutter/material.dart';

class AppLocalizations {
  final bool isArabic;

  AppLocalizations(this.isArabic);

  static AppLocalizations of(BuildContext context) {
    // Falls back to simple local state lookup or provider-based state lookup
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations ?? AppLocalizations(false);
  }

  TextDirection get textDirection => isArabic ? TextDirection.rtl : TextDirection.ltr;
  TextAlign get textAlign => isArabic ? TextAlign.right : TextAlign.left;
  Alignment get alignment => isArabic ? Alignment.centerRight : Alignment.centerLeft;

  String translate(String key) {
    if (isArabic) {
      return _arabicValues[key] ?? key;
    }
    return _englishValues[key] ?? key;
  }

  static const Map<String, String> _englishValues = {
    'appName': 'MilStock',
    'appSubtitle': 'Military Logistics Command',
    'slogan': 'Precision Inventory Control for Military Operations',
    'sloganDetails': 'Secure and real-time tracking of essential supplies and logistical assets across all units and warehouses.',
    'badgeSecure': 'Secure Access',
    'badgeRole': 'Role-Based Control',
    'badgeAnalytics': 'Real-Time Analytics',
    
    // Login Screen
    'loginTitle': 'Welcome Back',
    'loginSub': 'Sign in to access your command center',
    'emailOrUsername': 'Email or Username',
    'emailPlaceholder': 'Enter your email or username',
    'password': 'Password',
    'passwordPlaceholder': 'Enter your password',
    'rememberMe': 'Remember me',
    'forgotPassword': 'Forgot password?',
    'signInButton': 'Sign In to MilStock',
    'demoCredentials': 'DEMO CREDENTIALS',
    'demoAdmin': 'Admin',
    'demoUser': 'Unit User',
    'demoPasswordInfo': 'Password: any value',
    'switchLanguage': 'التبديل إلى العربية',
    'loginError': 'Invalid email or password',

    // Dashboard Screen
    'dashboard': 'Dashboard',
    'activeRequests': 'Active Requests',
    'pendingApproval': 'Pending Approval',
    'completedThisMonth': 'Completed This Month',
    'approvedToday': '1 approved today',
    'processingEst': 'Est. 18h processing',
    'vsLastMonth': '+3 vs last month',
    'stockLevelTitle': 'Stock Level — This Week',
    'capacityPercentage': '% of capacity',
    'recentRequests': 'Recent Requests',
    'viewAll': 'View All',
    'criticalAlerts': 'Critical Alerts',
    'notifications': 'Notifications',
    'searchPlaceholder': 'Search by item name or ID...',
    
    // Inventory Management
    'inventoryManagement': 'Inventory Management',
    'inventorySubtitle': 'Track and manage all inventory items across warehouses',
    'addNewItem': 'Add New Item',
    'itemId': 'ITEM ID',
    'itemName': 'ITEM NAME',
    'category': 'CATEGORY',
    'quantity': 'QUANTITY',
    'status': 'STATUS',
    'lastUpdated': 'LAST UPDATED',
    'warehouse': 'WAREHOUSE',
    'action': 'ACTION',
    'filters': 'Filters',
    'export': 'Export',
    
    // Status badges
    'inStock': 'In Stock',
    'lowStock': 'Low Stock',
    'outOfStock': 'Out of Stock',
    'pending': 'Pending',
    'approved': 'Approved',
    'delivered': 'Delivered',

    // Add Item Dialog
    'addItemTitle': 'Add New Inventory Item',
    'basicInfo': 'Basic Information',
    'stockInfo': 'Stock Information',
    'locationStorage': 'Location & Storage',
    'expirationTracking': 'Expiration & Tracking',
    'additionalDetails': 'Additional Details',
    'serialNumber': 'Serial Number',
    'serialNumberPlaceholder': 'Enter serial number',
    'itemNameLabel': 'Item Name',
    'itemNamePlaceholder': 'e.g. MRE Rations Type A',
    'categoryLabel': 'Category',
    'quantityLabel': 'Initial Quantity',
    'quantityPlaceholder': 'e.g. 500',
    'warehouseLabel': 'Warehouse Location',
    'warehousePlaceholder': 'Select Warehouse',
    'expiryDateLabel': 'Expiry Date',
    'expiryDatePlaceholder': 'YYYY-MM-DD',
    'manufacturerLabel': 'Manufacturer/Supplier',
    'manufacturerPlaceholder': 'e.g. Alpha Company',
    'additionalNotes': 'Notes',
    'additionalNotesPlaceholder': 'Add any additional notes...',
    'saveItemButton': 'Save Item',
    'cancelButton': 'Cancel',
    'successAddItem': 'Item added successfully',

    // Sidebar items
    'menuDashboard': 'Dashboard',
    'menuInventory': 'Inventory',
    'menuRequests': 'My Requests',
    'menuSettings': 'Settings',
    'menuProfile': 'Profile',
    'menuLogout': 'Logout',
    
    // Demographics
    'roleAdmin': 'Admin / Command',
    'roleUser': 'User / Requester',
    'averageProcessingTime': 'Avg. Processing Time',
    'averageHours': '18 Hrs',
    'hoursChange': '-2 hours from last week',
  };

  static const Map<String, String> _arabicValues = {
    'appName': 'ميلستوك',
    'appSubtitle': 'قيادة اللوجستيات العسكرية',
    'slogan': 'إدارة المخزون العسكري بدقة عالية وكفاءة استثنائية',
    'sloganDetails': 'تتبع أمني وفوري للإمدادات الأساسية والمستلزمات اللوجستية عبر جميع الوحدات والمستودعات.',
    'badgeSecure': 'وصول آمن',
    'badgeRole': 'تحكم بالأدوار',
    'badgeAnalytics': 'تحليلات فورية',

    // Login Screen
    'loginTitle': 'مرحباً بعودتك',
    'loginSub': 'سجل دخولك للوصول إلى لوحة القيادة',
    'emailOrUsername': 'البريد الإلكتروني أو اسم المستخدم',
    'emailPlaceholder': 'أدخل بريدك الإلكتروني أو اسم المستخدم',
    'password': 'كلمة المرور',
    'passwordPlaceholder': 'أدخل كلمة المرور',
    'rememberMe': 'تذكرني',
    'forgotPassword': 'نسيت كلمة المرور؟',
    'signInButton': 'تسجيل الدخول إلى MilStock',
    'demoCredentials': 'بيانات تجريبية',
    'demoAdmin': 'مسؤول',
    'demoUser': 'مستخدم',
    'demoPasswordInfo': 'كلمة المرور: أي كلمة',
    'switchLanguage': 'Switch to English',
    'loginError': 'البريد الإلكتروني أو كلمة المرور غير صالحة',

    // Dashboard Screen
    'dashboard': 'لوحة القيادة',
    'activeRequests': 'الطلبات النشطة',
    'pendingApproval': 'في انتظار الموافقة',
    'completedThisMonth': 'المكتملة هذا الشهر',
    'approvedToday': 'تمت الموافقة على 1 اليوم',
    'processingEst': 'المعالجة المتوقعة 18 ساعة',
    'vsLastMonth': '+3 مقارنة بالشهر الماضي',
    'stockLevelTitle': 'مستوى المخزون — هذا الأسبوع',
    'capacityPercentage': '% من السعة',
    'recentRequests': 'الطلبات الأخيرة',
    'viewAll': 'عرض الكل',
    'criticalAlerts': 'تنبيهات حرجة',
    'notifications': 'الإشعارات',
    'searchPlaceholder': 'البحث باسم العنصر أو الرقم التعريفي...',

    // Inventory Management
    'inventoryManagement': 'إدارة المخزون',
    'inventorySubtitle': 'تتبع وإدارة جميع عناصر المخزون عبر المستودعات والمخازن',
    'addNewItem': 'إضافة عنصر جديد +',
    'itemId': 'رقم العنصر',
    'itemName': 'اسم العنصر',
    'category': 'الفئة',
    'quantity': 'الكمية',
    'status': 'الحالة',
    'lastUpdated': 'آخر تحديث',
    'warehouse': 'المستودع',
    'action': 'الإجراء',
    'filters': 'تصفية',
    'export': 'تصدير',

    // Status badges
    'inStock': 'متوفر',
    'lowStock': 'مخزون منخفض',
    'outOfStock': 'نفذ المخزون',
    'pending': 'قيد الانتظار',
    'approved': 'موافق عليه',
    'delivered': 'تم التسليم',

    // Add Item Dialog
    'addItemTitle': 'إضافة عنصر مخزون جديد',
    'basicInfo': 'المعلومات الأساسية',
    'stockInfo': 'معلومات المخزون',
    'locationStorage': 'الموقع والتخزين',
    'expirationTracking': 'الصلاحية والتتبع',
    'additionalDetails': 'تفاصيل إضافية',
    'serialNumber': 'الرقم التسلسلي',
    'serialNumberPlaceholder': 'أدخل الرقم التسلسلي',
    'itemNameLabel': 'اسم العنصر',
    'itemNamePlaceholder': 'مثال: وجبات جاهزة فئة أ',
    'categoryLabel': 'الفئة',
    'quantityLabel': 'الكمية الأولية',
    'quantityPlaceholder': 'مثال: 500',
    'warehouseLabel': 'موقع المستودع',
    'warehousePlaceholder': 'اختر المستودع',
    'expiryDateLabel': 'تاريخ انتهاء الصلاحية',
    'expiryDatePlaceholder': 'YYYY-MM-DD',
    'manufacturerLabel': 'الشركة المصنعة / المورد',
    'manufacturerPlaceholder': 'مثال: شركة ألفا',
    'additionalNotes': 'ملاحظات',
    'additionalNotesPlaceholder': 'أضف أي ملاحظات إضافية...',
    'saveItemButton': 'حفظ العنصر',
    'cancelButton': 'إلغاء',
    'successAddItem': 'تم إضافة العنصر بنجاح',

    // Sidebar items
    'menuDashboard': 'لوحة القيادة',
    'menuInventory': 'المخزون',
    'menuRequests': 'طلباتي',
    'menuSettings': 'الإعدادات',
    'menuProfile': 'الملف الشخصي',
    'menuLogout': 'تسجيل الخروج',

    // Demographics
    'roleAdmin': 'مسؤول / القيادة العامة',
    'roleUser': 'مستخدم / مقدم الطلب',
    'averageProcessingTime': 'متوسط وقت المعالجة',
    'averageHours': '18 ساعة',
    'hoursChange': 'ساعتين أقل من الأسبوع الماضي',
  };
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final bool isArabic;

  const AppLocalizationsDelegate(this.isArabic);

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(isArabic);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => true;
}
