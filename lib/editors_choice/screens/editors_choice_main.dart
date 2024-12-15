import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'package:ajengan_halal_mobile/models/food_recommendation/food_recommendation.dart';
import 'package:ajengan_halal_mobile/models/food_recommendation/editor_choice.dart';
import 'package:http/http.dart' as http;

class EditorsChoiceMain extends StatefulWidget {
  const EditorsChoiceMain({super.key});

  @override
  State<EditorsChoiceMain> createState() => _EditorsChoiceMainState();
}

class _EditorsChoiceMainState extends State<EditorsChoiceMain> {
  String filter = "all";
  late Map<EditorChoice, List<FoodRecommendation>> editorChoices = {};

  @override
  void initState() {
    super.initState();
    fetchEditorChoices();
  }

  // Fetch the editor choices -> food-recommendations from the server
  Future<void> fetchEditorChoices() async {
    final responseFR = await http.get(
      Uri.parse('http://localhost:8000/editors-choice/json/food-rec/'));
    final responseEC = await http.get(
      Uri.parse('http://localhost:8000/editors-choice/json/editor-choice/'));
    if (responseEC.statusCode == 200 && responseFR.statusCode == 200) {
      final List<FoodRecommendation> foodRecommendations =
          foodRecommendationFromJson(responseFR.body);
      final List<EditorChoice> fetchedEdChoice =
          editorChoiceFromJson(responseEC.body);
      final Map<EditorChoice, List<FoodRecommendation>> editorChoicesMap = {};
      for (final editorChoice in fetchedEdChoice) {
        final List<FoodRecommendation> foodRecommendationsForEditorChoice = [];
        for (final foodRecommendation in foodRecommendations) {
          if (editorChoice.fields.foodItems.contains(foodRecommendation.pk)) {
            foodRecommendationsForEditorChoice.add(foodRecommendation);
          }
        }
        editorChoicesMap[editorChoice] = foodRecommendationsForEditorChoice;
      }
      setState(() {
        editorChoices = editorChoicesMap;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editors Choice'),
        backgroundColor: const Color(0xFF3D200A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      // The body is to be changed properly
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      NetworkImage('https://example.com/background-image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            editorChoices.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: editorChoices.length,
                  itemBuilder: (context, index) {
                    final editorChoice = editorChoices.keys.elementAt(index);
                    final foodRecommendations =
                      editorChoices[editorChoice]!;
                    return Card(
                      child: ExpansionTile(
                        title: Text(editorChoice.fields.week.toString()),
                        children: foodRecommendations
                          .map((foodRecommendation) => ListTile(
                                title: Text(foodRecommendation.fields.foodItem),
                              ))
                          .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
