/*
MIT License

Copyright (c) 2026 generic name guy

feel free to use this in your project! just include the above license info
somewhere visible, please.
*/

class PB_Materialsys : StaticEventHandler
{  
	map<string, int> texToMatKeyMap;
	array<PB_MaterialDataStorage> materialData;
	
	// key is used for identifying material type
	void SetupMaterial( array<string> refArray, name materialId, PB_MaterialDataStorage matData, int key )
	{
		// dump texture names in the map as keys, with the material key as value
		for ( int i = 0; i < refArray.Size(); i++ ) 
			texToMatKeyMap.Insert( refArray[i].MakeLower(), key );
		
		/*console.printf( 
			"PB_Materialsys: Finished setting up %s with a key of %i.", 
			materialId, key
		);*/
	}

	clearscope static name GetMaterialFromTexName( string texName )
	{
		PB_Materialsys seh = PB_Materialsys( PB_Materialsys.Find( "PB_Materialsys" ) );
		return seh.GetMaterialDefFromTexName( texName ).materialName;
	}

	clearscope static string GetFootstepFromTexName( string texName )
	{
		PB_Materialsys seh = PB_Materialsys( PB_Materialsys.Find( "PB_Materialsys" ) );
		return seh.GetMaterialDefFromTexName( texName ).footstepSound;
	}

	clearscope static PB_MaterialDataStorage GetMaterialDefFromTexName( string texName )
	{
		PB_Materialsys seh = PB_Materialsys( PB_Materialsys.Find( "PB_Materialsys" ) );
		texName = texName.MakeLower();
		
		if( texName.CodePointCount() > 8 )
			return seh.materialData[ seh.texToMatKeyMap.CheckValue( texName ) ];

		// [gng] previously the check matched the first few characters of the 
		// string, the map lookup cannot do this. it has to trim the characters
		// one by one to find the proper material, this is still faster
		while( texName.CodePointCount() >= 3 )
		{
			let [ result, exists ] = seh.texToMatKeyMap.CheckValue( texName );

			if( exists )
				return seh.materialData[ result ];	
			else
				texName.DeleteLastCharacter();
		}

		return seh.materialData[0];
	}

	const PB_INCLUDE_FILE = "PBINCLUD";

