# Student Satellite Project - Indian Institude of Technology, Bombay

## Star Tracker-based Attitude Determination System (STADS)

## Star Catalogue

### Author - KT Prajwal Prathiksh

We currently use the SKY2000 Star Catalogue.

*Refer:* http://tdc-www.harvard.edu/software/catalogs/sky2k.html

The following data fields of the SKY2000 Catalogue are used:

1. SKY2000 - *Identifier based on J2000 position*
1. RAJ2000 - *Right ascension (J2000) hours - ("h - m - s")*
1. DEJ2000 - *Declination degrees (J2000) - ("d - m - s")*
1. pmRA - *Proper motion in RA (J2000) - second per year*
1. pmDE - *Proper motion in Dec (J2000) - second of arc per year*
1. Vmag - *Photometric magnitude - (Optical V band between 500 and 600 nm)*

The catalogues are classified as follows:
* **SKY2000.csv :** Comprises of all the aforementioned datafields (unaltered), obtained from - http://vizier.u-strasbg.fr/viz-bin/VizieR-3?-source=V/145

* **Master_Star_Catalogue.csv :** Same as *SKY2000.csv* except for the following changes:
	1. **RAJ2000** is split into **RA_h**, **RA_m**, and **RA_s**
	1. **DEJ2000** is split into **DE_d**, **DE_m**, and **DE_s**

* **SSP_Star_Catalogue.csv :** Same as *Master_Star_Catalogue.csv*, which has been sorted based on *'Vmag'* field, in addition to the following changes:
	1. **RA_h**, **RA_m**, and **RA_s** is merged to create **RA** field - degrees
	1. **DE_d**, **DE_m**, and **DE_s** is merged to create **DE** field - degrees
	1. **SSP_ID** - Fictitious identifier created for stars, which is essentially the position of the stars after being sorted according to *'Vmag'*