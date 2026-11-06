# Microwave Filter Design: Lumped Elements vs. Transmission Lines

## Project Overview

Designed and simulated lumped-element and distributed transmission-line filters in Keysight ADS to compare their frequency responses and explore how circuit transformations affect filter behavior.

## Design Methodology

1. **Butterworth low-pass prototype:** Used normalized g coefficients to establish the filter order, circuit layout, and component values.
2. **Lumped-element band-pass:** Applied frequency and impedance scaling to transform the low-pass prototype into an LC band-pass filter.
3. **Richards' transformation:** Replaced lumped components with open- and short-circuited transmission-line stubs.
4. **Kuroda's identities:** Added redundant transmission lines and transformed series stubs into shunt stubs for a more practical distributed implementation.

## Attachments

1. **insertion loss_lumped.png:** LC circuit simulated frequency response.
2. **schematic_lumped.png:** LC circuit schematic
3. **analytical_soln_TL.pdf:** Full work shown to get from lumped low pass to TL bandpass
4. **Kuroda-transformed filter:** Ideal transmission-line circuit using shunt stubs and connecting lines.

## Results and Interpretation

Compared insertion loss S(2,1) across implementations to evaluate passband behavior, cutoff frequency, and stopband attenuation.

An unexpected band-pass-like response appeared in the distributed filter initially designed as a low-pass network, motivating further investigation of stub terminations, circuit connections, and electrical lengths.

The project demonstrates the importance of verifying analytical filter designs through circuit simulation rather than assuming theoretical transformations guarantee the intended response.
