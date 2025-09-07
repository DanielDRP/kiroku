import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../repository/anime_repository.dart';
import '../screens/anime_detail_screen.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final AnimeRepository repository;
  final VoidCallback? onTap;

  const AnimeCard({
    super.key,
    required this.anime,
    required this.repository,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ??
            () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeDetailScreen(anime: anime),
                ),
              );
            },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              anime.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  anime.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (anime.isFavorite)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            if (anime.progress > 0)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${anime.progress}/${anime.episodes ?? '?'}${anime.episodes != null && anime.progress == anime.episodes! ? ' ✔️' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}