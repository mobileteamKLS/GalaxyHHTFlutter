import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/import/model/flightcheck/awblistmodel.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../utils/awbformatenumberutils.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

class Damageuipart7 extends StatefulWidget {

  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  Damageuipart7({super.key, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<Damageuipart7> createState() => _Damageuipart7State();
}

class _Damageuipart7State extends State<Damageuipart7> {


  List<String> whetherConditionList = ["Clear", "Foggy", "Raining"];
  List<String> selectedWhetherList = [];


  String selectedOption = "Yes";
  String selectedOption2 = "Yes";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection =
    localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.ltr
        : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection =
    localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;


    return Column(
      children: [
        HeaderWidget(
          titleTextColor: MyColor.colorBlack,
          title: "Damage & Save",
          onBack: () {
            Navigator.pop(context, "true");
          },
          clearText: "${lableModel!.clear}",
          onClear: () {

          },
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: MyColor.colorWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: MyColor.colorBlack.withOpacity(0.09),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomeText(
                            text: "16. a) Any Space For Missing Items",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        Row(
                          children: [
                            Radio(

                              value: "Yes",
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                            const Text("Yes"),
                            Radio(
                              value: "No",
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;// Clear remark if "No" is selected
                                });
                              },
                            ),
                            const Text("No"),
                            Radio(
                              value: "N/A",
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;// Clear remark if "No" is selected
                                });
                              },
                            ),
                            const Text("N/A"),
                          ],
                        ),

                        /*  Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.cardBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GridView.builder(
                            itemCount: innerPackingList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10, // Spacing between columns
                              mainAxisSpacing: 0, // Spacing between rows
                              childAspectRatio: 4, // Adjust based on your desired width/height ratio
                            ),
                            itemBuilder: (context, index) {
                              String innerPacking = innerPackingList[index];

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomeText(
                                      text: innerPacking,
                                      fontColor: MyColor.colorBlack,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: selectedInnerPackList.contains("${innerPacking}~"),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: MyColor.primaryColorblue,
                                      inactiveThumbColor: MyColor.thumbColor,
                                      inactiveTrackColor: MyColor.textColorGrey2,
                                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value) {
                                            selectedInnerPackList.add("${innerPacking}~");
                                          } else {
                                            selectedInnerPackList.remove("${innerPacking}~");
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )*/



                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: MyColor.colorWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: MyColor.colorBlack.withOpacity(0.09),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomeText(
                            text: "b) Is Shortage Verified By Invoice",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        Row(
                          children: [
                            Radio(

                              value: "Yes",
                              groupValue: selectedOption2,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption2 = value!;
                                });
                              },
                            ),
                            const Text("Yes"),
                            Radio(
                              value: "No",
                              groupValue: selectedOption2,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption2 = value!;// Clear remark if "No" is selected
                                });
                              },
                            ),
                            const Text("No"),
                            Radio(
                              value: "N/A",
                              groupValue: selectedOption2,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption2 = value!;// Clear remark if "No" is selected
                                });
                              },
                            ),
                            const Text("N/A"),
                          ],
                        ),

                        /*  Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.cardBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GridView.builder(
                            itemCount: innerPackingList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10, // Spacing between columns
                              mainAxisSpacing: 0, // Spacing between rows
                              childAspectRatio: 4, // Adjust based on your desired width/height ratio
                            ),
                            itemBuilder: (context, index) {
                              String innerPacking = innerPackingList[index];

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomeText(
                                      text: innerPacking,
                                      fontColor: MyColor.colorBlack,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: selectedInnerPackList.contains("${innerPacking}~"),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: MyColor.primaryColorblue,
                                      inactiveThumbColor: MyColor.thumbColor,
                                      inactiveTrackColor: MyColor.textColorGrey2,
                                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value) {
                                            selectedInnerPackList.add("${innerPacking}~");
                                          } else {
                                            selectedInnerPackList.remove("${innerPacking}~");
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )*/



                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: MyColor.colorWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: MyColor.colorBlack.withOpacity(0.09),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomeText(
                            text: "17) Weather Condition ?",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.cardBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GridView.builder(
                            itemCount: whetherConditionList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of columns
                              crossAxisSpacing: 5, // Spacing between columns
                              mainAxisSpacing: 0, // Spacing between rows
                              childAspectRatio: 3, // Adjust based on your desired width/height ratio
                            ),
                            itemBuilder: (context, index) {
                              String whetherCondition = whetherConditionList[index];

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: CustomeText(
                                      text: whetherCondition,
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: selectedWhetherList.contains("${whetherCondition}~"),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: MyColor.primaryColorblue,
                                      inactiveThumbColor: MyColor.thumbColor,
                                      inactiveTrackColor: MyColor.textColorGrey2,
                                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value) {
                                            selectedWhetherList.add("${whetherCondition}~");
                                          } else {
                                            selectedWhetherList.remove("${whetherCondition}~");
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )





                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: MyColor.colorBlack.withOpacity(0.09),
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "Previous",
                  press: () async {
                    widget.preclickCallback();
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
              ),
              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "Next",
                  press: () async {
                    widget.nextclickCallback();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
