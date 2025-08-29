
# Cochlear Implant Signal Processing – SYDE 252 Project

## Overview

This project implements a **filter bank–based audio processing pipeline** in MATLAB, inspired by the principles of cochlear implants.

Cochlear implants mimic how the human ear processes sound:

* The **basilar membrane** in the cochlea responds differently to frequencies, where **low frequencies** are sensed near the apex and **high frequencies** near the base.
* Importantly, the frequency distribution is **logarithmic, not linear** — humans perceive pitch changes in a logarithmic scale. For example, the perceptual difference between 200 Hz and 400 Hz (an octave) feels similar to the difference between 2000 Hz and 4000 Hz, even though the absolute frequency gap is much larger.

To simulate this, the project uses **logarithmically spaced filter banks** to decompose speech/audio into sub-bands, extract their envelopes, and reconstruct the sound with carriers at band center frequencies.

This replicates the core processing stages of a cochlear implant.

---

## Features

* **Logarithmic filter spacing (30 bands, 100–7999 Hz):** Mimics cochlear frequency mapping.
* **Bandpass filtering:** Decomposes audio into frequency channels.
* **Envelope detection:** Rectifies and low-pass filters signals.
* **Amplitude modulation:** Replaces fine structure with band-specific carriers.
* **Signal reconstruction:** Combines sub-band signals into a single output.
* **Error metrics:** Quantifies reconstruction quality using RMSE and PSNR.
* **Waveform plots:** Visualizes processed signals for analysis.

---

## Project Structure

```
.
├── Sounds
│   ├── Input Sounds       # Original input audio files
│   └── Output Sounds      # Reconstructed signals
├── Figures                # Saved waveform plots
├── main.m                 # Main script (provided code)
```

---

## Usage

1. Place input audio files inside:

   ```
   Sounds/Input Sounds/
   ```

2. Run the main MATLAB script:

   ```matlab
   main
   ```

3. The script will:

   * Process each input audio file.
   * Save reconstructed audio into `Sounds/Output Sounds/`.
   * Save waveform figures into `Figures/`.
   * Print a summary table of RMSE and PSNR values.

---

## Core Functions

* **`processAudio(file_path)`** – Loads audio, converts stereo → mono, resamples to 16 kHz, and saves waveform plots.
* **`filter_bank(N, logIntervals, Fs, audio)`** – Decomposes the signal into logarithmic frequency bands and extracts envelopes.
* **`bandpass_filter_windows_hamming(Fc1, Fc2, audio)`** – FIR bandpass filter design with Hamming window.
* **`calculateRMSE(signal1, signal2)`** – Computes root mean square error between original and reconstructed signals.
* **`calculatePSNR(original, reconstructed)`** – Computes peak signal-to-noise ratio.

---

## Example Output

After running, you’ll see a summary table like:

| File Name | RMSE  | PSNR (dB) |
| --------- | ----- | --------- |
| audio1    | 0.052 | 28.1      |
| audio2    | 0.064 | 27.3      |
| ...       | ...   | ...       |

It also reports **average RMSE** and **average PSNR** across all test files.

---

## Biological Motivation

The human ear does **not process frequencies linearly**:

* A 100 Hz difference at low frequencies (e.g., 200 → 300 Hz) is more perceptually significant than the same difference at high frequencies (e.g., 7000 → 7100 Hz).
* The cochlea’s **tonotopic map** follows an approximately logarithmic relationship between place on the basilar membrane and frequency.
* This is why the project uses **logarithmic spacing** for filter bands — to better approximate human hearing and cochlear implant design.

---

## Requirements

* MATLAB R2018a or later
* Signal Processing Toolbox

---

## Future Improvements

* Use the **Greenwood function** for more biologically accurate cochlear frequency mapping.
* Explore **Hilbert transform envelope detection** for improved resolution.
* Add perceptual evaluation metrics (e.g., speech intelligibility index).
* Enable **real-time signal processing** for live input.

---

📘 This project was developed for **SYDE 252 – Biomedical Engineering Systems**, focusing on simulating the signal processing pipeline of a **cochlear implant**.

---

Do you want me to also add a **diagram** (e.g., block diagram of the pipeline: Input → Filter Bank → Rectification → Envelope Detection → Carrier Modulation → Reconstruction)? It could make the README more visually clear.
