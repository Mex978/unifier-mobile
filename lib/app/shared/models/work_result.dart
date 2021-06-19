class WorkResult {
  String? id;
  String? title;
  int? year;
  int? chaptersCount;
  String? author;
  String? description;
  String? rate;
  String? status;
  String? cover;
  List<String>? tags;
  String? mangaUrl;
  String? type;

  WorkResult(
      {this.id,
      this.title,
      this.year,
      this.chaptersCount,
      this.author,
      this.description,
      this.rate,
      this.status,
      this.cover,
      this.tags,
      this.type,
      this.mangaUrl});

  WorkResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    chaptersCount = json['chapters_count'];
    author = json['author'];
    description = json['description'];
    rate = json['rate'];
    status = json['status'];
    cover = json['cover'];
    tags = json['tags']?.cast<String>();
    mangaUrl = json['manga_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['year'] = this.year;
    data['chapters_count'] = this.chaptersCount;
    data['author'] = this.author;
    data['description'] = this.description;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['cover'] = this.cover;
    data['tags'] = this.tags;
    data['manga_url'] = this.mangaUrl;
    return data;
  }
}
