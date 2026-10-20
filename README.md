# HF CS Processing — Bharath

**A modified version of Brian Emery's HF Radar Cross-Spectra Processing Toolbox**

`hf_cs_processing_bharath` is a MATLAB-based project for processing High-Frequency (HF) radar cross-spectra data using the CODAR SeaSonde processing workflow. This repository contains modifications to the original toolbox, focusing on understanding, debugging, and improving the processing pipeline used to generate radial velocity products.

## Overview

HF radar systems estimate ocean-surface currents by analyzing backscattered radio signals. Cross-spectra processing is an important step in extracting Doppler information, estimating the direction of arrival of radar echoes, and deriving radial current velocity observations.

This project explores the processing of SeaSonde cross-spectra data and the generation of radial data products in `.ruv` format.

## Objectives

- Understand and modify the original HF radar cross-spectra processing toolbox.
- Process CODAR SeaSonde cross-spectra data.
- Investigate Doppler-frequency and radial-velocity calculations.
- Examine first-order Bragg-region detection and spectral peak selection.
- Study direction-of-arrival estimation using MUSIC and other supported algorithms.
- Improve the consistency of generated radial files with reference CODAR outputs.
- Investigate radial metadata and quality-control fields.
- Document the complete processing pipeline and its function dependencies.

## Processing Workflow

The main entry point is `run_cs_processing.m`.

The general workflow includes:

1. **Configuration and initialization** — Configure radar-site parameters, input/output paths, and processing settings.
2. **Input discovery and loading** — Locate and load cross-spectra files and their associated headers.
3. **Time-window selection** — Select input files for the target processing time and averaging interval.
4. **Cross-spectra preprocessing** — Average the selected data and perform configured preprocessing.
5. **Doppler and radial-velocity calculations** — Construct frequency and radial-velocity axes from radar parameters.
6. **First-order region detection** — Identify candidate spectral peaks in the first-order Bragg regions.
7. **Direction-of-arrival estimation** — Estimate echo bearings using the configured algorithms and antenna-pattern information.
8. **Radial data assembly** — Combine detection results with range, bearing, velocity, and metadata.
9. **Output generation** — Save intermediate results and generate radial products through the applicable output-writing workflow.

The exact processing sequence depends on the implementation and configuration of the MATLAB functions.

## Key MATLAB Functions

| Function | Purpose |
|---|---|
| `run_cs_processing.m` | Main processing entry point |
| `cs_load.m` | Cross-spectra loading |
| `cs_average.m` | Cross-spectra averaging |
| `cs_ship_rm.m` | Ship-interference removal, where configured |
| `get_setup_data.m` | Extraction of radar setup parameters |
| `getVelocities.m` | Construction of the radial-velocity axis |
| `getDopplerVelocities.m` | Construction of Doppler-frequency and velocity arrays |
| `imageFOLs.m` | First-order region processing and candidate detection |
| `convert_fol_ix.m` | Conversion of first-order-region indices |
| `doa_on_cs.m` | DOA processing across range cells |
| `doa_on_range_cell.m` | DOA processing for an individual range cell |
| `make_cov.m` | Covariance-matrix construction |
| `run_doa_calculations.m` | Execution of configured DOA calculations |
| `get_radial_meta.m` | Assembly of radial metadata |

Refer to the source files for the authoritative implementation and complete function dependencies.

## Algorithms and Processing Concepts

The project investigates the following concepts where supported by the implemented workflow:

- **Doppler spectral analysis:** Relating Doppler frequency to radial velocity.
- **Bragg-region identification:** Locating first-order Bragg regions in HF radar spectra.
- **Spectral peak selection:** Identifying candidate detections for subsequent processing.
- **Direction-of-arrival estimation:** Estimating the bearing of detected echoes.
- **MUSIC:** Multiple Signal Classification for direction-of-arrival estimation.
- **Maximum-likelihood estimation:** An alternative or complementary DOA method, where configured.
- **Antenna-pattern processing:** Using measured antenna-pattern information in bearing estimation.
- **Radial data generation:** Assembling detection-level results into radial observations.

## Input Data

The workflow is designed around CODAR SeaSonde cross-spectra data and associated radar configuration information.

Depending on the selected processing configuration, inputs may include:

- Cross-spectra files (`.cs`).
- Shortened cross-spectra files (`.csr`), where supported.
- Antenna Pattern Measurement (APM) data.
- Radar configuration and file-header parameters.
- Reference radial files (`.ruv`) for comparison and validation.

The expected file naming conventions, header formats, and directory structure should be verified against the input-loading functions and the configuration in `run_cs_processing.m`.

## Output Data

Depending on the configured workflow, processing may produce intermediate MATLAB structures or `.mat` files and radial velocity products in CODAR `.ruv` format.

The radial products may contain fields related to:

- Range and bearing.
- Radial velocity.
- Signal-to-noise ratio.
- Error estimates and quality-control indicators.
- Geographic coordinates and radial metadata.

The availability and calculation of individual fields depend on the implementation. Quality-control values should be calculated or validated using the relevant source functions rather than assumed from the presence of a column.

## Requirements

- MATLAB.
- The project source files and required dependencies.
- Compatible CODAR SeaSonde cross-spectra input data.
- Appropriate antenna-pattern and radar configuration files.

Additional MATLAB toolboxes may be required depending on the functions used by the selected processing configuration.

## Getting Started

### 1. Clone the repository

Replace `<your-username>` with your GitHub username.

```bash
git clone https://github.com/<your-username>/hf_cs_processing_bharath.git
cd hf_cs_processing_bharath
