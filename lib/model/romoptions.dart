class Romoptions{
  final String label;
  final bool selected;
  final String sku;
  final int quantity;
  final String url;

  Romoptions({
    required this.label,
    required this.selected,
    required this.sku,
    required this.quantity,
    required this.url
  });
  factory Romoptions.fromJson(Map<String,dynamic> json){
    return Romoptions(
        label: json['label'],
        selected: json['selected'],
        sku: json['sku'],
        quantity: json['quantity'],
        url: json['url']
    );
  }
}
class ColorOptions {
  final String title;
  final List<Romoptions> options;

  ColorOptions({
    required this.title,
    required this.options,
  });

  factory ColorOptions.fromJson(Map<String, dynamic> json) {
    return ColorOptions(
      title: json['title'],
      options: List<Romoptions>.from(
          json['options'].map((option) => Romoptions.fromJson(option))
      ),
    );
  }
}