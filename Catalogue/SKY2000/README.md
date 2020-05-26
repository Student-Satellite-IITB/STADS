# STADS

## Star Catalogue

We currently use the SKY2000 Star Catalogue.

*Refer:* http://tdc-www.harvard.edu/software/catalogs/sky2k.html

The following data fields of the SKY2000 Catalogue are used:

1. SKY2000 - *Identifier based on J2000 position*
1. RAJ2000 - *Right ascension (J2000) hours - ("h - m - s")*
1. DEJ2000 - *Declination degrees (J2000) - ("d - m - s")*
1. pmRA - *Proper motion in RA (J2000) - second per year*
1. pmDE - *Proper motion in Dec (J2000) - second of arc per year*
1. Vmag - *Photometric magnitude - (Optical V band between 500 and 600 nm)*
1. B-V - *Color index or magnitude difference - (Optical V band between 500 and 600 nm; Optical B band between 400 and 500 nm)*

The catalogues are classified as follows:
* **SKY2000.csv :** Comprises of all the aforementioned datafields (unaltered), obtained from - http://vizier.u-strasbg.fr/viz-bin/VizieR-3?-source=V/145

* **Master_Star_Catalogue.csv :** Same as *SKY2000.csv* except for the following changes:
	1. **RAJ2000** is split into **RA_h**, **RA_m**, and **RA_s**
	1. **DEJ2000** is split into **DE_d**, **DE_m**, and **DE_s**

* **SSP_Star_Catalogue.csv :** Same as *Master_Star_Catalogue.csv*, which has been sorted based on *'Vmag'* field, in addition to the following changes:
	1. **RA_h**, **RA_m**, and **RA_s** is merged to create **RA** field - degrees
	1. **DE_d**, **DE_m**, and **DE_s** is merged to create **DE** field - degrees
	1. **SSP_ID** - Fictitious identifier created for stars, which is essentially the position of the stars after being sorted according to *'Vmag'*

* **Guide_Star_Catalogue.csv :** This Catalogue has been generated specifically for the purpose of Star Matching. It contains the following data fields:
	1. **SSP_ID** - The fictitious identifier of all those stars which satisfy the condition, that their **Vmag** is <= the Limiting Magnitude (= 6)
	1. **[X, Y, Z]** - The Cartesian unit vector representation of each star generated from its Right-Ascension and Declination coordinate. The (X, Y, Z) coordinate system definition corresponds to the projection of the Earth’ North Pole onto the celestial sphere as the Z-axis, and the vernal equinox as the X-axis,at epoch ICRS2000, with the Y-axis completing the right-handed orthonormal coordinate system: Z = X \times Y

* **Preprocessed_Star_Catalogue.csv :** This Catalogue has been generated specifically for the purpose of Star Matching. It contains the following data fields:
	1.**SSP_ID_1** - The SSP-ID of (i-th) star
	1.**SSP_ID_2** - The SSP-ID of (j-th) star
	1. **AngDst_cos** - The dot product of the Cartesian unit vector corresponding to the (i-th) and (j-th) star
	1. **AngDst_deg** - The cos inverse of the corresponding dot product value in degrees
	* This catalogue has only those pairs of stars whose **AngDst_deg** is <= the circular Field-of-View (=16 degrees)


A detailed README of the SKY2000 catalogue is also present.
*Refer:* http://data.bao.ac.cn/ftp/cats/5/109/sky2kv4.pdf  
