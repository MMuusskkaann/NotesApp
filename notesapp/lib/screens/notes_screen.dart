import 'package:flutter/material.dart';
import 'package:notesapp/notes_database.dart';
import 'package:notesapp/screens/note_card.dart';
import 'package:notesapp/screens/note_dialogue.dart';

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

  Future<void> fetchNote() async {
    final fetchedNote = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNote;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFFF355E), // Radical Red
    const Color(0xFFFD5B78), // Wild Watermelon
    const Color(0xFFFF6037), // Outrageous Orange
    const Color(0xFFFF9966), // Atomic Tangerine
    const Color(0xFFFF9933), // Neon Carrot
    const Color(0xFFFFCC33), // Sunglow
    const Color(0xFFFFFF66), // Laser Lemon
    const Color(0xFFCCFF00), // Electric Lime
    const Color(0xFF66FF66), // Screamin' Green
    const Color(0xFFAAF0D1), // Magic Mint
    const Color(0xFF16D0CB), // Aqua variant
    const Color(0xFF50BFE6), // Blizzard Blue
    const Color(0xFF9C27B0), // Shocking Pink
    const Color(0xFFEE34D2), // Razzle Dazzle Rose
    const Color(0xFFFF00CC), // Hot Magenta
  ];

  void showNoteDialogue(
      {int? id, String? title, String? content, int colorIndex = 0}) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return NoteDialogue(
              colorIndex: colorIndex,
              noteColors: noteColors,
              noteId: id,
              title: title,
              content: content,
              onNoteSaved: (newtitle, newDesription, currentDate,
                  selectedColorIndex) async {
                if (id == null) {
                  await NotesDatabase.instance.addNotes(newtitle, newDesription,
                      currentDate, selectedColorIndex, colorIndex);
                } else {
                  await NotesDatabase.instance.updateNote(newtitle,
                      newDesription, currentDate, selectedColorIndex, id);
                }
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await NotesDatabase.instance.addNotes(
                'Sample Title', 'Sample Description', '2025-16-6', 0, 0);
            showNoteDialogue();
          },
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return NoteCard(
                        note: note, 
                        onDelete: () async{
                          await NotesDatabase.instance.deleteNote(note['id']);
                          fetchNote();
                        },
                         onTap: (){
                          showNoteDialogue(
                            id : note['id'],
                            title: note['title'],
                            content: note['content'],
                            colorIndex: note['color'],
                          );
                         }, 
                         noteColors: noteColors
                         );
                    }),
              ));
  }
}
