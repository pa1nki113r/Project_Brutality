
class PB_JSON
{
	const BACKSLASH = 0x5C;		// '\\'
	
	private static bool isWhitespace(int c)
	{
		return c == "\t" || c == "\n" || c == "\r" || c == " ";
	}
	
	private static bool isNumber(int c)
	{
		return c >= "0" && c <= "9";
	}
	
	private static int getEscape(int c)
	{ // doesn't support unicode (\uHHHH and \uHHHHHHHH), hex (\xhh) or octal (\ooo) escape sequences
		switch(c)
		{
		case "a":
			return "\a";
		case "b":
			return "\b";
		case "e":// '\e' -- ESC
			return 0x1B;
		case "n":
			return "\n";
		case "r":
			return "\r";
		case "t":
			return "\t";
		case "v":
			return "\v";
		default:
			return c;
		}
	}
	
	private static int needsEscape(int c, bool single_quote)
	{
		switch(c)
		{
		case "\a":
		case "\b":
		case 0x1B: // '\e' -- ESC
		case "\n":
		case "\r":
		case "\t":
		case "\v":
			return true;
		case "\'":
			return single_quote;
		case "\"":
			return !single_quote;
		default:
			return false;
		}
	}
	
	private static int makeEscape(int c)
	{
		switch(c)
		{
		case "\a":
			return "a";
		case "\b":
			return "b";
		case 0x1B: // '\e' -- ESC
			return "e";
		case "\n":
			return "n";
		case "\r":
			return "r";
		case "\t":
			return "t";
		case "\v":
			return "v";
		default:
			return c;
		}
	}
	
    
	private static void skipWhitespace(out string data, out uint i, uint len, out uint line)
	{ // skip whitespace and comments
		if(i >= len)return;
		// while data[i] is whitespace, cr/lf or tab, advance index
		for(uint c, next_i; i < len;)
		{
			[c, next_i] = data.getNextCodePoint(i);
			if(!isWhitespace(c))
			{
				if(next_i < len && c=="/")
				{
					uint i3;
					[c, i3] = data.getNextCodePoint(next_i);
					if(c == "/")
					{ // if is single line comment, skip until next LF or EOF
						next_i=i3;
						while(next_i < len)
						{
							[c, next_i] = data.getNextCodePoint(next_i);
							if(c == "\n")
							{
								line++;
								break;
							}
						}
					}
					else if(c == "*")
					{ // if is multiline comment, skip until next '*/'
						next_i = i3;
						while(next_i < len)
						{
							[c, next_i] = data.getNextCodePoint(next_i);
							if(c == "*" && next_i < len)
							{
								[c, next_i] = data.getNextCodePoint(next_i);
								if(c == "/")
								{
									break;
								}
							}
						}
					}
					else
					{
						break;
					}
				}
				else
				{
					break;
				}
			}
			else if(c == "\n")
			{
				line++;
			}
			i = next_i;
		}
	}
	
	private static PB_JsonElementOrError parseString(out string data, out uint i, uint len)
	{ // parse a string
		if(i >= len) return PB_JsonError.make("Expected String, got EOF");
		uint delim, next_i;
		[delim, next_i] = data.getNextCodePoint(i);
		if(delim != "'" && delim != "\"")
		{
			return PB_JsonError.make("Expected  '\'' or '\"' (String), got "..data.mid(i,1));
		}
		i = next_i;
		PB_JsonString s = PB_JsonString.make();
		uint c, i3;
		while(next_i < len)
		{
			[c, i3]=data.getNextCodePoint(next_i);
			if(c == delim)
			{
				s.s.appendFormat("%s", data.mid(i, next_i - i));
				i = i3;
				return s;
			}
			if(c == BACKSLASH)
			{
				if(i3 >= len)
				{
					return PB_JsonError.make("On String, expected Character, got EOF");
				}
				s.s.appendFormat("%s", data.mid(i, next_i - i));
				[c, next_i] = data.getNextCodePoint(i3);
				s.s.appendCharacter(getEscape(c));
				i = next_i;
			}
			else if(c == "\n")
			{
				return PB_JsonError.make("On String, expected Character, got EOL");
			}
			else
			{
				next_i = i3;
			}
		}
		string delim_s;
		delim_s.appendCharacter(delim);
		return PB_JsonError.make("On String, expected '"..delim_s.."', got EOF");
	}
    
