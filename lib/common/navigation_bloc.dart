import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/constants/route_names.dart';

abstract class NavigatorAction extends Equatable {
  NavigatorAction();
}

class NavigatorActionPop extends NavigatorAction {
  NavigatorActionPop();
}

class NavigateToHomeEvent extends NavigatorAction {
  NavigateToHomeEvent();
}

class NavigateToProfileEvent extends NavigatorAction {
  NavigateToProfileEvent();
}

class NavigatorBloc extends Bloc<NavigatorAction, dynamic>{

  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorAction event) async* {
    if(event is NavigatorActionPop){
      navigatorKey.currentState.pop();

    }else if(event is NavigateToHomeEvent){
      navigatorKey.currentState.pushNamed(LoginViewRoute);

    }
  }
}