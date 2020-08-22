# Sensor Model
##  Simulation - 2
### Status - DO NOT USE

**Simulation Run by:** Neilabh Banzal
**Simulation Run  Requested by:** Aravind Bharathi
**Date of Simulation:** 4th June, 2020
**Reviewer:** Neilabh Banzal
**Date of Review:**	4th June, 2020

**Permanent Links:** [The Repository Commit]()

**QA suggestions:**
1. The coordinates taken are incorrect (by comparing the estimated centroids from Feature Extraction and the actual centoids)

**Implementation:**
1.  The coordinate calculation before Image Generation has been corrected. Previously, the axes for Image Generation was set at the centre of the First Pixel assuming it is at (0,0), which is incorrect, as it is aat (1,1). So, the actual centre will be at a point 0.5 pixels to the left and 0.5 pixels to the top of the left top vertex of the Sensor Frame. 

**Post-QA Permanent Links:** [The Repository Commit]()