import 'package:flutter/material.dart';
import 'package:notesapp/notes_database.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNote();
    // You can initialize data here if needed
  }

  Future<void> fetchNote() async{
    final fetchedNote = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notes',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),),
        
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
        ),
      body: notes.isEmpty
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notes_outlined,
              size: 80,
              color: Colors.grey[600],
            ),

            const SizedBox(height: 20),

            Text(
              'No Notes Found',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      )
      : Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85
            ),
           itemCount: notes.length,
           itemBuilder: (context,index){
            final note = notes[index];

            return Text(note['title']);
           }
           ),
        )
    );
  }
}
