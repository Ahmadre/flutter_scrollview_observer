import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ListViewDemoPage extends StatefulWidget {
  const ListViewDemoPage({Key? key}) : super(key: key);

  @override
  State<ListViewDemoPage> createState() => _ListViewDemoPageState();
}

class _ListViewDemoPageState extends State<ListViewDemoPage> {
  int _hitIndex = 0;

  ScrollController scrollController =
      ScrollController(initialScrollOffset: 1000);

  late ListObserverController observerController;

  @override
  void initState() {
    super.initState();

    observerController = ListObserverController(controller: scrollController);

    // Trigger an observation manually
    WidgetsBinding.instance?.endOfFrame.then(
      (_) {
        // After layout
        if (mounted) {
          observerController.dispatchOnceObserve();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ListView")),
      body: ListViewObserver(
        child: _buildListView(),
        controller: observerController,
        onObserve: (resultModel) {
          print('visible -- ${resultModel.visible}');
          print('firstChild.index -- ${resultModel.firstChild?.index}');
          print('displaying -- ${resultModel.displayingChildIndexList}');
          setState(() {
            _hitIndex = resultModel.firstChild?.index ?? 0;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.airline_stops_outlined),
        onPressed: () {
          // observerController.jumpTo(index: 100);
          observerController.animateTo(
            index: 100,
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
          );
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 1000, bottom: 1000),
      controller: scrollController,
      itemBuilder: (ctx, index) {
        return _buildListItemView(index);
      },
      separatorBuilder: (ctx, index) {
        return _buildSeparatorView();
      },
      itemCount: 500,
    );
  }

  Widget _buildListItemView(int index) {
    return Container(
      height: (index % 2 == 0) ? 80 : 50,
      color: _hitIndex == index ? Colors.red : Colors.black12,
      child: Center(
        child: Text(
          "index -- $index",
          style: TextStyle(
            color: _hitIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Container _buildSeparatorView() {
    return Container(
      color: Colors.white,
      height: 5,
    );
  }
}
