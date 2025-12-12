
class PB_JsonObjectKeys
{
	Array<String> keys;
}


class PB_JsonObject : PB_JsonElement
{
	Map<String,PB_JsonElement> data;
	
	static PB_JsonObject make()
	{
		return new("PB_JsonObject");
	}
	
	PB_JsonElement Get(String key)
	{
		if(!data.CheckKey(key)) return null;
		return data.Get(key);
	}
	
	void Set(String key,PB_JsonElement e)
	{
		data.Insert(key,e);
	}
	
	bool Insert(String key, PB_JsonElement e)
	{ // only inserts if key doesn't exist, otherwise fails and returns false
		if(data.CheckKey(key)) return false;
		data.Insert(key,e);
		return true;
	}
	
	bool Delete(String key)
	{
		if(!data.CheckKey(key)) return false;
		data.Remove(key);
		return true;
	}
    
	void GetKeysInto(out Array<String> keys)
	{
		keys.Clear();
		MapIterator<String,PB_JsonElement> it;
		it.Init(data);
		while(it.Next()){
			keys.Push(it.GetKey());
		}
	}
    
	PB_JsonObjectKeys GetKeys()
	{
		PB_JsonObjectKeys keys = new("PB_JsonObjectKeys");
        GetKeysInto(keys.keys);
		return keys;
	}
    
    deprecated("0.0", "Use IsEmpty Instead") bool Empty()
	{
        return data.CountUsed() == 0;
    }

	bool IsEmpty()
	{
		return data.CountUsed() == 0;
	}
	
	void Clear()
	{
		data.Clear();
	}
	
	uint Size()
	{
		return data.CountUsed();
	}
	
	override string Serialize()
	{
		String s;
		s.AppendCharacter("{");
		bool first = true;
		
		MapIterator<String,PB_JsonElement> it;
		it.Init(data);
		
		while(it.Next()){
			if(!first){
				s.AppendCharacter(",");
			}
			s.AppendFormat("%s:%s", PB_JSON.serialize_string(it.GetKey()), it.GetValue().serialize());
			first = false;
		}
		
		s.AppendCharacter("}");
		return s;
	}
    
	override string GetPrettyName()
	{
		return "Object";
	}
}