	private static PB_JsonElementOrError parseObject(out string data, out uint i, uint len, out uint line)
	{ // parse a json object, allows trailing commas
		if(i >= len) return PB_JsonError.make("Expected Object, got EOF");
		uint c, next_i;
		[c, next_i] = data.getNextCodePoint(i);
		if(c != "{")
		{
			return PB_JsonError.make("Expected '{' (Object), got '"..data.mid(i, 1).."'");
		}
		i = next_i;
		PB_JsonObject obj = PB_JsonObject.make();
        string last_element;
        bool has_last_element = false;
		while(i<len)
		{
			skipWhitespace(data, i, len, line);
			[c,next_i] = data.getNextCodePoint(i);
			if(c == "}"){
				i = next_i;
				return obj;
			}
			let key = parseString(data, i, len);
			if(key is "PB_JsonError")
			{
                if(has_last_element)
				{
                    return PB_JsonError.make("After Object value '"..last_element.."', "..PB_JsonError(key).what);
                }
				else
				{
                    return PB_JsonError.make("On first Object value, "..PB_JsonError(key).what);
                }
			}
            last_element = PB_JsonString(key).s;
            has_last_element = true;
			skipWhitespace(data, i, len, line);
			if(i >= len)
			{
				return PB_JsonError.make("On Object value '"..last_element.."', expected ':', got EOF");
			}
			[c, next_i] = data.getNextCodePoint(i);
			if(c != ":")
			{
				return PB_JsonError.make("On Object value '"..last_element.."', expected ':', got '"..data.mid(i, 1).."'");
			}
			i = next_i;
			skipWhitespace(data, i, len, line);
			if(i >= len)
			{
				return PB_JsonError.make("On Object value '"..last_element.."', expected element, got EOF");
			}
			let elem = parseElement(data, i, len, line);
			if(elem is "PB_JsonError")
			{
				return PB_JsonError.make("On Object value '"..last_element.."', "..PB_JsonError(elem).what);
			}
			obj.set(PB_JsonString(key).s, PB_JsonElement(elem));
			skipWhitespace(data, i, len, line);
			if(i >= len)
			{
				return PB_JsonError.make("After Object value '"..last_element.."', expected ',', got EOF after element '"..last_element.."'");
			}
			[c, next_i] = data.getNextCodePoint(i);
			if(c != ",")
			{
				if(c == "}")
				{
					continue;
				}
				return PB_JsonError.make("After Object value '"..last_element.."', expected ',', got '"..data.mid(i, 1).."'");
			}
			i = next_i;
		}
        if(has_last_element)
		{
            return PB_JsonError.make("After Object value '"..last_element.."', expected }, got EOF");
        }
		else
		{
            return PB_JsonError.make("On Empty Object, expected }, got EOF");
        }
	}
	
