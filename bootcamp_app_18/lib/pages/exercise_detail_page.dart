import 'dart:convert';

import 'package:bootcamp_app_18/service/wger_exercise_api_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseDetailPage extends StatefulWidget {
  final int exerciseId;
  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
  Map exercise = {}; //exersiz detay map
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails(); // seçilen egzersizin detay bilgilerini alma
  }

  @override
  Widget build(BuildContext context) {
    String steps = exercise['steps'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Egzersiz Name Text
                  Text(
                    exercise['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  //egzersiz Image Carousel Slider
                  FutureBuilder<List<String>>(
                    future: getExerciseImages(exercise[
                        'name']), //Egzersize ait resim path leri alınır
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Hata: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Resim bulunamadı'));
                      } else {
                        //resim varsa carouser_slider oluştur.
                        return CarouselSliderWidget(imagePaths: snapshot.data!);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Egzersiz Adımları Text
                  Text(
                    steps,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  // egzersiz detay bilgisinde equipment varsa oluştur
                  buildDetailList(
                    'Gerekli Ekipman',
                    exercise['equipment'],
                    (equipment) => "- ${equipment["name"]}",
                  ),
                  const SizedBox(height: 16),
                  // egzersiz detay bilgisinde muscles varsa oluştur
                  buildDetailList(
                    'Çalışan Kaslar - Muscles',
                    exercise['muscles'],
                    (muscle) => "- ${muscle["name"]} (${muscle["name_en"]})",
                  ),
                  const SizedBox(height: 16),
                  // egzersiz detay bilgisinde muscles_secondary varsa yaz.
                  buildDetailList(
                    'Secondary Muscles',
                    exercise['muscles_secondary'],
                    (muscle) => "- ${muscle["name"]} (${muscle["name_en"]})",
                  ),
                ],
              ),
            ),
    );
  }

  // seçilen egzersizin detay bilgilerini alma
  fetchExerciseDetails() async {
    try {
      Map fetchedExercise =
          await ExerciseApiService.fetchExerciseDetails(widget.exerciseId);
      setState(() {
        exercise = fetchedExercise;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

/*
   buildDetailList : title, öğeler listesi ve her bir öğeyi nasıl 
   görüntüleyeceğinizi belirten bir itemBuilder fonksiyonu alır.
 */
  Widget buildDetailList(
      String title, List<dynamic> items, String Function(dynamic) itemBuilder) {
    //liste boşsa boş alan döndür
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      // title ve listeyi column içine yerleştirme
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Liste Title Text
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Text(
            itemBuilder(item),
            style: const TextStyle(fontSize: 16),
          );
        }),
      ],
    );
  }

  // lib/assets/images/exercise_detail/  =>dizinindeki egzersize ait resim path lerini al
  Future<List<String>> getExerciseImages(String exerciseName) async {
    exerciseName = exerciseName.replaceAll(' ', '').toLowerCase();

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Belirtilen egzersiz adına sahip olan resimleri filtrele
    final imagePaths = manifestMap.keys.where((String key) {
      // Dosya adının egzersiz adı ile başlaması ve numaralandırılmış olması gerekiyor
      return key.contains('lib/assets/images/exercise_detail/$exerciseName') &&
          RegExp(r'lib/assets/images/exercise_detail/' +
                  exerciseName +
                  r'\d+\.jpg')
              .hasMatch(key);
    }).toList();

    // Görüntü yollarını döndür
    return imagePaths;
  }
}

//CarouselSlider oluştur. CarouselSlider resimleri kaydırılabilir bir şekilde gösterir.
class CarouselSliderWidget extends StatelessWidget {
  final List<String> imagePaths;

  const CarouselSliderWidget({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true, // otomatik olarak kaydırma
        aspectRatio: 16 / 9, //Carousel'in en-boy oranı
        autoPlayInterval: const Duration(
            seconds: 3), //Her resim arasında 3 saniyelik geçiş süresi
        autoPlayAnimationDuration:
            const Duration(milliseconds: 800), //Geçiş animasyonunun süresi
        autoPlayCurve: Curves
            .fastOutSlowIn, //animasyon geçişi hızlı başlayıp yavaşlayarak sona erer.
        pauseAutoPlayOnTouch:
            true, //carousel'e dokunulduğunda otomatik oynatma durur
        viewportFraction: 0.8, //her resim görünüm alanının %80'ini kaplar.
      ),
      items: imagePaths.map((imagePath) {
        //listedeki her bir dosya yolu için bir Widget oluşturur.
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                  horizontal: 5.0), //her iki yanda da 5 piksel boşluk
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 218, 157),
              ),
              child: Image.asset(imagePath,
                  fit: BoxFit.cover), //resmin konteyneri tamamen kaplasın
            );
          },
        );
      }).toList(),
    );
  }
}
