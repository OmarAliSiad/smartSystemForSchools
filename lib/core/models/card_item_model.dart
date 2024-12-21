class CardItemModel {
  final dynamic image;
  final String title;
  final String subtitle;
  final double price;
  final String catgory;
  final bool IsImagePicked;
  int? quantity;

  CardItemModel( {
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.catgory,
    required this.IsImagePicked,
    this.quantity,
  });
}
