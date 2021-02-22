import 'package:circular_check_box/circular_check_box.dart';
import 'package:jjovpn/screens/shared_widgets/server_list_widget.dart';
import 'package:jjovpn/screens/home_page.dart';
import 'package:flutter/material.dart';

class ServerListPage extends StatefulWidget {
  @override
  _ServerListPageState createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {

  List serverList = [
    ['assets/AustraliaFlag.png', 'Australia', 'assets/ovpnfiles/jotest.ovpn'],
    ['assets/CanadaFlag.png', 'Canada', 'assets/ovpnfiles/canadaclient.ovpn'],
    ['assets/ChinaFlag.png', 'China', 'assets/ovpnfiles/hongkongclient.ovpn'],
    ['assets/FranceFlag.png', 'France', 'assets/ovpnfiles/parisclient.ovpn'],
    ['assets/GermanyFlag.png', 'Germany', 'assets/ovpnfiles/frankfurtclient.ovpn'],
    ['assets/IndiaFlag.png', 'India', 'assets/ovpnfiles/mumbaiclient.ovpn'],
    ['assets/IrelandFlag.png', 'Ireland', 'assets/ovpnfiles/irelandclient.ovpn'],
    ['assets/JapanFlag.png', 'Japan', 'assets/ovpnfiles/tokyoclient.ovpn'],
    ['assets/KoreaFlag.png', 'Korea', 'assets/ovpnfiles/seoulclient.ovpn'],
    ['assets/SaopaoloFlag.png', 'SaoPaolo', 'assets/ovpnfiles/splclient.ovpn'],
    ['assets/SGFlag.png', 'Singapore', 'assets/ovpnfiles/singaporeclient.ovpn'],
    ['assets/SwedenFlag.png', 'Sweden', 'assets/ovpnfiles/stockholmclient.ovpn'],
    ['assets/UKFlag.png', 'United Kingdom', 'assets/ovpnfiles/londonclient.ovpn'],
    ['assets/USAFlag.png', 'United States East 1', 'assets/ovpnfiles/nvirginiaclient.ovpn'],
    ['assets/USAFlag.png', 'United States East 2', 'assets/ovpnfiles/ohioclient.ovpn'],
    ['assets/USAFlag.png', 'United States West 1', 'assets/ovpnfiles/ncaliforniaclient.ovpn'],
    ['assets/USAFlag.png', 'United States West 2', 'assets/ovpnfiles/westoregonclient.ovpn'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Server',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        itemCount: serverList.length,
        itemBuilder: (_, index) {
          // Assign file path to variable
          //final selectedRegion = serverList[index][2];

          return ServerItemWidget(
              isFaded: true,
              label: serverList[index][1],
              flagAsset: serverList[index][0],
              onTap: () {
                print(serverList[index][1]);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage(value1: serverList[index][0], value2: serverList[index][1], value3: serverList[index][2]),
                ));
              }
              );
        },
        separatorBuilder: (_, index) => SizedBox(height: 10),
      ),
    );
  }
}
