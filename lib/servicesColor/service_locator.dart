import 'package:get_it/get_it.dart';
import 'package:personal_financial/servicesColor/storage/hive_storage_service.dart';
import 'package:personal_financial/servicesColor/storage/storage_service.dart';


final getIt = GetIt.I;

void setUpServiceLocator() {
  getIt.registerSingleton<StorageService>(HiveStorageService());
}
