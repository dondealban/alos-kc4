{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 /* \
 * This script sets up ALOS/PALSAR-1 and ALOS/PALSAR-2 images over Sibuyan Island, Romblon \
 * Province, Philippines at three time points for the years 2007, 2010, and 2015. The SAR \
 * images were classified at Level 1 of a multi-level, hierarchical classification system\
 * with 2 classes namely: Forest, Non-Forest.\
 */\
\
/*******************************\
  DEFINE RANDOM SEED\
********************************/\
\
var seed = 2015;\
\
\
/*******************************\
  DEFINE EXTENT AND VIEW\
********************************/\
\
// Set center of map view\
Map.setCenter(122.57789, 12.40841, 10); // Zoom in and center display to study area\
\
// Define and display box covering extent of PALSAR tile\
var box = ee.Geometry.Rectangle(122.419,12.51, 122.705,12.26);\
Map.addLayer(box, \{'color': 'FF0000'\}, 'Box Extents', false);\
\
\
/*******************************\
  LOAD DATASETS\
********************************/\
\
// Load PALSAR sigma-naught images (units in dB)\
var hh2007 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2007_PALSAR_HH_Sigma0').clip(box); // 2007 HH polarisation\
var hv2007 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2007_PALSAR_HV_Sigma0').clip(box); // 2007 HV polarisation\
var hh2010 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2010_PALSAR_HH_Sigma0').clip(box); // 2010 HH polarisation\
var hv2010 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2010_PALSAR_HV_Sigma0').clip(box); // 2010 HV polarisation\
var hh2015 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2015_PALSAR_HH_Sigma0').clip(box); // 2015 HH polarisation\
var hv2015 = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_2015_PALSAR_HV_Sigma0').clip(box); // 2015 HV polarisation\
\
// Load combined mask image\
var coMask = ee.Image('users/dondealban/Philippines/ALOSKC4/SBY/Sibuyan_PALSAR_Mask_Combined').clip(box); // Combined Mask\
\
\
/*******************************\
  GENERATE INDICES\
********************************/\
\
// Generate ratio indices\
var rat2007 = hh2007.divide(hv2007);\
var rat2010 = hh2010.divide(hv2010);\
var rat2015 = hh2015.divide(hv2015);\
\
// Generate normalised difference index (NDI, Saatchi et al. 2011)\
var ndi2007 = (hh2007.subtract(hv2007)).divide(hh2007.add(hv2007));\
var ndi2010 = (hh2010.subtract(hv2010)).divide(hh2010.add(hv2010));\
var ndi2015 = (hh2015.subtract(hv2015)).divide(hh2015.add(hv2015));\
\
// Generate NL index (NL, Li et al. 2012)\
var nli2007 = (hh2007.multiply(hv2007)).divide(hh2007.add(hv2007));\
var nli2010 = (hh2010.multiply(hv2010)).divide(hh2010.add(hv2010));\
var nli2015 = (hh2015.multiply(hv2015)).divide(hh2015.add(hv2015));\
\
\
/*******************************\
  CALCULATE TEXTURES\
********************************/\
\
// Rescale floating point to integer\
var scaledhh2007 = hh2007.expression('1000*b("b1")').int32();\
var scaledhv2007 = hh2007.expression('1000*b("b1")').int32();\
var scaledhh2010 = hh2010.expression('1000*b("b1")').int32();\
var scaledhv2010 = hh2010.expression('1000*b("b1")').int32();\
var scaledhh2015 = hh2015.expression('1000*b("b1")').int32();\
var scaledhv2015 = hh2015.expression('1000*b("b1")').int32();\
\
// Rename rescaled Sigma0 channels\
scaledhh2007 = scaledhh2007.rename('HH');\
scaledhv2007 = scaledhv2007.rename('HV');\
scaledhh2010 = scaledhh2010.rename('HH');\
scaledhv2010 = scaledhv2010.rename('HV');\
scaledhh2015 = scaledhh2015.rename('HH');\
scaledhv2015 = scaledhv2015.rename('HV');\
\
// Stack rescaled Sigma0 channels\
var dual2007 = scaledhh2007.addBands(scaledhv2007);\
var dual2010 = scaledhh2010.addBands(scaledhv2010);\
var dual2015 = scaledhh2015.addBands(scaledhv2015);\
\
// Calculate GLCM texture measures\
var textureMeasures = ['HH_asm', 'HH_contrast', 'HH_corr', 'HH_var', 'HH_idm', 'HH_savg', 'HH_ent', 'HH_diss',\
                       'HV_asm', 'HV_contrast', 'HV_corr', 'HV_var', 'HV_idm', 'HV_savg', 'HV_ent', 'HV_diss'];\
