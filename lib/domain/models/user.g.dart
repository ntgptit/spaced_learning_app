// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'displayName': instance.displayName,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'createdAt': instance.createdAt?.toIso8601String(),
  'roles': instance.roles,
};
