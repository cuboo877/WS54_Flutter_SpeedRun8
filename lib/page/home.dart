import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun8/page/add.dart';
import 'package:ws54_flutter_speedrun8/page/edit.dart';
import 'package:ws54_flutter_speedrun8/page/user.dart';
import 'package:ws54_flutter_speedrun8/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../widget/custom_textbutton.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List passwordList = [];
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController id_controller;
  bool hasFav = false;
  int isFav = 1;
  @override
  void initState() {
    super.initState();
    setAllPasswordList();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  bool searching = false;

  Future<void> setAllPasswordList() async {
    searching = false;
    List<PasswordData> dataList =
        await PasswordDAO.getPasswordListByUserID(widget.userID);
    setState(() {
      passwordList = dataList;
    });
    print("set password list :${passwordList.length}");
  }

  Future<void> setPasswordListByCondition() async {
    searching = true;
    List<PasswordData> dataList = await PasswordDAO.getPasswordListByConditoin(
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        id_controller.text,
        hasFav,
        isFav);
    setState(() {
      passwordList = dataList;
    });
    print("set password list by condition:${passwordList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.black,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddPage(userID: widget.userID)))),
        drawer: drawer(context),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: topbar(),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: searchBar(),
                ),
                passwordListViewBuilder(),
              ],
            ),
          ),
        ));
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.black, width: 2.0),
          borderRadius: BorderRadius.circular(45)),
      child: Column(children: [
        TextFormField(
          controller: tag_controller,
        ),
        TextFormField(
          controller: url_controller,
        ),
        TextFormField(
          controller: login_controller,
        ),
        TextFormField(
          controller: password_controller,
        ),
        TextFormField(
          controller: id_controller,
        ),
        Row(
          children: [
            Expanded(
                child: CheckboxListTile(
              title: const Text("包含我的最愛"),
              value: (hasFav),
              onChanged: (value) => setState(() {
                hasFav = !hasFav;
              }),
            )),
            Expanded(
                child: CheckboxListTile(
              enabled: hasFav,
              title: const Text("我的最愛"),
              value: (isFav == 0 ? false : true),
              onChanged: (value) => setState(() {
                isFav = isFav == 0 ? 1 : 0;
              }),
            ))
          ],
        ),
        Row(
          children: [
            customTextButton(AppColor.black, "搜尋", 20, () async {
              setPasswordListByCondition();
            }),
            customTextButton(AppColor.black, "取消設定", 20, () async {
              setState(() {
                tag_controller.text = "";
                url_controller.text = "";
                login_controller.text = "";
                password_controller.text = "";
                id_controller.text = "";
                hasFav = false;
                isFav = 1;
              });
            }),
            customTextButton(AppColor.black, "取消搜尋", 20, () async {
              setAllPasswordList();
            }),
          ],
        )
      ]),
    );
  }

  Widget passwordListViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: dataContainer(context, passwordList[index]),
          );
        }));
  }

  Widget dataContainer(BuildContext context, PasswordData data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.black, width: 2.0),
          borderRadius: BorderRadius.circular(45)),
      child: Column(
        children: [
          Text(data.tag),
          Text(data.url),
          Text(data.login),
          Text(data.password),
          Text(data.id),
          Row(
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: AppColor.red, width: 2.0),
                      shape: const CircleBorder(),
                      backgroundColor:
                          data.isFav == 0 ? AppColor.white : AppColor.red,
                      iconColor:
                          data.isFav == 1 ? AppColor.white : AppColor.red),
                  onPressed: () async {
                    setState(() {
                      data.isFav = data.isFav == 0 ? 1 : 0;
                    });

                    await PasswordDAO.updatePassordData(data);
                  },
                  child: const Icon(Icons.favorite)),
              TextButton(
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColor.green,
                      iconColor: AppColor.white),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(data: data))),
                  child: const Icon(Icons.edit)),
              TextButton(
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColor.red,
                      iconColor: AppColor.white),
                  onPressed: () async {
                    await PasswordDAO.removePassordData(data.id);
                    if (searching) {
                      setPasswordListByCondition();
                    } else {
                      setAllPasswordList();
                    }
                  },
                  child: const Icon(Icons.delete)),
            ],
          )
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close)),
        ListTile(
            title: const Text("主畫面"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pop()),
        ListTile(
          title: const Text("帳號設置"),
          leading: const Icon(Icons.home),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserPage(userID: widget.userID))),
        ),
        logOutButton(context)
      ]),
    );
  }

  Widget topbar() {
    return AppBar(
      backgroundColor: AppColor.black,
      title: const Text("主畫面"),
    );
  }

  Widget logOutButton(BuildContext context) {
    return customTextButton(AppColor.red, "log out", 30, () async {
      await Auth.logOiut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }
}
