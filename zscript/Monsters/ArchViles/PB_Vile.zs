class PB_Vile : Archvile //PLACEHOLDER, DELETE WHEN ZSCRIPTIFIED
{
	action void PB_SetHeight(int newHeight)
	{
		height = newHeight;
	}
	
	action void PB_VileChase(int oldHeight, int newHeight)
	{
		height = oldHeight;
		A_VileChase();
		height = newHeight;
	}
}