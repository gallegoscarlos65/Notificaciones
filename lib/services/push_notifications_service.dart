// SHA1: BA:E2:E2:EE:4D:F5:B5:34:09:03:3B:A5:2D:D7:F6:36:91:EB:A5:15

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Se trabaja todo con static para no tener que crear instancia o tener que usar provider
class PushNotificationService {
  //Esto es parte del archivo que se instalo en android/app, el .JSON
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  //El token es lo que se quiere generar
  static String? token;
  static StreamController<String> _messageStream = new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  //Recibe un RemoteMessage, message
  static Future _backgroundHandler( RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    print(message.data);
    // _messageStream.add( message.notification?.body ?? 'No title');
    _messageStream.add( message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler( RemoteMessage message) async {
    // print('onMessageHandler Handler ${message.messageId}');
    print(message.data);
    _messageStream.add( message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp( RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');
    print(message.data);
    _messageStream.add( message.data['product'] ?? 'No data');
  }

  //Para inicializar todo lo que es la instancia
  static Future initializeApp () async{

    //Push notifications
    await Firebase.initializeApp();
    token  = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //Local notifications

  }
  //Sirve para cerrarlo y que asi no muestre un warning en la parte de arriba
  static closeStreams() {
    _messageStream.close();
  }

}