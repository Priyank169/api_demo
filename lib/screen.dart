import 'package:flutter/material.dart';

import 'DBhelper.dart';
import 'apiservice.dart';


//priyank

class screen extends StatefulWidget {
  @override
  _screenState createState() => _screenState();
}

class _screenState extends State<screen> {
  List<String> _dogUrls = [];

  @override
  void initState() {
    super.initState();
    _loadDogImages();
  }

  Future<void> _loadDogImages() async {
    try {
      final url = await ApiService.fetchRandomDog();
      await DBHelper.insertDog(url);
      final urls = await DBHelper.getDogs();
      setState(() {
        _dogUrls = urls;
      });
    } catch (e) {
      print('Error loading dog images: $e');
      // Optionally, show an alert or message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dog Images'),
        ),
        body: _dogUrls.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _dogUrls.length,
          itemBuilder: (context, index) {
            final url = _dogUrls[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(url),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadDogImages,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
