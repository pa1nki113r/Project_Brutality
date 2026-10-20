class PB_LeechBeam : LineTracer
{
	override ETraceStatus TraceCallback()
	{
		if(results.HitType == TRACE_HitWall || results.HitType == TRACE_HitCeiling || results.HitType == TRACE_HitFloor || results.HitType == TRACE_HitActor && results.HitActor.bISMONSTER)
		{
			return TRACE_Stop;
		}
		return TRACE_Skip;
	}
}