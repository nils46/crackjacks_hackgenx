import os
import numpy as np
import rasterio
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn import preprocessing
from matplotlib.colors import LinearSegmentedColormap

def create_custom_colormap():
    colors = [(0, 'darkgreen'), (0.5, 'yellow'), (1, 'red')]
    return LinearSegmentedColormap.from_list('custom', colors)

def analyze_images(before_image_path, after_image_path):
    print("\n=== Starting Deforestation Analysis ===")
    
    print("\n1. Loading images...")
    try:
        with rasterio.open(before_image_path) as src:
            before_img = src.read()
            print(f"Before image loaded: {before_img.shape}")
        
        with rasterio.open(after_image_path) as src:
            after_img = src.read()
            print(f"After image loaded: {after_img.shape}")
            
        print("\n2. Calculating vegetation index...")
        before_red = before_img[0].astype('float32')
        before_nir = before_img[1].astype('float32')
        before_ndvi = (before_nir - before_red) / (before_nir + before_red + 1e-6)
        
        after_red = after_img[0].astype('float32')
        after_nir = after_img[1].astype('float32')
        after_ndvi = (after_nir - after_red) / (after_nir + after_red + 1e-6)
        
        print("\n3. Detecting changes...")
        vegetation_decrease = (before_ndvi - after_ndvi) > 0.2
        
        total_pixels = np.prod(before_ndvi.shape)
        deforested_pixels = np.sum(vegetation_decrease)
        deforestation_percentage = (deforested_pixels / total_pixels) * 100
        
        print("\n4. Creating visualization...")
        plt.figure(figsize=(20, 15))
        
        veg_cmap = create_custom_colormap()
        change_cmap = plt.cm.RdYlBu_r
        
        plt.subplot(2, 2, 1)
        im1 = plt.imshow(before_ndvi, cmap=veg_cmap, vmin=-1, vmax=1)
        cbar1 = plt.colorbar(im1, fraction=0.046, pad=0.04)
        cbar1.set_label('Vegetation Index\n(Dark Green = High, Red = Low)', fontsize=10)
        plt.title('Before Image - Vegetation Map', fontsize=12, pad=10)
        plt.axis('off')
        
        plt.subplot(2, 2, 2)
        im2 = plt.imshow(after_ndvi, cmap=veg_cmap, vmin=-1, vmax=1)
        cbar2 = plt.colorbar(im2, fraction=0.046, pad=0.04)
        cbar2.set_label('Vegetation Index\n(Dark Green = High, Red = Low)', fontsize=10)
        plt.title('After Image - Vegetation Map', fontsize=12, pad=10)
        plt.axis('off')
        
        plt.subplot(2, 2, 3)
        im3 = plt.imshow(vegetation_decrease, cmap='Reds')
        cbar3 = plt.colorbar(im3, fraction=0.046, pad=0.04)
        cbar3.set_label('Deforestation Probability', fontsize=10)
        plt.title('Deforestation Areas (Red = High Probability)', fontsize=12, pad=10)
        plt.axis('off')
        
        plt.subplot(2, 2, 4)
        change = after_ndvi - before_ndvi
        im4 = plt.imshow(change, cmap=change_cmap, vmin=-0.5, vmax=0.5)
        cbar4 = plt.colorbar(im4, fraction=0.046, pad=0.04)
        cbar4.set_label('Vegetation Change\n(Blue = Loss, Red = Gain)', fontsize=10)
        plt.title('Vegetation Change Map', fontsize=12, pad=10)
        plt.axis('off')
        
        plt.suptitle('Deforestation Analysis Results', fontsize=16, y=0.95)
        
        plt.tight_layout()
        plt.savefig('deforestation_analysis.png', dpi=300, bbox_inches='tight')
        plt.close()
        
        print("\n=== Analysis Results ===")
        print(f"Total area analyzed: {total_pixels:,} pixels")
        print(f"Deforested area: {deforested_pixels:,} pixels")
        print(f"Deforestation percentage: {deforestation_percentage:.2f}%")
        print("\nResults saved to 'deforestation_analysis.png'")
        
    except Exception as e:
        print(f"\nError: {str(e)}")
        print("Please make sure your images are in the correct format and have the same dimensions.")

if __name__ == "__main__":
    print("=== Deforestation Analysis Tool ===")
    print("This tool compares two satellite images to detect deforestation.")
    print("Please provide two images of the same area taken at different times.")
    print("The images should be in TIF format with at least 2 bands (red and NIR).")
    
    while True:
        before_image = input("\nEnter path to the 'before' image: ")
        if os.path.exists(before_image):
            break
        print("File not found. Please try again.")
    
    while True:
        after_image = input("Enter path to the 'after' image: ")
        if os.path.exists(after_image):
            break
        print("File not found. Please try again.")
    
    analyze_images(before_image, after_image) 