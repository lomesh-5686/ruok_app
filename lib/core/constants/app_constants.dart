class AppConstants {
  AppConstants._();

  static const int shiftDurationSeconds = 1 * 60;
  static const int alertDurationSeconds = 30;

  // static const int shiftDurationSeconds = 10 * 60;
  // static const int alertDurationSeconds = 5 * 60;

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
  static const String keyLastKnownLatitude = 'last_known_latitude';
  static const String keyLastKnownLongitude = 'last_known_longitude';

  static const String statusIdle = 'IDLE';
  static const String statusShiftRunning = 'SHIFT_RUNNING';
  static const String statusAlertRunning = 'ALERT_RUNNING';
  static const String statusInTrouble = 'IN_TROUBLE';

  static const int shiftAlarmId = 1001;
  static const int alertAlarmId = 1002;

  static const String notificationChannelId = 'ru_ok_safety_channel';
  static const String notificationChannelName = 'RU OK Safety Alerts';
  static const String notificationChannelDescription =
      'Urgent safety countdown and alert notifications';
  static const int shiftEndNotificationId = 2001;
  static const int alertEndNotificationId = 2002;
}
