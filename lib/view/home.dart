import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/quest_controller.dart';
import '../quest_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late QuestionController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _controller= Get.put(QuestionController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: _controller.title!=""?true:false,
                child: Container(
                  //height: 20,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 50),
                  child: Text(_controller.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
              ),

              Container(
               // height: 30,
                child: Obx(() {
                    return Text.rich(
                      TextSpan(
                        text:
                        "Question ${_controller.questionNumber.value}",
                        style: TextStyle(color: Colors.red,fontSize: 18),
                        children: [
                          TextSpan(
                            text: " of ${_controller.questions.length}",
                            style: TextStyle(color: Colors.red,fontSize: 18),
                          ),
                        ],
                      ),);
                }),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Obx(() {
                 return PageView.builder(
                      // Block swipe to next qn
                      physics: NeverScrollableScrollPhysics(),
                      controller: _controller.pageController,
                      onPageChanged: _controller.updateTheQnNum,
                      itemCount: _controller.questions.length,
                      itemBuilder: (context, index) => QuestionCard(
                          question: _controller.questions.first),
                    );
                }),
              ),
              Container(
               // height: 30,
                margin: EdgeInsets.only(bottom: 70,top: 20),
                child: ElevatedButton(
                    onPressed: _controller.nextQuestion,
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromWidth(250.0),
                        primary: Colors.red
                    ),
                    child: Text("Next",style: TextStyle(color: Colors.black),)
                ),
              ),

            ],
          ),
        ),
    );
  }
}
class QuestionCard extends StatelessWidget {
  QuestionCard({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Text(
              question.question,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.red,fontSize: 15),
              ),
            ),

            SizedBox(height: 15 / 2),
           ...List.generate(
              question.options.length,
                  (index) => Option(
                  index: index,
                  text: question.options[index]["value"].toString(),
                    press: ()=>question.options[index]["value"]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Option extends StatelessWidget {
  Option({
    Key? key,
    this.text,
    this.index,
    this.press,
  }) : super(key: key);
  final String? text;
  final int? index;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          Color getTheRightColor() {
            if (qnController.isAnswered) {
              if (index == qnController.correctAns) {
                return Colors.yellow;
              } else if (index == qnController.selectedAns && qnController.selectedAns != qnController.correctAns) {
                return Colors.red;
              }
            }
            return Colors.red;
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == Colors.red ? Icons.close : Icons.done;
          }

          return InkWell(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                        width: 50,
                        child: Divider(
                            thickness: 3,
                            color: getTheRightColor()
                        )
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: getTheRightColor(),width: 3),
                        borderRadius: BorderRadius.circular(35),

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${index! + 1}. $text",
                            style: TextStyle(color: getTheRightColor(), fontSize: 13),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: getTheRightColor() == Colors.red ? Colors.transparent : getTheRightColor(),
                              borderRadius: BorderRadius.circular(150),
                              border: Border.all(color: getTheRightColor()),
                            ),
                            child: getTheRightColor() == Colors.red
                                ? null
                                : Icon(getTheRightIcon(), size: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                        width: 50,
                        child: Divider(
                            thickness: 3,
                            color: getTheRightColor()

                        )
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
