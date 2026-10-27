# Engineering-Portfolio
This portfolio is dedicated to take a given problem, model it, analyze the results, validate it and explain the decision and assumptions made.


## HFSS Antenna Simulation


## ADS Rat Race Coupler Simulations
The goal for this project is how we can take an ideal transmission line design, translate it into a physical microstrip circuit, then evaluate what changes occur when we account for real ENM behavior.

3 distinct engineering skills involved:
1) **Analytical design:** Deriving transmission line impedences and electrical lengths in order to achieve a specified coupling ratio at a given frequency
2) **Physical implementation:** Converting ideal transmission lines into microstrip dimensions using the substrate and conductor properties
3) **EM validation:** Comparing the circuit level predictions with the actual electromagnetic response of the physical layout and explaining differences


## Python LIBS Research with ML
The goal of this project is to predict the composition of rocks (SiO2, TiO2, Al2O3, Fe2O3, MgO, CaO, Na2O and K2O in wt%) from laser induced breakdown spectroscopy (LIBS) spectra collected in a lab under lunar conditions. The algorithm takes the wavelengths and intensities at each wavelength as an input and will output the wt% from a regression problem.

Four distinct skills are involved:
1) **Physics informed preprocessing:** Normalizing over each of the spectrometer ranges independently, and checking emission lines from the NIST atomic dataset to line up with measured peaks.
2) **Physically grounded dimensionality reduction:** Built wavelength masks for each element from the NIST spectra. One regression calibration trained for each oxide, used the spectra of the oxide on its own to mask the original data respectively. Then, tested to see if the restricted data holds accuracy
3) **Leakage free evaluation:** Several spectra of the same rocks exist in the dataset, grouping those repeated pellets so they don't show up in training and testing sets. Test set made up of compositions that mirror training set and held out until the end. Hyperparameter tuning completed on training data using random search and scoring the test set once with bootstrap confidence intervals.
4) **Model comparison with hyperparameter optimization:** Based on previous research informed the models used to test different parameters and dimensionality reduction techniques. Best performance found with GBR, kept PLS since that is industry standard. Tuned both with grouped cross validation.


## MATLAB FMCW Simulation

## SystemVerilog ALU

