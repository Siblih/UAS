from flask import Flask, request, jsonify
import face_recognition
import numpy as np
import os
from PIL import Image
from io import BytesIO

app = Flask(__name__)

# Load known faces
known_face_encodings = []
known_face_names = []

for file in os.listdir("known_faces"):
    image = face_recognition.load_image_file(f"known_faces/{file}")
    encoding = face_recognition.face_encodings(image)[0]
    known_face_encodings.append(encoding)
    known_face_names.append(os.path.splitext(file)[0])

@app.route('/detect', methods=['POST'])
def detect():
    file = request.files['image']
    img = face_recognition.load_image_file(file)

    face_locations = face_recognition.face_locations(img)
    face_encodings = face_recognition.face_encodings(img, face_locations)

    names = []
    for face_encoding in face_encodings:
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        name = "Tidak dikenal"

        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        if len(face_distances) > 0:
            best_match_index = np.argmin(face_distances)
            if matches[best_match_index]:
                name = known_face_names[best_match_index]

        names.append(name)

    return jsonify({"detected": names})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
