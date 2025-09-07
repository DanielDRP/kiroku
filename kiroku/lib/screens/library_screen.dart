import 'package:flutter/material.dart';
import 'package:kiroku/models/list_type.dart';
import 'package:kiroku/screens/search_screen.dart';
import '../models/anime.dart';
import '../repository/anime_repository.dart';
import '../widgets/anime_card.dart';
import 'anime_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  final AnimeRepository repository = AnimeRepository();
  List<Anime> _libraryAnimes = [];
  List<Anime> _displayedAnimes = [];
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_applyFilter);
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    setState(() => _isLoading = true);
    _libraryAnimes = await repository.getAllAnimes();
    _applyFilter();
    setState(() => _isLoading = false);
  }

  void _applyFilter() {
    List<Anime> list;
    switch (_tabController.index) {
      case 0:
        list = _libraryAnimes;
        break;
      case 1:
        list = _libraryAnimes.where((a) => a.listType == ListType.completed).toList();
        break;
      case 2:
        list = _libraryAnimes.where((a) => a.isFavorite).toList();
        break;
      default:
        list = [];
    }
    setState(() => _displayedAnimes = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Completed"),
            Tab(text: "Favorites"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
              _loadLibrary();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displayedAnimes.isEmpty
              ? const Center(child: Text("No animes found"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _displayedAnimes.length,
                  itemBuilder: (context, idx) {
                    final anime = _displayedAnimes[idx];
                    return AnimeCard(
                      anime: anime,
                      repository: repository,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AnimeDetailScreen(anime: anime)),
                        );
                        _loadLibrary();
                      },
                    );
                  },
                ),
    );
  }
}