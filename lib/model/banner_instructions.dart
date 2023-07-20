part of nb_navigation_flutter;

class BannerInstructions {
  double? distanceAlongGeometry;
  Primary? primary;
  Sub? sub;

  BannerInstructions({
    this.distanceAlongGeometry,
    this.primary,
    this.sub,
  });

  factory BannerInstructions.fromJson(Map<String, dynamic> map) {
    return BannerInstructions(
      distanceAlongGeometry: map['distanceAlongGeometry'],
      primary: Primary.fromJson(map['primary'] ?? {}),
      sub: Sub.fromJson(map['sub'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceAlongGeometry': distanceAlongGeometry,
      'primary': primary?.toJson(),
      'sub': sub?.toJson(),
    };
  }
}

class Primary {
  List<Component>? components;
  double? degrees;
  String? instruction;
  String? modifier;
  String? text;
  String? type;

  Primary({
    this.components,
    this.degrees,
    this.instruction,
    this.modifier,
    this.text,
    this.type,
  });

  factory Primary.fromJson(Map<String, dynamic> map) {
    return Primary(
      components: List<Component>.from(map['components']?.map((x) => Component.fromJson(x)) ?? []),
      degrees: map['degrees'] ?? 0 ,
      instruction: map['instruction'] ?? "",
      modifier: map['modifier'] ?? "",
      text: map['text'] ?? "",
      type: map['type'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'components': List<Map>.from(components?.map((x) => x.toJson()) ?? {}),
      'degrees': degrees,
      'instruction': instruction,
      'modifier': modifier,
      'text': text,
      'type': type,
    };
  }
}

class Sub {
  List<Component>? components;
  double? degrees;
  String? modifier;
  String? text;
  String? type;

  Sub({
    this.components,
    this.degrees,
    this.modifier,
    this.text,
    this.type,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      components: List<Component>.from(json['components']?.map((x) => Component.fromJson(x)) ?? []),
      degrees: json["degrees"] ?? 0,
      modifier: json["modifier"] ?? "",
      text: json["text"] ?? "",
      type: json["type"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "components": components?.map((x) => x.toJson()).toList(),
        "degrees": degrees,
        "modifier": modifier,
        "text": text,
        "type": type,
      };
}

class Component {
  String? countryCode;
  String? text;
  String? type;

  Component({
    this.countryCode,
    this.text,
    this.type,
  });

  factory Component.fromJson(Map<String, dynamic> map) {
    return Component(
        countryCode: map['countryCode'] ?? "",
        text: map['text'] ?? "",
        type: map['type'] ?? "",
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'text': text,
      'type': type,
    };
  }
}
