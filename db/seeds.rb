# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Workshop.create_product(
  name:'Üçü Bir Arada',
  saloon: 'SALON C',
  moderator: 'Prof. Dr. Belma Tuğrul',
  price: 12000,
  stock:30,
  start_at: '2017-11-4 16:00:00 +0300',
  finish_at: '2017-11-4 17:30:00 +0300'
)
Workshop.create_product(
  name:'Zihni Sinir Bilim ve Matematik Ortamı',
  saloon: 'SALON H',
  moderator: 'Dr. Burak Karabey',
  price: 12000,
  stock:20,
  start_at: '2017-11-4 16:00:00 +0300',
  finish_at: '2017-11-4 17:30:00 +0300'
)
Workshop.create_product(
  name:'Çellodan Ansiklopediye, Şapka Evinden Çocuklara',
  saloon: 'SALON H',
  moderator: 'Dr. Tülay Üstündağ',
  price: 12000,
  stock:20,
  start_at: '2017-11-5 12:00:00 +0300',
  finish_at: '2017-11-5 13:30:00 +0300'
)
Workshop.create_product(
  name:'Kendini Dönüştürebilen Zihinler İçin: Drama',
  saloon: 'SALON C',
  moderator: 'Dr. Gökçen Özbek',
  price: 12000,
  stock:26,
  start_at: '2017-11-5 12:00:00 +0300',
  finish_at: '2017-11-5 13:30:00 +0300'
)
Workshop.create_product(
  name:'STEM’li Etkinlikler',
  saloon: 'SALON E',
  moderator: 'Yrd. Doç. Dr. Özlen DEMİRCAN',
  price: 12000,
  stock:25,
  start_at: '2017-11-5 12:00:00 +0300',
  finish_at: '2017-11-5 13:30:00 +0300'
)

Workshop.create_product(
  name:'Yakınsak Düşünmeye Iraksak Yaklaşımlar',
  saloon: 'SALON C',
  moderator: 'Yrd. Doç. Dr. Serap Sevimli Çelik',
  price: 12000,
  stock:25,
  start_at: '2017-11-4 12:00:00 +0300',
  finish_at: '2017-11-4 13:30:00 +0300'
)
Workshop.create_product(
  name:'Çellodan Ansiklopediye, Şapka Evinden Çocuklara',
  saloon: 'SALON E',
  moderator: 'Dr. Tülay Üstündağ',
  price: 12000,
  stock:20,
  start_at: '2017-11-4 12:00:00 +0300',
  finish_at: '2017-11-4 13:30:00 +0300'
)
Workshop.create_product(
  name:'Öyküler Bizi Söyler…',
  saloon: 'SALON H',
  moderator: 'Prof. Dr. Gaye Teksöz',
  price: 12000,
  stock:15,
  start_at: '2017-11-4 12:00:00 +0300',
  finish_at: '2017-11-4 13:30:00 +0300'
)

Attendance.create_product(
  price: 12000,
  name:'Zeka Kongresi Katılım',
  stock:900
)
