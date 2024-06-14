import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PukulEnam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Section 1: Introduction
              Container(
                color: Color(0xFFF2575B),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ceritakan Tugas Anda, Kami Bantu Bagai Teman Yang Selalu Ada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Perkenalkan! Kami tim PukulEnam.AI Orang yang mengatur teknis di balik berita hangat PukulEnam Newsletter sehingga Anda tidak perlu membaca 1100 berita dari seluruh dunia. PukulEnam telah menggunakan bantuan kecerdasan buatan dan otomatisasi pada produksi dan pemeriksaan berita setiap harinya. Mengapa tidak melakukannya ke produk, usaha, atau tugas Anda?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Section 2: What We Do
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Apa Yang Kami Lakukan ?',
                      style: TextStyle(
                        color: Color(0xFFF2575B),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mengatur teknis berita memang keseharian kami. Namun kami juga senang bila dapat membantu, serta memberikan dampak. Kami dapat membantu tidak hanya proses transformasi digital, juga transformasi data sesuai dengan kebutuhan terkini. Kami dapat membantu penelitian dan pengembangan teknologi khususnya kecerdasan buatan. Selain itu, bersama dokter-dokter muda kami yang cakap dalam bidang teknologi, kami dapat melaksanakan penelitian di bidang kesehatan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        _buildFeature(
                          icon: Icons.person,
                          title: 'Konsultasi dan Tutor',
                          description:
                          'Kami dapat memberikan konsultasi tanpa dipungut biaya awal bila Anda ingin melakukan proyek atau penelitian di bidang AI dan kesehatan.',
                        ),
                        _buildFeature(
                          icon: Icons.data_usage,
                          title: 'Transformasi Digital dan Data',
                          description:
                          'Kami dapat membantu Anda untuk bermigrasi dan menyesuaikan solusi teknologi yang tepat, terlepas apakah Anda membangun UMKM atau menggunakannya sebagai individual.',
                        ),
                        _buildFeature(
                          icon: Icons.people,
                          title: 'Untuk Segala Kalangan',
                          description:
                          'Baik mahasiswa, dokter, atau siswa SMP, semuanya berhak mendapat pelayanan yang setara dan setimbang oleh ahli kami. Menyesuaikan kebutuhan Anda.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Section 3 and 4: Statistics and Contact Information
              Container(
                color: Color(0xFFF2575B),
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        _buildStatistic('60', 'Sertifikasi Nasional dan Internasional'),
                        _buildStatistic('63', 'Penghargaan Nasional dan Internasional'),
                        _buildStatistic('12', 'Negara'),
                        _buildStatistic('14', 'Talenta Muda'),
                      ],
                    ),
                    SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        _buildContactInfo(Icons.phone, '+6281338345375 (Nyoman Ayu Sintya Dewi)'),
                        _buildContactInfo(Icons.email, 'newsteam@pukulenam.id'),
                        _buildContactInfo(Icons.location_on, 'Jln. Pemuda III No 22, Denpasar, Bali, Indonesia 80226'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      children: [
                        _buildSocialIcon(FontAwesomeIcons.instagram),
                        _buildSocialIcon(FontAwesomeIcons.whatsapp),
                        _buildSocialIcon(FontAwesomeIcons.facebook),
                        _buildSocialIcon(FontAwesomeIcons.linkedin),
                      ],
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      children: [
                        _buildFooterLink('Ketentuan Pelayanan'),
                        _buildFooterLink('Kebijakan Privasi'),
                        _buildFooterLink('Server Status'),
                        _buildFooterLink('Tetap Terhubung'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '© 2024 PukulEnam Newsletter',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Powered by Amazon Web Services',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({required IconData icon, required String title, required String description}) {
    return Container(
      width: 200, // Adjust width as needed
      child: Column(
        children: [
          Icon(icon, size: 40, color: Color(0xFFF2575B)),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFF2575B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String value, String description) {
    return Container(
      width: 150, // Adjust width as needed
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String info) {
    return Container(
      width: 200, // Adjust width as needed
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 8),
          Text(
            info,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: FaIcon(icon, size: 24, color: Color(0xFFF2575B)),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 14),
    );
  }
}


