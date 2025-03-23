import os
import yaml

from flask import Flask, request, jsonify
from ultralytics import YOLO
from werkzeug.utils import secure_filename

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

model = YOLO("weights/best.pt")

MAPPING_FILE = "type_mapping.yaml"
type_mapping = {}
if os.path.exists(MAPPING_FILE):
    with open(MAPPING_FILE, "r") as f:
        type_mapping = yaml.safe_load(f)

subtype_to_type = {subtype: category for category, subtypes in type_mapping.items() for subtype in subtypes}
print(f"subtype_to_type: {subtype_to_type}", flush=True)

@app.route("/predict", methods=["POST"])
def predict():
    print(f"Request Content-Length: {request.content_length}", flush=True)
    if "image" not in request.files:
        print("Error: No 'image' field in request.files", flush=True)
        return jsonify({"error": "No image provided"}), 400

    file = request.files["image"]
    if file.filename == "":
        print("Error: Received file is empty!", flush=True)
        return jsonify({"error": "Received file is empty"}), 400

    print(f"Received file: {file.filename}, Size: {request.content_length} bytes", flush=True)
    
    filename = secure_filename(file.filename)
    filepath = os.path.join(UPLOAD_FOLDER, filename)

    try:
        file.save(filepath)
        if os.path.getsize(filepath) == 0:
            print("Error: Saved file is empty!", flush=True)
            return jsonify({"error": "Saved file is empty"}), 400
    except Exception as e:
        print(f"File save error: {e}", flush=True)
        return jsonify({"error": "File save error"}), 500

    results = model.predict(filepath, save=True)
    os.remove(filepath)

    types, subtypes, confidence = [], [], []
    non_recyclables = set()

    for result in results:
        for i, box in enumerate(result.boxes):
            subtype = result.names[int(box.cls[0])]
            type_category = subtype_to_type.get(subtype, "unknown")

            types.append(type_category)
            subtypes.append(subtype)
            confidence.append(f"{float(box.conf[0]):.6f}")

            if type_category == "non-recyclable":
                non_recyclables.add(subtype)

    recycable_len = len(set(types) - non_recyclables)

    response_data = {
        "type": types,
        "subtype": subtypes,
        "confidence": confidence,
        "points": recycable_len if recycable_len <= 3 else 3,
        "non_recyclable": list(non_recyclables)
    }

    print(f'response_data: {response_data}', flush=True)
    return jsonify(response_data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
