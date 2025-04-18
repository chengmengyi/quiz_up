import 'package:get_storage/get_storage.dart';
import 'package:quiz_up/utils/storage/storage_name.dart';


StorageEvent<bool> firstClickBubble = StorageEvent<bool>(key: StorageName.firstClickBubble, defaultValue: true);
StorageEvent<bool> alreadyShowComment = StorageEvent<bool>(key: StorageName.alreadyShowComment, defaultValue: false);
StorageEvent<bool> localCheckResult = StorageEvent<bool>(key: StorageName.localCheckResult, defaultValue: false);
StorageEvent<bool> installEvent = StorageEvent<bool>(key: StorageName.installEvent, defaultValue: false);


StorageEvent<String> todayAnswerQuizNum = StorageEvent<String>(key: StorageName.todayAnswerQuizNum, defaultValue: "");
StorageEvent<String> todayShowAdNum = StorageEvent<String>(key: StorageName.todayShowAdNum, defaultValue: "");
StorageEvent<String> todayClickAdNum = StorageEvent<String>(key: StorageName.todayClickAdNum, defaultValue: "");
StorageEvent<String> valueConfig = StorageEvent<String>(key: StorageName.valueConfig, defaultValue: "");
StorageEvent<String> adConfig = StorageEvent<String>(key: StorageName.adConfig, defaultValue: "");
StorageEvent<String> appsflyerResult = StorageEvent<String>(key: StorageName.appsflyerResult, defaultValue: "");

StorageEvent<int> lastMoneyLevel = StorageEvent<int>(key: StorageName.lastMoneyLevel, defaultValue: 0);
StorageEvent<int> watchAdNum = StorageEvent<int>(key: StorageName.watchAdNum, defaultValue: 0);
StorageEvent<int> lastAdLevel = StorageEvent<int>(key: StorageName.lastAdLevel, defaultValue: 0);
StorageEvent<int> selectedCashType = StorageEvent<int>(key: StorageName.selectedCashType, defaultValue: 0);

StorageEvent<List<double>> h5Ecpm = StorageEvent<List<double>>(key: StorageName.h5Ecpm, defaultValue: []);




final GetStorage _storage=GetStorage();

class StorageEvent<T>{
  String key;
  T defaultValue;
  StorageEvent({
    required this.key,
    required this.defaultValue,
});

  save(T value){
    _storage.write(key, value);
  }

  T get()=>_storage.read(key)??defaultValue;

  remove(){
    _storage.remove(key);
  }
}