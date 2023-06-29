import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestImage extends StatefulWidget {
  const TestImage(this.url);

  final String url;
  @override
  State<TestImage> createState() => _TestImageState();
}

class _TestImageState extends State<TestImage> {
  @override
  Widget build(BuildContext context) {
    var imgurl = 'https://souqplace.herokuapp.com' + widget.url;
    print(imgurl);
    return Scaffold(body: Image(image: NetworkImage('${imgurl}')));
  }
}
