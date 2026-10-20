class PB_Rev : Revenant //PLACEHOLDER, DELETE WHEN ZSCRIPTIFIED
{
	action void PB_SetHeight(int newHeight)
	{
		height = newHeight;
	}
	
	action void PB_Chase(int oldHeight, int newHeight)
	{
		height = oldHeight;
		A_Chase();
		height = newHeight;
	}
}