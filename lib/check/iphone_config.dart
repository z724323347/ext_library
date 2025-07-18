/// Phone 相关配置
class IPhoneConfig {
  /// 获取手机型号
  static String phoneModel(String model) {
    return iphoneList[model] ?? model;
  }

  static Map<String, String> iphoneList =<String, String>{
    ...iphone,
    ...ipad,
  };

  /// iphone 型号类别
  static Map<String, String> iphone = <String, String>{
    'iPhone3,1': 'iPhone 4',
    'iPhone3,2': 'iPhone 4',
    'iPhone3,3': 'iPhone 4',
    'iPhone4,1': 'iPhone 4S',
    'iPhone5,1': 'iPhone 5',
    'iPhone5,2': 'iPhone 5',
    'iPhone5,3': 'iPhone 5c',
    'iPhone5,4': 'iPhone 5c',
    'iPhone6,1': 'iPhone 5s',
    'iPhone6,2': 'iPhone 5s',
    'iPhone7,1': 'iPhone 6 Plus',
    'iPhone7,2': 'iPhone 6',
    'iPhone8,1': 'iPhone 6s',
    'iPhone8,2': 'iPhone 6s Plus',
    'iPhone8,4': 'iPhone SE',
    'iPhone9,1': 'iPhone 7',
    'iPhone9,2': 'iPhone 7 Plus',
    'iPhone9,3': 'iPhone 7',
    'iPhone9,4': 'iPhone 7 Plus',
    'iPhone10,1': 'iPhone 8',
    'iPhone10,2': 'iPhone 8 Plus',
    'iPhone10,4': 'iPhone 8',
    'iPhone10,5': 'iPhone 8 Plus',
    'iPhone10,3': 'iPhone X',
    'iPhone10,6': 'iPhone X',
    'iPhone11,2': 'iPhone XS',
    'iPhone11,4': 'iPhone XS Max',
    'iPhone11,6': 'iPhone XS Max',
    'iPhone11,8': 'iPhone XR',
    'iPhone12,1': 'iPhone 11',
    'iPhone12,3': 'iPhone 11 Pro',
    'iPhone12,5': 'iPhone 11 Pro Max',
    'iPhone12,8': 'iPhone SE 2',
    'iPhone13,1': 'iPhone 12 mini',
    'iPhone13,2': 'iPhone 12',
    'iPhone13,3': 'iPhone 12 Pro',
    'iPhone13,4': 'iPhone 12 Pro Max',
    'iPhone14,4': 'iPhone 13 mini',
    'iPhone14,5': 'iPhone 13',
    'iPhone14,2': 'iPhone 13 Pro',
    'iPhone14,3': 'iPhone 13 Pro Max',
    'iPhone14,6': 'iPhone SE 3',
    'iPhone14,7': 'iPhone 14',
    'iPhone14,8': 'iPhone 14 Plus',
    'iPhone15,2': 'iPhone 14 Pro',
    'iPhone15,3': 'iPhone 14 Pro Max',
    'iPhone15,4': 'iPhone 14',
    'iPhone15,5': 'iPhone 14 Plus',
    'iPhone16,1': 'iPhone 15 Pro',
    'iPhone16,2': 'iPhone 15 Pro Max',
    'iPhone16,3': 'iPhone 15',
    'iPhone16,4': 'iPhone 15 Plus',
    'iPhone17,1': 'iPhone 16',
    'iPhone17,2': 'iPhone 16 Plus',
    'iPhone17,3': 'iPhone 16 Pro',
    'iPhone17,4': 'iPhone 16 Pro Max',
    'iPhone17,5': 'iPhone 16E',
  };

  ///  iPad 型号类别
  static Map<String, String> ipad = <String, String>{

  };
}
