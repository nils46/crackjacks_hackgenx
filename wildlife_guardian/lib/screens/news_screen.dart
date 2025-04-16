import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/models/news.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<ForestNews> _allNews = ForestNews.getSampleData();
  List<ForestNews> _filteredNews = [];
  NewsCategory? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _filteredNews = _allNews;
  }

  void _filterNewsByCategory(NewsCategory? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null) {
        _filteredNews = _allNews;
      } else {
        _filteredNews = _allNews.where((news) => news.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forest News'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _filteredNews.isEmpty
                ? const Center(
                    child: Text(
                      'No news found for this category',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final news = _filteredNews[index];
                      return _buildNewsCard(news);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.secondaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(null, 'All'),
                _buildCategoryChip(NewsCategory.wildlife, 'Wildlife'),
                _buildCategoryChip(NewsCategory.conservation, 'Conservation'),
                _buildCategoryChip(NewsCategory.technology, 'Technology'),
                _buildCategoryChip(NewsCategory.policy, 'Policy'),
                _buildCategoryChip(NewsCategory.training, 'Training'),
                _buildCategoryChip(NewsCategory.research, 'Research'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(NewsCategory? category, String label) {
    Color chipColor;
    
    if (category == null) {
      chipColor = AppTheme.accentBlue;
    } else {
      switch (category) {
        case NewsCategory.wildlife:
          chipColor = AppTheme.accentGreen;
          break;
        case NewsCategory.conservation:
          chipColor = Colors.teal;
          break;
        case NewsCategory.technology:
          chipColor = Colors.blue;
          break;
        case NewsCategory.policy:
          chipColor = Colors.purple;
          break;
        case NewsCategory.training:
          chipColor = Colors.orange;
          break;
        case NewsCategory.research:
          chipColor = Colors.deepPurple;
          break;
      }
    }

    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () => _filterNewsByCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? chipColor.withOpacity(0.2) 
              : AppTheme.tertiaryDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? chipColor : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(ForestNews news) {
    final formattedDate = DateFormat('MMM d, yyyy').format(news.publishDate);
    Color categoryColor;
    
    switch (news.category) {
      case NewsCategory.wildlife:
        categoryColor = AppTheme.accentGreen;
        break;
      case NewsCategory.conservation:
        categoryColor = Colors.teal;
        break;
      case NewsCategory.technology:
        categoryColor = Colors.blue;
        break;
      case NewsCategory.policy:
        categoryColor = Colors.purple;
        break;
      case NewsCategory.training:
        categoryColor = Colors.orange;
        break;
      case NewsCategory.research:
        categoryColor = Colors.deepPurple;
        break;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(0),
      onTap: () {
        _showNewsDetails(news);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  news.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news.category.name.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Source: ${news.source}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewsDetails(ForestNews news) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(news.publishDate);
    Color categoryColor;
    
    switch (news.category) {
      case NewsCategory.wildlife:
        categoryColor = AppTheme.accentGreen;
        break;
      case NewsCategory.conservation:
        categoryColor = Colors.teal;
        break;
      case NewsCategory.technology:
        categoryColor = Colors.blue;
        break;
      case NewsCategory.policy:
        categoryColor = Colors.purple;
        break;
      case NewsCategory.training:
        categoryColor = Colors.orange;
        break;
      case NewsCategory.research:
        categoryColor = Colors.deepPurple;
        break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppTheme.secondaryDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      news.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        news.category.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryDark.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Source: ${news.source}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        news.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Add more content for the full article
                      Text(
                        'The ${news.category.name} initiative mentioned above is part of a broader effort to protect our forest resources. Forest officials are encouraged to participate and contribute to the success of this program.',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Further developments will be shared through this platform as they unfold. Stay tuned for more updates on this and other ${news.category.name} initiatives.',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Related Topics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildRelatedTopicChip('Forest Protection'),
                          _buildRelatedTopicChip(news.category.name),
                          _buildRelatedTopicChip('Conservation'),
                          _buildRelatedTopicChip('Sustainability'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.secondaryDark,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.tertiaryDark,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Save'),
                        onPressed: () {
                          // TODO: Implement save functionality
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: AppTheme.accentBlue,
                          side: const BorderSide(
                            color: AppTheme.accentBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: () {
                          // TODO: Implement share functionality
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppTheme.accentGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRelatedTopicChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
} 