import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String duration;
  final int xpReward;
  final IconData icon;
  final Color color;
  double progress; // Calculated dynamically at runtime

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.xpReward,
    required this.icon,
    required this.color,
    this.progress = 0.0,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      xpReward: json['xp_reward'],
      icon: IconData(json['icon_codepoint'], fontFamily: 'MaterialIcons'),
      color: Color(int.parse(json['color_hex'])),
    );
  }
}

class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String subtitle;
  final int chapterNumber;
  final String? content;
  bool isCompleted;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.subtitle,
    required this.chapterNumber,
    this.content,
    this.isCompleted = false,
  });

  factory LessonModel.fromJson(
    Map<String, dynamic> json,
    List<String> completedIds,
  ) {
    return LessonModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      chapterNumber: json['chapter_number'],
      content: json['content'],
      isCompleted: completedIds.contains(json['id']),
    );
  }
}

class UserProfileModel {
  final String id;
  final String fullName;
  final int xp;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.xp,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      fullName: json['full_name'] ?? 'Learner',
      xp: json['xp'] ?? 0,
    );
  }
}
