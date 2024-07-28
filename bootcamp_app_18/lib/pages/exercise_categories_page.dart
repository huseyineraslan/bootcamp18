import 'package:bootcamp_app_18/pages/exercises_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseCategoriesPage extends StatefulWidget {
  const ExerciseCategoriesPage({super.key});

  @override
  State<ExerciseCategoriesPage> createState() => _ExerciseCategoriesPageState();
}

class _ExerciseCategoriesPageState extends State<ExerciseCategoriesPage> {
  bool isLoading = true;
/* 
 egzersiz çekme işlemi uygulama açılırken (main) çekilir
 hale getirildi istenirse buradan da çekme yapılabilir
 */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    // ExerciseProvider sağlayıcısına erişim sağlayarak _uniquePrimaryMuscles setine ulaşma
    Set<String> uniquePrimaryMuscles =
        Provider.of<AppProvider>(context).uniquePrimaryMuscles;

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
                    'lib/assets/images/exercise_detail/${muscle.replaceAll(' ', '')}.jpg';

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
      //await Provider.of<AppProvider>(context, listen: false).fetchExercises();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }
}
