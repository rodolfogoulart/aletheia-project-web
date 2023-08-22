import 'dart:convert';

class DataCards {
  String url;
  bool asset;
  String title;
  String? subtitle;
  DataCards({
    required this.url,
    this.asset = false,
    required this.title,
    this.subtitle,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'url': url});
    result.addAll({'asset': asset});
    result.addAll({'title': title});
    if (subtitle != null) {
      result.addAll({'subtitle': subtitle});
    }

    return result;
  }

  factory DataCards.fromMap(Map<String, dynamic> map) {
    return DataCards(
      url: map['url'] ?? '',
      asset: map['asset'] ?? false,
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataCards.fromJson(String source) => DataCards.fromMap(json.decode(source));

  DataCards copyWith({
    String? url,
    bool? asset,
    String? title,
    String? subtitle,
  }) {
    return DataCards(
      url: url ?? this.url,
      asset: asset ?? this.asset,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  String toString() {
    return 'DataCards(url: $url, asset: $asset, title: $title, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataCards && other.url == url && other.asset == asset && other.title == title && other.subtitle == subtitle;
  }

  @override
  int get hashCode {
    return url.hashCode ^ asset.hashCode ^ title.hashCode ^ subtitle.hashCode;
  }
}
