import numpy as np
import rasterio
import matplotlib.pyplot as plt
import random
from sklearn import preprocessing

sentinel_path="S2A_MSIL1C_20220516_TrainingData.tif"
sentinel_data = rasterio.open(sentinel_path)
sentinel_bands = sentinel_data.read()

ground_truth_path= "S2A_MSIL1C_20220516_Train_GT.tif"
ground_truth_data = rasterio.open(ground_truth_path)
ground_truth_labels= ground_truth_data.read(1)
bands,rows,cols=sentinel_bands.shape
print("sentinel 2 image shape- bands: {},rows: {},columns:{}".format(bands,rows,cols))
resolution = sentinel_data.res[0]
print("number of bands in sentinel 2 images:",bands)
print("spatial resolution : {} meters".format(resolution))

ground_truth_rows,ground_truth_cols=ground_truth_labels.shape
print("ground truth data shape - rows: {}, columns : {}".format(ground_truth_rows,ground_truth_cols))
red = sentinel_bands[2, :, :].astype('float32')   
nir = sentinel_bands[3, :, :].astype('float32')   


ndvi = (nir - red) / (nir + red + 1e-6)

rows, cols = ground_truth_labels.shape
X_bands = sentinel_bands.reshape(sentinel_bands.shape[0], -1).T  # (pixels, 4)
X_ndvi = ndvi.flatten().reshape(-1, 1)                            # (pixels, 1)


X_all = np.hstack((X_bands, X_ndvi))  # Final shape: (pixels, 5)


y_all = ground_truth_labels.flatten()


valid_mask = y_all > 0
X_valid = X_all[valid_mask]
y_valid = y_all[valid_mask]
plt.figure(figsize=(12,6))
for i in range(sentinel_bands.shape[0]):
  plt.subplot(1,sentinel_bands.shape[0]+1,i+1)
  plt.imshow(sentinel_bands[i,:,:],cmap='viridis')
  plt.title(f'sentinel band {i+1}')
  plt.axis('off')
plt.subplot(1,5,5)
plt.imshow(ground_truth_labels,cmap='tab10')
plt.title('ground truth labels')
plt.axis('off')

plt.tight_layout()
plt.show()
input_list=[]
label_list=[]

for row in range(rows):
  for col in range(cols):
    data = sentinel_bands[:,row,col]
    label = ground_truth_labels[row,col]
    if label > 0 and np.sum(data) >0 :
      input_list.append(data)
      label_list.append(label)
print('number of valid inputs:',len(input_list))
print('number of valid labels:',len(label_list))
total_number_of_pixels=len(input_list)
X= np.zeros((total_number_of_pixels,bands),dtype='float32')
Y= np.zeros((total_number_of_pixels,),dtype='float32')

for i in range(len(input_list)):
  X[i,:]=input_list[i]
  Y[i]=label_list[i]

print('X shape:', X.shape)
print('Y shape:', Y.shape)
training_data=100000

indexes=np.arange(X.shape[0])

np.random.shuffle(indexes)

X=X[indexes]
Y=Y[indexes]

X=X[:training_data]
Y=Y[:training_data]

print('X shapefor Training:', X.shape)
print('Y shape for Training:', Y.shape)
train_split=0.8

indexes=np.arange(X.shape[0])
np.random.shuffle(indexes)

train_index=indexes[:int(train_split*X.shape[0])]
val_index=indexes[int(train_split*X.shape[0]):]

x_train=X[train_index]
x_val=X[val_index]

y_train=Y[train_index]
y_val=Y[val_index]

print('x_train shape:', x_train.shape)
print('y_train shape:', y_train.shape)
print('x_val shape:', x_val.shape)
print('y_val shape:', y_val.shape)
scaler= preprocessing.MinMaxScaler().fit(x_train)
x_train=scaler.transform(x_train)
x_val=scaler.transform(x_val)

