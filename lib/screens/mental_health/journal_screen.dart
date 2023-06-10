import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedMoodIndex = -1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New Entry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'How was your mood today?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMoodButton(0, Icons.sentiment_very_dissatisfied),
                    _buildMoodButton(1, Icons.sentiment_satisfied),
                    _buildMoodButton(2, Icons.sentiment_very_satisfied),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _saveEntry(uid);
                    _clearFields();
                  },
                  child: Text('Save Entry'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(child: _buildEntryList(uid)),
        ],
      ),
    );
  }

  Widget _buildMoodButton(int index, IconData icon) {
    final isSelected = index == _selectedMoodIndex;
    final color = isSelected ? Colors.blue : Colors.grey;

    return IconButton(
      onPressed: () {
        setState(() {
          _selectedMoodIndex = index;
        });
      },
      icon: Icon(icon, color: color),
    );
  }

  Future<void> _saveEntry(String? uid) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final mood = _selectedMoodIndex;

    if (title.isEmpty || description.isEmpty || mood == -1) {
      return;
    }

    final entry = {
      'uid': uid,
      'title': title,
      'description': description,
      'mood': mood,
      'timestamp': DateTime.now(),
    };

    final entryRef = FirebaseFirestore.instance.collection('entries');
    await entryRef.add(entry);
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedMoodIndex = -1;
    });
  }

  Widget _buildEntryList(String? uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entries')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data?.docs ?? [];

        if (entries.isEmpty) {
          return Center(child: Text('No entries found.'));
        }

        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index].data() as Map<String, dynamic>;
            final title = entry['title'] ?? '';
            final description = entry['description'] ?? '';
            final mood = entry['mood'];
            final timestamp = entry['timestamp'] as Timestamp;

            final dateTime = timestamp.toDate();
            final formattedDate =
                '${dateTime.day}-${dateTime.month}-${dateTime.year}';

            return ListTile(
              title: Text('$title : $formattedDate'),
              subtitle: Text(description),
              trailing: _buildMoodEmoji(mood),
            );
          },
        );
      },
    );
  }

  Widget _buildMoodEmoji(int mood) {
    IconData icon;
    String text;

    switch (mood) {
      case 0:
        icon = Icons.sentiment_very_dissatisfied;
        text = 'Bad';
        break;
      case 1:
        icon = Icons.sentiment_satisfied;
        text = 'Neutral';
        break;
      case 2:
        icon = Icons.sentiment_very_satisfied;
        text = 'Good';
        break;
      default:
        icon = Icons.sentiment_neutral;
        text = 'Unknown';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
