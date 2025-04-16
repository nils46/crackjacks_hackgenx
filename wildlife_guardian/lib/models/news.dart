class ForestNews {
  final String id;
  final String title;
  final String content;
  final DateTime publishDate;
  final String imageUrl;
  final NewsCategory category;
  final String source;

  ForestNews({
    required this.id,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.imageUrl,
    required this.category,
    required this.source,
  });

  // Sample data for demonstration purposes
  static List<ForestNews> getSampleData() {
    return [
      ForestNews(
        id: '1',
        title: 'Bengal Tiger Census Shows Promising Growth',
        content: 'The latest tiger census reports a 12% increase in Bengal tiger population across protected forest areas. Conservation efforts over the past decade are showing positive results, with tigress sightings accompanied by cubs rising by 18%.',
        publishDate: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'https://images.unsplash.com/photo-1549366021-9f761d450615?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
        category: NewsCategory.wildlife,
        source: 'Forest Department',
      ),
      ForestNews(
        id: '2',
        title: 'New Anti-Poaching Drones Deployed',
        content: 'The Forest Department has deployed a fleet of advanced thermal-imaging drones to combat poaching. These drones can detect human movement at night and have already led to three successful arrests this month.',
        publishDate: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl: 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
        category: NewsCategory.technology,
        source: 'Wildlife Protection Bureau',
      ),
      ForestNews(
        id: '3',
        title: 'Reforestation Project Completes Phase One',
        content: 'The ambitious reforestation project in the eastern sector has successfully completed its first phase. Over 50,000 native tree saplings have been planted, covering an area of 200 hectares previously lost to illegal logging.',
        publishDate: DateTime.now().subtract(const Duration(days: 7)),
        imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
        category: NewsCategory.conservation,
        source: 'Environmental Ministry',
      ),
      ForestNews(
        id: '4',
        title: 'Forest Fire Season Preparedness Workshop',
        content: 'A workshop on forest fire prevention and rapid response was conducted for all rangers. The training focused on early detection methods and coordination with fire departments during the upcoming dry season.',
        publishDate: DateTime.now().subtract(const Duration(days: 10)),
        imageUrl: 'https://images.unsplash.com/photo-1576164285450-3aff78a28f22?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
        category: NewsCategory.training,
        source: 'Forest Department',
      ),
      ForestNews(
        id: '5',
        title: 'Rare Orchid Species Discovered',
        content: 'Botanists have discovered a previously undocumented orchid species in the protected western highlands. The species, temporarily named "Dendrobium sylvaticum", is believed to have medicinal properties and is now under study.',
        publishDate: DateTime.now().subtract(const Duration(days: 15)),
        imageUrl: 'https://images.unsplash.com/photo-1566408669374-5a6d5dca1ef5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
        category: NewsCategory.research,
        source: 'Botanical Research Institute',
      ),
    ];
  }
}

enum NewsCategory {
  wildlife,
  conservation,
  technology,
  policy,
  training,
  research,
} 