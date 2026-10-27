# Detailed walkthrough of notebooks

Both notebooks are working through the same problem and share the same preprocessing, so their results are comparable and parallel.

## Shared preprocessing
1) **Composition quality filter:** kept samples whose wt% for total oxides fall between 96% and 105%
2) **Compositional outp=lier removal:** Flags extreme compositions based on the Lunar Guidebook, removes 130 samples.
3) **Normalization:** Divided each spectrometer range (UV 240-351nm, VIS 370-479nm, and VNIR 508-859nm) by its own sum of intensities. This is a standard ChemCam approach, only works on one spectra at a time so no leakage.
4) **Repeat pellet groupings:** Samples with the same compositions share a single group so they neevr end up on different sides of the train/test split

--------
## NISTalign.ipynb: are the NIST emission lines for individual spectra where the data says they are?
**The problem:** Each spectra has 15,498 channels and most of them are noise and not independent of each other. To reduce the dimensionality of this in a physically informed way, only keep regions where each element emits.

**What it does:** Finds simulations of the spectra from NIST database, overlays those ranges of interest with the LIBS spectra. Use wide wavelength masks for each of the element that covers the NIST speak at or above 5% of the tallest peak in the spectral range. Then, builds a combined mask of all the areas of interest for each oxide.

**Outputs:** MASKS (wavelength windows per element), the overlaying figures, and the channel counts for each mask.

**Limitations:**
- NIST files are simulations and are not completely accurate for this real world setting that has noise and instrument error
- Some windows were determined by hand


________
## diffModelsDimReduc.ipynb: does masking help the model?
**The problem:** If the SiO2 model only looks at the silicon emission regions, will it perform better? Or is it dependent on other elements' lines.

**What it does:** Tests the masks from NISTalign fairly. Does this with a held out test set (15% of data). Each trial has three feature sets per oxide: its own element mask, the combined mask, and the full spectra. It then does a hyperparameter tuning on the training data with a randomized search and 5 fold grouped CV.

**Findings and results:** Plasma conditions and matrix affects link an elements signal to the rest of the sample. The mask costs accuracy but improves runtime and simplification. This begs the question, is accuracy to a degree more important than instantaneous computation and faster training?

**Limitations:**
- Comparison only focuses on one laster energy (7.2mJ), but the laser can scatter and come in contact with other particles. This leads to my next analysis, how accuracy changes with varying laser powers and if the model generalizes better with training data that varies with power.
