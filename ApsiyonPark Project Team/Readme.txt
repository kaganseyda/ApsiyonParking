# ApsiyonPark Otopark Yönetim Sistemi Kurulum ve Kullanım Yönergesi

## 1. Fiziksel Otopark Krokisinin Çıkarılması
Öncelikle modeli eğiteceğimiz otoparkın krokisini çıkarmamız gerekiyor. Bunun için önce alan ölçümü sonra çizim, en son da dijitalleştirme yapmamız gerekmekte. Bu adımlar standart prosedür adımları olduğu için projenin uygulanabilirliği adına teknik adımları aşağıda belirtelim.

### a. Alanın Ölçülmesi:
1. **Donanım:** Lazer ölçüm cihazları veya GPS cihazları kullanarak otoparkın kesin ölçümlerini yapıyoruz.
2. **Adımlar:**
   - Otoparkın uzunluk ve genişliğini ölçeceğiz.
   - Her bir park alanının boyutlarını (genişlik ve uzunluk) belirleyeceğiz.
   - Tüm önemli nesneleri (kolonlar, çıkış yolları vb.) ve yerleşimlerini belirleyeceğiz.


### b. Krokisinin Çizilmesi:
1. **Araçlar:** AutoCAD, SketchUp veya benzeri CAD yazılımları kullanarak fiziksel ölçümleri dijital bir krokiye dönüştüreceğiz.
2. **Adımlar:**
   - Önce otoparkın temel boyutlarını çizerek başlayalım.
   - Her bir park alanını belirleyelim ve konumlarına yerleştirelim.
   - Diğer önemli yapı ve nesneleri (kolon, giriş-çıkış vb) ekleyelim.

## 2. Dijital Krokilerin Kullanımı

### a. Krokinin Dijital Ortama Aktarılması:
1. **Format:** Krokileri PNG  formatında kaydedelim.
2. **Katmanlar:** Çizim yazılımı kullanarak farklı katmanlar oluşturalım (örneğin, park alanları, kolonlar, yollar).

### b. Dijital Krokilerin Veri Entegrasyonu:
1. **ROI Belirleme:** Her bir park alanı için ROI (Region of Interest) belirleyelim ve koordinatlarını kaydedelim. ROI belirleme sebebimiz kamera kurulumu sırasında entegrasyonu sağlayabilmektir. Database’e veri girişimize örnek olması bakımından kodu aşağı bırakıyorum:
     ```
     INSERT INTO parking_zones (zone_id, x, y, width, height)
     VALUES (1, 100, 200, 50, 100);
     ```
—————————
### c. Kameraların Yerleşimi:
1. **Konumlandırma:** Fiziksel krokide belirlenen kameraların yerlerini dijital krokide de belirteceğiz.
2. **ROI Tanımlama:** Her kamera için görüş alanı ve izleme bölgelerini tanımlayalım. Bunu yaparken otopark krokisinde belirlediğimiz sektörleri referans almalıyız.
     ```
     INSERT INTO cameras (location, roi_x, roi_y, roi_width, roi_height, stream_url)
     VALUES ('north_lot', 100, 200, 400, 300, 'rtsp://username:password@camera_ip/stream');
     ```
——————————
### d. Dijital Krokilerin Görselleştirilmesi:
1. **Uygulama:** Android uygulamamızda, park alanlarının durumunu görselleştirmek için GridView kullanmamız gerekiyor. Proje dosyasında yer alan uygulamamız, reelde bir otopark alanı-kamera entegrasyonu sağlamamız ve bunu sunucu üzerinde kaydetmemiz mümkün olmadığından 5 saniyede bir random güncellenmektedir. Ancak yeterli fiziki koşullar oluştuğunda projenin nasıl hayata geçirileceğini detaylı şekilde anlatmak istedik.
2. **Güncellemeler:** Kameralardan gelen verilerle park alanlarının durumunu (boş/dolu) sürekli olarak güncelliyoruz. (Kameraların ortalama 0.5 saniyede bir görüntü kaydettiğini, modelin de çalışma süresini hesaba katarsak 10 saniyede bir yenileme işlemi mantıklı görünüyor.)

### 3. Veri Entegrasyonu ve Görselleştirme:
1. **Veritabanı:** Tüm park alanı verilerini merkezi bir veritabanında saklayacağız.
2. **Görselleştirme:** Android uygulamamızda JSON formatında veri alarak görselleştirip  kullanıcıya park yeri doluluk oranlarını göstereceğiz.

