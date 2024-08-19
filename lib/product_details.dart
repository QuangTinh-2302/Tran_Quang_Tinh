import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:app_giohang_ctyteko/model/productdetails.dart';
import 'package:app_giohang_ctyteko/main.dart';
class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}
class _ProductDetailsState extends State<ProductDetails> {
  bool _isExpanded = false;
  bool _isLoading = true;
  final int _maxItemsToShow = 7;
  List<ProductDetail> listproduct = [];
  String? Getdescription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAllData();
  }
  Future<void> _fetchAllData() async {
    await Future.wait([
      _getProductDetail(),
      _getdescription()
    ]);
    setState(() {
    _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    int itemCount = _isExpanded ? listproduct.length : _maxItemsToShow;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),

            ),
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
          body: _isLoading ? Center(child: CircularProgressIndicator(),):
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Chi tiết sản phẩm',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: itemCount,
                          itemBuilder: (context, i) {
                            return Container(
                              color: i % 2 == 0 ? Colors.grey[200] : Colors.white,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(listproduct[i].name),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(listproduct[i].value),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        if (!_isExpanded && listproduct.length > _maxItemsToShow)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white,
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (listproduct.length > _maxItemsToShow)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_isExpanded ? 'Thu gọn' : 'Xem thêm'),
                            Icon(_isExpanded ? Icons.expand_less_outlined : Icons.expand_more_outlined),
                          ],
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Getdescription != null)
                        Html(
                          data: Getdescription!,
                          style: {
                            'body': Style(
                              fontSize: FontSize.large,
                              lineHeight: LineHeight.em(2),
                            ),
                          },
                        )
                      else
                        CircularProgressIndicator(), // Hiển thị khi đang tải dữ liệu
                    ],
                  ),
                ),
               ]
            ),
          )
        )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
  Future<void> _getProductDetail() async {
    setState(() {
      final DetailProduct = data?['result']['product']['productDetail']['attributeGroups'] as List;
      listproduct = List<ProductDetail>.from(DetailProduct.map((json) => ProductDetail.fromJson(json)));
    });
  }
  Future<void> _getdescription() async {
    setState(() {
      Getdescription = data?['result']['product']['productDetail']['description'];
    });
  }
}
