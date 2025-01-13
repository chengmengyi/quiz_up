import 'package:get_storage/get_storage.dart';
import 'package:quiz_up/utils/storage/storage_name.dart';


StorageEvent<String> valueStr = StorageEvent<String>(key: StorageName.valueStr, defaultValue: "");


StorageEvent<bool> firstClickBubble = StorageEvent<bool>(key: StorageName.firstClickBubble, defaultValue: true);




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
}