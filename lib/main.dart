
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    ToDoScreen(),
    ColorChangeScreen(),
    MusicPlayerScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "To-Do"),
            BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: "Colors"),
            BottomNavigationBarItem(icon: Icon(Icons.audiotrack), label: "Music"),
          ],
        ),
      ),
    );
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  ToDoScreenState createState() => ToDoScreenState();
}

class ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> todoList = [];

  void addToDo() {
    setState(() {
      if (controller.text.isNotEmpty) {
        todoList.add(controller.text);
        controller.clear();
      }
    });
  }

  void deleteToDo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("To-Do", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Task",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addToDo, child: Text("Add")),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(todoList[index], style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteToDo(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorChangeScreen extends StatefulWidget {
  const ColorChangeScreen({super.key});

  @override
  ColorChangeScreenState createState() => ColorChangeScreenState();
}

class ColorChangeScreenState extends State<ColorChangeScreen> {
  final List<Color> colors = [Colors.white, Colors.blueGrey, Colors.red, Colors.green, Colors.orange, Colors.purple];
  int colorIndex = 0;

  void changeColor() {
    setState(() {
      colorIndex = (colorIndex + 1) % colors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (_) => changeColor(),
      onVerticalDragEnd: (_) => changeColor(),
      child: Container(
        color: colors[colorIndex],
        child: Center(
          child: Text("Swipe to Change Color", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  MusicPlayerScreenState createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  final List<String> playlist = ['Bymyside.mp3','cali.mp3','Dreamworld.mp3','Righttime.mp3','Life.mp3','Neverletgo.mp3','King.mp3'];
  int currentIndex = 0;

  void toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource(playlist[currentIndex]));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextTrack() async {
    if (playlist.isNotEmpty) {
      await audioPlayer.stop(); 
      setState(() {
        currentIndex = (currentIndex + 1) % playlist.length;
        isPlaying = false;
      });

      try {
        await audioPlayer.setSource(AssetSource(playlist[currentIndex])); 
        await audioPlayer.resume(); 
        setState(() {
          isPlaying = true;
        });
      } catch (e) {
        debugPrint("Error playing next track: $e"); 
      }
    }
  }

  void previousTrack() async {
    if (playlist.isNotEmpty) {
      await audioPlayer.stop(); 
      setState(() {
        currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
        isPlaying = false;
      });

      try {
        await audioPlayer.setSource(AssetSource(playlist[currentIndex])); 
        await audioPlayer.resume(); 
        setState(() {
          isPlaying = true;
        });
      } catch (e) {
        debugPrint("Error playing previous track: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Music", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Now Playing: ${playlist[currentIndex]}", style: TextStyle(fontSize: 18, color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.skip_previous, color: Colors.white), onPressed: previousTrack),
              ElevatedButton(
                onPressed: toggleAudio,
                child: Text(isPlaying ? "Pause" : "Play"),
              ),
              IconButton(icon: Icon(Icons.skip_next, color: Colors.white), onPressed: nextTrack),
            ],
          ),
        ],
      ),
    );
  }
}
