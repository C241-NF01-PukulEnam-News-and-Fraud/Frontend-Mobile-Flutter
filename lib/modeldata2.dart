class NewsListData {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String date;
  NewsListData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.date,
  });

  factory NewsListData.fromJson(Map<String, dynamic> json) {
    return NewsListData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Future<List<NewsListData>> fetchNews() async {
    final response = await http.get(Uri.parse('https://pukulenam.id/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((article) => NewsListData.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}