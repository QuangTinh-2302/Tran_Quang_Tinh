import 'package:app_giohang_ctyteko/model/priceoption.dart';
import 'package:app_giohang_ctyteko/model/romoptions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_giohang_ctyteko/model/coloroptions.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:app_giohang_ctyteko/product_details.dart';
Map<String, dynamic>? data;
void main() {
  runApp(MaterialApp(home: Product(),debugShowCheckedModeBanner: false,));
}
class Product extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Product();
}
class _Product extends State<Product>{
  bool _isLoading = true;
  List<String> imageUrls = [];
  List<ColorOption> colorOptions = [];
  ColorOption? selectedColor;
  List<Romoptions> ROMOptions = [];
  Romoptions? selectedRom;
  String Nameproduct = '';
  PriceOption? priceOption;
  String? shortDescription;
  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }
  Future<void> _fetchAllData() async {
    data = await _getData();
    await Future.wait([
      _fetchProductImages(),
      _fetchProductColor(),
      _fetchproductRom(),
      _fetchproductName(),
      _fetchproductPrice(),
      _fetchShortDescription(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios_new),
          actions: [
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.shopping_cart_outlined)
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.more_vert)
            )
          ],
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator(),):
        Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CarouselSlider.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index, realIndex) {
                        return Image.network(imageUrls[index], fit: BoxFit.cover);
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        viewportFraction: 1.0,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Màu sắc: ${selectedColor == null ? '':selectedColor!.label}',style: TextStyle(fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 10.0,
                      children: colorOptions.map((colorOption) {
                        final isSelected = colorOption == selectedColor;
                        return IntrinsicWidth(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = colorOption;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  colorOption.label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.blue : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('DUNG LƯỢNG(ROM): ${selectedRom == null ? '' : selectedRom!.label}',style: TextStyle(fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10.0,
                          children: ROMOptions.map((ROMOption) {
                            final isSelected = ROMOption == selectedRom;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRom = ROMOption;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    ROMOption.label,
                                    style: TextStyle(
                                      color: isSelected ? Colors.blue : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text('$Nameproduct',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(
                    height: 30,
                    child: Text('${priceOption!.latestPrice} đ.',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Text('${priceOption!.terminalPrice} đ.',
                          style: const TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        height: 30,
                        child: Text('-${priceOption!.discountPercent} %.',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (shortDescription != null)
                            Html(
                              data: shortDescription,
                              style: {
                                'body': Style(
                                  fontSize: FontSize.large,
                                  lineHeight: LineHeight.em(1.5),
                                ),
                              },
                            )
                          else
                            CircularProgressIndicator(), // Hiển thị khi đang tải dữ liệu
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 5.0,
              right: 5.0,
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Liên hệ',style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ),
          ],
        )
      )
    );
  }
  Future<dynamic> _getData() async{
    String apiUrl = 'https://discovery.tekoapis.com/api/v1/product?productId=535038&sku=230900684&location=&terminalCode=phongvu';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      }else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode}');
      }
  }
  Future<void> _fetchProductImages() async {
    setState(() {
      imageUrls = List<String>.from(
        data?['result']['product']['productDetail']['images']
            .map((image) => image['url']),
      );
    });
  }
  Future<void> _fetchProductColor() async {
    setState(() {
      final colorOptionsJson =
      data?['result']['product']['productOptions']['rows'][1]['options'] as List;
      colorOptions = List<ColorOption>.from(
        colorOptionsJson.map((json) => ColorOption.fromJson(json)),);
    });
  }
  Future<void> _fetchproductRom() async{
    setState(() {
      final RomOptionsJson =
      data?['result']['product']['productOptions']['rows'][0]['options'] as List;
      ROMOptions = List<Romoptions>.from(
          RomOptionsJson.map((json) => Romoptions.fromJson(json))
      );
    });
  }
  Future<void> _fetchproductName() async{
    setState(() {
      Nameproduct = data?['result']['product']['productInfo']['name'];
    });
  }
  Future<void> _fetchproductPrice() async{
    setState(() {
      priceOption = PriceOption.fromJson(data?['result']['product']['prices'][0]);
    });
  }
  Future<void> _fetchShortDescription() async {
    setState(() {
      shortDescription = data?['result']['product']['productDetail']['shortDescription'];
    });
  }
}

