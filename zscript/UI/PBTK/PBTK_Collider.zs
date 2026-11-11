class PBTK_UICollider ui
{
    vector2 boundsStart, boundsEnd;

    bool ChecksInterceptsCollider(vector2 pos)
    {
        return (pos.x > boundsStart.x && pos.x < boundsEnd.x) && (pos.y > boundsStart.y && pos.y < boundsEnd.y);
    }
}