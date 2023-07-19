import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'styles_app.dart';
import 'update_page.dart';
import 'main.dart';

class MyDataPage extends StatefulWidget {
  const MyDataPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  late SupabaseClient _supabaseClient;
  List<dynamic> _data = [];
  List<dynamic> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _supabaseClient = SupabaseClient(
      'https://nwxjonnjyuwakfzodpmp.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53eGpvbm5qeXV3YWtmem9kcG1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgzNjAyNzksImV4cCI6MjAwMzkzNjI3OX0.q68yx4nDrzoWUugwxPvNLfNE4OuCjPDSnzHtF28CATM',
    );
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await _supabaseClient
        .from('articletable')
        .select('id, title, author, publication_year, content')
        .order('publication_year', ascending: false)
        // ignore: deprecated_member_use
        .execute();
    setState(() {
      _data = response.data;
      _filteredData = response.data;
    });
  }

  Future<void> deleteData(int index) async {
    var id = _filteredData[index]['id'];
    // ignore: deprecated_member_use
    await _supabaseClient.from('articletable').delete().eq('id', id).execute();

    Fluttertoast.showToast(
      msg: 'Data deleted successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );

    fetchData();
  }

  Future<void> _showConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteData(index);
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.red),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToUpdatePage(dynamic articleData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyUpdatePage(articleData: articleData),
      ),
    );
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data.where((dynamic item) {
        final title = item['title'].toString().toLowerCase();
        final author = item['author'].toString().toLowerCase();
        final publicationYear =
            item['publication_year'].toString().toLowerCase();
        final content = item['content'].toString().toLowerCase();

        return title.contains(query.toLowerCase()) ||
            author.contains(query.toLowerCase()) ||
            publicationYear.contains(query.toLowerCase()) ||
            content.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Mengubah background menjadi warna putih
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 50.0),
                  child: Text(
                    'Find facts about Indonesia on Factopia',
                    style: kPoppinsBold.copyWith(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText:
                                  'Search by title, author, year, or content',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _filterData(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  _filteredData[index]['title'],
                                  style: kPoppinsBold.copyWith(fontSize: 20.0),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),
                                  Text(
                                    '${_filteredData[index]['author']}',
                                    style: kPoppinsSemiBold.copyWith(
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Posted on ${_filteredData[index]['publication_year']}',
                                    style: kPoppinsRegular.copyWith(
                                        fontSize: 16.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    '${_filteredData[index]['content']}',
                                    textAlign: TextAlign.justify,
                                    style: kPoppinsRegular.copyWith(
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'update') {
                                    _navigateToUpdatePage(_filteredData[index]);
                                  } else if (value == 'delete') {
                                    _showConfirmationDialog(index);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'update',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Update'),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 2.0,
                              height: 20.0,
                              indent: 15.0,
                              endIndent: 15.0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyFormPage(),
                  ),
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
