from flask import Flask, request, jsonify
from tensorflow.keras.preprocessing import image
import numpy as np
from tensorflow.keras.models import load_model
import os

# Flask uygulamasını başlat
app = Flask(__name__)

# Modeli yükleyelim
model = load_model('model/cnn_model.h5')  # Burada modelinizi yükleyin

# Etiketlerinizi manuel olarak tanımlayalım
class_names = [
    'Kemer', 'Şapka', 'Gündelik Ayakkabı', 'Elbise', 'Klasik Ayakkabı', 'Ceket', 'Kot Pantolon',
    'Kurtas', 'Ruj', 'Oje', 'Gömlek', 'Şort', 'Çorap', 'Spor Ayakkabı',
    'Güneş Gözlüğü', 'Kazak', 'Caps', 'Kravat', 'Kadın Üst', 'Eşofman Altı', 'Pantolon',
    'Tişört', 'Cüzdan', 'Saat'
]  # 24 etiket

# Resmi yükleme ve ön işleme fonksiyonu
def prepare_image(img_path):
    img = image.load_img(img_path, target_size=(224, 224))  # Resmi boyutlandır
    img_array = image.img_to_array(img)  # Resmi numpy array'e çevir
    img_array = np.expand_dims(img_array, axis=0)  # Batch boyutunu ekle
    img_array = img_array / 255.0  # Normalizasyon
    return img_array


# Tahmin yapacak API endpoint'i
@app.route('/predict', methods=['POST'])
def predict():
    # Resmi alalım
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        # Geçici bir dosyaya kaydedelim
        img_path = os.path.join('temp', file.filename)
        file.save(img_path)

        # Resmi hazırlayalım
        img_array = prepare_image(img_path)

        # Model ile tahmin yapalım
        predictions = model.predict(img_array)
        print(f"Tahminler: {predictions}")
        print(f"Predictions Shape: {predictions.shape}")

        # Tahmin sonucunu etiketlere dönüştürelim
        predicted_index = np.argmax(predictions, axis=1)[0]  # 0. resmin tahminini alıyoruz
        predicted_label = class_names[predicted_index]  # Etiketlere manuel olarak erişiyoruz
        predicted_score = float(predictions[0][predicted_index])  # Tahmin edilen sınıfın skoru

        # Sonucu döndürelim
        return jsonify({'class': predicted_label, 'score': predicted_score})

    except Exception as e:
        print(f"API hatası: {e}")
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)