class PB_Materialsys : StaticEventHandler
{  
    map<int, name> materialKeyMap;
    array<int> materialRanges;
    array<string> textureNames;
    int lastMaterialKey;
    
    // format: 
    // range from, range to, key
    // key is used for identifying material type
    void SetupMaterial(array<string> refArray, name materialId)
    {
        // console.printf("PB_Materialsys: Setting up %s...", materialId);
        // push initial range
        materialRanges.Push(textureNames.Size());

        // dump textures in the names array
        for (int i = 0; i < refArray.Size(); i++) 
        {
            textureNames.Push(refArray[i].MakeLower());
            //console.printf("PB_Materialsys: Texture %s added to %s", refArray[i], materialId);
        }

        // push end range
        materialRanges.Push(textureNames.Size() - 1);

        // setup material key and add it to the key map
        lastMaterialKey++;
        materialRanges.Push(lastMaterialKey);
        materialKeyMap.Insert(lastMaterialKey, materialId);

        //console.printf("PB_Materialsys: %s takes range %i..%i, with a key of %i.", materialId, materialRanges[materialRanges.Size() - 3], materialRanges[materialRanges.Size() - 2], materialRanges[materialRanges.Size() - 1]);
        console.printf("PB_Materialsys: Finished setting up %s.", materialId);
    }

    clearscope static name GetMaterialFromTexName(string texName)
    {
        PB_Materialsys seh = PB_Materialsys(PB_Materialsys.Find("PB_Materialsys"));
        int matindex;

        texName = texName.MakeLower();

        for(int i = 0; i < seh.textureNames.Size(); i++)
        {
            if(texName.IndexOf(seh.textureNames[i]) == 0)
            {
                matIndex = i;
                break;
            }
        }

        // [gng] double check here or else it plays WATER sounds
        if(texName.IndexOf(seh.textureNames[matindex]) < 0)
            return 'err_nomaterialfound';

        // i = from range
        // i + 1 = to range
        // I + 2 = material key
        for(int i = 0; i < seh.materialRanges.Size(); i += 3)
        {
            // console.printf("%i %i %i", seh.materialRanges[i], seh.materialRanges[i + 1], seh.materialRanges[i + 2]);
            if(matIndex >= seh.materialRanges[i] && matIndex <= seh.materialRanges[i + 1])
            {
                // console.printf("%s", seh.materialKeyMap.GetIfExists(seh.materialRanges[i + 2]));
                return seh.materialKeyMap.GetIfExists(seh.materialRanges[i + 2]);
            }
        }

        return 'err_escapedloop';
    }

