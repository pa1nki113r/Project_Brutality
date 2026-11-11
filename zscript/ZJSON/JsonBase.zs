class PB_JsonElementOrError {}

class PB_JsonElement : PB_JsonElementOrError abstract
{
	abstract string Serialize();
	abstract string GetPrettyName();
}

class PB_JsonNumber : PB_JsonElement abstract
{
	abstract PB_JsonNumber Negate();
	abstract double  asDouble();
	abstract int asInt();
	
	override string GetPrettyName()
	{
		return "Number";
	}
}

class PB_JsonInt : PB_JsonNumber
{
	int i;
	
	static PB_JsonInt make(int i = 0)
	{
		let elem = new("PB_JsonInt");
		elem.i = i;
		return elem;
	}
	override PB_JsonNumber Negate()
	{
		i = -i;
		return self;
	}
	override string Serialize()
	{
		return ""..i;
	}
	
	override double asDouble()
	{
		return double(i);
	}
	
	override int asInt()
	{
		return i;
	}
}

class PB_JsonDouble : PB_JsonNumber
{
	double d;
	
	static PB_JsonDouble Make(double d = 0)
	{
		PB_JsonDouble elem = new("PB_JsonDouble");
		elem.d = d;
		return elem;
	}
	override PB_JsonNumber Negate()
	{
		d = -d;
		return self;
	}
	override string Serialize()
	{
		return ""..d;
	}
	
	override double asDouble()
	{
		return d;
	}
	
	override int asInt()
	{
		return int(d);
	}
}

class PB_JsonBool : PB_JsonElement
{
	bool b;
	
	static PB_JsonBool Make(bool b = false)
	{
		PB_JsonBool elem = new("PB_JsonBool");
		elem.b = b;
		return elem;
	}
	
	override string Serialize()
	{
		return b? "true" : "false";
	}
	
	override string GetPrettyName()
	{
		return "Bool";
	}
}

class PB_JsonString : PB_JsonElement
{
	string s;
	
	static PB_JsonString make(string s = "")
	{
		PB_JsonString elem = new("PB_JsonString");
		elem.s=s;
		return elem;
	}
	
	override string Serialize()
	{
		return PB_JSON.serialize_string(s);
	}
	
	override string GetPrettyName()
	{
		return "String";
	}
}

class PB_JsonNull : PB_JsonElement
{
	static PB_JsonNull Make()
	{
		return new("PB_JsonNull");
	}
	
	override string Serialize()
	{
		return "null";
	}
	
	override string GetPrettyName()
	{
		return "Null";
	}
}

class PB_JsonError : PB_JsonElementOrError
{
	String what;
	
	static PB_JsonError make(string s)
	{
		PB_JsonError err = new("PB_JsonError");
		err.what = s;
		return err;
	}
}