var glcm2007 = dual2007.glcmTexture(\{size: 3, average: true \}).select(textureMeasures);  // 7x7 kernel\
var glcm2010 = dual2010.glcmTexture(\{size: 3, average: true \}).select(textureMeasures);  // 7x7 kernel\
var glcm2015 = dual2015.glcmTexture(\{size: 3, average: true \}).select(textureMeasures);  // 7x7 kernel\
\
\
/*******************************\
  CREATE COMPOSITE STACK\
********************************/\
\
// Rename 2007 band filenames in metadata\
hh2007  = hh2007.rename('HH');\
hv2007  = hv2007.rename('HV');\
rat2007 = rat2007.rename('RAT');\
ndi2007 = ndi2007.rename('NDI');\
nli2007 = nli2007.rename('NLI');\
\
// Rename 2010 band filenames in metadata\
hh2010  = hh2010.rename('HH');\
hv2010  = hv2010.rename('HV');\
rat2010 = rat2010.rename('RAT');\
ndi2010 = ndi2010.rename('NDI');\
nli2010 = nli2010.rename('NLI'); \
\
// Rename 2015 band filenames in metadata\
hh2015  = hh2015.rename('HH');\
hv2015  = hv2015.rename('HV');\
rat2015 = rat2015.rename('RAT');\
ndi2015 = ndi2015.rename('NDI');\
nli2015 = nli2015.rename('NLI'); \
\
// Create image collection from images\
var stackSAR2007 = hh2007.addBands(hv2007).addBands(rat2007).addBands(ndi2007).addBands(nli2007).addBands(glcm2007);\
var stackSAR2010 = hh2010.addBands(hv2010).addBands(rat2010).addBands(ndi2010).addBands(nli2010).addBands(glcm2010);\
var stackSAR2015 = hh2015.addBands(hv2015).addBands(rat2015).addBands(ndi2015).addBands(nli2015).addBands(glcm2015);\
var bandsSAR = ['HH', 'HV', 'RAT', 'NDI', 'NLI',\
                'HH_asm', 'HH_contrast', 'HH_corr', 'HH_var', 'HH_idm', 'HH_savg', 'HH_ent', 'HH_diss',\
                'HV_asm', 'HV_contrast', 'HV_corr', 'HV_var', 'HV_idm', 'HV_savg', 'HV_ent', 'HV_diss'];\
