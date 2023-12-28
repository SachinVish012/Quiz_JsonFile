import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../quest_model.dart';

class QuestionController extends GetxController {
  var title="";
  var questions = <Question>[].obs;
  late PageController _pageController;
  List<String> result=[];

  PageController get pageController => this._pageController;

  bool _isAnswered = false;

  bool get isAnswered => this._isAnswered;

  //----for correct ans
  late int _correctAns;

  int get correctAns => this._correctAns;

  //------for select ans
  late int _selectedAns;

  int get selectedAns => this._selectedAns;

  //--------Quest number
  RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;

  int get numOfCorrectAns => this._numOfCorrectAns;

  @override
  void onInit() {
    _pageController = PageController();
    fetchQuiz();
    super.onInit();
  }

  void fetchQuiz() async {
    var response = await await rootBundle.loadString('assets/Questions.json');
    final data1 = await json.decode(response);
    print(data1);
    if (data1 != null) {
      var data = data1!;
      title = data["title"];
      List<Question> new_list = [];
      for (int i = 0; i < data.length; i++) {
        var question_title = data["schema"]["fields"][i]["schema"]["label"];
        //var question_field = data["schema"]["fields"][i]["schema"]["fields"];
        var question_option = data["schema"]["fields"][i]["schema"]["options"];
        print(question_option);
        //---for store above details
        Question hhd=   new Question(
            question: question_title,
            options: question_option
        );
        new_list.add(hhd);
      }
      questions.value=new_list;
      print("-----11----");
      print(questions.value);
      print("-----22----");
    }
  }
  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }


  void nextQuestion() {
    if (_questionNumber.value != questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 100), curve: Curves.ease);
      updateTheQnNum(1);
      update();
    } else {
     print("next quest screen");
    // Get.off(FinalQuizScore(statusmsg:statusmsg,numOfCorrectAns:numOfCorrectAns,questions:questions.length));

    }
  }
}