class ProductDetail{
  final int id;
  final String name;
  final String value;
  final int priority;
  final int parentId;


  ProductDetail({
    required this.id,
    required this.name,
    required this.value,
    required this.priority,
    required this.parentId
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json){
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      priority: json['priority'],
      parentId: json['parentId']
    );
  }
}