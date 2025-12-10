import 'package:finful_app/core/constant/model_constant.dart';
import 'package:finful_app/core/entity/entity.dart';

class SectionPayloadOptionResponse extends BaseEntity {
  final String? label;
  final dynamic value;
  final int? order;
  final String? title; // assumptions
  final String? sub; // assumptions
  final String? targetReturn; // assumptions
  final String? description; // assumptions
  final int? minReturn; // assumptions
  final int? maxReturn; // assumptions
  final int? returnRate; // assumptions

  SectionPayloadOptionResponse({
    this.label,
    this.value,
    this.order,
    this.title,
    this.sub,
    this.targetReturn,
    this.description,
    this.minReturn,
    this.maxReturn,
    this.returnRate,
  });

  factory SectionPayloadOptionResponse.fromJson(Map<String, dynamic> json) {
    return SectionPayloadOptionResponse(
      label: json['label'] ?? kString,
      value: json['value'],
      order: json['order'] ?? kInt,
      title: json['title'] ?? kString,
      sub: json['sub'] ?? kString,
      targetReturn: json['targetReturn'] ?? kString,
      description: json['description'] ?? kString,
      minReturn: json['minReturn'] ?? kInt,
      maxReturn: json['maxReturn'] ?? kInt,
      returnRate: json['returnRate'] ?? kInt,
    );
  }

  @override
  List<Object?> get props => [
    label,
    value,
    order,
    title,
    sub,
    targetReturn,
    description,
    minReturn,
    maxReturn,
    returnRate,
  ];

  @override
  Map<String, dynamic>? toJson() {
    return null;
  }
}

// assumptions
class SectionPayloadExplanationResponse extends BaseEntity {
  final String? sub;
  final String? main;

  SectionPayloadExplanationResponse({
    this.sub,
    this.main,
  });

  factory SectionPayloadExplanationResponse.fromJson(Map<String, dynamic> json) {
    return SectionPayloadExplanationResponse(
      sub: json['sub'] ?? kString,
      main: json['main'] ?? kString,
    );
  }

  @override
  List<Object?> get props => [
    sub,
    main,
  ];

  @override
  Map<String, dynamic>? toJson() {
    return null;
  }
}

// assumptions - "chartDataKey": "pctInvestmentReturn"
class SectionPayloadColorRangesResponse extends BaseEntity {
  final int? min;
  final int? max;
  final String? color;
  final bool? isLast;

  SectionPayloadColorRangesResponse({
    this.min,
    this.max,
    this.color,
    this.isLast,
  });

  factory SectionPayloadColorRangesResponse.fromJson(Map<String, dynamic> json) {
    return SectionPayloadColorRangesResponse(
      min: json['min'] ?? kString,
      max: json['max'] ?? kString,
      color: json['color'] ?? kString,
      isLast: json['isLast'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    min,
    max,
    color,
    isLast,
  ];

  @override
  Map<String, dynamic>? toJson() {
    return null;
  }
}

class SectionPayloadResponse extends BaseEntity {
  final String? key;
  final String? text;
  final String? questionType;
  final List<SectionPayloadOptionResponse>? options;
  final String? unit;
  final String? title; // education (questionType) / assumptions
  final String? summary; // education (questionType)
  final String? image; // education (questionType)
  final Map<String, dynamic>? points; // education (questionType)
  final String? ctaText; // education (questionType)
  final String? chartDataKey; // assumptions
  final String? name; // assumptions
  final String? label; // assumptions
  final List<SectionPayloadExplanationResponse>? explanations; // assumptions
  final int? min; // assumptions
  final int? max; // assumptions
  final int? defaultValue; // assumptions charts
  final String? step; // assumptions
  final String? suffix; // assumptions
  final bool? isCustom; // assumptions - "chartDataKey": "pctInvestmentReturn"
  final List<SectionPayloadColorRangesResponse>? colorRanges;

  SectionPayloadResponse({
    this.key,
    this.text,
    this.questionType,
    this.options,
    this.unit,
    this.title,
    this.summary,
    this.image,
    this.points,
    this.ctaText,
    this.chartDataKey,
    this.name,
    this.label,
    this.explanations,
    this.min,
    this.max,
    this.defaultValue,
    this.step,
    this.suffix,
    this.isCustom,
    this.colorRanges,
  });

  factory SectionPayloadResponse.fromJson(Map<String, dynamic> json) {
    final jsonOptions = json['options'];
    final mapJsonOptions = jsonOptions != null &&
        jsonOptions is List &&
        jsonOptions.isNotEmpty
        ? List<Map<String, dynamic>>.from(jsonOptions)
        : null;
    final options = mapJsonOptions?.map(SectionPayloadOptionResponse.fromJson)
        .toList();
    final jsonExplanations = json['explanations'];
    final mapJsonExplanations = jsonExplanations != null &&
        jsonExplanations is List &&
        jsonExplanations.isNotEmpty
        ? List<Map<String, dynamic>>.from(jsonExplanations)
        : null;
    final explanations = mapJsonExplanations?.map(SectionPayloadExplanationResponse.fromJson)
        .toList();
    final jsonColorRanges = json['colorRanges'];
    final mapJsonColorRanges = jsonColorRanges != null &&
        jsonColorRanges is List &&
        jsonColorRanges.isNotEmpty
        ? List<Map<String, dynamic>>.from(jsonColorRanges)
        : null;
    final colorRanges = mapJsonColorRanges?.map(SectionPayloadColorRangesResponse.fromJson)
        .toList();
    final step = json['step'] != null ? json['step'].toString() : kString;

    return SectionPayloadResponse(
      key: json['key'] ?? kString,
      text: json['text'] ?? kString,
      questionType: json['type'] ?? kString,
      options: options,
      unit: json['unit'] ?? kString,
      title: json['title'] ?? kString,
      summary: json['summary'] ?? kString,
      image: json['image'] ?? kString,
      points: json['points'],
      ctaText: json['ctaText'] ?? kString,
      chartDataKey: json['chartDataKey'] ?? kString,
      name: json['name'] ?? kString,
      label: json['label'] ?? kString,
      explanations: explanations,
      min: json['min'] ?? kInt,
      max: json['max'] ?? kInt,
      defaultValue: json['defaultValue'] ?? kInt,
      step: step,
      suffix: json['suffix'] ?? kString,
      isCustom: json['isCustom'] ?? false,
      colorRanges: colorRanges,
    );
  }

  @override
  List<Object?> get props => [
    key,
    text,
    questionType,
    options,
    unit,
    title,
    summary,
    image,
    points,
    ctaText,
    chartDataKey,
    name,
    label,
    explanations,
    min,
    max,
    step,
    suffix,
    isCustom,
    colorRanges,
  ];

  @override
  Map<String, dynamic>? toJson() {
    return null;
  }
}

class SectionResponse extends BaseEntity {
  final int? currentStep;
  final int? totalStep;
  final String? stepType;
  final String? status;
  final SectionPayloadResponse? payload;
  final String? message;

  SectionResponse({
    this.currentStep,
    this.totalStep,
    this.stepType,
    this.status,
    this.payload,
    this.message,
  });

  factory SectionResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] != null
        ? SectionPayloadResponse.fromJson(json['payload']) : null;
    return SectionResponse(
      currentStep: json['currentStep'] ?? kInt,
      totalStep: json['totalStep'] ?? kInt,
      stepType: json['stepType'] ?? kString,
      status: json['status'] ?? kString,
      payload: payload,
      message: json['message'] ?? kString,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    totalStep,
    stepType,
    status,
    payload,
  ];

  @override
  Map<String, dynamic>? toJson() {
    return null;
  }
}