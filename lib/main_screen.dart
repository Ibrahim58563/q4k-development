import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:q4k/cs/cs_screen.dart';
import 'package:q4k/is/is_screen.dart';
import 'package:q4k/it/it_screen.dart';
import 'package:q4k/screens/info_screen.dart';
import 'package:q4k/screens/settings_screen.dart';
import 'compnents.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'dialog.dart';
import 'mm/mm_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => const MyDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> sectionName = [
      'IT',
      'CS',
      'IS',
      'MM',
    ];
    List<IconData> iconName = [
      Icons.lan,
      Icons.laptop_sharp,
      Icons.data_array_rounded,
      Icons.display_settings,
    ];
    List<Widget> screens = [
      const IT(),
      const CS(),
      const IS(),
      const MM(),
    ];
    return Scaffold(
      backgroundColor: primaryColor,
      body: SliderDrawer(
        appBar: SliderAppBar(
            appBarColor: Colors.white,
            title: Text("",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700))),
        key: _key,
        sliderOpenSize: 190,
        slider: _SliderView(
          onItemClick: (title) {
            _key.currentState!.closeSlider();
            setState(() {
              // this.title = title;
            });
          },
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Text('Q4K',
                style: GoogleFonts.nunito(
                  fontSize: 60,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 5,
            ),
            Text('All you want is here',
                style: GoogleFonts.cookie(
                    fontSize: 40,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: primaryColor.withOpacity(0.5))),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 400,
              height: 1000,
              child: ListView.builder(
                itemCount: sectionName.length,
                itemBuilder: (context, index) => DepartmentCard(
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => screens[index]));
                    },
                    index: index,
                    icon_name: iconName,
                    section_name: sectionName),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(String)? onItemClick;

  const _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Profile Name',
            style: TextStyle(
                color: lightColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          _SliderMenuItem(
              title: 'Home', iconData: Icons.home, onTap: onItemClick),
          _SliderMenuItem(
            onTap: (p0) {},
            title: 'Setting',
            iconData: Icons.settings,
            // onTap: Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const SettingsScreen())),
          ),
          _SliderMenuItem(
            title: 'About',
            iconData: Icons.info,
            onTap: (p0) {},
            // onTap: Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => InfoScreen())),
          ),
          _SliderMenuItem(
              title: 'LogOut',
              iconData: Icons.arrow_back_ios,
              onTap: onItemClick),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            color: lightColor,
            // fontFamily: 'BalsamiqSans_Regular',
          )),
      leading: Icon(iconData, color: lightColor),
    );
  }
}
