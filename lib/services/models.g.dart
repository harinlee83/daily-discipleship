// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String? ?? "",
      dailyDevotionStreak: json['dailyDevotionStreak'] as int? ?? 0,
      spiritualHealthStreak: json['spiritualHealthStreak'] as int? ?? 0,
      uid: json['uid'] as String? ?? "",
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => HistoryDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      emailIsVerified: json['emailIsVerified'] as bool? ?? false,
      name: json['name'] as String? ?? "",
      notificationTime: json['notificationTime'] as String? ?? "8:00",
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'emailIsVerified': instance.emailIsVerified,
      'dailyDevotionStreak': instance.dailyDevotionStreak,
      'spiritualHealthStreak': instance.spiritualHealthStreak,
      'name': instance.name,
      'uid': instance.uid,
      'history': instance.history,
      'notificationTime': instance.notificationTime,
    };

HistoryDay _$HistoryDayFromJson(Map<String, dynamic> json) => HistoryDay(
      date: HistoryDay._timestampToDateTime(json['date'] as Timestamp),
      fruitOfSpiritRunningSum: json['fruitOfSpiritRunningSum'] == null
          ? null
          : FruitOfSpiritRunningSum.fromJson(
              json['fruitOfSpiritRunningSum'] as Map<String, dynamic>),
      hymnCompleted: json['hymnCompleted'] as bool? ?? false,
      prayerCompleted: json['prayerCompleted'] as bool? ?? false,
      readingCompleted: json['readingCompleted'] as bool? ?? false,
      spiritualHealthCheckCompleted:
          json['spiritualHealthCheckCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$HistoryDayToJson(HistoryDay instance) =>
    <String, dynamic>{
      'date': HistoryDay._dateTimeToTimestamp(instance.date),
      'fruitOfSpiritRunningSum': instance.fruitOfSpiritRunningSum,
      'hymnCompleted': instance.hymnCompleted,
      'prayerCompleted': instance.prayerCompleted,
      'readingCompleted': instance.readingCompleted,
      'spiritualHealthCheckCompleted': instance.spiritualHealthCheckCompleted,
    };

FruitOfSpiritRunningSum _$FruitOfSpiritRunningSumFromJson(
        Map<String, dynamic> json) =>
    FruitOfSpiritRunningSum(
      love: json['love'] as int?,
      joy: json['joy'] as int?,
      peace: json['peace'] as int?,
      patience: json['patience'] as int?,
      kindness: json['kindness'] as int?,
      goodness: json['goodness'] as int?,
      faithfulness: json['faithfulness'] as int?,
      gentleness: json['gentleness'] as int?,
      selfControl: json['selfControl'] as int?,
    );

Map<String, dynamic> _$FruitOfSpiritRunningSumToJson(
        FruitOfSpiritRunningSum instance) =>
    <String, dynamic>{
      'love': instance.love,
      'joy': instance.joy,
      'peace': instance.peace,
      'patience': instance.patience,
      'kindness': instance.kindness,
      'goodness': instance.goodness,
      'faithfulness': instance.faithfulness,
      'gentleness': instance.gentleness,
      'selfControl': instance.selfControl,
    };

Devotion _$DevotionFromJson(Map<String, dynamic> json) => Devotion(
      hymn: json['hymn'] == null
          ? null
          : Hymn.fromJson(json['hymn'] as Map<String, dynamic>),
      prayer: json['prayer'] == null
          ? null
          : Prayer.fromJson(json['prayer'] as Map<String, dynamic>),
      reading: json['reading'] == null
          ? null
          : Reading.fromJson(json['reading'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DevotionToJson(Devotion instance) => <String, dynamic>{
      'hymn': instance.hymn,
      'prayer': instance.prayer,
      'reading': instance.reading,
    };

Reading _$ReadingFromJson(Map<String, dynamic> json) => Reading(
      passage: json['passage'] as String? ?? "",
      version: json['version'] as String? ?? "ESV",
      text: json['text'] as String? ?? "",
    );

Map<String, dynamic> _$ReadingToJson(Reading instance) => <String, dynamic>{
      'passage': instance.passage,
      'version': instance.version,
      'text': instance.text,
    };

Prayer _$PrayerFromJson(Map<String, dynamic> json) => Prayer(
      title: json['title'] as String? ?? "",
      source: json['source'] as String? ?? "",
      text: json['text'] as String? ?? "",
    );

Map<String, dynamic> _$PrayerToJson(Prayer instance) => <String, dynamic>{
      'title': instance.title,
      'source': instance.source,
      'text': instance.text,
    };

Hymn _$HymnFromJson(Map<String, dynamic> json) => Hymn(
      title: json['title'] as String? ?? "",
      pdfFilePath: json['pdfFilePath'] as String? ?? "",
      audioFilePath: json['audioFilePath'] as String? ?? "",
    );

Map<String, dynamic> _$HymnToJson(Hymn instance) => <String, dynamic>{
      'title': instance.title,
      'pdfFilePath': instance.pdfFilePath,
      'audioFilePath': instance.audioFilePath,
    };
