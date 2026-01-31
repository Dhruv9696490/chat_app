import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repository/auth_repository_imple.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:chat_app/features/users/data/dataSource/user_remote_data_source.dart';
import 'package:chat_app/features/users/data/repository/users_repository_imple.dart';
import 'package:chat_app/features/users/domain/repository/users_repository.dart';
import 'package:chat_app/features/users/domain/useCase/get_all_user.dart';
import 'package:chat_app/features/auth/domain/usecase/get_current_user.dart';
import 'package:chat_app/features/auth/domain/usecase/signout.dart';
import 'package:chat_app/features/auth/domain/usecase/user_login.dart';
import 'package:chat_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/users/presentation/bloc/bloc/users_bloc.dart';
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

Future<void> init() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Auth Feature
  getIt.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImple(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImple(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );
  getIt.registerFactory(() => UserSignUp(getIt<AuthRepository>()));
  getIt.registerFactory(() => UserLogin(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignOut(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CurrentUserCubit());
  getIt.registerLazySingleton(
    () => AuthBloc(
      userSignUp: getIt<UserSignUp>(),
      userLogin: getIt<UserLogin>(),
      signOut: getIt<SignOut>(),
      isUserSignUp: getIt<GetCurrentUser>(),
      currentUserCubit: getIt<CurrentUserCubit>(),
    ),
  );

  // Chat Feature
  getIt.registerFactory<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerFactory<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );
  getIt.registerFactory(() => SendMessage(getIt<ChatRepository>()));
  getIt.registerFactory(() => GetMessages(getIt<ChatRepository>()));
  getIt.registerLazySingleton(
    () => ChatBloc(
      sendMessage: getIt<SendMessage>(),
      getMessages: getIt<GetMessages>(),
    ),
  );

  // Users Feature'

  getIt.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSourceImple(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerFactory<UsersRepository>(
    () => UsersRepositoryImple(
      userRemoteDataSource: getIt<UserRemoteDataSource>(),
    ),
  );
  getIt.registerFactory(() => GetAllUser(getIt<UsersRepository>()));
  getIt.registerLazySingleton(()=> UsersBloc(getAllUser: getIt<GetAllUser>()) );
}