### e. Flask Aracılığıyla Model Verilerini Uygulamada Çağırma:
1.**Flask Kurulumu: python app.py komutunu komut istemine yazarak kurulumumuzu başlatıyoruz.
2.**Uygulama Entegrasyonu: “MainActivity.kt” klasörümüze aşağıya bıraktığım kodu ekleyerek Flask sunucumuzla uygulamamızın haberleşmesini sağlıyoruz. 
“””
val url = "http://YOUR_SERVER_IP:5000/" val request = StringRequest(Request.Method.GET, url, Response.Listener<String> { response -> // Gelen JSON verisini işle }, Response.ErrorListener { error -> // Hata durumunu ele al }) // Volley RequestQueue ekleyin val requestQueue = Volley.newRequestQueue(this) requestQueue.add(request)val url = "http://YOUR_SERVER_IP:5000/" val request = StringRequest(Request.Method.GET, url, Response.Listener<String> { response -> // Gelen JSON verisini işle }, Response.ErrorListener { error -> // Hata durumunu ele al }) // Volley RequestQueue ekleyin val requestQueue = Volley.newRequestQueue(this) requestQueue.add(request)
“””
——————————
***Not: URL temsilidir.
### d. Database Oluşturma:
Database oluştururken aşağıda belirttiğim SQL kodunu kullanacağız. Halihazırda sunucumuz olmadığı için Database oluşturmadık ancak oluşturabilecek bilgi ve yetkinliğe sahibiz:
“””
CREATE TABLE parking_zones ( zone_id SERIAL PRIMARY KEY, x INT, y INT, width INT, height INT ); -- CREATE TABLE cameras ( location VARCHAR(255) PRIMARY KEY, roi_x INT, roi_y INT, roi_width INT, roi_height INT, stream_url VARCHAR(255) );

“””
-Görselleştirme, optimizasyon aşamasında elde ettiğimiz dataları sisteme giriyoruz. Bir kamera ve bir alan içeren iki tablomuz kamera ve alan sayısına göre genişletilebilir.

### f. Kamera Seçimi:
 Gerçek zamanlı veri için RTSP akış desteğine sahip IP kameraları seçeceğiz. Aynıağa bağlı olmaları görüntü işleme bakımından bir zorunluluk.

### g. Park Alanının Güncellenmesi
 -Tespit edilen araçların bulunduğu hücreler park yerleşiminde dolu (1) olarak işaretlenir. Uygulamada kırmızı renge karşılık geliyor.
 -Bu bilgiler düzenli aralıklarla güncellenir ve veritabanında saklanır.

### h. Son Aşama: Android Entegrasyon:
- ***Flask sunucusu çalıştırılırken entegrasyona dair bir aşamadan da bahsettik.
- ***Öncelikle build.gradle aracılığıyla Retrofit’i kuracağız. ———— implementation 'com.squareup.retrofit2:retrofit:2.9.0' implementation 'com.squareup.retrofit2:converter-gson:2.9.0' ————
- ***Sıradaki adım Retrofit Arayüzü: ———— public interface ApiService {     @GET("/")     Call<int[][]> getParkingLayout();}  —————
- ***Retrofit Başlatma: ————— Retrofit retrofit = new Retrofit.Builder()         .baseUrl("http://YOUR_FLASK_SERVER_IP:5000/")         .addConverterFactory(GsonConverterFactory.create())         .build(); ApiService apiService = retrofit.create(ApiService.class); ——————
- ***Veri Senkronizasyonu, UI güncelleme ve Doluluk yüzdesi Gösterimi: ————— apiService.getParkingLayout().enqueue(new Callback<int[][]>() {     @Override     public void onResponse(Call<int[][]> call, Response<int[][]> response) {         if (response.isSuccessful()) {             int[][] parkingLayout = response.body();         }     }      @Override     public void onFailure(Call<int[][]> call, Throwable t) {     } }); ——————

###ÖNEMLİ NOT###
Projemizin Android kodlama işlemini JAVA kullanarak yaptık. Ancak proje içerikleri Kotlin dilindedir. Android Studio otomatik kod entegrasyonu sayesinde bu şekilde olmuştur. Empty Activity için JAVA seçeneği olmadığından böyle bir yol izledik. 
## ONEMLI NOT###
Projemizin entegrasyon sayfasında MainActivity.kt, ApiService.kt ve RetroFitClient.kt dosyaları bulunmaktadır. Modelin gerçekten kurulu durumunda bu dosyalar projeye yerleştirildiğinde uygulamamız gerçek verilerle çalışacaktır.
