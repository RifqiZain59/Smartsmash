# Aturan umum untuk menjaga semua kelas TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }

# Aturan spesifik untuk menjaga kelas GPU delegate TensorFlow Lite
-keep class org.tensorflow.lite.gpu.** { *; }

# Ini adalah baris yang sering ditemukan di missing_rules.txt.
# Menambahkannya membantu menghindari peringatan, tapi aturan -keep di atas lebih krusial.
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Jika ada aturan lain dari missing_rules.txt yang muncul di masa depan, tambahkan di sini juga.