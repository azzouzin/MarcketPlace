class Product {
  final String title;
  final String descreption;
  final String price;
  final String state;
  final String category;
  String? id;
  String? createdat;
  List? images;
  Product(
      {required this.title,
      required this.descreption,
      required this.price,
      required this.state,
      required this.category,
      this.id,
      this.createdat,
      this.images});
}
