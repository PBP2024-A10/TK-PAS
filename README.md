# Ajengan Halal: Aplikasi Makanan Halal di Bali

## Anggota Kelompok
1. 2306211231 - Rafansya Daryltama Santoso
2. 2306165843 - Dandi Apriyansyah
3. 2306165673 - Anggun Sasmitha Dewi
4. 2306245560 - Salsabila Arumdapta
5. 2306230590 - Olav Dendy Christian Manullang
6. 2306165710 - Leonita Cecilia

# 📒 Latar Belakang 📒
**Bali telah menjadi tempat wisata yang mendunia**, baik untuk wisatawan lokal maupun mancanegara. Pulau yang dihuni sekitar empat juta orang (dilansir dari Dukcapil, 2024) ini memiliki aspek budaya yang beragam. Oleh karena alasan itu, **Pulau Bali wajib dikunjungi** oleh wisatawan lokal atau mancanegara yang sedang mengunjungi Indonesia.

Dengan keberagaman lokal yang melimpah, Pulau Bali tidak luput atas perhatian wisatawan Muslim. Salah satu aspek penting dalam kehidupan sehari-hari bagi umat Islam adalah memastikan kehalalan makanan yang dikonsumsi. Dengan penduduk agama nonmuslim yang **hampir mencapai 90%** (dilansir dari Dukcapil, 2024), Bali tetap memiliki banyak pilihan kuliner halal untuk memenuhi kebutuhan wisatawan Muslim. Oleh karena itu, aplikasi `Ajengan Halal` hadir untuk membantu wisatawan Muslim menikmati kuliner halal Bali.

**Aplikasi `Ajengan Halal` menampilkan rekomendasi wisata kuliner halal Pulau Bali** dengan menyeluruh. Tidak hanya **menampilkan restoran makanan halal Bali**, tetapi juga **lokasinya dan rekomendasi makanannya** beserta detail-detail pentingnya. Aplikasi ini juga memudahkan Anda yang memunyai alergi untuk **mengetahui makanan beralergen**. Anda juga akan mendapatkan informasi mengenai **tempat membeli dan peruntukan (makanan besar / kecil)** makanan tersebut. Dengan menggunakan aplikasi ini, kami berharap warga dan wisatawan Bali mendapatkan rekomendasi wisata halal terkini.

# 🥐 Manfaat 🥐
Aplikasi `Ajengan Halal` hadir dengan harapan membawa dampak positif bagi masyarakat, khususnya para wisatawan dan penduduk Bali yang sedang mencari makanan halal. Dengan aplikasi `Ajengan Halal`, kami berharap pengguna dapat dengan mudah menemukan restoran dan tempat makan halal yang terverifikasi, sehingga memberikan rasa aman dan nyaman dalam memilih makanan sesuai dengan kepercayaan mereka.

Aplikasi ini menyediakan fitur rating, rekomendasi tempat makan, kisaran harga, dan daftar souvenir yang ada di Bali. Melalui fitur ini, harapannya pengguna dapat menemukan pilihan makanan terbaik yang sesuai dengan selera dan preferensi mereka. Selain itu, pengguna juga dapat terbantu dalam memilih rekomendasi souvenir yang dapat dibeli di sekitar Bali. 

Kami juga berharap aplikasi ini dapat berkontribusi pada pengembangan sektor pariwisata Bali dengan memberikan solusi yang memudahkan wisatawan beragama Muslim. Dengan kemudahan akses informasi yang ditawarkan, diharapkan wisatawan dapat menikmati pengalaman kuliner yang lebih menyenangkan dan berkesan.

Dengan beragam fitur yang tersedia, harapannya aplikasi ini dapat memudahkan pengguna dan mendorong penggunaan teknologi dalam kehidupan sehari-hari, yang pada akhirnya akan meningkatkan kenyamanan dalam mencari makanan halal di Bali.

# 📚 Daftar Modul 📚
**i. Authentication** 