\
\
/*******************************\
  DEFINE REGIONS OF INTEREST\
********************************/\
\
var sibuyanROI = ee.FeatureCollection('users/dondealban/Philippines/ALOSKC4/SBY/sibuyan-landcover-roi');\
Map.addLayer(sibuyanROI, \{'color': '1E90FF'\}, 'Sibuyan ROI');\
\
// Initialise random column and values for ROI feature collection \
sibuyanROI = sibuyanROI.randomColumn('random', seed);\
\
// Create training and testing regions of interest from the image dataset\
var roi2007 = stackSAR2007.select(bandsSAR).sampleRegions(\{\
	collection: sibuyanROI,\
	properties: ['ClassID1', 'random'],\
	scale: 25\
\});\
var roi2010 = stackSAR2010.select(bandsSAR).sampleRegions(\{\
	collection: sibuyanROI,\
	properties: ['ClassID1', 'random'],\
	scale: 25\
\});\
var roi2015 = stackSAR2015.select(bandsSAR).sampleRegions(\{\
	collection: sibuyanROI,\
	properties: ['ClassID1', 'random'],\
	scale: 25\
\});\
\
// Partition the regions of interest into training and testing areas\
var train2007 = roi2007.filter(ee.Filter.lte('random', 0.7));\
var tests2007 = roi2007.filter(ee.Filter.gt('random', 0.7));\
var train2010 = roi2010.filter(ee.Filter.lte('random', 0.7));\
var tests2010 = roi2010.filter(ee.Filter.gt('random', 0.7));\
var train2015 = roi2015.filter(ee.Filter.lte('random', 0.7));\
var tests2015 = roi2015.filter(ee.Filter.gt('random', 0.7));\
\
// Print number of regions of interest for training and testing at the console \
print('Training, n =', train2015.aggregate_count('.all'));\
print('Testing, n =',  tests2015.aggregate_count('.all'));\
\
\
/*******************************\
  EXECUTE CLASSIFICATION\
********************************/\
\
// 2007\
\
// Classification using Random Forest algorithm\
var classifier2007 = ee.Classifier.randomForest(100,0,10,0.5,false,seed).train(\{\
  features: train2007.select(['HH', 'HV', 'RAT', 'NDI', 'NLI',\
                              'HH_asm', 'HH_contrast', 'HH_corr', 'HH_var', 'HH_idm', 'HH_savg', 'HH_ent', 'HH_diss',\
                              'HV_asm', 'HV_contrast', 'HV_corr', 'HV_var', 'HV_idm', 'HV_savg', 'HV_ent', 'HV_diss',\
                              'ClassID1']),\
  classProperty: 'ClassID1', \
  inputProperties: bandsSAR\
\});\
\
// Classify the validation data\
var validation2007 = tests2007.classify(classifier2007);\
\
// Calculate accuracy metrics\
var em2007 = validation2007.errorMatrix('ClassID1', 'classification'); // Error matrix\
var oa2007 = em2007.accuracy(); // Overall accuracy\
var ua2007 = em2007.consumersAccuracy().project([1]); // Consumer's accuracy\
var pa2007 = em2007.producersAccuracy().project([0]); // Producer's accuracy\
var fs2007 = (ua2007.multiply(pa2007).multiply(2.0)).divide(ua2007.add(pa2007)); // F1-statistic\
\
print('Error Matrix, 2007:', em2007);\
print('OA, 2007:', oa2007);\
print('UA, 2007 (rows):', ua2007);\
print('PA, 2007 (cols):', pa2007);\
print('F1, 2007: ', fs2007);\
\
// Classify the image Random Forest algorithm\
var classified2007 = stackSAR2007.select(bandsSAR).classify(classifier2007);\
\
\
// 2010\
\
// Classification using Random Forest algorithm\
var classifier2010 = ee.Classifier.randomForest(100,0,10,0.5,false,seed).train(\{\
  features: train2010.select(['HH', 'HV', 'RAT', 'NDI', 'NLI',\
                              'HH_asm', 'HH_contrast', 'HH_corr', 'HH_var', 'HH_idm', 'HH_savg', 'HH_ent', 'HH_diss',\
                              'HV_asm', 'HV_contrast', 'HV_corr', 'HV_var', 'HV_idm', 'HV_savg', 'HV_ent', 'HV_diss',\
                              'ClassID1']),\
  classProperty: 'ClassID1', \
  inputProperties: bandsSAR\
\});\
\
// Classify the validation data\
var validation2010 = tests2010.classify(classifier2010);\
\
// Calculate accuracy metrics\
var em2010 = validation2010.errorMatrix('ClassID1', 'classification'); // Error matrix\
var oa2010 = em2010.accuracy(); // Overall accuracy\
var ua2010 = em2010.consumersAccuracy().project([1]); // Consumer's accuracy\
var pa2010 = em2010.producersAccuracy().project([0]); // Producer's accuracy\
var fs2010 = (ua2010.multiply(pa2010).multiply(2.0)).divide(ua2010.add(pa2010)); // F1-statistic\
\
print('Error Matrix, 2010:', em2010);\
print('OA, 2010:', oa2010);\
print('UA, 2010 (rows):', ua2010);\
print('PA, 2010 (cols):', pa2010);\
print('F1, 2010: ', fs2010);\
\
// Classify the image Random Forest algorithm\
var classified2010 = stackSAR2010.select(bandsSAR).classify(classifier2010);\
\
\
// 2015\
\
// Classification using Random Forest algorithm\
var classifier2015 = ee.Classifier.randomForest(100,0,10,0.5,false,seed).train(\{\
  features: train2015.select(['HH', 'HV', 'RAT', 'NDI', 'NLI',\
                              'HH_asm', 'HH_contrast', 'HH_corr', 'HH_var', 'HH_idm', 'HH_savg', 'HH_ent', 'HH_diss',\
                              'HV_asm', 'HV_contrast', 'HV_corr', 'HV_var', 'HV_idm', 'HV_savg', 'HV_ent', 'HV_diss',\
                              'ClassID1']),\
  classProperty: 'ClassID1', \
  inputProperties: bandsSAR\
\});\
\
// Classify the validation data\
var validation2015 = tests2015.classify(classifier2015);\
\
// Calculate accuracy metrics\
var em2015 = validation2015.errorMatrix('ClassID1', 'classification'); // Error matrix\
var oa2015 = em2015.accuracy(); // Overall accuracy\
var ua2015 = em2015.consumersAccuracy().project([1]); // Consumer's accuracy\
var pa2015 = em2015.producersAccuracy().project([0]); // Producer's accuracy\
var fs2015 = (ua2015.multiply(pa2015).multiply(2.0)).divide(ua2015.add(pa2015)); // F1-statistic\
\
print('Error Matrix, 2015:', em2015);\
print('OA, 2015:', oa2015);\
print('UA, 2015 (rows):', ua2015);\
print('PA, 2015 (cols):', pa2015);\
print('F1, 2015: ', fs2015);\
\
// Classify the image Random Forest algorithm\
var classified2015 = stackSAR2015.select(bandsSAR).classify(classifier2015);\
\
\
/*******************************\
  FILTER CLASSIFICATION\
********************************/\
\
// Increase land cover class values by 1\
classified2007 = classified2007.add(1);\
classified2010 = classified2010.add(1);\
classified2015 = classified2015.add(1);\
\
// Perform a mode filter on the classified image\
var filtered2007 = classified2007.reduceNeighborhood(\{\
  reducer: ee.Reducer.mode(),\
  kernel: ee.Kernel.square(1),\
\});\
var filtered2010 = classified2010.reduceNeighborhood(\{\
  reducer: ee.Reducer.mode(),\
  kernel: ee.Kernel.square(1),\
\});\
var filtered2015 = classified2015.reduceNeighborhood(\{\
  reducer: ee.Reducer.mode(),\
  kernel: ee.Kernel.square(1),\
\});\
\
\
/*******************************\
  APPLY MASK  \
********************************/\
\
// Apply combined mask to filtered classified images\
var masked2007 = filtered2007.updateMask(coMask);\
var masked2010 = filtered2010.updateMask(coMask);\
var masked2015 = filtered2015.updateMask(coMask);\
\
\
/*******************************\
  DISPLAY RGB COMPOSITES\
********************************/\
\
// Display combined mask\
var maskPalette = ['000000', 'ffffff']; // Palette for combined mask image\
Map.addLayer(coMask, \{min: 0, max: 1, palette: maskPalette\}, 'Mask', false);\
\
// Display RGB composites of PALSAR mosaic data at three time points\
Map.addLayer(hh2007.addBands(hv2007).addBands(rat2007), \{min: [-30, -30, -5], max: [0, 0, 5]\}, 'PALSAR 2007', false);\
Map.addLayer(hh2010.addBands(hv2010).addBands(rat2010), \{min: [-30, -30, -5], max: [0, 0, 5]\}, 'PALSAR 2010', false);\
Map.addLayer(hh2015.addBands(hv2015).addBands(rat2015), \{min: [-30, -30, -5], max: [0, 0, 5]\}, 'PALSAR 2015', false);\
\
\
/*******************************\
  DISPLAY CLASSIFICATION \
********************************/\
\
// Display classified image\
var classPalette = ['66ccff',  // No data\
                    '246a24',  // Forest\
                    'ccff66']; // Non-Forest\
