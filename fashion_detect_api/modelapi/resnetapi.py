import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
import werkzeug

# Flask uygulaması başlatılıyor
app = Flask(__name__)

# Modeli yükle
model = load_model('model/resnet_model.h5')

# Sınıf isimlerini belirle
class_names = [
    'Kurtas', 'Heels', 'Dresses', 'Deodorant', 'Perfume and Body Mist', 'Casual Shoes',
    'Scarves', 'Tops', 'Shirts', 'Tunics', 'Stockings', 'Face Moisturisers', 'Eye Cream',
    'Face Serum and Gel', 'Fragrance Gift Set', 'Trousers', 'Tshirts', 'Bracelet',
    'Şapka', 'Earrings', 'Flats', 'Shapewear', 'Briefs', 'Nightdress', 'Bra',
    'Camisoles', 'Sarees', 'Lehenga Choli', 'Cufflinks', 'Pendant', 'Ring', 'Bangle',
    'Necklace and Chains', 'Formal Shoes', 'Clutches', 'Handbags', 'Sandals', 'X1',
    'Jackets', 'Rain Jacket', 'Kurtis', 'Klasik Ayakkabı', 'Sports Shoes', 'Accessory Gift Set',
    'Ties', 'Socks', 'Capris', 'Hair Accessory', 'Shorts', 'Tracksuits', 'Jeans', 'Sunglasses',
    'Ties and Cufflinks', 'Travel Accessory', 'Caps', 'Sweaters', 'Shrug', 'Wallets', 'Belts',
    'Patiala', 'Backpacks', 'Sports Sandals', 'Leggings', 'Kajal and Eyeliner', 'Mask and Peel',
    'Face Wash and Cleanser', 'Face Scrub and Exfoliator', 'Lip Care', 'Makeup Remover',
    'Body Lotion', 'Sunscreen', 'Toner', 'Ruj', 'Highlighter and Blush', 'Compact',
    'Eyeshadow', 'Foundation and Primer', 'Lip Gloss', 'Lip Liner', 'Mascara', 'Nail Polish',
    'Lipstick', 'Free Gifts', 'Robe', 'Oje', 'Jeggings', 'Skirts', 'Waistcoat', 'Kurta Sets',
    'Nail Essentials', 'Mens Grooming Kit', 'Night suits', 'Concealer', 'Beauty Accessory',
    'Hair Colour', 'Lounge Pants', 'Sweatshirts', 'Laptop Bag', 'Track Pants', 'Boxers',
    'Messenger Bag', 'Wristbands', 'Baby Dolls', 'Bath Robe', 'Lounge Tshirts', 'Lounge Shorts',
    'Tablet Sleeve', 'Rain Trousers', 'Innerwear Vests', 'Stoles', 'Dupatta', 'Trunk',
    'Spor Ayakkabı', 'Lip Plumper', 'Mobile Pouch', 'Güneş Gözlüğü', 'Ipad', 'Headband',
    'Body Wash and Scrub', 'Key chain', 'Swimwear', 'Trolley Bag', 'Cushion Covers', 'Tights',
    'Rucksacks', 'Waist Pouch', 'Rompers', 'Gloves', 'Booties', 'Clothing Set', 'Churidar',
    'Blazers', 'Nehru Jackets', 'Tshirts', 'Mufflers', 'Shoe Accessories', 'Umbrellas',
    'Hat', 'Cüzdan', 'Saat', 'Basketballs', 'Shoe Laces'
]


# Görseli yükleyip ön işleme
def load_and_preprocess_image(image_file):
    img = load_img(image_file, target_size=(128, 128))  # Resmi 128x128'e yeniden boyutlandır
    img_array = img_to_array(img)  # Resmi numpy array'e dönüştür
    img_array = tf.keras.applications.resnet50.preprocess_input(img_array)  # ResNet50 için ön işleme
    return np.expand_dims(img_array, axis=0)  # Veriyi (1, 128, 128, 3) şekline dönüştür

# API için route oluşturuluyor
@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        # Dosyayı geçici bir dosyaya kaydet
        upload_folder = 'uploads'
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)

        img_path = os.path.join(upload_folder, werkzeug.utils.secure_filename(file.filename))
        file.save(img_path)

        # Görseli yükle ve ön işleme
        image = load_and_preprocess_image(img_path)

        # Tahmin yap
        predictions = model.predict(image)

        # Modelin tahmin ettiği sınıf ve skor
        predicted_class_index = np.argmax(predictions)  # En yüksek olasılığa sahip sınıfın indeksi
        predicted_score = predictions[0][predicted_class_index]  # Olasılık değeri

        # Tahmin edilen sınıf ismi
        if 0 <= predicted_class_index < len(class_names):  # Sınıf dizini kontrolü
            predicted_class = class_names[predicted_class_index]
        else:
            return jsonify({'error': 'Predicted class index out of range'}), 500

        # Sonucu döndür
        result = {
            'class': predicted_class,
            'score': round(float(predicted_score), 4)  # Skoru yuvarla ve JSON uyumlu hale getir
        }

        return jsonify(result)

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        # Geçici dosyayı sil
        if os.path.exists(img_path):
            os.remove(img_path)
if __name__ == '__main__':
    # API'yi çalıştırıyoruz
    if not os.path.exists('uploads'):
        os.makedirs('uploads')
    app.run(host='0.0.0.0', port=5002)