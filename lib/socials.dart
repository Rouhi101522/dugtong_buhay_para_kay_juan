import 'package:dugtong_buhay_para_kay_juan_v2/rss_service.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/social_details.dart';
import 'package:flutter/material.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:intl/intl.dart';

const Map<String, String> rssFeeds = {
  'All': 'https://fetchrss.com/rss/677be086dac93257d1095ef3677c0f700f0f0334a8041f92.rss,https://fetchrss.com/rss/677be086dac93257d1095ef3677be06973cc0b9efc061872.rss,https://fetchrss.com/rss/677be086dac93257d1095ef3677c0f52dbada232cd02cdf3.rss',
  'Makati DRRM Office': 'https://fetchrss.com/rss/677be086dac93257d1095ef3677c0f700f0f0334a8041f92.rss',
  'University of Makati': 'https://fetchrss.com/rss/677be086dac93257d1095ef3677be06973cc0b9efc061872.rss',
  'PAGASA(DOST)': 'https://fetchrss.com/rss/677be086dac93257d1095ef3677c0f52dbada232cd02cdf3.rss',
};

class RssFeedPage extends StatefulWidget {
  const RssFeedPage({Key? key}) : super(key: key);

  @override
  _RssFeedPageState createState() => _RssFeedPageState();
}

class _RssFeedPageState extends State<RssFeedPage> {
  final Map<String, List<RssItem>> _rssCache = {};  // Cache for storing RSS feeds
  final RssService _rssService = RssService();
  late Future<List<RssItem>> _rssFeed;
  String _selectedCategory = 'All';
  bool _isRefreshing = false;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    // Check if the data is already cached
    if (_rssCache.containsKey(_selectedCategory)) {
      // Use cached data
      _rssFeed = Future.value(_rssCache[_selectedCategory]!);
    } else {
      // Fetch new data if not cached
      _rssFeed = _selectedCategory == 'All' ? _fetchAllFeeds() : _rssService.fetchRssFeed(rssFeeds[_selectedCategory]!);
    }

    setState(() {
      _isRefreshing = true;
    });

    try {
      final data = await _rssFeed;
      if (!_rssCache.containsKey(_selectedCategory)) {
        // Cache the fetched data
        _rssCache[_selectedCategory] = data;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load feed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<List<RssItem>> _fetchAllFeeds() async {
    final allFeeds = rssFeeds['All']!
        .split(',')
        .map((url) => _rssService.fetchRssFeed(url.trim()))
        .toList();

    final allRssItems = <RssItem>[];
    for (var feed in allFeeds) {
      try {
        final items = await feed;
        allRssItems.addAll(items);
      } catch (e) {
        print('Error fetching one feed: $e');
      }
    }
    return allRssItems;
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedCategory = rssFeeds.keys.elementAt(index);
      _fetchFeed();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparedness Feeds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _fetchFeed,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchFeed,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged, // Detect page change
                itemCount: rssFeeds.keys.length,
                itemBuilder: (context, index) {
                  final category = rssFeeds.keys.elementAt(index);
                  return FutureBuilder<List<RssItem>>(
                    future: _rssFeed,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildFeedList(snapshot.hasData ? snapshot.data! : []);
                      } else if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error.toString());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No RSS feeds found.'));
                      }

                      return _buildFeedList(snapshot.data!);
                    },
                  );
                },
              )

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: rssFeeds.keys.map((key) {
            bool isSelected = _selectedCategory == key;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: _isRefreshing || isSelected
                    ? null // Disable the button if refreshing or selected
                    : () {
                  setState(() {
                    _selectedCategory = key;
                    _fetchFeed();
                  });
                  int index = rssFeeds.keys.toList().indexOf(key);
                  _pageController.jumpToPage(index); // Jump to selected category page
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.blue; // Disabled background color
                      }
                      return isSelected ? Colors.blue : Colors.blueGrey; // Selected and unselected
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.white.withOpacity(1); // Disabled text color
                      }
                      return Colors.white; // Regular text color
                    },
                  ),
                ),
                child: Text(key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading feed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchFeed,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList(List<RssItem> items) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final item = items[index];

        final imageUrl = item.media?.contents?.isNotEmpty ?? false
            ? item.media!.contents!.first.url
            : null;

        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            leading: imageUrl != null
                ? Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return const Icon(Icons.error, size: 60, color: Colors.red);
              },
            )
                : const Icon(Icons.image_not_supported, size: 60),
            title: Text(
              item.title ?? 'No Title',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.pubDate is DateTime
                      ? DateFormat('yyyy-MM-dd HH:mm').format(item.pubDate as DateTime)
                      : 'No Date',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RssDetailPage(item: item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
