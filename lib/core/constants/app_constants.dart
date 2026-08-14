class AppConstants {
  AppConstants._();

  // Durations (in seconds) - Set to 1 minute (60s) for testing
  static const int shiftDurationSeconds = 1 * 60; // 1 minute (60 seconds)
  static const int alertDurationSeconds = 1 * 60; // 1 minute (60 seconds)

  // Hive Box & Keys
  static const String appBoxName = 'ru_ok_app_box';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserName = 'user_name';
  static const String keyUserPhone = 'user_phone';
  static const String keyCountryCode = 'country_code';
  static const String keySafetyStatus = 'safety_status';
  static const String keyShiftEndTime = 'shift_end_time';
  static const String keyAlertEndTime = 'alert_end_time';
  static const String keyIncidentTimestamp = 'incident_timestamp';
  static const String keyIncidentLatitude = 'incident_latitude';
  static const String keyIncidentLongitude = 'incident_longitude';

  // Safety Status Values
  static const String statusIdle = 'IDLE';
  static const String statusShiftRunning = 'SHIFT_RUNNING';
  static const String statusAlertRunning = 'ALERT_RUNNING';
  static const String statusInTrouble = 'IN_TROUBLE';

  // Alarm IDs for Android Alarm Manager
  static const int shiftAlarmId = 1001;
  static const int alertAlarmId = 1002;

  // Notification Constants
  static const String notificationChannelId = 'ru_ok_safety_channel';
  static const String notificationChannelName = 'RU OK Safety Alerts';
  static const String notificationChannelDescription = 'Urgent safety countdown and alert notifications';
  static const int shiftEndNotificationId = 2001;
  static const int alertEndNotificationId = 2002;
}
