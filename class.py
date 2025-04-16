import os
import numpy as np
import rasterio
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn import preprocessing
import joblib
from matplotlib.colors import ListedColormap

class_names = ['tree cover', 'shrubland', 'grassland', 'cropland', 'built-up',
               'bare/sparse vegetation', 'snow and ice', 'permanent water bodies']
colors = ['#006400', '#FFBB22', '#FFFF4C', '#F096FF', '#FA0000',
          '#B4B4B4', '#F0F0F0', '#0064C8']
cmap = ListedColormap(colors)

print("Loading training data...")
sentinel_path = "S2A_MSIL1C_20220516_TrainingData.tif"
ground_truth_path = "S2A_MSIL1C_20220516_Train_GT.tif"

if not os.path.exists(sentinel_path) or not os.path.exists(ground_truth_path):
    raise FileNotFoundError("Training data files not found.")

with rasterio.open(sentinel_path) as src:
    sentinel_bands = src.read()
with rasterio.open(ground_truth_path) as src:
    ground_truth_labels = src.read(1)

red = sentinel_bands[2, :, :].astype('float32')
nir = sentinel_bands[3, :, :].astype('float32')
ndvi = (nir - red) / (nir + red + 1e-6)

X_bands = sentinel_bands.reshape(sentinel_bands.shape[0], -1).T
X_ndvi = ndvi.flatten().reshape(-1, 1)
X_all = np.hstack((X_bands, X_ndvi))
y_all = ground_truth_labels.flatten()

valid_mask = y_all > 0
X_valid = X_all[valid_mask]
y_valid = y_all[valid_mask]

print("Training model...")
scaler = preprocessing.MinMaxScaler().fit(X_valid)
X_valid_scaled = scaler.transform(X_valid)

clf = RandomForestClassifier(n_estimators=100, random_state=42)
clf.fit(X_valid_scaled, y_valid)
print("Model trained successfully!")

print("\nClassifying new image (RASTER_10.tif)...")
new_image_path = "RASTER_10.tif"

if os.path.exists(new_image_path):
    with rasterio.open(new_image_path) as src:
        new_img = src.read()
        new_rows, new_cols = new_img.shape[1], new_img.shape[2]
        print(f"New image shape: Bands={new_img.shape[0]}, Rows={new_rows}, Cols={new_cols}")

    new_red = new_img[2, :, :].astype('float32')
    new_nir = new_img[3, :, :].astype('float32')
    new_ndvi = (new_nir - new_red) / (new_nir + new_red + 1e-6)

    X_new_bands = new_img.reshape(new_img.shape[0], -1).T
    X_new_ndvi = new_ndvi.flatten().reshape(-1, 1)
    X_new = np.hstack((X_new_bands, X_new_ndvi))

    X_new_scaled = scaler.transform(X_new)
    y_new_pred = clf.predict(X_new_scaled)
    prediction_image_new = y_new_pred.reshape(new_rows, new_cols)

    print("Saving classification results...")
    with rasterio.open('RASTER_10_classified.tif', 'w',
                      driver='GTiff',
                      height=new_rows,
                      width=new_cols,
                      count=1,
                      dtype=rasterio.uint8,
                      crs=src.crs,
                      transform=src.transform) as dst:
        dst.write(prediction_image_new.astype(rasterio.uint8), 1)

    plt.figure(figsize=(15, 8))
    
    plt.subplot(1, 2, 1)
    rgb = np.stack([new_img[2], new_img[1], new_img[0]], axis=0)  # Bands 3,2,1 for RGB
    rgb = np.clip(rgb * 2.5, 0, 1)  # Enhance contrast
    plt.imshow(rgb.transpose(1, 2, 0))
    plt.title('Original Image (RGB)', fontsize=12, pad=10)
    plt.axis('off')
    
    plt.subplot(1, 2, 2)
    im = plt.imshow(prediction_image_new, cmap=cmap, vmin=1, vmax=8)
    plt.title('Land Cover Classification', fontsize=12, pad=10)
    plt.axis('off')
    
    cbar = plt.colorbar(im, fraction=0.046, pad=0.04)
    cbar.set_ticks(np.arange(1, 9))
    cbar.set_ticklabels(class_names)
    cbar.ax.tick_params(labelsize=8)
    
    plt.tight_layout()
    plt.savefig('classification_visualization.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("Classification complete! Results saved to:")
    print("- RASTER_10_classified.tif (classified image)")
    print("- classification_visualization.png (visualization)")
else:
    print(f"Error: New image not found at {new_image_path}")