    // generate the tables
    override void OnRegister()
    {
        console.printf("PB_Materialsys: Setting up material system.");
        double startTime = MsTimeF();

        array<string> texnamesBuf;

        for (int i = 0; i < FLATS_WATER.Size(); i++) 
			texnamesBuf.Push(FLATS_WATER[i]);
        SetupMaterial(texnamesBuf, "water");
        texnamesBuf.Clear();

        for (int i = 0; i < FLATS_SLIME.Size(); i++) 
			texnamesBuf.Push(FLATS_SLIME[i]);
        SetupMaterial(texnamesBuf, "slime");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_FLESH.Size(); i++) 
			texnamesBuf.Push(FLATS_FLESH[i]);
        SetupMaterial(texnamesBuf, "flesh");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_LAVA.Size(); i++) 
            texnamesBuf.Push(FLATS_LAVA[i]);
        SetupMaterial(texnamesBuf, "lava");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_ROCK.Size(); i++) 
			texnamesBuf.Push(FLATS_ROCK[i]);
        SetupMaterial(texnamesBuf, "rock");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_WOOD.Size(); i++) 
			texnamesBuf.Push(FLATS_WOOD[i]);
        SetupMaterial(texnamesBuf, "wood");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_TILEA.Size(); i++) 
			texnamesBuf.Push(FLATS_TILEA[i]);
        SetupMaterial(texnamesBuf, "tile/a");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_TILEB.Size(); i++) 
			texnamesBuf.Push(FLATS_TILEB[i]);
        SetupMaterial(texnamesBuf, "tile/b");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_HARD.Size(); i++) 
			texnamesBuf.Push(FLATS_HARD[i]);
        SetupMaterial(texnamesBuf, "hard");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_CARPET.Size(); i++) 
			texnamesBuf.Push(FLATS_CARPET[i]);
        SetupMaterial(texnamesBuf, "carpet");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_METALA.Size(); i++) 
			texnamesBuf.Push(FLATS_METALA[i]);
        SetupMaterial(texnamesBuf, "metal/a");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_METALB.Size(); i++) 
			texnamesBuf.Push(FLATS_METALB[i]);
        SetupMaterial(texnamesBuf, "metal/b");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_DIRT.Size(); i++) 
			texnamesBuf.Push(FLATS_DIRT[i]);
        SetupMaterial(texnamesBuf, "dirt");
        texnamesBuf.Clear();

		for (int i = 0; i < FLATS_GRAVEL.Size(); i++) 
			texnamesBuf.Push(FLATS_GRAVEL[i]);
        SetupMaterial(texnamesBuf, "gravel");
        texnamesBuf.Clear();

        console.printf("PB_Materialsys: Materials set up. took %fms", MsTimeF() - startTime);
    }

    // definitions
    // TODO: turn this into a lump?
    static const string FLATS_SLIME[] = { "SFALL", "BFALL", "BDT_WFL", "BDT_BFL", "BDT_AFL", "BDT_SFL1", "BDT_SFL2", "NUKAGE1", "NUKAGE2", "NUKAGE3", "SLIME01", "SLIME02", "SLIME03", "SLIME04", "SLIME05", "SLIME06", "SLIME07", "SLIME08" };
    static const string FLATS_WATER[] = { "FWATER1", "FWATER2", "FWATER3", "FWATER4", "BLOOD1", "BLOOD2", "BLOOD3", "WATER", "BLOOD", "WFALL", "BDT_W", "BDT_B", "BDT_S" };
    static const string FLATS_FLESH[] = { "SFLR6_1","SFLR6_4","SFLR7_1","SFLR7_4" };
    static const string FLATS_LAVA[] = { "LAVA1","LAVA2","LAVA3","LAVA4","BDT_LFL" };
    static const string FLATS_ROCK[] = { "SLIME09","SLIME10","SLIME11","SLIME12","RROCK01","RROCK02","RROCK05","RROCK06","RROCK07","RROCK08","FLAT1","FLAT1_1","FLAT1_2","FLAT5_6","FLAT5_7","FLAT5_8","FLOOR5_4","GRNROCK","MFLR8_2","MFLR8_3","RROCK03","RROCK04","RROCK09","RROCK10","RROCK11","RROCK12","RROCK13","RROCK14","RROCK15","SLIME13", "STONE6", "STONE7", "SW1STON6", "TANROCK", "ZIMMER3", "ZIMMER4" };
    static const string FLATS_WOOD[] = { "FLOOR0_2","CEIL1_1","CRATOP1","CRATOP2","FLAT5_1","FLAT5_2", "WOOD", "PAN", "CRAT", "PANEL", "STUCCO", "FLAT5_1", "FLAT5_2", "CEIL1_1", "FLOOR0_1", "FLOOR0_2", "FLOOR0_3", "FLOOR7_1", "FLAT5_5", "TANROCK2", "TANROCK3", "TANROCK8", "ZZWOLF5", "ZZWOLF6", "ZZWOLF7", "BIGDOOR5", "BIGDOOR6", "BIGDOOR7", "ZZWOLF5" };
    static const string FLATS_TILEA[] = { "CEIL1_3","CEIL3_3","CEIL3_4","COMP01","FLAT2","FLAT3","FLAT8","FLAT9","FLAT17","FLAT18","FLAT19","FLOOR0_6","FLOOR0_7","FLOOR3_3","FLOOR4_1","FLOOR4_5","FLOOR4_6","FLOOR4_8","FLOOR5_1","FLOOR5_2","FLOOR5_3","TLITE6_1","TLITE6_4","TLITE6_5","TLITE6_6" };
    static const string FLATS_TILEB[] = { "DEM1_1","DEM1_2","DEM1_3","DEM1_4","DEM1_5","DEM1_6","FLOOR7_2" };
    static const string FLATS_HARD[] = { "CEIL3_1","CEIL3_2","CEIL3_5","CEIL3_6","CEIL5_1","CEIL5_2","FLAT5","FLOOR0_1","FLOOR0_3","FLOOR1_6","FLOOR1_7","FLOOR7_1","GRNLITE1","MFLR8_1" };
    static const string FLATS_CARPET[] = { "CEIL4_1","CEIL4_2","CEIL4_3","FLAT5_3","FLAT5_4","FLAT5_5","FLAT14","FLOOR1_1" };
    static const string FLATS_METALA[] = { "FLOOR0_5","CEIL1_2","FLAT1_3","FLAT20","GATE1","GATE2","GATE3","SLIME14","SLIME15","SLIME16","STEP1","STEP2", "SHAWN", "SILVER", "BRONZ", "SUPPORT", "ZZZFACE6", "ZZZFACE7", "ZZZFACE8", "ZZZFACE9", "FLOOR0_6", "FLOOR0_7", "FLOOR3_3", "FLOOR4_1", "FLOOR4_5", "FLOOR4_8", "FLOOR5_1", "STEP", "CEIL5_2", "FLAT22", "FLAT23", "CONS", "CEIL1_1", "CEIL1_2", "CEIL1_1", "SLIME14", "SLIME15", "SLIME16", "LITE", "COMM", "SW2MET", "BIGDOOR1", "BIGDOOR2", "BIGDOOR3", "BIGDOOR4", "DOOR", "EXITDOOR", "SPCDOOR", "BRNSMAL", "PLAT" };
    static const string FLATS_METALB[] = { "CONS1_1","CONS1_5","CONS1_7","FLAT4","FLAT22","FLAT23","GATE4", "PIPE", "FLAT4", "COMP", "TEK", "MIDS", "MIDB", "FLAT23", "METAL", "SPACE", "STAR" };
    static const string FLATS_DIRT[] = { "FLAT10","GRASS1","GRASS2","MFLR8_4","RROCK16","RROCK17","RROCK18","RROCK19","RROCK20", "ASHWALL3", "ASHWALL4", "ZIMMER5" };
    static const string FLATS_GRAVEL[] = { "FLOOR6_1","FLOOR6_2" };
}