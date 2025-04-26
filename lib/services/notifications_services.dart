import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitialized = false;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await requestPermission();
    await setupFlutterNotifications();
    await setupMessageHandlers();
    final String? token = await getFCMToken();
    print('FCM Token: $token');
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Updated iOS initialization without deprecated parameter
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle when a notification is tapped
        print('Notification tapped: ${response.payload}');
      },
    );
    _isFlutterLocalNotificationInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data['route'],
      );
    }
  }

  Future<void> setupMessageHandlers() async {
    // Background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // When app is opened from terminated state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Get initial message if app was opened from notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Handle navigation based on message data
    // Example: Navigator.pushNamed(context, message.data['route']);
    print('Message opened: ${message.messageId}');
    print('Notification data: ${message.data}');
  }

  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }
}
