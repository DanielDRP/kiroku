import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../repository/anime_repository.dart';
import '../widgets/anime_card.dart';
import 'anime_detail_screen.dart';

enum DiscoverFilter { top, news, trending }

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final AnimeRepository repository = AnimeRepository();
  List<Anime> _animes = [];
  bool _isLoading = true;

  DiscoverFilter _selectedFilter = DiscoverFilter.top;

  @override
  void initState() {
    super.initState();
    _loadAnimes();
  }

  Future<void> _loadAnimes() async {
    setState(() => _isLoading = true);

    try {
      List<Anime> results = [];
      switch (_selectedFilter) {
        case DiscoverFilter.top:
          results = await repository.getTopAnime();
          break;
        case DiscoverFilter.news:
          results = await repository.getNewAnime();
          break;
        case DiscoverFilter.trending:
          results = await repository.getTrendingAnime();
          break;
      }

      setState(() {
        _animes = results;
      });
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Top"),
                  selected: _selectedFilter == DiscoverFilter.top,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = DiscoverFilter.top;
                        _loadAnimes();
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("New"),
                  selected: _selectedFilter == DiscoverFilter.news,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = DiscoverFilter.news;
                        _loadAnimes();
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Trending"),
                  selected: _selectedFilter == DiscoverFilter.trending,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = DiscoverFilter.trending;
                        _loadAnimes();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _animes.length,
                    itemBuilder: (context, index) {
                      final anime = _animes[index];
                      return AnimeCard(
                        anime: anime,
                        repository: repository,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeDetailScreen(anime: anime),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}