import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/translations.dart';
import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../widgets/sub_page_header.dart';
import '../../widgets/app_toast.dart';
import '../trip_detail/trip_detail_screen.dart';

/// Mirrors `#pg-favorites`.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _loading = true;
  List<Trip> _favorites = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await context.read<AppState>().fetchFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = trips.map((t) => t.toTrip()).toList();
      _loading = false;
    });
  }

  Future<void> _remove(int i) async {
    final trip = _favorites[i];
    if (trip.apiId == null) return;
    setState(() => _favorites.removeAt(i));
    final active = await context.read<AppState>().toggleFavorite(trip.apiId!);
    if (!mounted) return;
    if (active == false) {
      showAppToast(context, tr('more_menu.favorites.delete_toast'));
    } else {
      // Toggle failed or somehow re-added — put it back rather than
      // silently losing it from the list.
      setState(() => _favorites.insert(i, trip));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(title: tr('more_menu.favorites')),
      body: _loading
          ? const Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2)))
          : _favorites.isEmpty
              ? Center(
                  child: Text(tr('orders.no_trips'),
                      style: const TextStyle(color: AppColors.muted)))
              : ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _favorites.length,
        itemBuilder: (context, i) {
          final t = _favorites[i];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TripDetailScreen(trip: t))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: t.networkImage != null
                      ? CachedNetworkImage(
                          imageUrl: t.networkImage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(gradient: t.bg),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))),
                          errorWidget: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(gradient: t.bg),
                              alignment: Alignment.center,
                              child: Text(t.emoji, style: const TextStyle(fontSize: 28))),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(gradient: t.bg),
                          alignment: Alignment.center,
                          child: Text(t.emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr(t.title),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text)),
                        Text('${tr(t.hotel)} · ${t.stars}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.muted)),
                        Text(tr(t.price),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: t.accent)),
                      ]),
                ),
                GestureDetector(
                  onTap: () => _remove(i),
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E4),
                          shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const FaIcon(FontAwesomeIcons.heartCrack,
                          size: 13, color: Color(0xFFE84040))),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
