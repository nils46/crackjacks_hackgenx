import os
import cv2
import numpy as np
from ultralytics import YOLO
import matplotlib.pyplot as plt
from PIL import Image
import torch

def load_and_preprocess_image(image_path):
   
    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return image

def detect_deforestation(before_image_path, after_image_path):
  
    print("Loading YOLOv8 model...")
    model = YOLO('yolov8n-seg.pt')  
    
    print("Processing before image...")
    before_image = load_and_preprocess_image(before_image_path)
    before_results = model(before_image)
    
    print("Processing after image...")
    after_image = load_and_preprocess_image(after_image_path)
    after_results = model(after_image)
    
    
    before_mask = before_results[0].masks.data if before_results[0].masks is not None else None
    after_mask = after_results[0].masks.data if after_results[0].masks is not None else None
    
   
    plt.figure(figsize=(15, 10))
    
    
    plt.subplot(2, 2, 1)
    plt.imshow(before_image)
    if before_mask is not None:
        for mask in before_mask:
            mask = mask.cpu().numpy()
            plt.imshow(mask, alpha=0.3, cmap='viridis')
    plt.title('Before Image with Detections')
    plt.axis('off')
    
   
    plt.subplot(2, 2, 2)
    plt.imshow(after_image)
    if after_mask is not None:
        for mask in after_mask:
            mask = mask.cpu().numpy()
            plt.imshow(mask, alpha=0.3, cmap='viridis')
    plt.title('After Image with Detections')
    plt.axis('off')
    
   
    plt.subplot(2, 2, 3)
    if before_mask is not None and after_mask is not None:
       
        diff = np.zeros_like(before_image)
        for b_mask, a_mask in zip(before_mask, after_mask):
            b_mask = b_mask.cpu().numpy()
            a_mask = a_mask.cpu().numpy()
            diff += np.abs(b_mask - a_mask)
        plt.imshow(diff, cmap='hot')
        plt.title('Detected Changes (Deforestation)')
    else:
        plt.imshow(np.abs(before_image.astype(float) - after_image.astype(float)))
        plt.title('Image Difference')
    plt.axis('off')
    
  
    plt.tight_layout()
    plt.savefig('deforestation_analysis.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("Analysis complete! Results saved to 'deforestation_analysis.png'")
    
    
    if before_mask is not None and after_mask is not None:
        before_area = sum(mask.sum().item() for mask in before_mask)
        after_area = sum(mask.sum().item() for mask in after_mask)
        deforestation_percentage = ((before_area - after_area) / before_area) * 100
        print(f"\nEstimated deforestation: {deforestation_percentage:.2f}%")
    else:
        print("\nCould not calculate deforestation percentage due to missing detections")

