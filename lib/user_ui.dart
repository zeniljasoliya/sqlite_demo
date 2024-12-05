import 'package:flutter/material.dart';
import 'package:sqlite_demo/local_database.dart';
import 'package:sqlite_demo/user.model.dart';

class UserUi extends StatefulWidget {
  const UserUi({super.key});

  @override
  State<UserUi> createState() => _UserUiState();
}

class _UserUiState extends State<UserUi> {
  late Future<List<UserData>> futureUserData;
  bool isupdated = false;
  int selectedId = 0;
  TextEditingController txtUserNameController = TextEditingController();
  @override
  void initState() {
    futureUserData = LocalDatabase.selectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'UserName:'),
              controller: txtUserNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: isupdated == true
                    ? () async {
                        UserData obj = UserData(
                            username: txtUserNameController.text,
                            id: selectedId);
                        await LocalDatabase.updateData(obj);
                        futureUserData = LocalDatabase.selectData();
                      }
                    : () async {
                        await LocalDatabase.insertData(
                            UserData(username: txtUserNameController.text));
                        futureUserData = LocalDatabase.selectData();
                        setState(() {});
                      },
                child: Text(isupdated == true ? 'update' : 'Submit')),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: futureUserData,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          await LocalDatabase.deletData(
                              snapshot.data![index].id!);
                          futureUserData = LocalDatabase.selectData();
                          setState(() {});
                        },
                        child: ListTile(
                          title: Text(snapshot.data![index].username),
                          onTap: () {
                            txtUserNameController.text =
                                snapshot.data![index].username;
                            selectedId = snapshot.data![index].id!;
                            isupdated == true;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Text('Threre is no Data');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
