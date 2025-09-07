import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../models/list_type.dart';
import '../repository/anime_repository.dart';

class AnimeDetailScreen extends StatefulWidget {
  final Anime anime;

  const AnimeDetailScreen({super.key, required this.anime});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  late Anime _anime;
  final AnimeRepository repository = AnimeRepository();
  bool _isInLibrary = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _anime = widget.anime;
    _checkIfInLibrary();
  }

  Future<void> _checkIfInLibrary() async {
    final allAnimes = await repository.getAllAnimes();
    final found = allAnimes.any((a) => a.id == _anime.id);
    setState(() {
      _isInLibrary = found;
      if (found && _anime.dateAdded == null) {
        _anime.dateAdded = DateTime.now();
      }
    });
  }

  void _toggleFavorite() async {
    setState(() {
      _anime.isFavorite = !_anime.isFavorite;
    });
    await repository.updateAnime(_anime);
  }

  void _incrementProgress() async {
    if (_anime.episodes != null && _anime.progress < _anime.episodes!) {
      setState(() {
        _anime.progress++;
      });
      await repository.updateAnime(_anime);
    }
  }

  void _decrementProgress() async {
    if (_anime.progress > 0) {
      setState(() {
        _anime.progress--;
      });
      await repository.updateAnime(_anime);
    }
  }

  void _toggleLibrary() async {
    if (!_isInLibrary) {
      await repository.addAnimeToLibrary(_anime);
      setState(() {
        _isInLibrary = true;
        _anime.dateAdded = DateTime.now();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Anime added to Library")));
    } else {
      await repository.deleteAnimeFromLibrary(_anime.id);
      setState(() {
        _isInLibrary = false;
        _anime.dateAdded = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anime removed from Library")),
      );
    }
  }

  void _toggleListType() async {
    setState(() {
      _anime.listType = _anime.listType == ListType.pending
          ? ListType.completed
          : ListType.pending;
    });
    await repository.updateAnime(_anime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_anime.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.all(12.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _anime.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _anime.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _toggleLibrary,
                                icon: Icon(
                                  _isInLibrary ? Icons.bookmark : Icons.bookmark_border,
                                  color: _isInLibrary ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
                                ),
                                tooltip: _isInLibrary ? 'Remove from Library' : 'Add to Library',
                              ),
                              IconButton(
                                onPressed: _isInLibrary ? _toggleListType : null,
                                icon: Icon(
                                  _anime.listType == ListType.completed ? Icons.check_circle : Icons.watch_later_outlined,
                                  color: _isInLibrary ? (_anime.listType == ListType.completed ? Colors.green : Colors.grey.shade600) : Colors.grey.shade300,
                                ),
                                tooltip: _isInLibrary ? (_anime.listType == ListType.completed ? 'Mark as Pending' : 'Mark as Watched') : 'Add to library first',
                              ),
                              IconButton(
                                onPressed: _isInLibrary ? _toggleFavorite : null,
                                icon: Icon(
                                  _anime.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isInLibrary ? (_anime.isFavorite ? Colors.red : Colors.grey.shade600) : Colors.grey.shade300,
                                ),
                                tooltip: _isInLibrary ? (_anime.isFavorite ? 'Remove from Favorites' : 'Add to Favorites') : 'Add to library first',
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (_anime.episodes != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _isInLibrary ? _decrementProgress : null,
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: _isInLibrary ? Colors.grey : Colors.grey.shade300,
                                  ),
                                  iconSize: 20,
                                ),
                                Text(
                                  "${_anime.progress}/${_anime.episodes}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _isInLibrary ? Colors.black : Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _isInLibrary ? _incrementProgress : null,
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: _isInLibrary ? Colors.grey : Colors.grey.shade300,
                                  ),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_anime.type != null) Text("Type: ${_anime.type}"),
                      if (_anime.episodes != null)
                        Text("Episodes: ${_anime.episodes}"),
                      if (_anime.score != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(_anime.score.toString()),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_anime.status != null) Text("Status: ${_anime.status}"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: _anime.genres
                        .map((g) => Chip(label: Text(g)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  if (_anime.synopsis != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _anime.synopsis!,
                          style: const TextStyle(fontSize: 14),
                          maxLines: _isExpanded ? null : 4,
                          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        ),
                        if (_anime.synopsis!.length > 200)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? 'Show less' : 'Show more',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}