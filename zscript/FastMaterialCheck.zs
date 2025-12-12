class PB_Materialsys : StaticEventHandler
{  
    map<int, PB_MaterialDataStorage> materialKeyMap;
    array<int> materialRanges;
    array<string> textureNames;
    array<PB_MaterialDataStorage> materialData;
    int lastMaterialKey;
    
    // format: 
    // range from, range to, key
    // key is used for identifying material type
    void SetupMaterial(array<string> refArray, name materialId, PB_MaterialDataStorage matData)
    {
        console.printf("PB_Materialsys: Setting up %s...", materialId);
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
        materialKeyMap.Insert(lastMaterialKey, matData);

        console.printf("PB_Materialsys: %s takes range %i..%i, with a key of %i.", materialId, materialRanges[materialRanges.Size() - 3], materialRanges[materialRanges.Size() - 2], materialRanges[materialRanges.Size() - 1]);
        console.printf("PB_Materialsys: Finished setting up %s.", materialId);
    }

    clearscope static name GetMaterialFromTexName(string texName)
    {
        PB_Materialsys seh = PB_Materialsys(PB_Materialsys.Find("PB_Materialsys"));
        return seh.GetMaterialDefFromTexName(texName).materialName;
    }

    clearscope static string GetFootstepFromTexName(string texName)
    {
        PB_Materialsys seh = PB_Materialsys(PB_Materialsys.Find("PB_Materialsys"));
        return seh.GetMaterialDefFromTexName(texName).footstepSound;
    }

    clearscope static PB_MaterialDataStorage GetMaterialDefFromTexName(string texName)
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
            return seh.materialKeyMap.GetIfExists(1);

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

        return seh.materialKeyMap.GetIfExists(1);
    }

    const PB_MATERIALS_PATH = "pbdata/matsys/materials.json";
    const PB_TEXTURES_PATH = "pbdata/matsys/textures.json";

    // generate the tables
    override void OnRegister()
    {
        console.printf("PB_Materialsys: Setting up material system.");
        double startTime = MsTimeF();

        array<String> jsonToParse;

        // the reason this is done here is because you want the index to be 1
        // always
        array<String> wfgojnanfipaw;
        wfgojnanfipaw.Push("-NOFLAT-");
        PB_MaterialDataStorage matData = PB_MaterialDataStorage.CreateMaterial(
            "PB_BulletImpact", 
            "FFFFFF", 
            "step/default", 
            "default"
        );
        SetupMaterial(wfgojnanfipaw, "default", matData);
        wfgojnanfipaw.Clear();
        /*int lump = Wads.FindLump(PB_MATERIALS_PATH, 0);
        while (lump != -1)
        {
            String lumpContents = Wads.ReadLump(lump);
            jsonToParse.Push(lumpContents);
            lump = Wads.FindLump(PB_MATERIALS_PATH, lump + 1);
        }*/

        int lump = Wads.CheckNumForFullName(PB_MATERIALS_PATH);
        jsonToParse.Push(Wads.ReadLump(lump));

        array<PB_JsonObject> materialObjects;
        map<string, int> materialKeysToIndex;
        array<string> materialsBuffer1;

        for(int i = jsonToParse.Size() - 1; i >= 0; i--)
        {
            array<string> materialsBuffer2;
            PB_JsonObject materialsList = PB_JsonObject(PB_JSON.parse(jsonToParse[i]));
            materialsList.GetKeysInto(materialsBuffer2);

            for(int i = 0; i < materialsBuffer2.Size(); i++)
            {
                if(materialsBuffer1.Find(materialsBuffer2[i]) == materialsBuffer1.Size())
                {
                    // console.printf("gwa");
                    materialsBuffer1.Push(materialsBuffer2[i]);
                    materialKeysToIndex.Insert(materialsBuffer2[i], i);
                    PB_JsonObject obj = PB_JsonObject(materialsList.Get(materialsBuffer2[i]));
                    materialObjects.Push(obj);

                    PB_JsonString bulletImpact = PB_JsonString(materialObjects[i].get("bulletimpact"));
                    PB_JsonString tintColor = PB_JsonString(materialObjects[i].get("color"));
                    PB_JsonString footstepSound = PB_JsonString(materialObjects[i].get("footstep"));

                    PB_MaterialDataStorage matData = PB_MaterialDataStorage.CreateMaterial(
                        bulletImpact ? bulletImpact.s : "PB_BulletImpact", 
                        tintColor ? tintColor.s : "FFFFFF", 
                        footstepSound ? footstepSound.s : "step/default", 
                        materialsBuffer2[i]
                    );

                    materialData.Push(matData);
                }
            }
            materialsBuffer2.Clear();
        }
        
        jsonToParse.Clear();
        lump = Wads.CheckNumForFullName(PB_TEXTURES_PATH);
        jsonToParse.Push(Wads.ReadLump(lump));

        for(int i = jsonToParse.Size() - 1; i >= 0; i--)
        {
            array<string> materialsBuffer2;
            PB_JsonObject materialsList = PB_JsonObject(PB_JSON.parse(jsonToParse[i]));
            materialsList.GetKeysInto(materialsBuffer2);

            PB_JsonArray textureList;

            for(int i = 0; i < materialsBuffer2.Size(); i++)
            {
                textureList = PB_JsonArray(materialsList.Get(materialsBuffer2[i]));

                int indexOfMat;
                bool matExists;

                [indexOfMat, matExists] = materialKeysToIndex.CheckValue(materialsBuffer2[i]);

                if(matExists)
                {
                    PB_MaterialDataStorage matData = materialData[indexOfMat];

                    for(int i = 0; i < textureList.arr.Size(); i++)
                    {
                        PB_JsonString tName = PB_JsonString(textureList.arr[i]);
                        matData.tmpTextureNames.Push(tName.s);
                    }
                }
                else
                {  
                    console.printf("PB_Materialsys: Material %s does not exist!", materialsBuffer2[i]);
                    continue;
                }
            }
            materialsBuffer2.Clear();
        }
        jsonToParse.Clear();

        for(int i = 0; i < materialData.Size(); i++)
        {
            SetupMaterial(materialData[i].tmpTextureNames, materialData[i].materialName, materialData[i]);
            materialData[i].tmpTextureNames.Clear();
        }

        console.printf("PB_Materialsys: Materials set up. took %fms", MsTimeF() - startTime);
    }
}

class PB_MaterialDataStorage
{
    string bulletImpact;
    color tintColor;
    string footstepSound;
    array<string> tmpTextureNames;

    string materialName;

    static PB_MaterialDataStorage CreateMaterial(string bImp, color tintCol, string stepS, string matName)
    {
        PB_MaterialDataStorage m = new("PB_MaterialDataStorage");

        if(m)
        {
            m.bulletImpact = bImp;
            m.tintColor = tintCol;
            m.footstepSound = stepS;
            m.materialName = matName;

            return m;
        }

        return NULL;
    }
}