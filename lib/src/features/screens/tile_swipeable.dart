// Packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:vibration/vibration.dart';

import 'package:kupuhu/src/constants/kg_colors.dart' show MyColors;

class Learn2Screen extends StatefulWidget {
  const Learn2Screen({Key? key}) : super(key: key);

  @override
  _Learn2ScreenState createState() => _Learn2ScreenState();
}

class _Learn2ScreenState extends State<Learn2Screen> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const ClampingScrollPhysics(),
      children: const <Widget>[
//        NormalScreen(),
        CardScreen(),
        ChatReplyScreen(),
      ],
    );
  }
}

class NormalScreen extends StatefulWidget {
  const NormalScreen({Key? key}) : super(key: key);

  @override
  _NormalScreenState createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Swipeable list'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: persons
            .map(
              (Person person) => SwipeableTile(
                color: Colors.white,
                swipeThreshold: 0.2,
                direction: SwipeDirection.horizontal,
                isElevated: false,
                borderRadius: 0,
                onSwiped: (_) {
                  // final index = persons.indexOf(person);

                  // setState(() {
                  //   persons.removeAt(index);
                  // });
                },
                backgroundBuilder: (
                  _,
                  SwipeDirection direction,
                  AnimationController progress,
                ) {
                  if (direction == SwipeDirection.endToStart) {
                    return Container(color: Colors.red);
                  } else if (direction == SwipeDirection.startToEnd) {
                    return Container(color: Colors.blue);
                  }
                  return Container();
                },
                key: UniqueKey(),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: Image.network(person.imageURL),
                  ),
                  title: Text(
                    person.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('${person.context}'),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CardScreen extends StatefulWidget {
  const CardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'swipeable tiles',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: MyColors.kgOrange[50],
      ),
      backgroundColor: Colors.white,
      body: ListView(children: <Widget>[
        ...persons.map(
          (Person person) => SwipeableTile.card(
            color: const Color(0xFFFFFFFFF),
            shadow: BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
            horizontalPadding: 16,
            verticalPadding: 8,
            direction: SwipeDirection.horizontal,
            onSwiped: (_) {
              // final index = persons.indexOf(person);

              // setState(() {
              //   persons.removeAt(index);
              // });
            },
            backgroundBuilder:
                (_, SwipeDirection direction, AnimationController progress) {
              return AnimatedBuilder(
                animation: progress,
                builder: (_, __) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: progress.value > 0.4
                        ? const Color(0xFFed7474)
                        : const Color(0xFFeded98),
                  );
                },
              );
            },
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(148),
                    child: Image.network(person.imageURL)),
                title: Text(
                  person.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
                subtitle: Text(
                  '${person.context}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class ChatReplyScreen extends StatefulWidget {
  const ChatReplyScreen({Key? key}) : super(key: key);

  @override
  _ChatReplyScreenState createState() => _ChatReplyScreenState();
}

class _ChatReplyScreenState extends State<ChatReplyScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Person? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'swipe to reply',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: MyColors.kgOrange[50],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              ...persons.map(
                (Person person) => SwipeableTile.swipeToTrigger(
                  behavior: HitTestBehavior.translucent,
                  isElevated: false,
                  color: Colors.white,
                  swipeThreshold: 0.2,
                  direction: SwipeDirection.endToStart,
                  onSwiped: (_) {
                    _focusNode.requestFocus();
                    setState(() {
                      _selectedPerson = person;
                    });
                  },
                  backgroundBuilder: (
                    _,
                    SwipeDirection direction,
                    AnimationController progress,
                  ) {
                    bool vibrated = false;
                    return AnimatedBuilder(
                      animation: progress,
                      builder: (_, __) {
                        if (progress.value > 0.9999 && !vibrated) {
                          Vibration.vibrate(duration: 40);
                          vibrated = true;
                        } else if (progress.value < 0.9999) {
                          vibrated = false;
                        }
                        return Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Transform.scale(
                              scale: Tween<double>(
                                begin: 0.0,
                                end: 1.2,
                              )
                                  .animate(
                                    CurvedAnimation(
                                      parent: progress,
                                      curve: const Interval(0.5, 1.0,
                                          curve: Curves.linear),
                                    ),
                                  )
                                  .value,
                              child: Icon(
                                Icons.reply,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  key: UniqueKey(),
                  child: MessageBubble(
                    url: person.imageURL,
                    message: person.message,
                    name: person.name,
                  ),
                ),
              ),
            ]),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: Colors.grey.shade200.withOpacity(0.5),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: <Widget>[
                      _selectedPerson != null
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.reply_rounded,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _selectedPerson!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          _selectedPerson!.message,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPerson = null;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: (_) {
                          _focusNode.canRequestFocus;
                        },
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: Color(0xFFe8e6d5)
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Type your message',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {},
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide.none),

                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String name;
  final String message;
  final String url;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: Image.network(
              url,
              width: 48,
              height: 48,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFa1ffb7),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xFF457d52)),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(message),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Person> persons = <Person>[
  Person(
      name: '??huru - warm',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02442_01.gif',
      message: 'make a video'),
  Person(
      name: 'h??iho - horse',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00133_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'hiwai - open water in a swamp',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02494_01.gif',
      message: 'share this'),
  Person(
      name: 'etahi - how great',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02451_01.gif',
      message: 'share this'),
  Person(
      name: 'haiku - haiku',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02296_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??rua - to toboggan',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02323_01.gif',
      message: 'make a video'),
  Person(
      name: 'ngaro - fly',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00209_01.gif',
      message: 'share this'),
  Person(
      name: 'k??uru - top of a tree',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02510_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??kiha - ox',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00433_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tohua - to guide',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02434_01.gif',
      message: 'share this'),
  Person(
      name: 'aitu?? - accident',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00612_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'piana - piano',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02635_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'wheto - small',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02586_01.gif',
      message: 'share this'),
  Person(
      name: 'k??tao - cool',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02343_01.gif',
      message: 'make a video'),
  Person(
      name: 'hiato - to be gathered together',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02305_01.gif',
      message: 'make a video'),
  Person(
      name: 'newha - to doze',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02349_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tapou - downcast',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02548_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'k??hua - ghost',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01351_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'purua - to plug',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02553_01.gif',
      message: 'share this'),
  Person(
      name: 'k??rua - you',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00865_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'heheu - to separate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02300_01.gif',
      message: 'make a video'),
  Person(
      name: 'koera - fearful',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02460_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'ringa - arm',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01654_01.gif',
      message: 'make a video'),
  Person(
      name: 'akura - eel-pot entrance',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02559_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tarie - to wait',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02429_01.gif',
      message: 'share this'),
  Person(
      name: 't??one - city',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00174_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??hau - to search for',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02488_01.gif',
      message: 'share this'),
  Person(
      name: 'parai - frying',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01820_01.gif',
      message: 'share this'),
  Person(
      name: 'tioka - chalk',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01692_01.gif',
      message: 'share this'),
  Person(
      name: 'tiehe - cardigan',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02037_01.gif',
      message: 'share this'),
  Person(
      name: '??rama - adam',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02220_01.gif',
      message: 'make a video'),
  Person(
      name: 't??nga - print',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02217_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'warea - to be preoccupied',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02686_01.gif',
      message: 'share this'),
  Person(
      name: 'poaka - pig',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00238_01.gif',
      message: 'share this'),
  Person(
      name: 'awhai - spouse',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02402_01.gif',
      message: 'make a video'),
  Person(
      name: 'hiapo - to be gathered together',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02304_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'arewa - restless',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02404_01.gif',
      message: 'share this'),
  Person(
      name: 'omaki - to move swiftly',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02351_01.gif',
      message: 'share this'),
  Person(
      name: 'wh??ki - to admit',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02663_01.gif',
      message: 'make a video'),
  Person(
      name: 'arok?? - to be busy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02400_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'm??hio - to know',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02309_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'raina - to form in a line',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02687_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tuaka - axis',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02387_01.gif',
      message: 'share this'),
  Person(
      name: 'aweko - old ancient',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02564_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'arahi - to guide',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02294_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'koaea - choir',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02254_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'heuhi - zeus',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02371_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??kai - to coil',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01069_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'auaka - do not',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02563_01.gif',
      message: 'share this'),
  Person(
      name: 'h??ng?? - not talkative',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02452_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'whati - to break rigid things',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02515_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??reo - to  project out',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02556_01.gif',
      message: 'make a video'),
  Person(
      name: 'punga - ankle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01128_01.gif',
      message: 'share this'),
  Person(
      name: 'haup?? - to place in a heap',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02372_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'inohi - scale',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02499_01.gif',
      message: 'share this'),
  Person(
      name: 'au??tu - never mind',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02259_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??rai - to fashion',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02547_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'horoi - to wash',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02322_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'puroa - floor',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02554_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??hoi - thin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02504_01.gif',
      message: 'share this'),
  Person(
      name: 'ringa - hand',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00160_01.gif',
      message: 'share this'),
  Person(
      name: 'hahae - to slash',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02295_01.gif',
      message: 'share this'),
  Person(
      name: 'maewa - to wander',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02307_01.gif',
      message: 'share this'),
  Person(
      name: 'ariki - chief',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02464_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??rea - wheelchair',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02226_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??kau - back',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02065_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'mania - to slide',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02283_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'rewha - eyelid',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01509_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??wheo - to be surrounded by a halo',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02278_01.gif',
      message: 'make a video'),
  Person(
      name: 'uret?? - male relative',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02585_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'h??wai - tea kettle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02579_01.gif',
      message: 'make a video'),
  Person(
      name: 'tuapa - dance',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02251_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'uarua - biceps',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02524_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'r??wai - potatoe',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01195_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'anip?? - anxious',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01909_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'pueru - mantle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02365_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??ona - horn',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02573_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??nana - wow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02443_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'marae - courtyard',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00289_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'umere - to shout in appreciation',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02439_01.gif',
      message: 'share this'),
  Person(
      name: 'h??pua - pond',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02225_01.gif',
      message: 'share this'),
  Person(
      name: 'korou - energy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02508_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'p??uri - sad',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00239_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??tao - water',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02466_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'huamo - raised in waves',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02495_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'taik?? - tiger',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00530_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'uawh?? - quadriceps',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02525_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??ura - student',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02413_01.gif',
      message: 'make a video'),
  Person(
      name: 'tatau - count',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00235_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tikei - to step over',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02542_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kuoro - to rasp',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02613_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??rau - gaze',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02244_01.gif',
      message: 'make a video'),
  Person(
      name: '??whea - when will',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02638_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'wa??nu - water fountain',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02392_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??hah?? - oh no',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02409_01.gif',
      message: 'share this'),
  Person(
      name: 'whika - to calculate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02440_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??mea - to draw up',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02419_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kekeu - to pull the trigger',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02471_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tiora - viola',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02538_01.gif',
      message: 'make a video'),
  Person(
      name: 'rarua - to be in doubt',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02426_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'onep?? - sand',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02097_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'm??eke - cold',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02345_01.gif',
      message: 'share this'),
  Person(
      name: 'k??anu - cold',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02457_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??ura - brown',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01572_01.gif',
      message: 'share this'),
  Person(
      name: 'k??iwi - bone',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01930_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'mang?? - shark',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02641_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??hiki - to make haste',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02396_01.gif',
      message: 'make a video'),
  Person(
      name: 'mangu - black',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01568_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'puaru - ripples',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02352_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'marau - to attack',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02680_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'paoka - fork',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00441_01.gif',
      message: 'make a video'),
  Person(
      name: 'hoap?? - contact',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02315_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'whenu - to spin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02487_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'punga - ankle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01766_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??nae - file',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01632_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??hae - hyena',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00284_01.gif',
      message: 'make a video'),
  Person(
      name: 'mahia - to work',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02347_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'p??oru - music',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02645_01.gif',
      message: 'make a video'),
  Person(
      name: 'hahao - hollow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02410_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??rai - fender',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02662_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tioke - jockey',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02541_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??ngi - king',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00705_01.gif',
      message: 'make a video'),
  Person(
      name: 'pukea - sunken',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02249_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'amine - amen',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02271_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tekau - ten',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00111_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tuone - gesticulate while making a speech',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02529_01.gif',
      message: 'share this'),
  Person(
      name: '??kano - ipod',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02331_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'maiea - to surface',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02482_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'm??ngi - unsettled',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02577_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'hohou - to bind together',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02317_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tiemi - to play at see-saw',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02360_01.gif',
      message: 'make a video'),
  Person(
      name: 'h??mua - elder brother or sister',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02569_01.gif',
      message: 'share this'),
  Person(
      name: 'ngeru - cat',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00426_01.gif',
      message: 'make a video'),
  Person(
      name: 'koniu - mouth of a river',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02492_01.gif',
      message: 'make a video'),
  Person(
      name: 'wheke - octopus',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01422_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??mau - pliers',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02229_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??hoe - to be steep',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02533_01.gif',
      message: 'make a video'),
  Person(
      name: 'upane - crest or terrace of a hill',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02521_01.gif',
      message: 'make a video'),
  Person(
      name: 't??kau - escarpment',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02379_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'opeti - crowded',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02212_01.gif',
      message: 'make a video'),
  Person(
      name: 'whet?? - star',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00577_01.gif',
      message: 'share this'),
  Person(
      name: 'auaha - creative',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02207_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'teiti - date',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02655_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??nia - small canoe',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02353_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??wai?? - exclamation surprise',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02401_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??ria - to be waited for',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02601_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tirau - draw a canoe sideways with the paddle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02537_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??hei - carry on the back',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02617_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??tete - to afront',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02417_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'reina - reins',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02373_01.gif',
      message: 'make a video'),
  Person(
      name: 'aeae?? - panting',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02486_01.gif',
      message: 'make a video'),
  Person(
      name: 'anuh?? - sickly',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02406_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'aumoe - to be fast asleep',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02448_01.gif',
      message: 'make a video'),
  Person(
      name: '??tahu - to charm',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02275_01.gif',
      message: 'share this'),
  Person(
      name: 'kait?? - publisher',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02455_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'p??tae - cap',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00738_01.gif',
      message: 'share this'),
  Person(
      name: '??mine - amen',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02272_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??ira - chromosome',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02366_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??whio - to go round about',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02566_01.gif',
      message: 'make a video'),
  Person(
      name: 'h??oro - to murmur as wind',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02497_01.gif',
      message: 'make a video'),
  Person(
      name: 'konae - angle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00379_01.gif',
      message: 'make a video'),
  Person(
      name: 'tuuta - junction of spine with skull',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02526_01.gif',
      message: 'make a video'),
  Person(
      name: 'whiro - pluto',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02666_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'm??hoe - purple',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01604_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'ruaki - vomit',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02643_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'taipa - to keep mouth shut',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02552_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??rahi - lead',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02588_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kakau - handle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02501_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'atiru - rain clouds',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02589_01.gif',
      message: 'make a video'),
  Person(
      name: 't??tua - belt',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02280_01.gif',
      message: 'share this'),
  Person(
      name: 'r??kau - tree',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00080_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'koeke - shrimp',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02473_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'mamae - pain',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00223_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'wawae - to part',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02675_01.gif',
      message: 'share this'),
  Person(
      name: 'k??hue - pot for boiling food',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02462_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'rango - cylinder',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01442_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'k??kai - phloem',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02507_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'okewa - nimbus cloud',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02673_01.gif',
      message: 'make a video'),
  Person(
      name: 't??ihi - to stride',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02534_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tuar?? - back',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00682_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??heia - to be confident',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02557_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'ku??ni - queen',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02166_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tatae - to arrive',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02600_01.gif',
      message: 'share this'),
  Person(
      name: 'auahi - smoke',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02583_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??pou - to bow the head',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02438_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tukua - to give',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02292_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??hao - hole as in a needle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02461_01.gif',
      message: 'share this'),
  Person(
      name: '??tute - to jostle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02596_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'totoa - impetuous',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02411_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??p??p?? - tomorrow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02135_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??tui - embroidery',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02380_01.gif',
      message: 'make a video'),
  Person(
      name: 't??tae - shit',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02644_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'k??pia - glue',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02502_01.gif',
      message: 'make a video'),
  Person(
      name: 'kaik?? - impatient',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01747_01.gif',
      message: 'share this'),
  Person(
      name: 't??kou - burnt orange',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02216_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??aha - intake',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02364_01.gif',
      message: 'share this'),
  Person(
      name: 't??roa - hypotenuse',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02650_01.gif',
      message: 'share this'),
  Person(
      name: 'k??tua - adult of animal',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02468_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'ak??ka - vine',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02270_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tihei - to sneeze',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02543_01.gif',
      message: 'make a video'),
  Person(
      name: 'tawh?? - diameter',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02651_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'akut?? - slow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02397_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'purei - to play',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02362_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'ngutu - lips',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00430_01.gif',
      message: 'share this'),
  Person(
      name: 'arero - tongue',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01503_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??iti - toe little',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01524_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tueke - covered in sores',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02250_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??wai - clavicle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02358_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'mamae - sore',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01744_01.gif',
      message: 'make a video'),
  Person(
      name: 'taewa - potatoes',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02658_01.gif',
      message: 'share this'),
  Person(
      name: '??rani - orange',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01672_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'arara - there',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02302_01.gif',
      message: 'share this'),
  Person(
      name: 'uarei - pectoral muscle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02523_01.gif',
      message: 'share this'),
  Person(
      name: 'haria - to be happy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02416_01.gif',
      message: 'share this'),
  Person(
      name: 'kitea - to see',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02421_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??rita - touchy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02264_01.gif',
      message: 'share this'),
  Person(
      name: '??inga - driving force',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02558_01.gif',
      message: 'share this'),
  Person(
      name: 'haipu - to place in a heap',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02279_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'ngira - needle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00427_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'whero - red',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00923_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tuaki - to disembowel fish',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02388_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??pio - globe',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01776_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'p??tau - cell',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02236_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??uto - to knead',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02470_01.gif',
      message: 'make a video'),
  Person(
      name: 'ur??ru - rotor',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02390_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??tai - to ask a question',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02357_01.gif',
      message: 'share this'),
  Person(
      name: 'k??tea - pale',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02509_01.gif',
      message: 'make a video'),
  Person(
      name: '??mana - almonds',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02636_01.gif',
      message: 'share this'),
  Person(
      name: 'amaru - climbing plant',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02288_01.gif',
      message: 'share this'),
  Person(
      name: 'k??nui - thumb',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00380_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'k??hua - pot',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00377_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'waero - tail of an animal',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02518_01.gif',
      message: 'make a sentence'),
  Person(
      name: '??rohi - to examine',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02447_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'takai - bandage',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02247_01.gif',
      message: 'share this'),
  Person(
      name: 'taip?? - sand dune',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01467_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??kao - peacock',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00475_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'taur?? - cord',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02381_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'puoto - kitchen',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01862_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??nati - almonds',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01753_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tiaka - jug',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01826_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'toroa - albatross',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02386_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'urur?? - sunroof',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02389_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'maiti - small',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02574_01.gif',
      message: 'make a video'),
  Person(
      name: 'haina - to sign',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02285_01.gif',
      message: 'make a video'),
  Person(
      name: 'wawao - to distract ones attention',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02591_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??m??ra - e-mail',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02498_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'wh??r?? - wrench',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02481_01.gif',
      message: 'share this'),
  Person(
      name: 'taut?? - to drag',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02430_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??era - to boil',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02424_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'amiku - to gather everything up',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02399_01.gif',
      message: 'share this'),
  Person(
      name: 't??wai - trunk',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02010_01.gif',
      message: 'share this'),
  Person(
      name: 'pango - black',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01062_01.gif',
      message: 'make a video'),
  Person(
      name: 'kokoi - astute',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02463_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'arop?? - to accost',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02405_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tunou - bow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02282_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??pia - gel',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02297_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'r??ngi - ring',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01851_01.gif',
      message: 'make a video'),
  Person(
      name: 'whare - house',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00044_01.gif',
      message: 'make a video'),
  Person(
      name: 'ranga - checked',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02214_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kaewa - to wander',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02640_01.gif',
      message: 'make a video'),
  Person(
      name: 'whana - kick',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02265_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'honae - wallet',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02018_01.gif',
      message: 'make a video'),
  Person(
      name: 'porou - to be eager',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02425_01.gif',
      message: 'make a video'),
  Person(
      name: 'kohei - anything worn round the neck',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02511_01.gif',
      message: 'share this'),
  Person(
      name: 'moua - awnmower',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02011_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'hiemi - to pass by',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02290_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'arap?? - alphabet',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02273_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 't??hau - exclamation',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02684_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??ata - glass',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01821_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??wai - to taunt',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02599_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??keta - bluish',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02240_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'ngaru - waves',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00777_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'wh??r?? - wipe the anus',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02578_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'waoko - bushman',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02516_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'atiti - to turn aside',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02565_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'p??hau - woodwind',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02633_01.gif',
      message: 'make a video'),
  Person(
      name: 'tawhi - to beckon',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02431_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tiaki - to care for',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02383_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kounu - to escape',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02679_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'maero - to drift',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02346_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tuiri - shiver',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02376_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'r??nei - or',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00186_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'p??kai - oesophagus',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02690_01.gif',
      message: 'make a video'),
  Person(
      name: 'makau - spouse',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02575_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'm??ota - green',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02145_01.gif',
      message: 'make a video'),
  Person(
      name: 'maita - mitre',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02261_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 't??aho - to emit rays of light',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02385_01.gif',
      message: 'make a video'),
  Person(
      name: 'urut?? - epidemic',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02584_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tonoa - to request',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02435_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'reira - there',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02374_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'anga - rame',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01890_01.gif',
      message: 'share this'),
  Person(
      name: 't??uru - top of a tree',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02545_01.gif',
      message: 'share this'),
  Person(
      name: 'whaea - mother',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00281_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kauae - chin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00368_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'k??whe - calf',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01258_01.gif',
      message: 'share this'),
  Person(
      name: 'h??kai - diagonal',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02328_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??tea - sperm',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02653_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'pari?? - bra',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02356_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 't??pao - to wander',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02598_01.gif',
      message: 'make a video'),
  Person(
      name: 'arihi - chop',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02561_01.gif',
      message: 'make a video'),
  Person(
      name: 'puoto - flask',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00507_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tioma - to hasten',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02540_01.gif',
      message: 'share this'),
  Person(
      name: 'waoku - dense forest',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02694_01.gif',
      message: 'make a video'),
  Person(
      name: 'maika - banana',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00874_01.gif',
      message: 'share this'),
  Person(
      name: 'k??ura - gold',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00775_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??hau - shin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02691_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'peita - paint',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02245_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'pirau - corruption',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02668_01.gif',
      message: 'share this'),
  Person(
      name: 'kaiao - organism',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02500_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'popoi - to dive',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02480_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'komai - to rejoice',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02340_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'puare - open',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02479_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??kau - wing',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00438_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??mau - server',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02243_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??niwa - reckless',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02445_01.gif',
      message: 'share this'),
  Person(
      name: 'hauh?? - carbon dioxide',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01481_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'hapui - betrothed',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02595_01.gif',
      message: 'share this'),
  Person(
      name: '??poro - apple',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00312_01.gif',
      message: 'share this'),
  Person(
      name: 'whara - to be injured',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02329_01.gif',
      message: 'make a video'),
  Person(
      name: 'hauma - to shout',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02407_01.gif',
      message: 'make a video'),
  Person(
      name: 'toene - to set of the sun',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02432_01.gif',
      message: 'make a video'),
  Person(
      name: 'r??tou - they',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02015_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kaihe - donkey',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02257_01.gif',
      message: 'share this'),
  Person(
      name: 'paera - boiler',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02354_01.gif',
      message: 'make a video'),
  Person(
      name: 'tenea - invention',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02382_01.gif',
      message: 'share this'),
  Person(
      name: 'h??iki - pinched with cold',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02333_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'mamau - to wrestle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02423_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kawhi - coffee',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02256_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'r??kai - adornment',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02369_01.gif',
      message: 'share this'),
  Person(
      name: 'kiore - rat',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00371_01.gif',
      message: 'share this'),
  Person(
      name: 't??iri - violin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02395_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'herea - to bind',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02303_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kaut?? - to wade',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02338_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'awata - grief',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02408_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kakai - to take council',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02420_01.gif',
      message: 'make a video'),
  Person(
      name: 't??mau - thumbtack',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02582_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 't??tou - three or more people',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02393_01.gif',
      message: 'share this'),
  Person(
      name: 'whiti - to cross',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02512_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??rua - to clone',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02367_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??eke - level',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02459_01.gif',
      message: 'make a video'),
  Person(
      name: 'tinei - fire extinguisher',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02571_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tiwai - yacht',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02535_01.gif',
      message: 'share this'),
  Person(
      name: 'hoiho - penguin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00322_01.gif',
      message: 'make a sentence'),
  Person(
      name: '??toro - atoll',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02276_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'r??tou - they',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00015_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??mua - protein',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02689_01.gif',
      message: 'make a video'),
  Person(
      name: 'koito - smooth',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02514_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??hau - to sweat',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02433_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'patua - to hit',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02310_01.gif',
      message: 'make a video'),
  Person(
      name: 'whiua - to fling',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02301_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kawea - to carry',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02326_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??hoe - stretch out the arms swimming',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02603_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??ohe - to hollow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02318_01.gif',
      message: 'share this'),
  Person(
      name: 'upoko - head',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00565_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'p??roi - drug',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02253_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'huaki - to elevate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02324_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tarau - trousers',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00536_01.gif',
      message: 'make a video'),
  Person(
      name: '??p??ho - podcast',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02334_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??kara - eagle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00337_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'koari - abashed',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02458_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'mauti - lawn',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01459_01.gif',
      message: 'share this'),
  Person(
      name: 'koeka - scold',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02472_01.gif',
      message: 'share this'),
  Person(
      name: 'aurau - harp',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02449_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'h??koi - to walk',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02306_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tiamu - jam',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02656_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'manga - stream',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02576_01.gif',
      message: 'share this'),
  Person(
      name: 'koara - koala',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00374_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'wahie - planks',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02688_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'waere - to clear',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02287_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'hueke - to be unrelenting',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02325_01.gif',
      message: 'share this'),
  Person(
      name: 'p??ina - to bask',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02311_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 't??mau - to tighten',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02602_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'katau - right hand',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02467_01.gif',
      message: 'share this'),
  Person(
      name: 'tiaho - to emit rays of light',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02384_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'whitu - seven',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00860_01.gif',
      message: 'make a video'),
  Person(
      name: 'tungi - ignition',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02248_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'm??hie - hatred',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02483_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kaik?? - impatient',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02456_01.gif',
      message: 'share this'),
  Person(
      name: 'taunu - to jeer',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02394_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'pouri - unhappy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01748_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'p??nui - to read',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00233_01.gif',
      message: 'make a video'),
  Person(
      name: 'p??oho - pager',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00506_01.gif',
      message: 'share this'),
  Person(
      name: 'p??tau - hook',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02234_01.gif',
      message: 'share this'),
  Person(
      name: 'honga - to lean on one side',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02321_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kapeu - pendant with curved end',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02685_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'h??nua - high  lying sterile lands',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02332_01.gif',
      message: 'share this'),
  Person(
      name: 'ukura - glow',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02522_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tirua - to check',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02597_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'matiu - matt',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02232_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'heip?? - to be on target',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01036_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'hango - shovel',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02493_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'k??nga - corn',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01255_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'amaia - halo',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02289_01.gif',
      message: 'make a sentence'),
  Person(
      name: '??nini - dizzy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01746_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'nanao - to gather together',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02348_01.gif',
      message: 'make a video'),
  Person(
      name: 'tuohu - to bow the head',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02436_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'haura - invalid',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02403_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'aouru - dawn',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02560_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??tai - surveillance',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02527_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tuoma - to hasten',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02693_01.gif',
      message: 'share this'),
  Person(
      name: 'tioko - assemble',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02539_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'hewha - heifer',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02266_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'p??reu - rake',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02555_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'whata - elevate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02642_01.gif',
      message: 'share this'),
  Person(
      name: '??piha - officer',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02446_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'ehara - on the contrary',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00194_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'towha - spread out',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02609_01.gif',
      message: 'share this'),
  Person(
      name: 'huene - to desire',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02453_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'matua - father',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00102_01.gif',
      message: 'share this'),
  Person(
      name: 'tunua - to bake',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02530_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kauae - jaw',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01519_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'koawa - watercourse',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02489_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'koiri - swaying',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02491_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'k??kau - to be roughly made',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02669_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'm??nia - plateau',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01363_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'ng??eo - snail whelk',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00414_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'puhau - inflatable raft',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02648_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??pure - patch',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01711_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'matea - to be needed',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02308_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??iti - finger little',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01525_01.gif',
      message: 'make a video'),
  Person(
      name: 'tuari - to serve food',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01205_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'waip?? - reddened',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02517_01.gif',
      message: 'share this'),
  Person(
      name: 'titei - to spy',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02536_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'h??are - spittle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02496_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'h??tai - mild',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02211_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'awheo - to be surrounded by a halo',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02277_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'wheua - bone',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01931_01.gif',
      message: 'make a video'),
  Person(
      name: 'h??koa - euphoric',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02255_01.gif',
      message: 'make a video'),
  Person(
      name: 'irak?? - to mutate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02337_01.gif',
      message: 'make a video'),
  Person(
      name: 'h??pai - support',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02101_01.gif',
      message: 'share this'),
  Person(
      name: 'moana - ocean',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00113_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??kona - teach',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02206_01.gif',
      message: 'share this'),
  Person(
      name: 't??hei - closed',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02215_01.gif',
      message: 'share this'),
  Person(
      name: 'k??ura - lobster',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00387_01.gif',
      message: 'share this'),
  Person(
      name: 'koro?? - conifer',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02342_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'k??are - to be unaware',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02422_01.gif',
      message: 'share this'),
  Person(
      name: 'm??tua - parents',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00229_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'hirou - rake',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02267_01.gif',
      message: 'make a video'),
  Person(
      name: 'hinga - to fall from an upright position',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02314_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'k??ura - crayfish',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01695_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'm??rau - garden fork',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02672_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'koira - to stare fiercely',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02312_01.gif',
      message: 'share this'),
  Person(
      name: 'p??hau - beard',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01943_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'karae - a sea bird',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02503_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kapua - clouds',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00357_01.gif',
      message: 'make a video'),
  Person(
      name: 'm??tou - we',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00017_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'tatau - door',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02091_01.gif',
      message: 'make a video'),
  Person(
      name: 'taiao - environment',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02238_01.gif',
      message: 'share this'),
  Person(
      name: 'toit?? - to be sustainable',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02661_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'kuiwi - cowardly',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02344_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'w??hia - to break open',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02608_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'ahine - woman',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02441_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'hoari - sword',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01245_01.gif',
      message: 'make a video'),
  Person(
      name: 'peara - pearl',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02359_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??tei - sentry',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02692_01.gif',
      message: 'share this'),
  Person(
      name: 'haira - scythe',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02260_01.gif',
      message: 'make a video'),
  Person(
      name: 'anuhe - catepillar',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02637_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'tuhia - to write',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02375_01.gif',
      message: 'share this'),
  Person(
      name: 'naihi - knife',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00420_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'kaheu - cashew',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02674_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'koemi - flinch',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02474_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'hunga - group',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00123_01.gif',
      message: 'make a video'),
  Person(
      name: 'hoatu - to give away from speaker',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02316_01.gif',
      message: 'make a video'),
  Person(
      name: 'kanae - to stare wildly',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02454_01.gif',
      message: 'make a video'),
  Person(
      name: 'hahau - generate',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02568_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kope?? - bra',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02028_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??rika - visible form atua',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02562_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kanga - swear',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02140_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'wharo - to cough',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02469_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'aroha - love',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00189_01.gif',
      message: 'make a video'),
  Person(
      name: 'raihe - hutch',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02368_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tieke - to set out',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02544_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'h??pua - lagoon',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02221_01.gif',
      message: 'practice with a friend'),
  Person(
      name: '??whai - maybe',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02258_01.gif',
      message: 'make a sentence'),
  Person(
      name: 't??ohu - to bow the head',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02437_01.gif',
      message: 'make a video'),
  Person(
      name: 'k??roa - index',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w01515_01.gif',
      message: 'share this'),
  Person(
      name: 'hoeha - saucer',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02268_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kaute - score',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w00720_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'tunga - send',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02531_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'k??wai - freshwater crayfish',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02339_01.gif',
      message: 'share this'),
  Person(
      name: 'atata - small circular net',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02587_01.gif',
      message: 'make a sentence'),
  Person(
      name: 'maoho - break in',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02237_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 'uruao - winter',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02519_01.gif',
      message: 'send me a voice file'),
  Person(
      name: 't??rua - saddle',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02089_01.gif',
      message: 'send me a voice file'),
  Person(
      name: '??piti - to add',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02414_01.gif',
      message: 'practice with a friend'),
  Person(
      name: 'kuihi - goose',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02230_01.gif',
      message: 'make a video'),
  Person(
      name: 't??oke - toxin',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02550_01.gif',
      message: 'make a video'),
  Person(
      name: 'purau - rake',
      context: 'essential 14,400',
      imageURL: 'https://whanau.tv/eventMedia/w02269_01.gif',
      message: 'share this'),
];

class Person {
  final String name;
  final String context;
  final String imageURL;
  final String message;

  Person({
    required this.name,
    required this.context,
    required this.imageURL,
    required this.message,
  });
}
