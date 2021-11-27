import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/strapi_media.dart';

class StrapiMediaModel extends StrapiMedia {
  const StrapiMediaModel({
    required name,
    required alternativeText,
    required caption,
    required width,
    required height,
    required formats,
    required size,
    required url,
  }) : super(
          name: name,
          alternativeText: alternativeText,
          caption: caption,
          width: width,
          height: height,
          formats: formats,
          size: size,
          url: url,
        );

  factory StrapiMediaModel.fromJson(Map<String, dynamic> json) =>
      StrapiMediaModel(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: FormatsModel.fromJson(json["formats"]),
        size: json["size"].toDouble(),
        url: 'https://cms.mirea.ninja' + json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": (formats as FormatsModel).toJson(),
        "size": size,
        "url": url,
      };
}

class FormatsModel extends Formats {
  const FormatsModel({
    required large,
    required small,
    required medium,
    required thumbnail,
  }) : super(
          large: large,
          small: small,
          medium: medium,
          thumbnail: thumbnail,
        );

  factory FormatsModel.fromJson(Map<String, dynamic> json) => FormatsModel(
        large: StrapiImageModel.fromJson(json["large"]),
        small: StrapiImageModel.fromJson(json["small"]),
        medium: StrapiImageModel.fromJson(json["medium"]),
        thumbnail: StrapiImageModel.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "large": (large as StrapiImageModel).toJson(),
        "small": (small as StrapiImageModel).toJson(),
        "medium": (medium as StrapiImageModel).toJson(),
        "thumbnail": (thumbnail as StrapiImageModel).toJson(),
      };
}

class StrapiImageModel extends StrapiImage {
  const StrapiImageModel({
    required url,
    required name,
    required path,
    required size,
    required width,
    required height,
  }) : super(
          url: url,
          name: name,
          path: path,
          size: size,
          width: width,
          height: height,
        );

  factory StrapiImageModel.fromRawJson(String str) =>
      StrapiImageModel.fromJson(json.decode(str));

  factory StrapiImageModel.fromJson(Map<String, dynamic> json) =>
      StrapiImageModel(
        url: 'https://cms.mirea.ninja' + json["url"],
        name: json["name"],
        path: json["path"],
        size: json["size"].toDouble(),
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "name": name,
        "path": path,
        "size": size,
        "width": width,
        "height": height,
      };
}
