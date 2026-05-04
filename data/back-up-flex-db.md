Instructions for backing up a FLEx DB in its entirety.

Note: as of 5/4/26, the APS Tunica project uses FLEx version 9.1.

# Create backup

1. Open the FLEx DB that you want to back up.
2. Click File -> Project Management -> Back up this project...
3. This will produce a .fwbackup file including interlinear text, lexicon, and (presumably) whatever other info is stored in your database.

# Import/view a backup

1. In FLEx, click File -> Project management -> Restore a project.
2. Select Another location, then Browse... Navigate to your .fwbackup file, click on it, and click Open.
3. Change whatever settings you want to change and click OK to open your project.

# Notes

To export interlinear text only, click into the Interlinear Texts section of Texts & Words, select Verifiable generic XML, click Export..., and select the pages/notebooks that you want to export.

This will NOT preserve the Lexicon section of the database. To back this up, click into Lexicon, click Export, and select your desired export format.

If you want to export info from other sections (like Grammar or Lists), you'll probably need to follow a similar process.