import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show immutable;
part 'anime_model.g.dart';

@HiveType(typeId: 0)
class Anime extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final int numEpisodes;

  @HiveField(4)
  final String genres;

  @HiveField(5)
  final String year;

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.numEpisodes,
    required this.genres,
    required this.year,
  });
}
