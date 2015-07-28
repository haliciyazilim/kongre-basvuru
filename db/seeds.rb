# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Workshop.create_product(
  name:'Üstün Yetenekli Çocuklarda Sık Görülen Psikolojik Sorunlar ve Profesyonel Yardım Uygulamaları Atölyesi',
  saloon: 'SALON B',
  moderator: 'Yrd. Doç. Dr. Mehmet Palancı',
  price: 10000,
  stock:20,
  start_at: '2015-10-24 14:30:00 +0300',
  finish_at: '2015-10-24 16:00:00 +0300'
)
Workshop.create_product(
  name:'Üstün Yetenekli Çocuklar için İlkokul ve/veya Ortaokul düzeyinde Matematikte Iraksak ve Yakınsak Problem Uygulamaları',
  saloon: 'SALON B',
  moderator: 'Dr. Burak Karabey',
  stock:20,
  price: 10000,
  start_at: '2015-10-24 16:00:00 +0300',
  finish_at: '2015-10-24 17:30:00 +0300'
)
Workshop.create_product(
  name:'Ahşap Atölyesi',
  saloon: 'SALON B',
  moderator: 'Gilika Çocuk Tasarım Atölyesi',
  stock:20,
  price: 18000,
  start_at: '2015-10-24 14:30:00 +0300',
  finish_at: '2015-10-24 17:30:00 +0300'
)
Workshop.create_product(
  name:'Erken Yaştaki Üstün Potansiyelli Çocuklara Erken Müdahale Yöntemleri ve Uygulamaları',
  saloon: 'SALON B',
  moderator: 'Gilika Çocuk Tasarım Atölyesi',
  stock:20,
  price: 10000,
  start_at: '2015-10-25 10:30:00 +0300',
  finish_at: '2015-10-25 12:00:00 +0300'
)
Workshop.create_product(
  name:'Çocuklarda Yaratıcı Hareket Yoluyla Düşünme ve Problem Çözme Becerilerini Geliştirme Atölyesi',
  saloon: 'SALON B',
  moderator: 'Gilika Çocuk Tasarım Atölyesi',
  stock:20,
  price: 10000,
  start_at: '2015-10-25 12:00:00 +0300',
  finish_at: '2015-10-25 13:30:00 +0300'
)
Workshop.create_product(
  name:'Kâğıt Atölyesi – Origami & Krigami',
  saloon: 'SALON B',
  moderator: 'Gilika Çocuk Tasarım Atölyesi',
  stock:20,
  price: 18000,
  start_at: '2015-10-25 10:30:00 +0300',
  finish_at: '2015-10-25 13:30:00 +0300'
)
Workshop.create_product(
  name:'Zekâ Oyunları ve Oyuncakları Tasarımı Atölyesi',
  saloon: 'SALON B',
  moderator: 'Gilika Çocuk Tasarım Atölyesi',
  stock:20,
  price: 10000,
  start_at: '2015-10-25 13:30:00 +0300',
  finish_at: '2015-10-25 16:30:00 +0300'
)
Attendance.create_product(
  price: 18000,
  name:'Zeka Kongresi Katılım',
  stock:900
)
