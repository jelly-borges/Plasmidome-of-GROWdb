# Introduction
This repository contains scripts, notebooks, and output files from my MS thesis project identifying and functionally characterizing the plasmidome in the
Genome Resolved Open Watersheds database (GROWdb).

## Plasmidome Datasets
Among the files are references to "unfiltered", "filtered", "default" calibrated", and "conservative" plasmid sets. These refer to five different protocols used to detect
plasmids using two different software: Platon and geNomad.
| Plasmid Detection Method | Protocol |
| ---------- | ---------------------------|
| **Unfiltered Platon** | Platon with "meta" tag |
| **Filtered Platon** | Unfiltered Platon but excluding circularity-only plasmids |
| **Default geNomad** | geNomad default parameters, no score calibration |
| **Calibrated geNomad** | geNomad with score calibration |
| **Conservative geNomad** | geNomad with score calibration and conservative parameters |
