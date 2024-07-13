import 'package:bootcamp_app_18/models/exercise_model.dart';
import 'package:bootcamp_app_18/provider/exercise_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseId;
  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, _) {
        Exercise? exercise =
            exerciseProvider.getExerciseById(widget.exerciseId);

        if (exercise == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Exercise Details')),
            body: const Center(child: Text('Exercise not found')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Exercise Details'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Egzersiz Name Text
                Text(
                  exercise.name!.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                //egzersiz Image Carousel Slider
                CarouselSliderWidget(imagePaths: exercise.images!),
                const SizedBox(height: 16),
                // Egzersiz Adımları varsa
                buildDetailList(
                  'Egzersiz Adımları',
                  exercise.instructions!,
                  (item) => item,
                ),
                const SizedBox(height: 16),

                Text(
                  "Level : ${exercise.level ?? 'No level available'}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),
                // egzersiz detay bilgisinde Primary muscles varsa oluştur
                buildDetailList(
                  'Primary Muscles',
                  exercise.primaryMuscles!,
                  (muscle) => "- $muscle",
                ),
                const SizedBox(height: 16),
                // egzersiz detay bilgisinde Secondary muscles varsa yaz.
                buildDetailList(
                  'Secondary Muscles',
                  exercise.secondaryMuscles!,
                  (muscle) => "- $muscle",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* detay bilgiisnde yer alan listelerin widgetını oluşturma
   buildDetailList : title, öğeler listesi ve her bir öğeyi nasıl 
   görüntüleyeceğinizi belirten bir itemBuilder fonksiyonu alır.
 */
Widget buildDetailList(
    String title, List<dynamic> items, String Function(dynamic) itemBuilder) {
  //liste boşsa boş alan döndür
  if (items.isEmpty) return const SizedBox.shrink();

  // Egzersiz talimatları için numaralandırma işlemini kontrol etmek için flag
  bool isInstructionsList =
      (title == 'Egzersiz Adımları' && items is List<String>);

  return Column(
    // title ve listeyi column içine yerleştirme
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Liste Title Text
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      // Egzersiz talimatları için numaralandırma
      if (isInstructionsList)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.asMap().entries.map((entry) {
            int index = entry.key + 1;
            String instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      instruction,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

      // Diğer listeler için genel map işlemi
      ...(!isInstructionsList
          ? items.map((item) {
              return Text(
                itemBuilder(item),
                style: const TextStyle(fontSize: 16),
              );
            }).toList()
          : []),
      const SizedBox(width: 8),
    ],
  );
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
              child: Image.network(
                'https://github.com/havva-nur-ezginci/free-exercise-db_tr/blob/main/exercises/$imagePath?raw=true',
                //Görsel URL'sindeki ?raw=true parametresi, GitHub'dan doğrudan dosyayı almanıza yardımcı olur.
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Text('Görsel yüklenirken bir hata oluştu: $exception');
                },
                fit: BoxFit.cover,
              ), // resmin konteyneri tamamen kaplasın
            );
          },
        );
      }).toList(),
    );
  }
}