Map.addLayer(masked2007, \{min: 0, max: 2, palette: classPalette\}, '2007 Classification',  true);\
Map.addLayer(masked2010, \{min: 0, max: 2, palette: classPalette\}, '2010 Classification',  true);\
Map.addLayer(masked2015, \{min: 0, max: 2, palette: classPalette\}, '2015 Classification',  true);\
\
\
/*******************************\
  EXPORT IMAGES &  TABLES\
********************************/\
\
// Export masked filtered classified images\
Export.image.toDrive(\{\
  image: masked2007.uint8(), \
  description: 'Classification_Sibuyan_2007_L1',\
  folder: 'Google Earth Engine',\
  region: box,\
  scale: 25,\
  maxPixels: 300000000,\
\});\
Export.image.toDrive(\{\
  image: masked2010.uint8(), \
  description: 'Classification_Sibuyan_2010_L1',\
  folder: 'Google Earth Engine',\
  region: box,\
  scale: 25,\
  maxPixels: 300000000,\
\});\
Export.image.toDrive(\{\
  image: masked2015.uint8(), \
  description: 'Classification_Sibuyan_2015_L1',\
  folder: 'Google Earth Engine',\
  region: box,\
  scale: 25,\
  maxPixels: 300000000,\
\});\
\
// Export computed statistics as csv file\
Export.table.toDrive(roi2007, 'ROI_Sibuyan_2007_L1', 'Google Earth Engine');\
Export.table.toDrive(roi2010, 'ROI_Sibuyan_2010_L1', 'Google Earth Engine');\
Export.table.toDrive(roi2015, 'ROI_Sibuyan_2015_L1', 'Google Earth Engine');\
Export.table.toDrive(train2007, 'Training_Sibuyan_2007_L1', 'Google Earth Engine');\
Export.table.toDrive(train2010, 'Training_Sibuyan_2010_L1', 'Google Earth Engine');\
Export.table.toDrive(train2015, 'Training_Sibuyan_2015_L1', 'Google Earth Engine');\
Export.table.toDrive(validation2007, 'Validation_Sibuyan_2007_L1', 'Google Earth Engine');\
Export.table.toDrive(validation2010, 'Validation_Sibuyan_2010_L1', 'Google Earth Engine');\
Export.table.toDrive(validation2015, 'Validation_Sibuyan_2015_L1', 'Google Earth Engine');\
\
// Export accuracy assessment results\
var aa2007 = ee.Feature(null, \{\
  training: train2007.aggregate_count('.all'),\
  testing: tests2007.aggregate_count('.all'),\
  matrix: em2007.array(),\
  accuracy: oa2007,\
  consumersAccuracy: ua2007,\
  producersAccuracy: pa2007,\
\});\
Export.table.toDrive(\{\
  collection: ee.FeatureCollection(aa2007),\
  description: 'AA_Sibuyan_2007_L1',\
  fileFormat: 'CSV',\
  folder: 'Google Earth Engine',\
\});\
var aa2010 = ee.Feature(null, \{\
  training: train2010.aggregate_count('.all'),\
  testing: tests2010.aggregate_count('.all'),\
  matrix: em2010.array(),\
  accuracy: oa2010,\
  consumersAccuracy: ua2010,\
  producersAccuracy: pa2010,\
\});\
Export.table.toDrive(\{\
  collection: ee.FeatureCollection(aa2010),\
  description: 'AA_Sibuyan_2010_L1',\
  fileFormat: 'CSV',\
  folder: 'Google Earth Engine',\
\});\
var aa2015 = ee.Feature(null, \{\
  training: train2015.aggregate_count('.all'),\
  testing: tests2015.aggregate_count('.all'),\
  matrix: em2015.array(),\
  accuracy: oa2015,\
  consumersAccuracy: ua2015,\
  producersAccuracy: pa2015,\
\});\
Export.table.toDrive(\{\
  collection: ee.FeatureCollection(aa2015),\
  description: 'AA_Sibuyan_2015_L1',\
  fileFormat: 'CSV',\
  folder: 'Google Earth Engine',\
\});\
\
}