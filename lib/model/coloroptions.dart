class ColorOption {
  final String label;
  final bool selected;
  final String sku;
  final int quantity;
  final String url;

  ColorOption({
    required this.label,
    required this.selected,
    required this.sku,
    required this.quantity,
    required this.url,
  });

  factory ColorOption.fromJson(Map<String, dynamic> json) {
    return ColorOption(
      label: json['label'],
      selected: json['selected'],
      sku: json['sku'],
      quantity: json['quantity'],
      url: json['url'],
    );
  }
}

class ColorOptions {
  final String title;
  final List<ColorOption> options;

  ColorOptions({
    required this.title,
    required this.options,
  });

  factory ColorOptions.fromJson(Map<String, dynamic> json) {
    return ColorOptions(
      title: json['title'],
      options: List<ColorOption>.from(
          json['options'].map((option) => ColorOption.fromJson(option))
      ),
    );
  }
}
