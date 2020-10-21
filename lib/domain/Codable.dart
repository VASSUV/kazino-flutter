
import 'dart:collection';

abstract class Codable {
  final dynamic _data;

  Map toJson() => _data is Map ? _data : _data is LinkedHashMap ? _data : Map();

  const Codable(this._data);

  T get<T>(String key) {
    if (_data is Map) {
      Object value = _data[key];
      return value is T ? value : null;
    }
    return null;
  }

  void put<T>(String key, T value) {
    if (_data is Map) {
      Map data = _data;
      data[key] = value;
    }
  }

  T codable<T>(List<String> keys, T create(dynamic)) {
    if (_data is LinkedHashMap) {
      Map map = _data;
      Object value;

      for (int i = 0; i < keys.length; i++) {
        value = map[keys[i]];
        if (value is Map) {
          map = value;
        }
      }
      return value != null ? create(value) : null;
    }
    return null;
  }

  List<T> array<T>(List<String> keys, T create(dynamic)) {
    if (_data is Map) {
      Map map = _data;
      Object value;
      for (int i = 0; i < keys.length; i++) {
        value = map[keys[i]];
        if (value is Map) {
          map = value;
        }
      }
      return value == null ? null : CodableArray.from(value, create);
    }
    return null;
  }

  @override
  String toString() => _data.toString();
}

class CodableArray {
  static List<T> from<T>(dynamic data, T mapFunc(dynamic)) {
    var isList = data is Iterable;
    if(isList) {
      var value = (data as List);
      var mappedValue = value.map(mapFunc);
      return mappedValue.toList();
    } else return List();
  }
}