import 'package:bootcamp_app_18/pages/exercises_page.dart';
import 'package:bootcamp_app_18/provider/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseCategoriesPage extends StatefulWidget {
  const ExerciseCategoriesPage({super.key});

  @override
  State<ExerciseCategoriesPage> createState() => _ExerciseCategoriesPageState();
}

class _ExerciseCategoriesPageState extends State<ExerciseCategoriesPage> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    // ExerciseProvider sağlayıcısına erişim sağlayarak _uniquePrimaryMuscles setine ulaşma
    Set<String> uniquePrimaryMuscles =
        Provider.of<ExerciseProvider>(context).uniquePrimaryMuscles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Categories'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: uniquePrimaryMuscles.length,
              itemBuilder: (context, index) {
                String muscle =
                    uniquePrimaryMuscles.elementAt(index).toUpperCase();

                String imageName =
                    'lib/assets/images/${muscle.replaceAll(' ', '')}.jpg';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  // InkWell widget, dokunmayı / tıklanmayı algılar
                  child: InkWell(
                    onTap: () {
                      // seçilen egzersiz kategorisine ait egzersizler sayfasına yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExercisesPage(categoryName: muscle.toLowerCase()),
                        ),
                      );
                    },
                    child: Container(
                      height: 130, //card yüksekliği
                      //card arka plan
                      decoration: BoxDecoration(
                        color: Colors.blueGrey, //arka plan rengini
                        image: DecorationImage(
                          image: AssetImage(imageName),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.dstATop,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        //Egzersiz Kategori Text
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              muscle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void fetchCategories() async {
    try {
      // Egzersiz verilerini çek, listen: false parametresi, widget'ın yeniden çizilmesini önler.
      await Provider.of<ExerciseProvider>(context, listen: false)
          .fetchExercises();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

//  Resimin varlığının kontrolü amaçlı yazılmış fonksiyon şuan lık koda entegre edilmemiştir.
/*
  // lib/assets/images/  => dizinindeki egzersize ait resim varmı
  Future<bool> doesExerciseCategoryImageExist(String exerciseName) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // manifestMap içinde exerciseName ile eşleşen bir anahtar var mı diye kontrol ediyoruz
      final bool imageExists = manifestMap.keys.any(
        (String key) => key.contains(exerciseName),
      );

      return imageExists;
    } catch (e) {
      // Hata durumunda false döndürüyoruz
      return false;
    }
  }
  */
}
