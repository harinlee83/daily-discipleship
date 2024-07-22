import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  final String email;
  final bool emailIsVerified;
  final int dailyDevotionStreak;
  final int spiritualHealthStreak;
  final String name;
  final String uid;
  final List<HistoryDay> history;
  final String notificationTime;

  User({
    this.email = "",
    this.dailyDevotionStreak = 0,
    this.spiritualHealthStreak = 0,
    this.uid = "",
    this.history = const [],
    this.emailIsVerified = false,
    this.name = "",
    this.notificationTime = "8:00",
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class HistoryDay {
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime date;
  final FruitOfSpiritRunningSum fruitOfSpiritRunningSum;
  final bool hymnCompleted;
  final bool prayerCompleted;
  final bool readingCompleted;
  final bool spiritualHealthCheckCompleted;

  HistoryDay({
    DateTime? date,
    FruitOfSpiritRunningSum? fruitOfSpiritRunningSum,
    this.hymnCompleted = false,
    this.prayerCompleted = false,
    this.readingCompleted = false,
    this.spiritualHealthCheckCompleted = false,
  })  : date = date ?? DateTime.now(),
        fruitOfSpiritRunningSum =
            fruitOfSpiritRunningSum ?? FruitOfSpiritRunningSum();

  // Custom function to convert Timestamp to DateTime
  static DateTime _timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  // Custom function to convert DateTime to Timestamp
  static Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  factory HistoryDay.fromJson(Map<String, dynamic> json) =>
      _$HistoryDayFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryDayToJson(this);
}

@JsonSerializable()
class FruitOfSpiritRunningSum {
  final int? love;
  final int? joy;
  final int? peace;
  final int? patience;
  final int? kindness;
  final int? goodness;
  final int? faithfulness;
  final int? gentleness;
  final int? selfControl;

  FruitOfSpiritRunningSum({
    this.love,
    this.joy,
    this.peace,
    this.patience,
    this.kindness,
    this.goodness,
    this.faithfulness,
    this.gentleness,
    this.selfControl,
  });

  factory FruitOfSpiritRunningSum.fromJson(Map<String, dynamic> json) =>
      _$FruitOfSpiritRunningSumFromJson(json);
  Map<String, dynamic> toJson() => _$FruitOfSpiritRunningSumToJson(this);
}

@JsonSerializable()
class Devotion {
  final Hymn hymn;
  final Prayer prayer;
  final Reading reading;

  Devotion({
    Hymn? hymn,
    Prayer? prayer,
    Reading? reading,
  })  : hymn = hymn ?? Hymn(),
        reading = reading ?? Reading(),
        prayer = prayer ?? Prayer();

  factory Devotion.fromJson(Map<String, dynamic> json) =>
      _$DevotionFromJson(json);
  Map<String, dynamic> toJson() => _$DevotionToJson(this);
}

@JsonSerializable()
class Reading {
  final String passage;
  final String version;
  final String text;

  Reading({this.passage = "", this.version = "ESV", this.text = ""});

  factory Reading.fromJson(Map<String, dynamic> json) =>
      _$ReadingFromJson(json);
  Map<String, dynamic> toJson() => _$ReadingToJson(this);
}

@JsonSerializable()
class Prayer {
  final String title;
  final String source;
  final String text;

  Prayer({this.title = "", this.source = "", this.text = ""});
  factory Prayer.fromJson(Map<String, dynamic> json) => _$PrayerFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerToJson(this);
}

@JsonSerializable()
class Hymn {
  final String title;
  final String pdfFilePath;
  final String audioFilePath;

  Hymn({this.title = "", this.pdfFilePath = "", this.audioFilePath = ""});
  factory Hymn.fromJson(Map<String, dynamic> json) => _$HymnFromJson(json);
  Map<String, dynamic> toJson() => _$HymnToJson(this);
}
