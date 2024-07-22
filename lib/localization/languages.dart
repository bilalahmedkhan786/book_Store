import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'screenName': 'Login Screen',
          'hint_email': 'Your Email Here',
          'hint_password': 'Your Password Here',
          'Sign IN': 'SIGN IN',
          'Sign UP': 'SIGN UP',
          'no account': "Can't have an account?"
        },
        'ur_PK': {
          'screenName': 'لاگ ان اسکرین',
          'hint_email': 'آپکی ای میل',
          'hint_password': 'اپکا پاس ورڈ',
          'Sign IN': 'سائن ان',
          'Sign UP': ' سائن اپ کریں',
          'no account': 'اککوٹ نہیں ہے'
        },
      };
}
