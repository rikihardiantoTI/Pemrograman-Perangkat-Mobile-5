import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<RegistrationTicket> _registeredTickets = [];

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        categories: const ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'],
        selectedCategory: _selectedCategory,
        onSelect: (cat) => setState(() => _selectedCategory = cat),
      ),
    );
  }

  void _registerForEvent(EventItem event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventRegistrationScreen(event: event)),
    );
    if (result != null && result is RegistrationTicket) {
      setState(() => _registeredTickets.add(result));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = sampleEvents.where((event) {
      final matchesCategory =
          _selectedCategory == 'Semua' || event.category == _selectedCategory;
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.speaker.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF5746E8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'NusaEvent',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Filter kategori',
              onPressed: _showFilter,
              icon: const Icon(Icons.tune_rounded),
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            labelColor: Color(0xFF5746E8),
            unselectedLabelColor: Color(0xFF89879A),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(icon: Icon(Icons.event_rounded), text: 'Seminar'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Galeri & Venue'),
              Tab(icon: Icon(Icons.confirmation_number_outlined), text: 'Tiket'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventsTab(filteredEvents),
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: sampleEvents.length,
                    itemBuilder: (context, index) {
                      final event = sampleEvents[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              event.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                color: Color(0xFFECEAF8),
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xCC11101C),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 13,
                              right: 12,
                              bottom: 13,
                              child: Text(
                                event.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                const VenueMapViewer(),
              ],
            ),
            RegisteredTicketsScreen(
              tickets: _registeredTickets,
              onRemove: (ticket) => setState(() => _registeredTickets.remove(ticket)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab(List<EventItem> filteredEvents) {
    final categories = const ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5746E8), Color(0xFF8875FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5746E8).withValues(alpha: 0.22),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -19,
                child: Icon(
                  Icons.auto_awesome,
                  size: 115,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'IDE & INOVASI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Temukan event\\nyang menginspirasi.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Belajar hal baru. Bertemu komunitas hebat.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Cari seminar atau pembicara',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: 17),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (_) => setState(() => _selectedCategory = category),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF68667A),
                  fontWeight: FontWeight.w600,
                ),
                selectedColor: const Color(0xFF5746E8),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF5746E8)
                      : const Color(0xFFE9E8F1),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Event pilihan',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF25233B),
                ),
              ),
            ),
            Text(
              '${filteredEvents.length} event',
              style: const TextStyle(
                color: Color(0xFF89879A),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filteredEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Icon(Icons.search_off_rounded, size: 42, color: Color(0xFFAAA8B8)),
                SizedBox(height: 10),
                Text('Event tidak ditemukan'),
              ],
            ),
          )
        else
          ...filteredEvents.map(
            (event) => EventCard(
              key: ValueKey(event.id),
              event: event,
              onTap: () => _registerForEvent(event),
            ),
          ),
      ],
    );
  }
}