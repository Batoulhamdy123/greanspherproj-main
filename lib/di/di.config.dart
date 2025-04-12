// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/api_manager/api_manager.dart' as _i1000;
import '../data/data_source/remote_data_sourse/auth_remote_data_source/login_remote_data_source/login_remote_data_source.dart'
    as _i105;
import '../data/data_source/remote_data_sourse/auth_remote_data_source/login_remote_data_source/login_remote_data_source_impl.dart'
    as _i882;
import '../data/data_source/remote_data_sourse/auth_remote_data_source/register_remote_data_source/register_remote_data_source.dart'
    as _i530;
import '../data/data_source/remote_data_sourse/auth_remote_data_source/register_remote_data_source/register_remote_data_source_impl.dart'
    as _i326;
import '../data/repository/auth_repository_impl/login_repository_impl.dart'
    as _i1018;
import '../data/repository/auth_repository_impl/register_repository_impl.dart'
    as _i79;
import '../domain/repository/LoginRepositoryContract.dart' as _i540;
import '../domain/repository/RegisterRepositoryContract.dart' as _i343;
import '../domain/use_case/LoginUseCase%20.dart' as _i655;
import '../domain/use_case/RegisterUseCase.dart' as _i734;
import '../features/auth/login/controller/cubit/logincubit_cubit.dart' as _i79;
import '../features/auth/register/controller/cubit/signupcubit_cubit.dart'
    as _i552;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i1000.ApiManager>(() => _i1000.ApiManager());
    gh.factory<_i530.RegisterRemoteDataSource>(() =>
        _i326.RegisterRemoteDataSourceImpl(
            apiManager: gh<_i1000.ApiManager>()));
    gh.factory<_i105.LoginRemoteDataSource>(() =>
        _i882.LoginRemoteDataSourceImpl(apiManager: gh<_i1000.ApiManager>()));
    gh.factory<_i343.RegisterRepositoryContract>(() =>
        _i79.RegisterRepositoryImpl(
            registerRemoteDataSource: gh<_i530.RegisterRemoteDataSource>()));
    gh.factory<_i734.RegisterUseCase>(() => _i734.RegisterUseCase(
        registerRepository: gh<_i343.RegisterRepositoryContract>()));
    gh.factory<_i552.RegisterScreenCubit>(() => _i552.RegisterScreenCubit(
        registerUseCase: gh<_i734.RegisterUseCase>()));
    gh.factory<_i540.LoginRepositoryContract>(() => _i1018.LoginRepositoryImpl(
        loginRemoteDataSource: gh<_i105.LoginRemoteDataSource>()));
    gh.factory<_i655.LoginUseCase>(() => _i655.LoginUseCase(
        loginRepository: gh<_i540.LoginRepositoryContract>()));
    gh.factory<_i79.LoginScreenCubit>(
        () => _i79.LoginScreenCubit(loginUseCase: gh<_i655.LoginUseCase>()));
    return this;
  }
}