	// generate the tables
	override void OnRegister()
	{
		console.printf( "PB_Materialsys: Setting up material system." );
		double startTime = MsTimeF();

		array<String> jsonToParse;
		array<String> tmpBufferReusable;
		array<string> tempKeyNames;

		// the reason this is done here is because you want the index to be 1
		// always
		PB_MaterialDataStorage matData = PB_MaterialDataStorage.CreateMaterial( 
			"PB_BulletImpact", 
			"FFFFFF", 
			"step/default", 
			"default"
		);
		matData.tmpTextureNames.Push( "-NOFLAT-" );
		materialData.Push( matData );

		int lump = Wads.FindLump( PB_INCLUDE_FILE, 0 );
		PB_JsonObject materialsInclude;
		array<int> materialFiles, textureFiles;
		while ( lump != -1 )
		{
			String lumpContents = Wads.ReadLump( lump );
			materialsInclude = PB_JsonObject( PB_JSON.parse( lumpContents ) );

			PB_JsonArray texturesJSON = PB_JsonArray( materialsInclude.Get( "textures" ) );
			if( texturesJSON )
			{
				for( int i = 0; i < texturesJSON.arr.Size(); i++ )
					textureFiles.Push( Wads.CheckNumForFullName( PB_JsonString( texturesJSON.arr[i] ).s ) );
			}
			texturesJSON.Destroy();

			PB_JsonArray materialsJSON = PB_JsonArray( materialsInclude.Get( "materials" ) );
			if( materialsJSON )
			{
				for( int i = 0; i < materialsJSON.arr.Size(); i++ )
					materialFiles.Push( Wads.CheckNumForFullName( PB_JsonString( materialsJSON.arr[i] ).s ) );
			}
			materialsJSON.Destroy();

			lump = Wads.FindLump( PB_INCLUDE_FILE, lump + 1 );
		}


		map<string, int> materialKeysToIndex; // this is used later for textures

		// not entirely sure what this code does when multiple materials using 
		// the same name are created, need to check that sometime

		for( int i = materialFiles.Size() - 1; i >= 0; i-- )
		{
			if( materialFiles[i] == -1 ) 
				continue;

			PB_JsonObject matListJsonObject = PB_JsonObject( PB_JSON.parse( Wads.ReadLump( materialFiles[i] ) ) );

			matListJsonObject.GetKeysInto( tempKeyNames );

			for( int j = 0; j < tempKeyNames.Size(); j++ )
			{
				// tmpBufferReusable holds processed materials here
				if( tmpBufferReusable.Find( tempKeyNames[j] ) == tmpBufferReusable.Size() )
				{
					tmpBufferReusable.Push( tempKeyNames[j] );
					materialKeysToIndex.Insert( tempKeyNames[j], materialData.Size() );

					PB_JsonObject materialDef = PB_JsonObject( matListJsonObject.Get( tempKeyNames[j] ) );

					PB_JsonString bulletImpact = PB_JsonString( materialDef.get( "bulletimpact" ) );
					PB_JsonString tintColor = PB_JsonString( materialDef.get( "color" ) );
					PB_JsonString footstepSound = PB_JsonString( materialDef.get( "footstep" ) );

					PB_MaterialDataStorage matData = PB_MaterialDataStorage.CreateMaterial( 
						bulletImpact ? bulletImpact.s : "PB_BulletImpact", 
						tintColor ? tintColor.s : "FFFFFF", 
						footstepSound ? footstepSound.s : "step/default", 
						tempKeyNames[j]
					);

					materialData.Push( matData );
				}
			}
		}
		
		jsonToParse.Clear();
		tempKeyNames.Clear();

		for( int i = textureFiles.Size() - 1; i >= 0; i-- )
		{
			if( textureFiles[i] == -1 ) 
				continue;

			PB_JsonObject matListJsonObject = PB_JsonObject( PB_JSON.parse( Wads.ReadLump( textureFiles[i] ) ) );

			matListJsonObject.GetKeysInto( tempKeyNames );

			PB_JsonArray textureList;

			for( int i = 0; i < tempKeyNames.Size(); i++ )
			{
				textureList = PB_JsonArray( matListJsonObject.Get( tempKeyNames[i] ) );

				int indexOfMat;
				bool matExists;

				[indexOfMat, matExists] = materialKeysToIndex.CheckValue( tempKeyNames[i] );

				if( matExists )
				{
					PB_MaterialDataStorage matData = materialData[indexOfMat];

					for( int i = 0; i < textureList.arr.Size(); i++ )
					{
						PB_JsonString tName = PB_JsonString( textureList.arr[i] );
						matData.tmpTextureNames.Push( tName.s );
					}
				}
				else
				{  
					console.printf( "PB_Materialsys: Material %s does not exist!", tempKeyNames[i] );
					continue;
				}
			}
			tempKeyNames.Clear();
		}
		jsonToParse.Clear();

		for( int i = 0; i < materialData.Size(); i++ )
		{
			SetupMaterial( materialData[i].tmpTextureNames, materialData[i].materialName, materialData[i], i );
			materialData[i].tmpTextureNames.Clear();
		}

		console.printf( "PB_Materialsys: Materials set up. took %fms", MsTimeF() - startTime );
	}
}

class PB_MaterialDataStorage
{
	string bulletImpact;
	color tintColor;
	string footstepSound;
	array<string> tmpTextureNames;

	string materialName;

	static PB_MaterialDataStorage CreateMaterial( string bImp, color tintCol, string stepS, string matName )
	{
		PB_MaterialDataStorage m = new( "PB_MaterialDataStorage" );

		if( m )
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