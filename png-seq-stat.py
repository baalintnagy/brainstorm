import cv2
import numpy as np
import os

# Directory containing the PNG files
image_directory = '/path/to/png/files'
images = sorted([img for img in os.listdir(image_directory) if img.endswith(".png")])

# Threshold for considering a frame faulty based on difference
difference_threshold = 10  # Adjust this value based on your needs

def compare_images(img1, img2):
    # Convert images to grayscale for comparison
    gray1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
    
    # Compute absolute difference
    diff = cv2.absdiff(gray1, gray2)
    
    # Check if the difference is above the threshold
    if np.mean(diff) > difference_threshold:
        return True
    return False

faulty_frames = []

# Compare each image to its predecessor
for i in range(1, len(images)):
    img1 = cv2.imread(os.path.join(image_directory, images[i-1]))
    img2 = cv2.imread(os.path.join(image_directory, images[i]))
    
    if compare_images(img1, img2):
        faulty_frames.append(images[i])

print("Faulty frames detected:", faulty_frames)
