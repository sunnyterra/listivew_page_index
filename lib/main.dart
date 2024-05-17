import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

//https://chat.openai.com/share/0a3478e5-8459-464b-867b-ea9146182fd5

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> allItems = List.generate(400, (index) => 'Item $index');
  int itemsPerPage = 50;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter  Example'),
      ),
      body: Column(
        children: [
          //_buildIndexList(),
          buildIndexNavigation(),
          Expanded(
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget buildIndexNavigation() {
    int totalIndexes = (allItems.length / itemsPerPage).ceil();
    bool canGoPrevious = currentPage > 1;
    bool canGoNext = currentPage < totalIndexes;

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: canGoPrevious ? () => _loadPage(currentPage - 1) : null,
            color: canGoPrevious ? Colors.black : Colors.grey,
          ),
          Text(
            'Index $currentPage',
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: canGoNext ? () => _loadPage(currentPage + 1) : null,
            color: canGoNext ? Colors.black : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildIndexList() {
    int totalIndexes = (allItems.length / itemsPerPage).ceil();
    List<int> indexes = List.generate(totalIndexes, (index) => index + 1);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: indexes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _loadPage(index + 1);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Index ${indexes[index]}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    /*List<String> displayedItems = allItems.sublist(
        startIndex, endIndex > allItems.length ? allItems.length : endIndex);*/

    List<String> displayedItems = [];

    if (startIndex < allItems.length) {
      displayedItems = allItems.sublist(
          startIndex, endIndex > allItems.length ? allItems.length : endIndex);
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedItems.length + 1,
      itemBuilder: (context, index) {
        if (index == displayedItems.length) {
          return _buildLoadMoreButton();
        } else {
          return ListTile(
            title: Text(displayedItems[index]),
          );
        }
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            _loadNextPage();
          },
          child: Text('Load More'),
        ),
      ),
    );
  }

  void _loadPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  void _loadNextPage() {
    /*setState(() {
      currentPage++;
    });*/

    int totalIndexes = (allItems.length / itemsPerPage).ceil();

    setState(() {
      if (currentPage < totalIndexes) {
        currentPage++;
        _scrollController.jumpTo(0.0); // Scroll to the top
      } else {
        // Optionally, you can show a message or handle this case differently.
        // For now, we'll simply keep the current page as the last page.
      }
    });
  }
}
