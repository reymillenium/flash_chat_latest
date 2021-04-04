// Packages:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Allows to use FieldValue, etc
import 'package:bubble/bubble.dart';
import 'package:intl/intl.dart'; // Allows to use DateFormat
import 'package:audioplayers/audio_cache.dart';

// Screens:
import 'package:flash_chat_latest/screens/welcome_screen.dart';
import 'package:flash_chat_latest/screens/login_screen.dart';
import 'package:flash_chat_latest/screens/registration_screen.dart';
import 'package:flash_chat_latest/screens/chat_screen.dart';

// Components:

// Helpers:
import 'package:flash_chat_latest/helpers/auth.dart';

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class SoundEffectsHelper {
  final AudioCache player = AudioCache(prefix: 'assets/audio/');

  void playSendButtonClick() {
    playNote(fileName: 'zapsplat_multimedia_notification_pop_message_tooltip_small_click_007_63077.mp3');
  }

  void playNote({String fileName, double volume = 1.00}) {
    player.play(fileName, volume: volume);
  }
}
