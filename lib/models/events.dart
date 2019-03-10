import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'dart:convert';
import 'package:built_value/built_value.dart';

part 'events.g.dart';


abstract class Events implements Built<Events, EventsBuilder> {

  static Serializer<Events> get serializer => _$eventsSerializer;

  @nullable
  String get title;
  @nullable
  String get image;
  @nullable
  String get location;
  @nullable
  String get date;
  @nullable
  String get price;
  @nullable
  String get by;
  @nullable
  String get about;
  @nullable
  String get category;
  Events._();
  bool get isFavorite;
  factory Events([updates(EventsBuilder b)]) = _$Events;
}
/*class Events {
  final String title;
  final String image;
  final String location;
  final DateTime date;
  final String price;
  final String by;
  final String about;
  final String category;

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
    'location': location,
    'date': date,
    'price': price,
    'by': by,
    'about': about,
    'category': category,
};




  Events({this.title, this.image = '', this.date, this.location, this.price, this.by, this.about, this.category});

  Events.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        location = json['location'],
        date = json['date'],
        price = json['price'],
        by = json['by'],
        about = json['about'],
        category = json['category'];

}*/




/*
final events = [
  Events(image: 'https://picsum.photos/800/600/?random', date: DateTime.now(),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat‐5'),

  Events(image: 'https://source.unsplash.com/user/erondu/800x600', date: Timestamp.fromDate(DateTime.utc(2019,3,19,8,45,30)),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'BMW says electric car mass production not viable until 2020'),

  Events(image: 'https://source.unsplash.com/800x600/?nature,water', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Evolution Is the New Deep Learning'),

  Events(image: 'TCP Tracepoints have arrived in Linux', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'TCP Tracepoints have arrived in Linux'),

  Events(image: 'https://source.unsplash.com/800x600/?light', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Section 230: A Key Legal Shield for Facebook, Google Is About to Change'),

  Events(image: 'https://source.unsplash.com/800x600/?earth', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'A Visiting Star Jostled Our Solar System 70,000 Years Ago'),

  Events(image: 'https://source.unsplash.com/800x600/?cars', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Cow Game Extracted Facebook Data'),

  Events(image: 'https://source.unsplash.com/800x600/?technology', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Ask HN: How do you find freelance work?'),


  Events(image: 'https://source.unsplash.com/800x600/?stars', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Hedge-fund managers that do the most research will post the best returns'),

  Events(image: 'https://source.unsplash.com/800x600/?life', date: DateTime.now()),
      price: '50', by: 'Sourabh Pal', about: 'BMW says electric car mass production not viable until 2020. '
          'Section 230: A Key Legal Shield for Facebook, Google Is About to Change. A Visiting Star Jostled '
          'Our Solar System 70,000 Years Ago. Hedge-fund managers that do the most research will post the best returns',
      location: GeoPoint(0.0, 0.0), category: 'Technology', title: 'Number systems of the world, sorted by complexity of counting (2006)'),
];
*/
