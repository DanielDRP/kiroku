import 'package:kiroku/data/db_helper.dart';
import '../data/api_service.dart';
import '../models/anime.dart';

class AnimeRepository {
  final ApiService apiService = ApiService();
  final DBHelper _db = DBHelper();

  Future<void> addAnimeToLibrary(Anime anime) async {
    await _db.insertAnime(anime);
  }

  Future<void> deleteAnimeFromLibrary(int id) async {
    await _db.deleteAnime(id);
  }

  Future<List<Anime>> getAllAnimes() async {
    return await _db.getAllAnimes();
  }

  Future<void> updateAnime(Anime anime) async {
    await _db.updateAnime(anime);
  }

  Future<List<Anime>> searchAnimeInLibrary(String query) async {
    final all = await getAllAnimes();
    return all
        .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Anime>> searchAnime(String query) async {
    final data = await apiService.get("anime?q=$query&limit=10");
    final List results = data['data'];
    return results.map((animeJson) => Anime.fromJson(animeJson)).toList();
  }

  Future<List<Anime>> getTopAnime() async {
    final data = await apiService.get("top/anime?limit=10");
    final List results = data['data'];
    return results.map((animeJson) => Anime.fromJson(animeJson)).toList();
  }

  Future<List<Anime>> getNewAnime() async {
    final data = await apiService.get("seasons/now");
    final List results = data['data'];
    return results.map((animeJson) => Anime.fromJson(animeJson)).toList();
  }

  Future<List<Anime>> getTrendingAnime() async {
    final data = await apiService.get("top/anime?filter=airing");
    final List results = data['data'];
    return results.map((animeJson) => Anime.fromJson(animeJson)).toList();
  }
}