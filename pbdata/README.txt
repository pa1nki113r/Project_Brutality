matsys/materials.json:

 Material definition list
  - This file is where materials are defined. Here you can add bullet impact
    actors and footstep sounds.

  Every material is a sub-object that includes keys for "bulletimpact" and
  "footstep" by default.

matsys/textures.json:

 Texture definition list
  - This file is where textures are attached to materials.

  Add arrays containing texture names, named after the material type they belong
  to.

pda/meta.json:

 Meta reference file for PB PDA definitions
  - This file is where you will point the JSON parser to your PDA entries.
 
  It is organized into arrays of actor types that organized into tiers which
  store the path with files for the actual entry data.