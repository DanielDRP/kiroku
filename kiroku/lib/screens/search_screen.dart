import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../repository/anime_repository.dart';
import 'anime_detail_screen.dart';
import '../widgets/anime_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AnimeRepository repository = AnimeRepository();
  List<Anime> _results = [];
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();

  Future<void> _search(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    final results = await repository.searchAnime(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Anime")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter anime name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text("No animes found"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, idx) {
                          final anime = _results[idx];
                          return AnimeCard(
                            anime: anime,
                            repository: repository,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AnimeDetailScreen(anime: anime),
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