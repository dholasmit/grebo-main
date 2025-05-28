import 'package:flutter_keychain/flutter_keychain.dart';

putKeyChain({required String? name, required String? email}) async {
  await FlutterKeychain.put(key: "com.example.grebo-email", value: email ?? "");
  await FlutterKeychain.put(key: "com.example.grebo-name", value: name ?? "");
}

Future<Map<String, dynamic>?> getKeyChain() async {
  var email = await FlutterKeychain.get(key: "com.example.grebo-email");
  var name = await FlutterKeychain.get(key: "com.example.grebo-name");
  if (email == null && name == null) {
    return null;
  } else {
    return {"name": name ?? "", "email": email ?? ""};
  }
}
