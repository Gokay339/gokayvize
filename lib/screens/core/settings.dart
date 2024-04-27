import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String camResult = "";
  String locationResult = "";
  String locationAllwaysResult = "";
  String locationInfo = "";
  bool loading = false;

  controlPermission() async {
    var status = await Permission.camera.status;

    switch (status) {
      case (PermissionStatus.granted):
        setState(() {
          camResult = "Yetki Alinmis.";
        });
        break;
      case (PermissionStatus.denied):
        setState(() {
          camResult = "Yetki Rededilmis.";
        });
        break;
      case PermissionStatus.restricted:
        setState(() {
          camResult = "Kisitlanmis Yetki, hic turlu alamayiz.";
        });
        break;
      case PermissionStatus.limited:
        setState(() {
          camResult = "Kisitlanmis Yetki, hKullanici kisitli yetki secmis.";
        });
        break;
      case PermissionStatus.permanentlyDenied:
        setState(() {
          camResult = "Yetki vermesin diye istemis kullanic";
        });
        break;
      case PermissionStatus.provisional:
        setState(() {
          camResult = "Provisional";
        });
        break;
    }

    await Permission.locationAlways.onDeniedCallback(() {
      setState(() {
        locationResult = "Yetki vermeyi reddetti";
      });
    }).onGrantedCallback(() async {
      setState(() {
        locationResult = "Yetki Verildi";
      });

      await Permission.camera.onDeniedCallback(() {
        setState(() {
          locationAllwaysResult = "Herzaman Konum Erişimi Reddedildi";
        });
      }).onGrantedCallback(() {
        setState(() {
          locationAllwaysResult = "HERZAMAN KONUM ERİŞİMİ " + status.toString();
        });
      }).onPermanentlyDeniedCallback(() {
        setState(() {
          locationAllwaysResult = "HERZAMAN KONUM ERİŞİMİ" + status.toString();
        });
      }).onRestrictedCallback(() {
        setState(() {
          locationAllwaysResult = "HERZAMAN KONUM ERİŞİMİ" + status.toString();
        });
      }).onLimitedCallback(() {
        setState(() {
          locationAllwaysResult = "HERZAMAN KONUM ERİŞİMİ " + status.toString();
        });
      }).onProvisionalCallback(() {
        setState(() {
          locationAllwaysResult = "HERZAMAN KONUM ERİŞİMİ" + status.toString();
        });
      }).request();
    }).onPermanentlyDeniedCallback(() {
      setState(() {
        locationResult = "Herzaman Engellendi.";
      });
    }).onRestrictedCallback(() {
      setState(() {
        locationResult = "Kısıtlanmış ve alınamaz.";
      });
    }).onLimitedCallback(() {
      setState(() {
        locationResult = "Kullanıcı kısıtlanmış yetki.";
      });
    }).onProvisionalCallback(() {
      setState(() {
        locationResult = "Provisonal";
      });
    }).request();
  }

  getLocation() async {
    setState(() {
      loading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationInfo = "Konum Hizmetleri Ayarlardan Kapalı";
      });

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationInfo = "Yetki Verilmiyor";
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationInfo = "Yetkiler tamamen kapatıldı.";
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      locationInfo = '''
        accuracy: ${pos.accuracy}
        longitude: ${pos.longitude}
        latitude: ${pos.latitude}
        speed: ${pos.speed}
        speed Dikkati: ${pos.speedAccuracy}
        veri zamani: ${pos.timestamp}
        ''';
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controlPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getTranslate("settings")),
      ),
      body: SizedBox.expand(
        child: ListView(
          children: [
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).getTranslate("camera_perm")),
              children: [
                Text(camResult),
                Gap(20),
                ElevatedButton(
                  onPressed: () async {
                    final status = await Permission.camera.request();
                  },
                  child: Text(AppLocalizations.of(context).getTranslate("req")),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).getTranslate("location_perm")),
              children: [
                Text(locationResult),
                Divider(),
                Text(AppLocalizations.of(context).getTranslate("stat")),
                Text(locationAllwaysResult),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).getTranslate("location_info")),
              children: [
                IconButton(
                  onPressed: getLocation,
                  icon: const Icon(Icons.location_on),
                ),
                const Divider(),
                Text(locationInfo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
