

import 'package:chat_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repository/auth_repository_imple.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:chat_app/features/auth/domain/usecase/get_all_user.dart';
import 'package:chat_app/features/auth/domain/usecase/is_user_signUp.dart';
import 'package:chat_app/features/auth/domain/usecase/signout.dart';
import 'package:chat_app/features/auth/domain/usecase/user_login.dart';
import 'package:chat_app/features/auth/domain/usecase/user_signUp.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/chat/data/dataSource/chat_remote_data_source.dart';
import 'features/chat/data/repository/chat_repository_imple.dart';
import 'features/chat/domain/repository/chat_repository.dart';
import 'features/chat/domain/usecase/get_message.dart';
import 'features/chat/domain/usecase/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async{
    getIt.registerLazySingleton<FirebaseAuth>(()=> FirebaseAuth.instance);
    getIt.registerLazySingleton<FirebaseFirestore>(()=> FirebaseFirestore.instance);
    getIt.registerLazySingleton<AuthRemoteDataSource>(()=> AuthRemoteDataSourceImple(auth: getIt<FirebaseAuth>(), firestore: getIt<FirebaseFirestore>()));
    getIt.registerLazySingleton<AuthRepository>(()=> AuthRepositoryImple(getIt<AuthRemoteDataSource>()));
    getIt.registerLazySingleton(()=> UserSignUp(getIt<AuthRepository>()));
    getIt.registerLazySingleton(()=> UserLogin(getIt<AuthRepository>()));
    getIt.registerLazySingleton(()=> SignOut(getIt<AuthRepository>()));
    getIt.registerLazySingleton(()=> IsUserSignUp(getIt<AuthRepository>()));
    getIt.registerLazySingleton(()=> GetAllUser(getIt<AuthRepository>()));
    getIt.registerFactory(()=> AuthBloc(userSignUp: getIt<UserSignUp>(), userLogin: getIt<UserLogin>(), signOut: getIt<SignOut>(), isUserSignUp: getIt<IsUserSignUp>(), getAllUser:  getIt<GetAllUser>()));


    getIt.registerLazySingleton<ChatRemoteDataSource>(()=>ChatRemoteDataSourceImpl(getIt<FirebaseFirestore>()));
    getIt.registerLazySingleton<ChatRepository>(()=> ChatRepositoryImpl(getIt<ChatRemoteDataSource>()));
    getIt.registerLazySingleton(() => SendMessage(getIt<ChatRepository>()));
    getIt.registerLazySingleton(() => GetMessages(getIt<ChatRepository>()));
    getIt.registerFactory(() => ChatBloc(
        sendMessage: getIt<SendMessage>(),
        getMessages: getIt<GetMessages>(),
    ));
}