/// Feed item entity
class Item {
  const Item({
    required this.id,
    required this.title,
    required this.body,
    this.userId,
  });

  final int id;
  final int? userId;
  final String title;
  final String body;

  Item copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Item(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
