import 'package:flutter/material.dart';
import 'package:flutter_application_api/styles_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'data_page.dart';
import 'splash_page.dart';
import 'update_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Factopia',
    debugShowCheckedModeBanner: false,
    home: const SplashPage(),
    routes: {
      '/data': (context) => const MyDataPage(),
      '/update': (context) => const MyUpdatePage(
            articleData: null,
          ),
    },
  ));
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publicationYearController = TextEditingController();
  final _contentController = TextEditingController();
  late SupabaseClient _supabaseClient;

  @override
  void initState() {
    super.initState();
    _supabaseClient = SupabaseClient(
      'https://nwxjonnjyuwakfzodpmp.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53eGpvbm5qeXV3YWtmem9kcG1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgzNjAyNzksImV4cCI6MjAwMzkzNjI3OX0.q68yx4nDrzoWUugwxPvNLfNE4OuCjPDSnzHtF28CATM',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publicationYearController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _supabaseClient.from('articletable').insert({
        'title': _titleController.text,
        'author': _authorController.text,
        'publication_year': _publicationYearController.text,
        'content': _contentController.text,
        // ignore: deprecated_member_use
      }).execute();

      _titleController.clear();
      _authorController.clear();
      _publicationYearController.clear();
      _contentController.clear();

      // Show toast message after successful post
      Fluttertoast.showToast(
        msg: 'Data posted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 35.0),
                    Text(
                      'Write down any facts you have about Indonesia!',
                      style: kPoppinsBold.copyWith(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    TextFormField(
                      controller: _titleController,
                      style: kPoppinsRegular.copyWith(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _authorController,
                  style: kPoppinsRegular.copyWith(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Author Name',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an author name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _publicationYearController,
                  style: kPoppinsRegular.copyWith(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Publication Year',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a publication year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contentController,
                  style: kPoppinsRegular.copyWith(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Facts You Know',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the fact you know';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: SizedBox(
                    height: 50.0,
                    child: Center(
                      child: Text(
                        'Post',
                        style: kPoppinsRegular.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/data');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: SizedBox(
                    height: 50.0,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: kPoppinsRegular.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Created by Naufal Choirul Ananda - 2023.',
                    style: kPoppinsRegular.copyWith(
                      fontSize: 12.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