print('x_train Max',x_train.max())
print('x_train Min',x_train.min())
print('x_val Max',x_val.max())
print('x_val Min',x_val.min())
from sklearn.metrics import accuracy_score,classification_report,f1_score

from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier

import seaborn as sns
models = [
    SVC(gamma='auto',C=0.8,kernel='rbf'),
    KNeighborsClassifier(n_neighbors=10,weights='uniform'),
    LogisticRegression(solver='lbfgs',C=1.0),
    RandomForestClassifier(n_estimators=300,max_depth=None,min_samples_split=2,min_samples_leaf=1),
    DecisionTreeClassifier(max_depth=None,min_samples_split=2,min_samples_leaf=1)
]
def score_model(x_train,y_train,x_test,y_test,model):
  model.fit(x_train,y_train)
  predicted= model.predict(x_test)
  accuracy=accuracy_score(y_test,predicted)
  print("{}Accuracy: {:.2%}".format(model.__class__.__name__,accuracy))
for model in models:
  score_model(x_train,y_train,x_val,y_val,model)
  rf_classifier=RandomForestClassifier(n_estimators=300,max_depth=None,min_samples_split=2,min_samples_leaf=1)
rf_classifier.fit(x_train,y_train)
y_pred=rf_classifier.predict(x_val)
accuracy = accuracy_score(y_val,y_pred)
print(f"Accuracy: {accuracy}")
class_names= ['tree cover', 'shrubland','grassland','cropland','built-up','bare/sparse vegetation', 'snow and ice','permanent water bodies']
print(classification_report(y_val,y_pred,target_names=class_names))
from sklearn.metrics import confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

cmat=confusion_matrix(y_val,y_pred)
class_name=['tree cover','shrubland','grassland','cropland','build-up','bare/sparse vegetation','snow and ice','permanent water bodies']
plt.figure(figsize=(5,3),dpi=150)
heatmap=sns.heatmap(cmat,annot=True,cmap='RdYlGn',linewidths=.2,yticklabels=class_name,xticklabels=class_names)
heatmap.set_yticklabels(class_name,size=5)
heatmap.set_xticklabels(class_names,size=5)
plt.ylabel('actual',fontsize=10,fontweight='bold')
plt.xlabel('predicted',fontsize=10,fontweight='bold')
plt.show()
from sklearn.ensemble import RandomForestClassifier

clf = RandomForestClassifier(n_estimators=100, random_state=42)
clf.fit(X_valid, y_valid)  # This must run before you predict
# Predict the entire image (even unlabeled) #added
y_full_pred = clf.predict(X_all)

# Reshape to image dimensions
prediction_image = y_full_pred.reshape(rows, cols)
plt.figure(figsize=(10, 6))
plt.imshow(prediction_image, cmap='tab10')  # Use 'terrain' or 'viridis' if preferred
plt.title("Predicted Land Cover Map (with NDVI)")
plt.axis('off')
plt.colorbar()
plt.show()
import numpy as np
import matplotlib.pyplot as plt
import rasterio
from google.colab import files

# 1. Upload the image
uploaded = files.upload()

# 2. Load the uploaded image using rasterio
import os
image_path = list(uploaded.keys())[0]  # Get the filename
with rasterio.open(image_path) as src:
    new_img = src.read()  # Shape: (bands, height, width)

# 3. Prepare the image for prediction
bands, rows, cols = new_img.shape
X_new = new_img.reshape(bands, -1).T  # Shape: (rows*cols, bands)
mask = np.sum(X_new, axis=1) > 0

# 4. Predict using the trained model
y_new_pred = np.full(X_new.shape[0], fill_value=-1)
y_new_pred[mask] = clf.predict(X_new[mask])

# 5. Reshape and visualize the prediction
prediction_image = y_new_pred.reshape(rows, cols)

plt.figure(figsize=(10, 6))
plt.imshow(prediction_image, cmap='tab10')
plt.title("Predicted Land Cover Map (New Image)")
plt.axis('off')
plt.colorbar(label='Class Index')
plt.show()
