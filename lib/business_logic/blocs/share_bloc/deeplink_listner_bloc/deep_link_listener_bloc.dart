import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:uni_links/uni_links.dart';

part 'deep_link_listener_event.dart';
part 'deep_link_listener_state.dart';

class DeepLinkListenerBloc
    extends Bloc<DeepLinkListenerEvent, DeepLinkListenerState> {
  DeepLinkListenerBloc() : super(DeepLinkListenerInitial()) {
    streamSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.host != 'yenepay') {
          print("share =>  uriLinkStream ${isValidateHttpUri(uri)}");
          if (isValidateUri(uri)) {
            this.add(
              SetDeepLinkListenerOpenEvent(
                appShareTypes: getUriShareType(uri),
                itemId: getUriItemId(uri),
              ),
            );
          } else if (isValidateHttpUri(uri)) {
            this.add(
              SetDeepLinkListenerOpenEvent(
                appShareTypes: getUriShareType(uri),
                itemId: getHttpUriItemId(uri),
              ),
            );
          } else {
            this.add(
              SetDeepLinkListenerErrorEvent(
                error: "INVALID FORMAT",
              ),
            );
          }
        }
      } else {
        this.add(
          SetDeepLinkListenerErrorEvent(
            error: "URI IS NULL",
          ),
        );
      }
    }, onError: (err) {
      this.add(
        SetDeepLinkListenerErrorEvent(
          error: err.toString(),
        ),
      );
    });
  }

  late StreamSubscription streamSubscription;

  @override
  Stream<DeepLinkListenerState> mapEventToState(
    DeepLinkListenerEvent event,
  ) async* {
    if (event is StartDeepLinkListenerEvent) {
      ///FIRST CHECK getInitialUri ONLY ON APP START
      Uri? initialUri = await getInitialUri();
      print("share =>  getInitialUri ${initialUri}");
      if (initialUri != null) {
        ///CHECK IF LINK IS DEEPLINK
        if (isValidateUri(initialUri)) {
          yield DeepLinkOpenState(
            appShareTypes: getUriShareType(initialUri),
            itemId: getUriItemId(initialUri),
          );
        } else {
          ///CHECK IF LINK IS HTP URL
          if (isValidateHttpUri(initialUri)) {
            yield DeepLinkOpenState(
              appShareTypes: getUriShareType(initialUri),
              itemId: getHttpUriItemId(initialUri),
            );
          } else {
            yield DeepLinkErrorState(error: 'INVALID FORMAT');
          }
        }
      } else {
        yield DeepLinkListenerStartedState();
      }
    }
    if (event is SetDeepLinkListenerErrorEvent) {
      yield DeepLinkErrorState(error: event.error);
    }
    if (event is SetDeepLinkListenerOpenEvent) {
      yield DeepLinkOpenState(
        appShareTypes: event.appShareTypes,
        itemId: event.itemId,
      );
    }
  }

  bool isValidateUri(Uri uri) {
    bool isValidateUri = true;

    ///CHECK IF HAS SCHEMA AND QUERY PARAMS
    //if (!uri.hasScheme) isValidateUri = false;
    if (!uri.hasQuery) isValidateUri = false;

    ///CHECK IF TYPE AND ITEM ID EXIST
    if (uri.queryParameters['type'] == null) {
      isValidateUri = false;
    } else {
      ///GET TYPE
      String type = uri.queryParameters['type']!;

      ///CHEK IF TYPE IS VALID
      if (!(type == 'album' ||
          type == 'playlist' ||
          type == 'artist' ||
          type == 'song')) isValidateUri = false;
    }
    if (uri.queryParameters['item_id'] == null) {
      isValidateUri = false;
    } else {
      ///GET ITEM ID
      String itemId = uri.queryParameters['item_id']!;

      ///CHECK ITEM ID IS VALID
      try {
        int.parse(itemId);
      } catch (e) {
        isValidateUri = false;
      }
    }

    return isValidateUri;
  }

  bool isValidateHttpUri(Uri uri) {
    bool isValidateUri = true;

    ///CHECK IF HAS SCHEMA AND QUERY PARAMS
    //if (!uri.hasScheme) isValidateUri = false;
    if (!uri.hasQuery) isValidateUri = false;

    ///CHECK IF TYPE AND ITEM ID EXIST
    if (uri.queryParameters['type'] == null) {
      isValidateUri = false;
    } else {
      ///GET TYPE
      String type = uri.queryParameters['type']!;

      ///CHEK IF TYPE IS VALID
      if (!(type == 'album' ||
          type == 'playlist' ||
          type == 'artist' ||
          type == 'song')) isValidateUri = false;
    }
    if (uri.queryParameters['id'] == null) {
      isValidateUri = false;
    } else {
      ///GET ITEM ID
      String itemId = uri.queryParameters['id']!;

      ///CHECK ITEM ID IS VALID
      try {
        int.parse(AppApi.fromBase64(itemId));
      } catch (e) {
        isValidateUri = false;
      }
    }

    return isValidateUri;
  }

  AppShareTypes getUriShareType(Uri uri) {
    String type = uri.queryParameters['type']!;
    AppShareTypes appShareTypes = AppShareTypes.OTHER;
    if (type == 'album') {
      appShareTypes = AppShareTypes.ALBUM;
    }
    if (type == 'playlist') {
      appShareTypes = AppShareTypes.PLAYLIST;
    }
    if (type == 'artist') {
      appShareTypes = AppShareTypes.ARTIST;
    }
    if (type == 'song') {
      appShareTypes = AppShareTypes.SONG;
    }
    return appShareTypes;
  }

  int getUriItemId(Uri uri) {
    return int.parse(uri.queryParameters['item_id']!);
  }

  int getHttpUriItemId(Uri uri) {
    return int.parse(AppApi.fromBase64(uri.queryParameters['id']!));
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