	private static PB_JsonElementOrError parseArray(out string data, out uint i, uint len, out uint line) 
	{ // parse a json array, allows trailing commas
		if(i >= len) return PB_JsonError.make("Expected Array, got EOF");
		uint c, next_i;
		[c, next_i] = data.getNextCodePoint(i);
		if(c != "[")
		{
			return PB_JsonError.make("Expected '[' (Array), got '"..data.mid(i, 1).."'");
		}
		i = next_i;
		PB_JsonArray arr=PB_JsonArray.make();
		while(i<len)
		{
			skipWhitespace(data, i, len, line);
			[c, next_i] = data.getNextCodePoint(i);
			if(c == "]")
			{
				i=next_i;
				return arr;
			}
			let elem = parseElement(data, i, len, line);
			if(elem is "PB_JsonError")
			{
				return PB_JsonError.make("On Array index "..arr.size()..", "..PB_JsonError(elem).what);
			}
			arr.push(PB_JsonElement(elem));
			skipWhitespace(data, i, len, line);
			if(i >= len)
			{
				return PB_JsonError.make("On Array index "..(arr.size() - 1)..", expected ',', got EOF");
			}
			[c, next_i] = data.getNextCodePoint(i);
			if(c != ",")
			{
				if(c == "]")
				{
					continue;
				}
				return PB_JsonError.make("After Array index "..(arr.size() - 1)..", expected ',', got '"..data.mid(i, 1).."'");
			}
			i = next_i;
		}
        if(arr.size() == 0)
		{
            return PB_JsonError.make("On Empty Array, expected ], got EOF");
        }
		else
		{
            return PB_JsonError.make("After Array index "..(arr.size() - 1)..", expected ], got EOF");
            
        }
	}
	
    
	private static PB_JsonElementOrError parseNumber(out string data, out uint i, uint len)
	{ // parse a number in the format [0-9]+(?:\.[0-9]+)?
	  // TODO match floating point numbers in exponent format
		if(i >= len) return PB_JsonError.make("Expected Number, got EOF");
		uint next_i, i3, c;
		[c, next_i] = data.getNextCodePoint(i);
		if(!isNumber(c)) return PB_JsonError.make("Expected '0'-'9' (Number), got '"..data.mid(i, 1).."'");
		next_i = i;
		bool is_double=false;
		while(next_i < data.length())
		{
			[c,i3]=data.getNextCodePoint(next_i);
			if(c == ".")
			{
				if(is_double)
				{
					return PB_JsonError.make("On Number, duplicate dot");
				}
				is_double = true;
			}
			else if(!isNumber(c))
			{
				break;
			}
			next_i = i3;
		}
		uint n = next_i - i;
		PB_JsonElement o;
		if(is_double)
		{
			o = PB_JsonDouble.make(data.mid(i,n).toDouble());
		}
		else
		{
			o = PB_JsonInt.make(data.mid(i,n).toInt());
		}
		i = next_i;
		return o;
	}
	
	
	private static PB_JsonElementOrError parseElement(out string data,out uint i,uint len,out uint line)
	{ // returns one of:
	  //	PB_JsonArray
	  //	PB_JsonObject
	  //	PB_JsonString
	  //	PB_JsonInt
	  //	PB_JsonDouble
	  //	PB_JsonNull
	  //	PB_JsonError
		skipWhitespace(data, i, len, line);
		if(i >= len)
		{
			return PB_JsonError.make("Expected JSON Element, got EOF");
		}
		uint c, next_i;
		[c, next_i] = data.getNextCodePoint(i);
		if(isNumber(c))
		{ // number
			return parseNumber(data,i,len);
		}
		else if(c == "+" || c == "-")
		{
			i = next_i;
			skipWhitespace(data,i,len,line);
			let num = parseNumber(data,i,len);
			if(c == "-" && num is "PB_JsonNumber")
			{
				return PB_JsonNumber(num).negate();
			}
			else
			{
				return num;
			}
		}
		else if(c == "[")
		{ // array
			return parseArray(data, i, len, line);
		}
		else if(c == "{")
		{ // object
			return parseObject(data, i, len, line);
		}
		else if(c == "\'" || c == "\"" )
		{ // string
			return parseString(data, i, len);
		}
		else if(data.mid(i, 4) == "true")
		{ // bool, true
			i+=4;
			return PB_JsonBool.make(true);
		}
		else if(data.mid(i, 5) == "false")
		{ // bool, false
			i+=5;
			return PB_JsonBool.make(false);
		}
		else if(data.mid(i, 4) == "null")
		{ // null
			i+=4;
			return PB_JsonNull.make();
		}
		else
		{
			return PB_JsonError.make("Expected JSON Element, got '"..data.mid(i, 1).."'");
		}
	}
	
	static PB_JsonElementOrError parse(string json_string,bool allow_data_past_end=false)
	{ // roughly O(n), has extra complexity from data structures (DynArray, HashTable) and string copying
		uint index = 0;
		uint line = 1;
		uint len = json_string.length();
		PB_JsonElementOrError elem = parseElement(json_string, index, len, line);
		if(!(elem is "PB_JsonError"))
		{
			skipWhitespace(json_string, index, len, line);
			if(
				index < len
			&& !allow_data_past_end
			&& !( index == (len-1)
			   && json_string.getNextCodePoint(index) == 0
				)
			  )
			{
				return PB_JsonError.make("On JSON line "..line.." - expected EOF, got '"..json_string.mid(index, 1).."'");
			}
		}
		else
		{
			return PB_JsonError.make("On JSON line "..line.." - "..PB_JsonError(elem).what);
		}
		return elem;
	}
	
	static string serialize_string(string s)
	{
		String o;
		uint len = s.length();
		o.AppendCharacter("\"");
		uint i, c;
		i = 0;
		while(i < len)
		{
			[c,i] = s.getNextCodePoint(i);
			if(needsEscape(c, false))
			{
				o.AppendCharacter(BACKSLASH);
				o.AppendCharacter(makeEscape(c));
			}
			else
			{
				o.AppendCharacter(c);
			}
		}
		o.AppendCharacter("\"");
		return o;
	}
	
}
