import ee
import geemap
import numpy as np
import matplotlib.pyplot as plt

ee.Initialize(project='probable-hash-456710-a0')

point = ee.Geometry.Point([81.2, 27.7])
region = point.buffer(500).bounds()

image_before = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED") \
    .filterBounds(region) \
    .filterDate("2023-01-01", "2023-06-01") \
    .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10)) \
    .sort('CLOUDY_PIXEL_PERCENTAGE') \
    .first()

image_after = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED") \
    .filterBounds(region) \
    .filterDate("2023-07-01", "2023-12-31") \
    .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10)) \
    .sort('CLOUDY_PIXEL_PERCENTAGE') \
    .first()

if image_before is None or image_after is None:
    raise Exception("No suitable Sentinel-2 images found for the specified region and dates.")

ndvi_before = image_before.normalizedDifference(['B8', 'B4']).rename('NDVI')
ndvi_after = image_after.normalizedDifference(['B8', 'B4']).rename('NDVI')
nbr_before = image_before.normalizedDifference(['B8', 'B12']).rename('NBR')
nbr_after = image_after.normalizedDifference(['B8', 'B12']).rename('NBR')


def image_to_numpy(image, band, region, scale=10):
    arr = geemap.ee_to_numpy(image.select(band), region=region, scale=scale)
    if arr is None or arr.size == 0:
        raise ValueError(f"Failed to extract array for {band}")
    return arr.squeeze()


ndvi_before_np = image_to_numpy(ndvi_before, 'NDVI', region)
ndvi_after_np = image_to_numpy(ndvi_after, 'NDVI', region)
nbr_before_np = image_to_numpy(nbr_before, 'NBR', region)
nbr_after_np = image_to_numpy(nbr_after, 'NBR', region)


ndvi_change = ndvi_after_np - ndvi_before_np
nbr_change = nbr_after_np - nbr_before_np


print("NDVI change shape:", ndvi_change.shape)
print("NDVI change range:", np.min(ndvi_change), "to", np.max(ndvi_change))


def save_change_map(array, title, filename, cmap='RdYlGn'):
    plt.figure(figsize=(8, 6))
    plt.imshow(array, cmap=cmap, vmin=-1, vmax=1)
    plt.colorbar(label=title)
    plt.title(title)
    plt.axis('off')
    plt.savefig(filename, dpi=300)
    plt.close()

save_change_map(ndvi_change, 'NDVI Change Map', 'ndvi_change_map.png')
save_change_map(nbr_change, 'NBR Change Map', 'nbr_change_map.png', cmap='coolwarm')
print("NDVI and NBR change maps saved!")


Map = geemap.Map(center=[27.7, 81.2], zoom=12)
Map.addLayer(image_before, {'bands': ['B4', 'B3', 'B2'], 'min': 0, 'max': 3000}, 'True Color Before')
Map.addLayer(image_after, {'bands': ['B4', 'B3', 'B2'], 'min': 0, 'max': 3000}, 'True Color After')
Map.addLayer(region, {}, "Region of Interest")
Map.to_html("sentinel_map.html")
print("Interactive map saved as sentinel_map.html")