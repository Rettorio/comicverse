class GenreKomik {
  final String title;
  final String slug;

  GenreKomik({required this.title, required this.slug});

  factory GenreKomik.fromJson(Map<String, dynamic> json) {
    return GenreKomik(
      title: json['title'] as String,
      slug: json['slug'] as String,
    );
  }
}