Authentication merupakan tahap memvalidasi akun milik user. Authentication meliputi _login_, _logout_, dan _sign-in._ Pada tahapan awal, user akan diminta untuk _sign-in_ dengan membentuk username dan password. Terdapat _constraint_ yang harus dipenuhi dalam pembuatan password, yakni minimal terdiri atas 6 karakter dan merupakan kombinasi huruf besar, huruf kecil, dan juga simbol/angka.

**ii. Home Page** 

Home Page merupakan tampilan awal dari situs website yang diakses user setelah _login_. Home Page berisikan _navigation bar_ serta menampilkan daftar restoran yang menjual makanan halal. Selain itu, _home page_ berisi fitur *search* di mana user dapat mencari nama restoran dan nama makanan yang diinginkan

**iii. Profile** 

Modul Profile memungkinkan user untuk mengelola informasi pribadi mereka. User dapat melihat dan mengedit data profil seperti nama, foto profile, serta alamat email. Profile juga memungkinkan user untuk melihat riwayat pemesanan dan ulasan yang pernah mereka buat.

**iv. Manajemen Makanan** 

Manajemen makanan menyediakan berbagai informasi terkait restoran dan makanan halal yang tersedia dalam bentuk _cards_. Manajemen makanan melibatkan dua pihak, yakni Admin dan User.
Admin:
- Dapat menambahkan informasi restoran yang terdiri dari nama, gambar, *review*, dan lokasi restoran.
- Dapat menghapus informasi mengenai restoran.
  
User:
- *User* dapat melihat nama, gambar, lokasi, dan *review* makanan. (READ)
- *User* dapat melihat *card* makanan, dengan rincian:
  - *User* dapat melihat nama dan gambar makanan halal *card* informasi.
  - *User* dapat membaca deskripsi makanan.
  - *User* dapat mengetahui kategori makanan (berupa makanan yang cocok untuk breakfast/lunch/dinner) pada *card* informasi.
  - *User* dapat melihat informasi mengenai kisaran harga makanan pada *card* informasi.
  - *User* dapat membaca ulasan tentang makanan yang tersedia pada *card* informasi.
  - *User* dapat memasukkan makanan ke dalam *wishlist page*.

**iv. *Wishlist page*** 

*Wishlist page* memungkinkan user untuk menyimpan makanan favorit mereka untuk dilihat di kemudian hari. Fitur ini memudahkan user dalam menyusun daftar makanan yang ingin dicoba atau restoran yang ingin dikunjungi. Pada modul ini, user dapat menambahkan makanan ke dalam *wishlist* page, menghapus makanan dari *wishlist* page, dan mengedit makanan dari *wishlist page*

**v. Manajemen Pemesanan** 

Manajemen pemesanan menyediakan informasi mengenai seluruh proses pemesanan makanan. Terdapat dua pihak yang terlibat dalam modul ini, yakni Admin dan User. Pada modul ini, user dapat memilih makanan, menambahkan ke keranjang, dan melacak status pesanan mereka, termasuk pemesanan yang sedang berjalan dan riwayat pesanan yang telah selesai. Admin dapat mengatur pemesanan yang dilakukan user, dan melakukan otomatisasi apabila user belum mengonfirmasi menerima pesanan sampai waktu yang telah ditentukan.

**vi. Manajemen Oleh-oleh** 

Manajemen oleh-oleh menyediakan informasi mengenai oleh-oleh yang dapat dibeli di Bali. 
Modul ini memberikan informasi tentang apa saja jenis souvenir yang tersedia di Bali kepada User. Terdapat dua pihak yang terlibat dalam modul ini, yakni Admin dan User. User dapat melihat oleh-oleh yang dapat dibeli di daerah Bali. Admin dapat menambahkan informasi mengenai oleh-oleh, meliputi nama, gambar, dan deskripsi.

**vii. *Editor's Choice*** 

*Editor's Choice* menampilkan rekomendasi makanan dan restoran terbaik berdasarkan *rating* dan *review* user. User dapat menemukan pilihan makanan atau restoran yang sedang populer atau memiliki ulasan terbaik. Pada modul ini, user juga dapat menambahkan *review* dan *rating* makanan yang tertera.


# 📖 Sumber Initial Dataset 📖
Kami mengumpulkan *dataset* secara *manual*, yang dapat diakses pada tautan berikut:

https://ristek.link/DatasetPBPA10

# 🎭 Role Pengguna 🎭
**1. Admin**

Admin memiliki kontrol penuh terhadap aplikasi dan dapat mengelola pengguna, konten, pengaturan sistem, serta keamanan aplikasi. 

**2. *Non-registered User***

*Non-registered user* hanya dapat mengakses *home page*, melihat *card* makanan, editor's choice, dan melihat oleh-oleh. Beberapa fitur tidak dapat diakses, seperti melakukan pemesanan, menyimpan makanan favorit pada *Wishlist page*, dan memberikan penilaian makanan.

**3. *Registered User***

*Registered user* dapat mengakses semua halaman dan fitur yang ada dalam aplikasi, seperti melakukan pemesanan, menambahkan dan mengedit makanan di *Wishlist page*, dan dapat memberikan penilaian berupa *rating* dan *review*.

# 🔗Alur Pengintegrasian dengan Web Service untuk terhubung dengan Aplikasi Web🔗
1. Menyelesaikan Penambahan End-Point pada Situs Web
Kami menambahkan end-point untuk setiap modul dalam aplikasi yang memungkinkan kami untuk mengambil (GET) dan mengirim (POST) data. End-point ini akan memungkinkan kami untuk mengakses data dalam database dan mengirim atau menerima data dalam format yang dapat diproses, seperti JSON. GET akan kami gunakan untuk mengambil data dari server dan mengirimkannya ke frontend. POST akan kami gunakan untuk mengirim data dari frontend ke server untuk disimpan atau diproses lebih lanjut.

2. Menambahkan Middleware untuk Akses API dari Luar Situs Web
Untuk memungkinkan API kami diakses oleh aplikasi atau situs lain, kami perlu menambahkan middleware yang menangani CORS (Cross-Origin Resource Sharing). Middleware ini akan memungkinkan server untuk mengizinkan atau membatasi akses dari domain lain. Kami biasanya menggunakan paket django-cors-headers untuk mengatur aturan akses eksternal.

3. Mengembangkan Fungsi Asinkron untuk Pengambilan, Pengiriman, dan Pembaruan Data
Kami harus mengelola operasi I/O seperti pengambilan, pengiriman, dan pembaruan data secara asinkron, agar aplikasi kami tidak memblokir proses lainnya. Fungsi asinkron memungkinkan kami untuk melakukan banyak tugas sekaligus tanpa harus menunggu satu per satu. Untuk Django, kami bisa menggunakan `async def` dalam views.

4. Menggunakan HTTP GET untuk Mengambil Data dan Menampilkan dalam Widget
Di sisi frontend, kami akan menggunakan HTTP GET untuk mengambil data dari server. Data yang kami ambil kemudian akan ditampilkan dalam bentuk widget atau elemen visual lainnya di halaman web. Pengambilan data ini memungkinkan kami untuk memperbarui tampilan halaman tanpa harus memuat ulang seluruh halaman.

5. Menggunakan HTTP POST untuk Mengirim Data ke End-Point dan Menyimpannya ke Basis Data Django
Untuk mengirim data dari frontend ke server, kami akan menggunakan metode POST. Data yang kami kirimkan melalui POST akan diterima oleh end-point yang kami siapkan di server dan disimpan dalam database Django. Proses ini memungkinkan kami untuk memperbarui atau menyimpan informasi baru yang dimasukkan oleh pengguna.


## Daftar Pustaka
🔗 https://gis.dukcapil.kemendagri.go.id/peta/

## Pembagian Tugas
| Nama       | Modul dan Jobdesc                                                                     |
|------------|-------------------------------------------------------------------------------------|
| Anggun     | Authentication, authorization, profile, homepage (list restoran)                    |
| Dandi      | Manajemen oleh-oleh (cards, form)                                                   |
| Leonita    | Manajemen makanan (list restoran, menu makanan, form add restaurant), database json |
| Rafansya   | Editor's choice (cards, form)                                                       |
| Salsabila  | Manajemen pemesanan (cards, form)                                                   |
| Olav       | Wishlist                                                                            |

## Link Progres
🔗 https://ristek.link/ProgresTKA10
