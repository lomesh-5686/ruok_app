class AppStrings {
  AppStrings._();

  // App Name
  static const String appName = 'RU OK';

  // Splash Screen
  static const String splashTagline = 'Personal Safety Alert';

  // Auth Screen
  static const String authTitle = 'Tell us about yourself';
  static const String authSubtitle = 'Enter your name and phone number to continue.';
  static const String nameLabel = 'Name';
  static const String namePlaceholder = 'John Doe';
  static const String phoneLabel = 'Mobile number';
  static const String phonePlaceholder = '9876543210';
  static const String btnContinue = 'Continue';
  static const String nameValidation = 'Please enter your name';
  static const String phoneValidation = 'Please enter a valid 10-digit mobile number';
  static const String permissionError = 'Please grant notification and location permissions to continue.';

  // Alert Idle Screen
  static const String alertHeader = 'Alert';
  static const String idleSubtitle = 'By pressing start you are confirming your phone will messages the selected emergency contacts if you do not respond.';
  static const String btnStartShift = 'Start Shift';

  // Active Shift Screen
  static const String shiftRunningSubtitle = "An hour timer has started. Once the timer ends, we'll send you a notification to confirm that you are in a safe area.";
  static const String timerNotifyAfter = "We'll notify after";
  static const String btnEndShift = 'End Shift';

  // Alert Response Screen
  static const String alertResponseSubtitle = "Confirm if you're working in a safe area. You have 5 minutes to respond; otherwise, the app will automatically send an alert to your emergency contacts with relevant info, including your location and status.";
  static const String timerSendAlert = "We'll send alert";
  static const String alertQuestion = 'Are you sure that you are working in safe area?';
  static const String btnNo = 'No';
  static const String btnYesImSafe = "Yes I'm Safe";

  // Incident Screen
  static const String incidentDetectedPrefix = 'We have detected an emergency situation involving you on ';
  static const String incidentLocationPrefix = '. Your GPS location has been recorded as ';
  static const String incidentContactsSuffix = ', and your emergency contacts have been notified.';
  static const String btnRestartShift = 'Restart Shift';

  // Confirmation Bottom Sheet Strings
  static const String confirmStartShiftTitle = 'Are you sure you want to start shift?';
  static const String confirmEndShiftTitle = 'Are you sure you want to end shift?';
  static const String confirmRestartShiftTitle = 'Are you sure you want to restart shift?';
  static const String confirmSafeTitle = 'By clicking "Yes, I\'m Safe" you are confirming that you are working in safe area.';
  static const String confirmTroubleTitle = 'By clicking "No" app will send an emergency alert to your contacts.';
  static const String btnYes = 'Yes';
  static const String btnCancel = 'Cancel';
  static const String btnYesIConfirm = 'Yes, I Confirm';

  // Notifications
  static const String notif1Title = 'Shift Timer Finished';
  static const String notif1Body = 'Your timer is finished. Tap this notification to respond on alert timer.';
  static const String notif2Title = 'Emergency Alert Triggered';
  static const String notif2Body = "You might be in trouble. Don't worry, we saved your current location.";
}
