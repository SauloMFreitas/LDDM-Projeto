import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationManager {
  NotificationManager() {
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );

    // Verifica e solicita permissão se necessário
    await _checkAndRequestNotificationPermission();
  }

  Future<void> _checkAndRequestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleNotification(int id, String nome, int minutos, DateTime vencimento) async {
    // Garante que as permissões são verificadas novamente antes de agendar a notificação
    await _checkAndRequestNotificationPermission();

    DateTime agora = DateTime.now();

    // Calcula a diferença em minutos entre a data/hora atual e o vencimento
    int minutosFaltando = vencimento.difference(agora).inSeconds;
    minutosFaltando -= minutos * 60;

    print("Minutos faltando até o vencimento: $minutosFaltando");
    print('Notificação agendada para daqui: $minutosFaltando');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Alerta de tarefa: MyPlanner',
        body: 'Você possui a tarefa [$nome] agendada para $minutos minutos! Programe-se!',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationInterval(
        interval: minutosFaltando,
        repeats: false,
      ),
    );
  }
}
