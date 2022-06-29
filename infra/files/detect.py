import os, boto3
import json
import base64

rekognition_cli = boto3.client('rekognition')
s3_cli = boto3.client('s3')
image_bucket = os.environ['IMAGE_BUCKET']

# split string with comma and store in list
def split_string(string, deli=','):
    return string.split(deli)

def buildResponse(result):
    responseObject = {}
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = json.dumps(result)

    return responseObject


def detect_faces(faces):
    result = {}
    result["Number_of_Faces"] = {
        "Amount": len(faces)
    }
    result["Male"] = {
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["Female"] = {
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["AgeRange"] = {
        "High": 0,
        "Low": 100,
        "BoundingBoxesHigh": [],
        "BoundingBoxesLow": [],
    }
    result["Beard"] = {
        "Value": False,
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["Mustache"] = {
        "Value": False,
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["General_Emotion"] = {
        "emotion": "",
        "score": 0,
        "BoundingBoxes": []
    }
    result["Eyeglasses"] = {
        "Value": False,
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["Sunglasses"] = {
        "Value": False,
        "Amount": 0,
        "BoundingBoxes": []
    }
    result["MouthOpen"] = {
        "Value": False,
        "Amount": 0,
        "BoundingBoxes": []
    }
    for face in faces:
        # Calculate number of Male and Female
        if face["Gender"]["Value"] == "Male":
            result["Male"]["Amount"] += 1
            result["Male"]["BoundingBoxes"].append(face["BoundingBox"])
        elif face["Gender"]["Value"] == "Female":
            result["Female"]["Amount"] += 1
            result["Female"]["BoundingBoxes"].append(face["BoundingBox"])

        # Get the General AgeRange
        if face["AgeRange"]["High"] > result["AgeRange"]["High"]:
            result["AgeRange"]["High"] = face["AgeRange"]["High"]
            result["AgeRange"]["BoundingBoxesHigh"] = []
            result["AgeRange"]["BoundingBoxesHigh"].append(face["BoundingBox"])
        if face["AgeRange"]["Low"] < result["AgeRange"]["Low"]:
            result["AgeRange"]["Low"] = face["AgeRange"]["Low"]
            result["AgeRange"]["BoundingBoxesLow"] = []
            result["AgeRange"]["BoundingBoxesLow"].append(face["BoundingBox"])

        # Get anyone with a beard
        if face["Beard"]["Value"]:
            result["Beard"]["Value"] = True
            result["Beard"]["Amount"] += 1
            result["Beard"]["BoundingBoxes"].append(face["BoundingBox"])

        # Get anyone with a mustache
        if face["Mustache"]["Value"]:
            result["Mustache"]["Value"] = True
            result["Mustache"]["Amount"] += 1
            result["Mustache"]["BoundingBoxes"].append(face["BoundingBox"])

        # Get the general emotion
        for emo in face["Emotions"]:
            if emo["Confidence"] > result["General_Emotion"]["score"]:
                result["General_Emotion"]["emotion"] = emo["Type"]
                result["General_Emotion"]["score"] = emo["Confidence"]
                result["General_Emotion"]["BoundingBox"] = []
                result["General_Emotion"]["BoundingBox"].append(face["BoundingBox"])

        # Get anyone with a glasses
        if face["Eyeglasses"]["Value"]:
            result["Eyeglasses"]["Value"] = True
            result["Eyeglasses"]["Amount"] += 1
            result["Eyeglasses"]["BoundingBoxes"].append(face["BoundingBox"])

        # Get anyone with a sunglasses
        if face["Sunglasses"]["Value"]:
            result["Sunglasses"]["Value"] = True
            result["Sunglasses"]["Amount"] += 1
            result["Sunglasses"]["BoundingBoxes"].append(face["BoundingBox"])

        # Get anyone with a mouth open
        if face["MouthOpen"]["Value"]:
            result["MouthOpen"]["Value"] = True
            result["MouthOpen"]["Amount"] += 1
            result["MouthOpen"]["BoundingBoxes"].append(face["BoundingBox"])
    return result

def lambda_handler(event, context):

    # Get data from event
    event_body = json.loads(event["body"])

    # Get Image data from the data body
    body_encoded = event_body["image"]

    # Split the body data to get the base64 image data
    image_raw = split_string(body_encoded, ';')[1]
    image_data = split_string(image_raw)[1]

    # Decode the base64 image data
    image_bytes = base64.b64decode(image_data)

    # Face detection
    response = rekognition_cli.detect_faces(Image = {'Bytes': image_bytes}, Attributes = ['ALL'])

    # Celebrity recognition
    response_celeb = rekognition_cli.recognize_celebrities(Image = {'Bytes': image_bytes})

    faces = response["FaceDetails"]
    celebs = response_celeb["CelebrityFaces"]
    print(faces)

    result = detect_faces(faces)

    # Add the celebrity data to the result
    result["Number_of_Celebrities"] = len(celebs)
    result["Celebrities"] = []
    for celeb in response_celeb["CelebrityFaces"]:
        result["Celebrities"].append(celeb["Name"])

    return buildResponse(result)