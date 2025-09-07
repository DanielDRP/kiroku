import 'dart:convert';
import 'package:kiroku/models/list_type.dart';

class Anime {
  final int id;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String imageUrl;
  final String? type;
  final int? episodes;
  final String? status;
  final double? score;
  final String? synopsis;
  final int? year;
  final List<String> genres;

  DateTime? dateAdded;
  int progress;
  bool isFavorite;
  ListType listType;

  Anime({
    required this.id,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    required this.imageUrl,
    this.type,
    this.episodes,
    this.status,
    this.score,
    this.synopsis,
    this.year,
    required this.genres,
    this.dateAdded,
    this.progress = 0,
    this.isFavorite = false,
    this.listType = ListType.pending,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'] ?? 'No title',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      type: json['type'],
      episodes: json['episodes'],
      status: json['status'],
      score: (json['score'] != null) ? (json['score'] as num).toDouble() : null,
      synopsis: json['synopsis'],
      year: json['year'],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => g['name'] as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'malId': id,
      'title': title,
      'titleEnglish': titleEnglish,
      'titleJapanese': titleJapanese,
      'imageUrl': imageUrl,
      'type': type,
      'episodes': episodes,
      'status': status,
      'score': score,
      'synopsis': synopsis,
      'year': year,
      'genres': jsonEncode(genres),
      'dateAdded': dateAdded?.toIso8601String(),
      'progress': progress,
      'isFavorite': isFavorite ? 1 : 0,
      'listType': listType.index,
    };
  }

  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      id: map['id'],
      title: map['title'],
      titleEnglish: map['titleEnglish'],
      titleJapanese: map['titleJapanese'],
      imageUrl: map['imageUrl'],
      type: map['type'],
      episodes: map['episodes'],
      status: map['status'],
      score: map['score'] != null ? (map['score'] as num).toDouble() : null,
      synopsis: map['synopsis'],
      year: map['year'],
      genres: map['genres'] != null
          ? List<String>.from(jsonDecode(map['genres']))
          : [],
      dateAdded: map['dateAdded'] != null
          ? DateTime.parse(map['dateAdded'])
          : null,
      progress: map['progress'] ?? 0,
      isFavorite: (map['isFavorite'] ?? 0) == 1,
      listType: map['listType'] != null
          ? ListType.values[map['listType']]
          : ListType.pending,
    );
  }
}