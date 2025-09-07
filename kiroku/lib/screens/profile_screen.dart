import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../repository/anime_repository.dart';
import '../models/list_type.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AnimeRepository repository = AnimeRepository();
  List<Anime> _libraryAnimes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    setState(() => _isLoading = true);
    _libraryAnimes = await repository.getAllAnimes();
    setState(() => _isLoading = false);
  }

  String _mostCommonGenre() {
    if (_libraryAnimes.isEmpty) return "-";
    final Map<String, int> genreCount = {};
    for (var anime in _libraryAnimes) {
      for (var genre in anime.genres) {
        genreCount[genre] = (genreCount[genre] ?? 0) + 1;
      }
    }
    if (genreCount.isEmpty) return "-";
    final mostCommon = genreCount.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    return mostCommon.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "User",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(
                        "Total",
                        _libraryAnimes.length,
                      ),
                      _buildStatColumn(
                        "Completed",
                        _libraryAnimes
                            .where((a) => a.listType == ListType.completed)
                            .length,
                      ),
                      _buildStatColumn(
                        "Favorites",
                        _libraryAnimes.where((a) => a.isFavorite).length,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Most Common Genre",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(_mostCommonGenre()),
                    avatar: const Icon(Icons.category, color: Colors.black54),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Recent Anime",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: _libraryAnimes
                        .take(5)
                        .map(
                          (anime) => ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                anime.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                              ),
                            ),
                            title: Text(anime.title),
                            subtitle: Text('${anime.progress}/${anime.episodes ?? '?'} episodes'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}