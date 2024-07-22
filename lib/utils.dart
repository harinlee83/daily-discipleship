import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';

bool isFirstLoginToday(List<HistoryDay> history) {
  // This function checks to see if the most recent historyDay is older than today
  DateTime now = DateTime.now();
  DateTime lastHistoryDay = history.last.date;
  return now.year > lastHistoryDay.year ||
      (now.year == lastHistoryDay.year && now.month > lastHistoryDay.month) ||
      (now.year == lastHistoryDay.year &&
          now.month == lastHistoryDay.month &&
          now.day > lastHistoryDay.day);
}

bool isDailyDevotionStreakBroken(List<HistoryDay> history) {
  // Check to see if today's check in is completed
  if (history.last.hymnCompleted &&
      history.last.readingCompleted &&
      history.last.prayerCompleted) {
    return false;
  }

  // If the history is length 1, then there is no streak in the first place
  if (history.length == 1) {
    return false;
  }
  // Grab yesterday's date as a DateTime object
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime dateYesterday =
      DateTime(yesterday.year, yesterday.month, yesterday.day);

  // Grab the second to last HistoryDay in the history
  DateTime lastHistoryDate = history[history.length - 2].date;
  DateTime dateLastHistory = DateTime(
      lastHistoryDate.year, lastHistoryDate.month, lastHistoryDate.day);

  // Because a new day is added when the user logs in, this will give the user all day to complete the daily devotions
  if (dateLastHistory == dateYesterday) {
    return false;
  }
  return true;
}

bool isSpiritualHealthStreakBroken(List<HistoryDay> history) {
  debugPrint("Checking Spiritual Health Streak...");
  // Check to see if today's check in is completed
  if (history.last.spiritualHealthCheckCompleted) {
    return false;
  }

  // If the history is length 1, then there is no streak in the first place
  if (history.length == 1) {
    return false;
  }
  // Grab yesterday's date as a DateTime object
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime dateYesterday =
      DateTime(yesterday.year, yesterday.month, yesterday.day);

  // Grab the second to last HistoryDay in the history
  DateTime lastHistoryDate = history[history.length - 2].date;
  DateTime dateLastHistory = DateTime(
      lastHistoryDate.year, lastHistoryDate.month, lastHistoryDate.day);

  // Because a new day is added when the user logs in, this will give the user all day to complete the daily devotions
  if (dateLastHistory == dateYesterday) {
    return false;
  }
  return true;
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return "";
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
