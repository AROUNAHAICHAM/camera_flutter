import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<Home> {
  String? content, translation;
  final ImagePicker picker = ImagePicker();
  XFile? imgPicked;

  void shareText() {
    if (content != null && translation != null) {
      final textToShare = "Texte original : $content\nTraduction : $translation";
      Share.share(textToShare);
    }
  }

  Future<void> readTextFromImage() async {
    if (imgPicked == null) {
      return;
    }

    final inputImage = InputImage.fromFilePath(imgPicked!.path);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);
    String text = recognisedText.text;

    textRecognizer.close();
    setState(() => content = text);

    // Ajout de l'appel à la fonction de traduction
    translateText();
  }

  Future<void> translateText() async {
    if (content == null || content!.isEmpty) {
      return;
    }

    final String targetLanguage = Platform.localeName.split('_')[0];

    final translator = GoogleTranslator();
    final translatedText = await translator.translate(content!, from: 'en', to: targetLanguage);

    setState(() => translation = translatedText.text);
  }

  void resetText() {
    setState(() {
      content = null;
      translation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.newspaper),
        centerTitle: true,
        title: const Text('SnapReader Pro'),
        elevation: 5,
      ),
      drawer: Drawer(child: ListView()),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20.0),
              minScale: 0.5,
              maxScale: 3.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                  image: imgPicked != null
                      ? DecorationImage(
                          image: Image.file(File(imgPicked!.path)).image,
                          fit: BoxFit.fitHeight,
                        )
                      : null,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text("Prendre photo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);

                      setState(() {
                        imgPicked = photo;
                        resetText(); // Réinitialiser le texte après avoir choisi une image.
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_album_rounded),
                    label: const Text("Choisir photo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 59, 62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imgPicked = image;
                        resetText(); // Réinitialiser le texte après avoir choisi une image.
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                readTextFromImage();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 116, 175, 76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.scanner, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Scanner", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Texte de l'image",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(content ?? ""),
            const SizedBox(height: 20),
            const Text(
              "Traduction en la langue du téléphone",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(translation ?? ""),
            ElevatedButton.icon(
              onPressed: () {
                shareText();
              },
              icon: Icon(Icons.share),
              label: Text("Partager le texte"),
            ),
          ],
        ),
      ),
    );
  }
}
