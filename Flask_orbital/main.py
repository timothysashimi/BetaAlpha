from flask import Flask, request, jsonify
import werkzeug
import os
from pose_estimation import pose_estimation

app = Flask(__name__)

@app.route('/upload', methods=["POST"])
def upload():
    if (request.method == "POST"):
        videofile = request.files['video']
        filename = werkzeug.utils.secure_filename(videofile.filename)
        script_dir = os.path.dirname(os.path.abspath(__file__))
        video_path = os.path.join(script_dir, filename)
        videofile.save(video_path)
        cloudinary_url = pose_estimation(video_path)

        #Delete the local video file 
        os.remove(video_path)

        return jsonify({
            "message": "Video Uploaded Successfully",
            "cloudinary_url": cloudinary_url
        })
    else:
        return jsonify({
            "error": "Invalid request method"
        })

if __name__ == "__main__":
    app.run(debug=True, port=4000)