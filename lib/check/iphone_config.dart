/// Phone 相关配置
class IPhoneConfig {
  /// 获取手机型号
  static String phoneModel(String model) {
    return iphoneList[model] ?? model;
  }

  static Map<String, String> iphoneList = <String, String>{
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
    'iPhone17,1': 'iPhone 16 Pro',
    'iPhone17,2': 'iPhone 16 Pro Max',
    'iPhone17,3': 'iPhone 16',
    'iPhone17,4': 'iPhone 16 Plus',
    'iPhone17,5': 'iPhone 16E',
    'iPhone18,1': 'iPhone 17 Pro',
    'iPhone18,2': 'iPhone 17 Pro Max',
    'iPhone18,3': 'iPhone 17',
    'iPhone18,4': 'iPhone Air',
  };

  ///  iPad 型号类别
  static Map<String, String> ipad = <String, String>{
    // Original iPad
    'iPad1,1': 'iPad (1st generation)',
    // iPad 2
    'iPad2,1': 'iPad 2 (Wi-Fi)',
    'iPad2,2': 'iPad 2 (GSM)',
    'iPad2,3': 'iPad 2 (CDMA)',
    'iPad2,4': 'iPad 2 (Rev A)',
    // iPad (3rd generation)
    'iPad3,1': 'iPad (3rd generation) Wi-Fi',
    'iPad3,2': 'iPad (3rd generation) CDMA',
    'iPad3,3': 'iPad (3rd generation) GSM',
    // iPad (4th generation)
    'iPad3,4': 'iPad (4th generation) Wi-Fi',
    'iPad3,5': 'iPad (4th generation) GSM',
    'iPad3,6': 'iPad (4th generation) Global',
    // iPad Air (1st)
    'iPad4,1': 'iPad Air (Wi-Fi)',
    'iPad4,2': 'iPad Air (Cellular)',
    'iPad4,3': 'iPad Air (China)',
    // iPad Air 2
    'iPad5,3': 'iPad Air 2 (Wi-Fi)',
    'iPad5,4': 'iPad Air 2 (Cellular)',
    // iPad (5th gen)
    'iPad6,11': 'iPad (5th generation) Wi-Fi',
    'iPad6,12': 'iPad (5th generation) Cellular',
    // iPad (6th gen)
    'iPad7,5': 'iPad (6th generation) Wi-Fi',
    'iPad7,6': 'iPad (6th generation) Cellular',
    // iPad (7th gen)
    'iPad7,11': 'iPad (7th generation) Wi-Fi',
    'iPad7,12': 'iPad (7th generation) Cellular',
    // iPad (8th gen)
    'iPad11,6': 'iPad (8th generation) Wi-Fi',
    'iPad11,7': 'iPad (8th generation) Cellular',
    // iPad (9th gen)
    'iPad12,1': 'iPad (9th generation) Wi-Fi',
    'iPad12,2': 'iPad (9th generation) Cellular',
    // iPad (10th gen)
    'iPad13,18': 'iPad (10th generation) Wi-Fi',
    'iPad13,19': 'iPad (10th generation) Cellular',
    // iPad mini
    'iPad2,5': 'iPad mini (Wi-Fi)',
    'iPad2,6': 'iPad mini (GSM)',
    'iPad2,7': 'iPad mini (CDMA)',
    // iPad mini 2
    'iPad4,4': 'iPad mini 2 (Wi-Fi)',
    'iPad4,5': 'iPad mini 2 (Cellular)',
    'iPad4,6': 'iPad mini 2 (China)',
    // iPad mini 3
    'iPad4,7': 'iPad mini 3 (Wi-Fi)',
    'iPad4,8': 'iPad mini 3 (Cellular)',
    'iPad4,9': 'iPad mini 3 (China)',
    // iPad mini 4
    'iPad5,1': 'iPad mini 4 (Wi-Fi)',
    'iPad5,2': 'iPad mini 4 (Cellular)',
    // iPad mini (5th gen)
    'iPad11,1': 'iPad mini (5th generation) Wi-Fi',
    'iPad11,2': 'iPad mini (5th generation) Cellular',
    // iPad mini (6th gen)
    'iPad14,1': 'iPad mini (6th generation) Wi-Fi',
    'iPad14,2': 'iPad mini (6th generation) Cellular',
    // iPad Pro 9.7"
    'iPad6,3': 'iPad Pro 9.7" (Wi-Fi)',
    'iPad6,4': 'iPad Pro 9.7" (Cellular)',
    // iPad Pro 12.9" (1st gen)
    'iPad6,7': 'iPad Pro 12.9" (Wi-Fi)',
    'iPad6,8': 'iPad Pro 12.9" (Cellular)',
    // iPad Pro 10.5"
    'iPad7,3': 'iPad Pro 10.5" (Wi-Fi)',
    'iPad7,4': 'iPad Pro 10.5" (Cellular)',
    // iPad Pro 12.9" (2nd gen)
    'iPad7,1': 'iPad Pro 12.9" (2nd generation) Wi-Fi',
    'iPad7,2': 'iPad Pro 12.9" (2nd generation) Cellular',
    // iPad Pro 11" (1st gen)
    'iPad8,1': 'iPad Pro 11" (Wi-Fi)',
    'iPad8,2': 'iPad Pro 11" (Wi-Fi, 1TB)',
    'iPad8,3': 'iPad Pro 11" (Cellular)',
    'iPad8,4': 'iPad Pro 11" (Cellular, 1TB)',
    // iPad Pro 12.9" (3rd gen)
    'iPad8,5': 'iPad Pro 12.9" (Wi-Fi)',
    'iPad8,6': 'iPad Pro 12.9" (Wi-Fi, 1TB)',
    'iPad8,7': 'iPad Pro 12.9" (Cellular)',
    'iPad8,8': 'iPad Pro 12.9" (Cellular, 1TB)',
    // iPad Pro 11" (2nd gen)
    'iPad8,9': 'iPad Pro 11" (2nd generation) Wi-Fi',
    'iPad8,10': 'iPad Pro 11" (2nd generation) Cellular',
    // iPad Pro 12.9" (4th gen)
    'iPad8,11': 'iPad Pro 12.9" (4th generation) Wi-Fi',
    'iPad8,12': 'iPad Pro 12.9" (4th generation) Cellular',
    // iPad Pro (M1, 2021)
    'iPad13,4': 'iPad Pro 11" (3rd generation) Wi-Fi',
    'iPad13,5': 'iPad Pro 11" (3rd generation) Cellular',
    'iPad13,6': 'iPad Pro 11" (3rd generation) Wi-Fi+Cellular',
    'iPad13,7': 'iPad Pro 11" (3rd generation) Cellular (Intl)',
    'iPad13,8': 'iPad Pro 12.9" (5th generation) Wi-Fi',
    'iPad13,9': 'iPad Pro 12.9" (5th generation) Cellular',
    'iPad13,10': 'iPad Pro 12.9" (5th generation) Wi-Fi+Cellular',
    'iPad13,11': 'iPad Pro 12.9" (5th generation) Cellular (Intl)',
    // iPad Pro (M2, 2022)
    'iPad14,3': 'iPad Pro 11" (4th generation) Wi-Fi',
    'iPad14,4': 'iPad Pro 11" (4th generation) Cellular',
    'iPad14,5': 'iPad Pro 12.9" (6th generation) Wi-Fi',
    'iPad14,6': 'iPad Pro 12.9" (6th generation) Cellular',
    // iPad Air (3rd gen)
    'iPad11,3': 'iPad Air (3rd generation) Wi-Fi',
    'iPad11,4': 'iPad Air (3rd generation) Cellular',
    // iPad Air (4th gen)
    'iPad13,1': 'iPad Air (4th generation) Wi-Fi',
    'iPad13,2': 'iPad Air (4th generation) Cellular',
    // iPad Air (5th gen, M1)
    'iPad13,16': 'iPad Air (5th generation) Wi-Fi',
    'iPad13,17': 'iPad Air (5th generation) Cellular',
    // iPad Air (6th gen, M2, 2024)
    'iPad14,8': 'iPad Air (6th generation) 11" Wi-Fi',
    'iPad14,9': 'iPad Air (6th generation) 11" Cellular',
    'iPad14,10': 'iPad Air (6th generation) 13" Wi-Fi',
    'iPad14,11': 'iPad Air (6th generation) 13" Cellular',
    // iPad Pro (M4, 2024)
    'iPad16,3': 'iPad Pro 11" (M4, 2024) Wi-Fi',
    'iPad16,4': 'iPad Pro 11" (M4, 2024) Cellular',
    'iPad16,5': 'iPad Pro 13" (M4, 2024) Wi-Fi',
    'iPad16,6': 'iPad Pro 13" (M4, 2024) Cellular',
  };
}
