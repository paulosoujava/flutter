import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;
  final _todoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = json.decode((data));
      });
    });
  }

  void _addTodo() {
    Map<String, dynamic> newTodo = Map();

    if (_todoCtrl.text.isNotEmpty) {
      setState(() {
        newTodo["title"] = _todoCtrl.text;
        newTodo["isCheck"] = false;
        _todoList.add(newTodo);
        _todoCtrl.clear();
        if (_todoList != null) _refresh();
      });
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 0)); //
    setState(() {
      _todoList.sort((x, y) {
        if (x["isCheck"] && !y["isCheck"])
          return 1;
        else if (!x["isCheck"] && y["isCheck"])
          return -1;
        else
          return 0;
      });
      saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renata Lista"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 25.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoCtrl,
                    decoration: InputDecoration(
                        labelText: "Do que precisamos?",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("+"),
                  textColor: Colors.white,
                  onPressed: _addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: (_todoList != null ? _todoList.length : 0),
                    itemBuilder: buildItem)),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, idx) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(
          _todoList[idx]["title"],
          style: TextStyle(
              fontSize: 25.0,
              color: _todoList[idx]["isCheck"] ? Colors.red : Colors.black,
              decoration: _todoList[idx]["isCheck"]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        value: _todoList[idx]["isCheck"],
        secondary: CircleAvatar(
          child: Icon(
            _todoList[idx]["isCheck"] ? Icons.check : Icons.error,
          ),
        ),
        onChanged: (c) {
          setState(() {
            _todoList[idx]["isCheck"] = c;
            _refresh();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[idx]);
          _lastRemovedPos = idx;
          _todoList.removeAt(idx);

          saveData();

          final snack = SnackBar(
            content: Text("Tarefa: ${_lastRemoved['title']} removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPos, _lastRemoved);
                  saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> saveData() async {
    String data = json.encode(_todoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("Erro $e");
    }
  }
}
