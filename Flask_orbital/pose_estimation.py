# from flask import Flask, jsonify, request
# import time

# app = Flask(__name__)
# @app.route("/betaalpha", method = ["POST"])

# #response
# def response():
#     query = dict(request.form)['query']
#     result = query + " " + time.ctime()
#     return jsonify({"response" : result})

# if __name__ == "__main__":
#     app.run(host = "0.0.0.0",) 


#python script
import cv2 as cv
import matplotlib.pyplot as plt
import os

net = cv.dnn.readNetFromTensorflow("graph_opt.pb") #weights

inWidth = 368
inHeight = 368
thr = 0.2

BODY_PARTS = { "Nose": 0, "Neck": 1, "RShoulder": 2, "RElbow": 3, "RWrist": 4,
                   "LShoulder": 5, "LElbow": 6, "LWrist": 7, "RHip": 8, "RKnee": 9,
                   "RAnkle": 10, "LHip": 11, "LKnee": 12, "LAnkle": 13, "REye": 14,
                   "LEye": 15, "REar": 16, "LEar": 17, "Background": 18 }

POSE_PAIRS = [ ["Neck", "RShoulder"], ["Neck", "LShoulder"], ["RShoulder", "RElbow"],
                ["RElbow", "RWrist"], ["LShoulder", "LElbow"], ["LElbow", "LWrist"],
                ["Neck", "RHip"], ["RHip", "RKnee"], ["RKnee", "RAnkle"], ["Neck", "LHip"],
                ["LHip", "LKnee"], ["LKnee", "LAnkle"], ["Neck", "Nose"], ["Nose", "REye"],
                ["REye", "REar"], ["Nose", "LEye"], ["LEye", "LEar"] ]

def pose_estimation(video_path):
    video_dir = os.path.dirname(video_path)
    video_name = os.path.basename(video_path)
     # Set the output path using the same directory and file name, but with a different directory or file extension
    output_dir = video_dir  # Set the same directory as the input video
    output_name = os.path.splitext(video_name)[0] + '_annotated.mp4'  # Set a new file extension or add a suffix to the file name
    output_path = os.path.join(output_dir, output_name)

    cap = cv.VideoCapture(video_path)
    #cap.set(3, 800)
    #cap.set(4, 800)

    if not cap.isOpened():
        cap = cv.VideoCapture(0)
    if not cap.isOpened():
        raise IOError("Cannot open video")

    fourcc = cv.VideoWriter_fourcc(*'mp4v')
    output_video = cv.VideoWriter(output_path, fourcc, cap.get(cv.CAP_PROP_FPS),
                                  (int(cap.get(cv.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv.CAP_PROP_FRAME_HEIGHT))))

    while cv.waitKey(1) < 0:
        hasFrame, frame = cap.read()
        if not hasFrame:
            cv.waitKey()
            break
        
        frameWidth = frame.shape[1]
        frameHeight = frame.shape[0]
        inp = cv.dnn.blobFromImage(frame, 1.0, (inWidth, inHeight),
                                (127.5, 127.5, 127.5), swapRB=False, crop=False)
        net.setInput(inp)
        out = net.forward()
        out = out[:, :19, :, :]

        assert(len(BODY_PARTS) <= out.shape[1])

        points = []
        for i in range(len(BODY_PARTS)):
            # Slice heatmap of corresponding body's part.
            heatMap = out[0, i, :, :]

            # Originally, we try to find all the local maximums. To simplify a sample
            # we just find a global one. However only a single pose at the same time
            # could be detected this way.
            _, conf, _, point = cv.minMaxLoc(heatMap)
            x = (frameWidth * point[0]) / out.shape[3]
            y = (frameHeight * point[1]) / out.shape[2]

            # Add a point if it's confidence is higher than threshold.
            points.append((int(x), int(y)) if conf > thr else None)

        for pair in POSE_PAIRS:
            partFrom = pair[0]
            partTo = pair[1]
            assert(partFrom in BODY_PARTS)
            assert(partTo in BODY_PARTS)

            idFrom = BODY_PARTS[partFrom]
            idTo = BODY_PARTS[partTo]

            if points[idFrom] and points[idTo]:
                cv.line(frame, points[idFrom], points[idTo], (0, 255, 0), 3)
                cv.ellipse(frame, points[idFrom], (3, 3), 0, 0, 360, (0, 0, 255), cv.FILLED)
                cv.ellipse(frame, points[idTo], (3, 3), 0, 0, 360, (0, 0, 255), cv.FILLED)

        t, _ = net.getPerfProfile() 
        freq = cv.getTickFrequency() / 1000
        cv.putText(frame, '%.2fms' % (t / freq), (10, 20), cv.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0))
        output_video.write(frame)
        cv.imshow('Video analysed', frame)
    
    cap.release()
    output_video.release()
    cv.destroyAllWindows()
    return output_path

