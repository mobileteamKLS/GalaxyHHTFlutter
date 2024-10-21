import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../../../core/images.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import 'dart:ui' as ui;

import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customeuiwidgets/footer.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/dropdowntextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';

class CheckAWBPage extends StatefulWidget {

  int uldSeqNo;
  FlightCheckInAWBBDList aWBItem;
  String mainMenuName;
  FlightDetailSummary flightDetailSummary;
  String location;

  CheckAWBPage({super.key, required this.aWBItem, required this.mainMenuName, required this.flightDetailSummary, required this.location, required this.uldSeqNo});

  @override
  State<CheckAWBPage> createState() => _CheckAWBPageState();
}

class _CheckAWBPageState extends State<CheckAWBPage> with SingleTickerProviderStateMixin{

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;




  TextEditingController piecesController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController groupIdController = TextEditingController();
  TextEditingController nogController = TextEditingController();



  FocusNode piecesFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();
  FocusNode nogFocusNode = FocusNode();


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController); // color animation


  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      inactivityTimerManager = InactivityTimerManager(
        context: context,
        timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
        onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
      );
      inactivityTimerManager?.startTimer();
    }
  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT FLIGHT_CHECK====== ${activateORNot}");
    if(activateORNot == true){
      inactivityTimerManager!.resetTimer();
    }else{
      _logoutUser();
    }

  }
  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (context) => const SignInScreenMethod(),), (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, "Done");
    return false; // Prevents the default back button action
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inactivityTimerManager!.stopTimer();
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


    List<String> shcCodes = widget.aWBItem.sHCCode!.split(',');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: uiDirection,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: Stack(
            children: [

              MainHeadingWidget(mainMenuName: widget.mainMenuName!),
              Positioned(
                  top: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      _resumeTimerOnInteraction(); // Reset the timer on scroll event
                      return true;
                    },
                    child: Container(
                                    decoration: BoxDecoration(
                      color: MyColor.bgColorGrey,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                          topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                                    child: Directionality(
                    textDirection: textDirection,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                          child: HeaderWidget(
                            titleTextColor: MyColor.colorBlack,
                            title: "${lableModel!.checkAWb}",
                            onBack: () {
                              _onWillPop();
                            },
                            clearText: lableModel.clear,
                            onClear: () {},
                          ),
                        ),

                        Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
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
                                          Directionality(
                                            textDirection: uiDirection,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                CustomeText(
                                                    text: "${lableModel.detailsForAWBNo} ${AwbFormateNumberUtils.formatAWBNumber(widget.aWBItem.aWBNo!)}",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start)
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                          // text manifest and recived in pices text counter
                                          Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: piecesController,
                                                    focusNode: piecesFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "${lableModel.pieces}",
                                                    readOnly: false,
                                                    maxLength: 3,
                                                    onChanged: (value) {},
                                                    fillColor:  Colors.grey.shade100,
                                                    textInputType: TextInputType.number,
                                                    inputAction: TextInputAction.next,
                                                    hintTextcolor: Colors.black45,
                                                    verticalPadding: 0,
                                                    digitsOnly: true,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                    circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                    boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please fill out this field";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                              Expanded(
                                                flex:1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: weightController,
                                                    focusNode: weightFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "${lableModel.weight}",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    onChanged: (value) {},
                                                    fillColor:  Colors.grey.shade100,
                                                    textInputType: TextInputType.number,
                                                    inputAction: TextInputAction.next,
                                                    hintTextcolor: Colors.black45,
                                                    verticalPadding: 0,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                    circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                    boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please fill out this field";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical,
                                    ),
                                    Container(
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
                                              text: lableModel.otherDetail!.toUpperCase(),
                                              fontColor: MyColor.colorBlack,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                          // text manifest and recived in pices text counter
                                          Directionality(
                                            textDirection: uiDirection,
                                            child: CustomTextField(
                                              controller: groupIdController,
                                              focusNode: groupIdFocusNode,
                                              onPress: () {},
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "${lableModel.groupId}",
                                              readOnly: false,
                                              onChanged: (value) {},
                                              fillColor: Colors.grey.shade100,
                                              textInputType:
                                              TextInputType.text,
                                              inputAction:
                                              TextInputAction.next,
                                              hintTextcolor: Colors.black45,
                                              verticalPadding: 0,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please fill out this field";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                          // text manifest and recived in pices text counter
                                          Directionality(
                                            textDirection: uiDirection,
                                            child: CustomTextField(
                                              controller: nogController,
                                              focusNode: nogFocusNode,
                                              onPress: () {},
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "${lableModel.natureOfGoods}",
                                              readOnly: false,
                                              onChanged: (value) {},
                                              fillColor: Colors.grey.shade100,
                                              textInputType:
                                              TextInputType.text,
                                              inputAction:
                                              TextInputAction.next,
                                              hintTextcolor: Colors.black45,
                                              verticalPadding: 0,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please fill out this field";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical,
                                    ),
                                    Container(
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

                                          Row(
                                            children: [
                                              CustomeText(
                                                text: "${lableModel.flight} : ",
                                                fontColor: MyColor.textColorGrey2,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: 5),
                                              CustomeText(
                                                text: "${widget.flightDetailSummary.flightNo!} - ${widget.flightDetailSummary.flightDate!.replaceAll(" ", "-")}",
                                                fontColor: MyColor.colorBlack,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          (shcCodes.isNotEmpty) ? SizedBox(height: SizeConfig.blockSizeVertical,) : SizedBox(),

                                          Row(
                                            children: [
                                              widget.aWBItem.sHCCode!.isNotEmpty
                                                  ? Row(
                                                children:shcCodes.asMap().entries.take(3).map((entry) {
                                                  int index = entry.key; // Get the index for colorList assignment
                                                  String code = entry.value.trim(); // Get the code value and trim it

                                                  return Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: AnimatedBuilder(
                                                      animation: _colorAnimation,
                                                      builder: (context, child) {
                                                        return Container(
                                                          padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 1.2, vertical: 1),
                                                          decoration : BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: (code.trim() == "DGR") ? _colorAnimation.value! : MyColor.shcColorList[index % MyColor.shcColorList.length],),
                                                          child: CustomeText(
                                                            text: code.trim(),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                                  : SizedBox(),
                                            ],
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    CustomeText(
                                                      text: "NPX",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w400,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    SizedBox(width: 5),
                                                    CustomeText(
                                                      text: "${widget.aWBItem.nPX}",
                                                      fontColor: MyColor.colorBlack,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    CustomeText(
                                                      text: "NPR",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w400,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    SizedBox(width: 5),
                                                    CustomeText(
                                                      text: "${widget.aWBItem.nPR}",
                                                      fontColor: MyColor.colorBlack,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container())
                                            ],
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeVertical,),


                                          Row(
                                            children: [
                                              CustomeText(
                                                text: "${lableModel.location} : ",
                                                fontColor: MyColor.textColorGrey2,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: 5),
                                              CustomeText(
                                                text: widget.location,
                                                fontColor: MyColor.colorBlack,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical,),

                                          Row(
                                            children: [
                                              CustomeText(
                                                text: "Suggestive Location : ",
                                                fontColor: MyColor.textColorGrey2,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: 5),
                                              CustomeText(
                                                text: "-",
                                                fontColor: MyColor.colorBlack,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),



                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
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
                                              text: "${lableModel.damageAndSave}",
                                              press: () async {
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: RoundedButtonBlue(
                                              text: "${lableModel.save}",
                                              press: () async {
                                                Navigator.pop(context, "true");
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),),),
                  )),

            ],
          ),
        )),
      ),
    );
  }
}

// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

