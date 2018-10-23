#library "parkmore"
#include "zcommon.acs"

#define PARKMORE_BASE 354

#define PARKMORE_OPEN               (PARKMORE_BASE-1)
#define PARKMORE_ENTER              (PARKMORE_BASE-2)
#define PARKMORE_ENTER2             (PARKMORE_BASE-3)

#define PARKMORE_TURN               (PARKMORE_BASE+31)
#define PARKMORE_PITCH              (PARKMORE_BASE+32)
#define PARKMORE_SETTURN            (PARKMORE_BASE+33)
#define PARKMORE_SETPITCH           (PARKMORE_BASE+34)

#define PARKMORE_WALLBOUNCE         (PARKMORE_BASE+10)
#define PARKMORE_LEDGEWALL          (PARKMORE_BASE+11)
#define PARKMORE_LEDGEHOLD          (PARKMORE_BASE+12)
#define PARKMORE_WALLHOLD           (PARKMORE_BASE+13)
#define PARKMORE_REQUESTDODGE       (PARKMORE_BASE+14)

#define PARKMORE_HELP               (PARKMORE_BASE+20)
#define PARKMORE_TOGGLE             (PARKMORE_BASE+21)

#define PARKMORE_ASSORTED           (PARKMORE_BASE+41)

#define CLOCKWISE           0
#define COUNTERCLOCKWISE    1

#define PITCH_UP    0
#define PITCH_DOWN  1

#define WB_XYBASE   20.0
#define WB_ZBASE    1.25

#define LW_LEDGE    0
#define LW_WALL     1

#define WB_DODGE    0
#define WB_KICK     1
#define WB_KICKUP   2

#define WD_FORWARD  0
#define WD_FORWRITE 1
#define WD_RIGHT    2
#define WD_BACKRITE 3
#define WD_BACK     4
#define WD_BACKLEFT 5
#define WD_LEFT     6
#define WD_FORWLEFT 7
#define WD_KICK     8

int wallCheckers[9] =
{
    "ParkmoreCheckS",
    "ParkmoreCheckSE",
    "ParkmoreCheckE",
    "ParkmoreCheckNE",
    "ParkmoreCheckN",
    "ParkmoreCheckNW",
    "ParkmoreCheckW",
    "ParkmoreCheckSW",
    "ParkmoreCheckKick",
};

#define JUMP_FORWARD 15.0
#define JUMP_BACK    5.0
#define JUMP_SIDE    15.0

#define LUNGE_FORWARD 20.0
#define LUNGE_ZMULT   0.8

#define HIJUMP_BACK   5.0
#define HIJUMP_ZMULT  1.6

#define TIMER_COUNT     7

#define TIMER_CFORWARD   0
#define TIMER_CRIGHT     1
#define TIMER_CBACK      2
#define TIMER_CLEFT      3
#define TIMER_BOUNCED    4
#define TIMER_DIDDODGE   5
#define TIMER_HBACK      6

#define CACOUNT         15
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// A bunch of functions that I've built up
// They come in handy :>

#define PLAYERMAX 64
#define DEFAULTTID_SCRIPT 471

function int itof(int x) { return x << 16; }
function int ftoi(int x) { return x >> 16; }

function int abs(int x)
{
    if (x < 0) { return -x; }
    return x;
}

function int sign(int x)
{
    if (x < 0) { return -1; }
    return 1;
}

function int randSign(void)
{
    return (2*random(0,1))-1;
}

function int mod(int x, int y)
{
    int ret = x - ((x / y) * y);
    if (ret < 0) { ret = y + ret; }
    return ret;
}

function int pow(int x, int y)
{
    int n = 1;
    while (y-- > 0) { n *= x; }
    return n;
}

function int powFloat(int x, int y)
{
    int n = 1.0;
    while (y-- > 0) { n = FixedMul(n, x); }
    return n;
}

function int min(int x, int y)
{
    if (x < y) { return x; }
    return y;
}

function int max (int x, int y)
{
    if (x > y) { return x; }
    return y;
}

function int middle(int x, int y, int z)
{
    if ((x < z) && (y < z)) { return max(x, y); }
    return max(min(x, y), z);
}

function int percFloat(int intg, int frac)
{
    return itof(intg) + (itof(frac) / 100);
}

function int percFloat2(int intg, int frac1, int frac2)
{
    return itof(intg) + (itof(frac1) / 100) + (itof(frac2) / 10000);
}

function int keyUp(int key)
{
    int buttons = GetPlayerInput(-1, INPUT_BUTTONS);

    if ((~buttons & key) == key) { return 1; }
    return 0;
}

function int keyDown(int key)
{
    int buttons = GetPlayerInput(-1, INPUT_BUTTONS);

    if ((buttons & key) == key) { return 1; }
    return 0;
}

function int keyDown_any(int key)
{
    int buttons = GetPlayerInput(-1, INPUT_BUTTONS);

    if (buttons & key) { return 1; }
    return 0;
}

function int keyPressed(int key)
{
    int buttons     = GetPlayerInput(-1, INPUT_BUTTONS);
    int oldbuttons  = GetPlayerInput(-1, INPUT_OLDBUTTONS);
    int newbuttons  = (buttons ^ oldbuttons) & buttons;

    if ((newbuttons & key) == key) { return 1; }
    return 0;
}

function int keyPressed_any(int key)
{
    int buttons     = GetPlayerInput(-1, INPUT_BUTTONS);
    int oldbuttons  = GetPlayerInput(-1, INPUT_OLDBUTTONS);
    int newbuttons  = (buttons ^ oldbuttons) & buttons;

    if (newbuttons & key) { return 1; }
    return 0;
}

function int adjustBottom(int tmin, int tmax, int i)
{
    if (tmin > tmax)
    {
        tmax ^= tmin; tmin ^= tmax; tmax ^= tmin;  // XOR swap
    }

    if (i < tmin) { tmin = i; }
    if (i > tmax) { tmin += (i - tmax); }

    return tmin;
}

function int adjustTop(int tmin, int tmax, int i)
{
    if (tmin > tmax)
    {
        tmax ^= tmin; tmin ^= tmax; tmax ^= tmin;
    }

    if (i < tmin) { tmax -= (tmin - i); }
    if (i > tmax) { tmax = i; }

    return tmax;
}

function int adjustShort(int tmin, int tmax, int i)
{
    if (tmin > tmax)
    {
        tmax ^= tmin; tmin ^= tmax; tmax ^= tmin;
    }

    if (i < tmin)
    {
        tmax -= (tmin - i);
        tmin = i;
    }
    if (i > tmax)
    {
        tmin += (i - tmax);
        tmax = i;
    }
    
    return packShorts(tmin, tmax);
}


// Taken from http://zdoom.org/wiki/sqrt

function int sqrt_i(int number)
{
    if (number <= 3) { return number > 0; }

    int oldAns = number >> 1,                     // initial guess
        newAns = (oldAns + number / oldAns) >> 1; // first iteration

    // main iterative method
    while (newAns < oldAns)
    {
        oldAns = newAns;
        newAns = (oldAns + number / oldAns) >> 1;
    }

    return oldAns;
}

function int sqrot(int number)
{
    if (number == 1.0) { return 1.0; }
    if (number <= 0) { return 0; }
    int val = 150.0;
    for (int i=0; i<15; i++) { val = (val + FixedDiv(number, val)) >> 1; }

    return val;
}

function int magnitudeTwo(int x, int y)
{
    return sqrt_i(x*x + y*y);
}

function int magnitudeTwo_f(int x, int y)
{
    return sqrt(FixedMul(x, x) + FixedMul(y, y));
}

function int magnitudeThree(int x, int y, int z)
{
    return sqrt_i(x*x + y*y + z*z);
}

function int magnitudeThree_f(int x, int y, int z)
{
    int len, ang;

    ang = VectorAngle(x, y);
    if (((ang + 0.125) % 0.5) > 0.25) { len = FixedDiv(y, sin(ang)); }
    else { len = FixedDiv(x, cos(ang)); }

    ang = VectorAngle(len, z);
    if (((ang + 0.125) % 0.5) > 0.25) { len = FixedDiv(z, sin(ang)); }
    else { len = FixedDiv(len, cos(ang)); }

    return len;
}


function int quadPos(int a, int b, int c)
{
    int s1 = sqrt(FixedMul(b, b)-(4*FixedMul(a, c)));
    int s2 = (2 * a);
    int b1 = FixedDiv(-b + s1, s2);

    return b1;
}

function int quadNeg(int a, int b, int c)
{
    int s1 = sqrt(FixedMul(b, b)-(4*FixedMul(a, c)));
    int s2 = (2 * a);
    int b1 = FixedDiv(-b - s1, s2);

    return b1;
}

// All the arguments are to be fixed-point
function int quad(int a, int b, int c, int y)
{
    return FixedMul(a, FixedMul(y, y)) + FixedMul(b, y) + c + y;
}

function int quadHigh(int a, int b, int c, int x)
{
    return quadPos(a, b, c-x);
}

function int quadLow(int a, int b, int c, int x)
{
    return quadNeg(a, b, c-x);
}

function int inRange(int low, int high, int x)
{
    return ((x >= low) && (x < high));
}

function void AddAmmoCapacity(int type, int add)
{
    SetAmmoCapacity(type, GetAmmoCapacity(type) + add);
}

function int packShorts(int left, int right)
{
    return ((left & 0xFFFF) << 16) + (right & 0xFFFF);
}

function int leftShort(int packed) { return packed >> 16; }
function int rightShort(int packed) { return (packed << 16) >> 16; }


// This stuff only works with StrParam

function int cleanString(int string)
{
    int ret = "";
    int strSize = StrLen(string);

    int c, i, ignoreNext;
    
    for (i = 0; i < strSize; i++)
    {
        c = GetChar(string, i);

        if ( ( ((c > 8) && (c < 14)) || ((c > 31) && (c < 127)) || ((c > 160) && (c < 173)) ) && !ignoreNext)
        {
            ret = StrParam(s:ret, c:c);
        }
        else if (c == 28 && !ignoreNext)
        {
            ignoreNext = 1;
        }
        else
        {
            ignoreNext = 0;
        }
    }

    return ret;
}

function int padStringR(int baseStr, int padChar, int len)
{
    int baseStrLen = StrLen(baseStr);
    int pad = "";
    int padLen; int i;

    if (baseStrLen >= len)
    {
        return baseStr;
    }
    
    padChar = GetChar(padChar, 0);
    padLen = len - baseStrLen;

    for (i = 0; i < padLen; i++)
    {
        pad = StrParam(s:pad, c:padChar);
    }

    return StrParam(s:baseStr, s:pad);
}

function int padStringL(int baseStr, int padChar, int len)
{
    int baseStrLen = StrLen(baseStr);
    int pad = "";
    int padLen; int i;

    if (baseStrLen >= len)
    {
        return baseStr;
    }
    
    padChar = GetChar(padChar, 0);
    padLen = len - baseStrLen;

    for (i = 0; i < padLen; i++)
    {
        pad = StrParam(s:pad, c:padChar);
    }

    return StrParam(s:pad, s:baseStr);
}

function int changeString(int string, int repl, int where)
{
    int i; int j; int k;
    int ret = "";
    int len = StrLen(string);
    int rLen = StrLen(repl);

    if ((where + rLen < 0) || (where >= len))
    {
        return string;
    }
    
    for (i = 0; i < len; i++)
    {
        if (inRange(where, where+rLen, i))
        {
            ret = StrParam(s:ret, c:GetChar(repl, i-where));
        }
        else
        {
            ret = StrParam(s:ret, c:GetChar(string, i));
        }
    }

    return ret;
}

function int sliceString(int string, int start, int end)
{
    int len = StrLen(string);
    int ret = "";
    int i;

    if (start < 0)
    {
        start = len + start;
    }

    if (end <= 0)
    {
        end = len + end;
    }

    start = max(0, start);
    end   = min(end, len-1);
    
    for (i = start; i < end; i++)
    {
        ret = StrParam(s:ret, c:GetChar(string, i));
    }

    return ret;
}


// End StrParam

function int unusedTID(int start, int end)
{
    int ret = start - 1;
    int tidNum;

    if (start > end) { start ^= end; end ^= start; start ^= end; }  // good ol' XOR swap
    
    while (ret++ != end)
    {
        if (ThingCount(0, ret) == 0)
        {
            return ret;
        }
    }
    
    return -1;
}

function int getMaxHealth(void)
{
    int maxHP = GetActorProperty(0, APROP_SpawnHealth);

    if ((maxHP == 0) && (PlayerNumber() != -1))
    {
        maxHP = 100;
    }

    return maxHP;
}

function int giveHealth(int amount)
{
    return giveHealthFactor(amount, 1.0);
}

function int giveHealthFactor(int amount, int maxFactor)
{
    return giveHealthMax(amount, ftoi(getMaxHealth() * maxFactor));
}

function int giveHealthMax(int amount, int maxHP)
{
    int newHP;

    int curHP = GetActorProperty(0, APROP_Health);

    if (maxHP == 0) { newHP = max(curHP, curHP+amount); }
    else { newHP = middle(curHP, curHP+amount, maxHP); }

    SetActorProperty(0, APROP_Health, newHP);

    return newHP - curHP;
}

function int isDead(int tid)
{
    return GetActorProperty(tid, APROP_Health) <= 0;
}

function int isSinglePlayer(void)
{
    return GameType() == GAME_SINGLE_PLAYER;
}

function int isLMS(void)
{
    return GetCVar("lastmanstanding") || GetCVar("teamlms");
}

function int isCoop(void)
{
    int check1 = GameType() == GAME_NET_COOPERATIVE;
    int check2 = GetCVar("cooperative") || GetCVar("invasion") || GetCVar("survival");

    return check1 || check2;
}

function int isInvasion(void)
{
    return GetCVar("invasion");
}

function int isFreeForAll(void)
{
    if (GetCVar("terminator") || GetCVar("duel"))
    {
        return 1;
    }

    int check1 = GetCVar("deathmatch") || GetCVar("possession") || GetCVar("lastmanstanding");
    int check2 = check1 && !GetCVar("teamplay");

    return check2;
}

function int isTeamGame(void)
{
    int ret = (GetCVar("teamplay") || GetCVar("teamgame"));
    return ret;
}

function int spawnDistance(int item, int dist, int tid)
{
    int myX, myY, myZ, myAng, myPitch, spawnX, spawnY, spawnZ;

    myX = GetActorX(0); myY = GetActorY(0); myZ = GetActorZ(0);
    myAng = GetActorAngle(0); myPitch = GetActorPitch(0);

    spawnX = FixedMul(cos(myAng) * dist, cos(myPitch));
    spawnX += myX;
    spawnY = FixedMul(sin(myAng) * dist, cos(myPitch));
    spawnY += myY;
    spawnZ = myZ + (-sin(myPitch) * dist);

    return Spawn(item, spawnX, spawnY, spawnZ, tid, myAng >> 8);
}

function void SetInventory(int item, int amount)
{
    int count = CheckInventory(item);

    if (count == amount) { return; }
    
    if (count > amount)
    {
        TakeInventory(item, count - amount);
        return;
    }

    GiveAmmo(item, amount - count);
    return;
}
function void ToggleInventory(int inv)
{
    if (CheckInventory(inv))
    {
        TakeInventory(inv, 0x7FFFFFFF);
    }
    else
    {
        GiveInventory(inv, 1);
    }
}

function void GiveAmmo(int type, int amount)
{
    if (GetCVar("sv_doubleammo"))
    {
        int m = GetAmmoCapacity(type);
        int expected = min(m, CheckInventory(type) + amount);

        GiveInventory(type, amount);
        TakeInventory(type, CheckInventory(type) - expected);
    }
    else
    {  
        GiveInventory(type, amount);
    }
}

function void GiveActorAmmo(int tid, int type, int amount)
{
    if (GetCVar("sv_doubleammo"))
    {
        int m = GetAmmoCapacity(type);
        int expected = min(m, CheckActorInventory(tid, type) + amount);

        GiveActorInventory(tid, type, amount);
        TakeActorInventory(tid, type, CheckActorInventory(tid, type) - expected);
    }
    else
    {  
        GiveActorInventory(tid, type, amount);
    }
}

function int cond(int test, int trueRet, int falseRet)
{
    if (test) { return trueRet; }
    return falseRet;
}

function int condTrue(int test, int trueRet)
{
    if (test) { return trueRet; }
    return test;
}

function int condFalse(int test, int falseRet)
{
    if (test) { return test; }
    return falseRet;
}

function void saveCVar(int cvar, int val)
{
    //ConsoleCommand(StrParam(s:"set ", s:cvar, s:" ", d:val));
    //ConsoleCommand(StrParam(s:"archivecvar ", s:cvar));
}

function int defaultCVar(int cvar, int defaultVal)
{
    int ret = GetCVar(cvar);
    if (ret == 0) { saveCVar(cvar, defaultVal); return defaultVal; }

    return ret;
}


function int onGround(int tid)
{
    return (GetActorZ(tid) - GetActorFloorZ(tid)) == 0;
}

function int ThingCounts(int start, int end)
{
    int i, ret = 0;

    if (start > end) { start ^= end; end ^= start; start ^= end; }
    for (i = start; i < end; i++) { ret += ThingCount(0, i); }

    return ret;
}

function int PlaceOnFloor(int tid)
{
    if (ThingCount(0, tid) != 1) { return 1; }
    
    SetActorPosition(tid, GetActorX(tid), GetActorY(tid), GetActorFloorZ(tid), 0);
    return 0;
}

#define DIR_E  1
#define DIR_NE 2
#define DIR_N  3
#define DIR_NW 4
#define DIR_W  5
#define DIR_SW 6
#define DIR_S  7
#define DIR_SE 8

function int getDirection(void)
{
    int sideMove = keyDown(BT_MOVERIGHT) - keyDown(BT_MOVELEFT);
    int forwMove = keyDown(BT_FORWARD) - keyDown(BT_BACK);

    if (sideMove || forwMove)
    {
        switch (sideMove)
        {
          case -1: 
            switch (forwMove)
            {
                case -1: return DIR_SW;
                case  0: return DIR_W;
                case  1: return DIR_NW;
            }
            break;

          case 0: 
            switch (forwMove)
            {
                case -1: return DIR_S;
                case  1: return DIR_N;
            }
            break;

          case 1: 
            switch (forwMove)
            {
                case -1: return DIR_SE;
                case  0: return DIR_E;
                case  1: return DIR_NE;
            }
            break;
        }
    }

    return 0;
}

function int isInvulnerable(void)
{
    int check1 = GetActorProperty(0, APROP_Invulnerable);
    int check2 = CheckInventory("PowerInvulnerable");

    return check1 || check2;
}

function void saveStringCVar(int string, int cvarname)
{
    int slen = StrLen(string);
    int i, c, cvarname2;

    for (i = 0; i < slen; i++)
    {
        cvarname2 = StrParam(s:cvarname, s:"_char", d:i);
        SaveCVar(cvarname2, GetChar(string, i));
    }

    while (1)
    {
        cvarname2 = StrParam(s:cvarname, s:"_char", d:i);
        c = GetCVar(cvarname2);

        if (c == 0) { break; }

        //ConsoleCommand(StrParam(s:"unset ", s:cvarname2));
        i += 1;
    }
}

function int loadStringCVar(int cvarname)
{
    int ret = "";
    int i = 0, c, cvarname2;

    while (1)
    {
        cvarname2 = StrParam(s:cvarname, s:"_char", d:i);
        c = GetCVar(cvarname2);

        if (c == 0) { break; }

        ret = StrParam(s:ret, c:c);
        i += 1;
    }

    return ret;
}

function int defaultTID(int def)
{
    int tid = ActivatorTID();

    if (ThingCount(0, tid) == 1) { return tid; }

    tid = def;
    if (def <= 0) { tid = unusedTID(17000, 27000); }

    Thing_ChangeTID(0, tid);
    ACS_ExecuteAlways(DEFAULTTID_SCRIPT, 0, tid,0,0);

    return tid;
}

script DEFAULTTID_SCRIPT (int tid) clientside
{
    Thing_ChangeTID(0, tid);
}

function int JumpZFromHeight(int height, int gravFactor)
{
    return sqrt(2 * height * gravFactor);
}

function int roundZero(int toround)
{
    int i = toround % 1.0;
    return ftoi(toround - i);
}

function int roundAway(int toround)
{
    int i = toround % 1.0;

    if (i == 0) { return ftoi(toround); }
    return ftoi(toround + (1.0 - i));
}

function int roundParkmore(int toround)
{
    return ftoi(toround + 0.5);
}

function int intFloat(int toround)
{
    return itof(ftoi(toround));
}

function int distance_ftoi(int x1, int y1, int z1, int x2, int y2, int z2)
{
    return magnitudeThree(ftoi(x2-x1), ftoi(y2-y1), ftoi(z2-z1));
}

function void printDebugInfo(void)
{
    int classify    = ClassifyActor(0);
    int fead        = classify & ACTOR_DEAD;
    int player      = classify & ACTOR_PLAYER;
    int pln         = PlayerNumber();

    Log(s:" -- DEBUG INFO -- ");

    Log(s:"Executed on tic ", d:Timer(), s:" on map ", d:GetLevelInfo(LEVELINFO_LEVELNUM));

    if (classify & (ACTOR_PLAYER | ACTOR_MONSTER))
    {
        Log(s:"Script activator has ", d:GetActorProperty(0, APROP_Health), s:"/", d:getMaxHealth(), s:" HP");
    }

    if (player)
    {
        Log(s:"Is player ", d:pln, s:" (", n:0, s:"\c-) with class number ", d:PlayerClass(pln));
    }

    Log(s:" -- END DEBUG -- ");
}


function int PlayerTeamCount(int teamNo)
{
    int i, ret;
    for (i = 0; i < PLAYERMAX; i++)
    {
        if (GetPlayerInfo(i, PLAYERINFO_TEAM) == teamNO) { ret++; }
    }
    return ret;
}







///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

world int 0:MaxJumpCount;

int playerJumps[PLAYERMAX] = {0};
int hasKicked[PLAYERMAX]   = {0};
int grabbing[PLAYERMAX]    = {0};
int dontGrab[PLAYERMAX]    = {0};

int CPlayerGrounds[PLAYERMAX][2];
int PlayerGrounds[PLAYERMAX][2];
int DidSpecials[PLAYERMAX];
int playerTimers[PLAYERMAX][TIMER_COUNT];
int ClientEnterLocks[PLAYERMAX];
int IsServer;

/* Comment markers:
 *  :TURNING    - Turning scripts
 *  :MOVEMENT   - Wall-jumping, dodging scripts
 *  :DAEMONS    - The scripts that loop
 *  :USER       - The customisable crap
 *  :ASSORTED   - Where everything else goes
 */

function int parkmoreOnGround(int tid)
{
    return (onGround(tid) ||
        (GetActorVelZ(tid) == 0 && !Spawn("ParkmoreFloorChecker", GetActorX(tid), GetActorY(tid), GetActorZ(tid)-4.0)));
}


/*  :TURNING
 * Turning scripts
 */

script PARKMORE_TURN (int degrees, int factor, int direction) net clientside
{
    if (degrees < 0)
    {
        degrees *= -1;
        direction = cond(direction == CLOCKWISE, COUNTERCLOCKWISE, CLOCKWISE);
    }
    
    factor = cond(factor, factor, 4);

    int prevDegrees, addDegrees, curAngle;
    int curDegrees = 0;
    int floatDegrees = itof(degrees);
    int dirMult = cond(direction == CLOCKWISE, -1, 1);

    while (curDegrees < (floatDegrees - 0.1))
    {
        prevDegrees = curDegrees;
        addDegrees = (floatDegrees - curDegrees) / factor;
        curDegrees += addDegrees;

        SetActorAngle(0, GetActorAngle(0) + ((addDegrees * dirMult) / 360));
        Delay(1);
    }

    addDegrees = floatDegrees - curDegrees;
    SetActorAngle(0, GetActorAngle(0) + ((addDegrees * dirMult) / 360));
}

script PARKMORE_PITCH (int degrees, int factor, int direction) net clientside
{
    if (degrees < 0)
    {
        degrees *= -1;
        direction = cond(direction == CLOCKWISE, COUNTERCLOCKWISE, CLOCKWISE);
    }
    
    factor = cond(factor, factor, 4);

    int prevDegrees, addDegrees, curAngle;
    int curDegrees = 0;
    int floatDegrees = itof(degrees);
    int dirMult = cond(direction == PITCH_UP, -1, 1);

    while (curDegrees < (floatDegrees - 0.1))
    {
        prevDegrees = curDegrees;
        addDegrees = (floatDegrees - curDegrees) / factor;
        curDegrees += addDegrees;

        SetActorPitch(0, GetActorPitch(0) + ((addDegrees * dirMult) / 360));
        Delay(1);
    }

    addDegrees = floatDegrees - curDegrees;
    SetActorPitch(0, GetActorPitch(0) + ((addDegrees * dirMult) / 360));
}


script PARKMORE_SETTURN (int angle, int factor) net clientside
{
    int newAngle = mod(ftoi(GetActorAngle(0) * 360) - angle, 360);
    int direction = CLOCKWISE;

    if (newAngle > 180)
    {
        direction = COUNTERCLOCKWISE;
        newAngle = 360 - newAngle;
    }

    ACS_ExecuteAlways(PARKMORE_TURN, 0, newAngle, factor, direction);
}

script PARKMORE_SETPITCH (int pitch, int factor) net
{
    int newPitch = mod(ftoi(-GetActorPitch(0) * 360) - pitch, 360);
    int direction = PITCH_UP;

    if (newPitch > 180)
    {
        direction = PITCH_DOWN;
        newPitch = 360 - newPitch;
    }

    ACS_ExecuteAlways(PARKMORE_PITCH, 0, -newPitch, factor, direction);
}

/*  :MOVEMENT
 * Wall-jumping, dodging scripts
 */

function int hasHighJump(void)
{
    return CheckInventory("RuneHighJump") || CheckInventory("PowerHighJump");
}

function int getJumpZ(void)
{
    int ret = GetActorProperty(0, APROP_JumpZ);

    ret *= (hasHighJump() + 1);
    
    return ret;
}

function void wallBounce (int type, int direction) 
{
    int forwardMult, sideMult, xyMult, zMult;
    int forward, side, up;
    int forwardx, forwardy, sidex, sidey;
    int velx, vely, velz;

    int pln = PlayerNumber();
    int angle = GetActorAngle(0);

    if (type == WB_KICKUP && hasKicked[pln]) { return; }

    switch (type)
    {
        case WB_DODGE:  xyMult =  1.0;  zMult = 0.707; break;
        case WB_KICK:   xyMult =  0.8;  zMult = 1.0; break;
        case WB_KICKUP: xyMult =  0.02; zMult = 1.3; break;
        default: return;
    }

    if (hasHighJump())
    {
        xyMult = FixedMul(xyMult, 1.25);
        zMult  = FixedMul(zMult, 1.25);
    }

    switch (direction)
    {
        case WD_FORWARD:  forwardMult =  1.0;   sideMult =  0.0;    break;
        case WD_FORWRITE: forwardMult =  0.707; sideMult =  0.707;  break;
        case WD_RIGHT:    forwardMult =  0.0;   sideMult =  1.0;    break;
        case WD_BACKRITE: forwardMult = -0.707; sideMult =  0.707;  break;
        case WD_BACK:     forwardMult = -1.0;   sideMult =  0.0;    break;
        case WD_BACKLEFT: forwardMult = -0.707; sideMult = -0.707;  break;
        case WD_LEFT:     forwardMult =  0.0;   sideMult = -1.0;    break;
        case WD_FORWLEFT: forwardMult =  0.707; sideMult = -0.707;  break;
        case WD_KICK:     forwardMult = -1.0;   sideMult =  0.0;    break;
        default: return;
    }
    
    forward = FixedMul(WB_XYBASE, forwardMult); 
    side    = FixedMul(WB_XYBASE, sideMult); 

    up      = FixedMul(GetActorProperty(0, APROP_JumpZ), WB_ZBASE);
    up      = FixedMul(up, zMult);

    forwardx = FixedMul(cos(angle), forward);
    forwardy = FixedMul(sin(angle), forward);
    sidex = FixedMul(cos(angle-0.25), side);
    sidey = FixedMul(sin(angle-0.25), side);
    
    velx = FixedMul(forwardx + sidex, xyMult);
    vely = FixedMul(forwardy + sidey, xyMult);
    velz = up;

    switch (type)
    {
        case WB_KICK:   SetActorVelocity(0, velx, vely, velz, 0, 1); break;
        case WB_DODGE:
         if (parkmoreOnGround(0))
         {
             SetActorVelocity(0, velx + (GetActorVelX(0)/3), vely + (GetActorVelY(0)/3), velz, 0, 1); break;
         }
         else
         {
             SetActorVelocity(0, velx + (GetActorVelX(0)/2), vely + (GetActorVelY(0)/2), velz, 0, 1); break;
         }
        case WB_KICKUP: SetActorVelocity(0, velx + GetActorVelX(0), GetActorVelY(0), velz, 0, 1); break;
    }

    playerJumps[pln] = min(playerJumps[pln]+1, 1);

    if (type == WB_KICK)
    {
        switch (direction)
        {
            case WD_FORWRITE: ACS_ExecuteAlways(PARKMORE_TURN, 0, 45,  2, CLOCKWISE); break;
            case WD_RIGHT:    ACS_ExecuteAlways(PARKMORE_TURN, 0, 90,  2, CLOCKWISE); break;
            case WD_BACKRITE: ACS_ExecuteAlways(PARKMORE_TURN, 0, 135, 2, CLOCKWISE); break;
            case WD_BACK:     ACS_ExecuteAlways(PARKMORE_TURN, 0, 180, 2, CLOCKWISE); break;
            case WD_BACKLEFT: ACS_ExecuteAlways(PARKMORE_TURN, 0, 135, 2, COUNTERCLOCKWISE); break;
            case WD_LEFT:     ACS_ExecuteAlways(PARKMORE_TURN, 0, 90,  2, COUNTERCLOCKWISE); break;
            case WD_FORWLEFT: ACS_ExecuteAlways(PARKMORE_TURN, 0, 45,  2, COUNTERCLOCKWISE); break;
        }
    }

    if (type == WB_KICKUP) { hasKicked[pln] = 1; }
    else { hasKicked[pln] = 0; }

    grabbing[pln] = 0;
    dontGrab[pln] = 0;

    GiveInventory("KickTrail", 1);
}


script PARKMORE_WALLBOUNCE (int type, int direction, int mask)
{
    int newDir = -1;

    if (type == WB_DODGE)
    {
        int sideMove = keyDown(BT_MOVERIGHT) - keyDown(BT_MOVELEFT);
        int forwMove = keyDown(BT_FORWARD) - keyDown(BT_BACK);

        switch (direction)
        {
          case WD_FORWARD: 
            switch (sideMove)
            {
                case -1: newDir = WD_FORWLEFT; break;
                case  0: break;
                case  1: newDir = WD_FORWRITE; break;
            }
            break;
            
          case WD_BACK: 
            switch (sideMove)
            {
                case -1: newDir = WD_BACKLEFT; break;
                case  0: break;
                case  1: newDir = WD_BACKRITE; break;
            }
            break;
            
          case WD_LEFT: 
            switch (forwMove)
            {
                case -1: newDir = WD_BACKLEFT; break;
                case  0: break;
                case  1: newDir = WD_FORWLEFT; break;
            }
            break;
            
          case WD_RIGHT: 
            switch (forwMove)
            {
                case -1: newDir = WD_BACKRITE; break;
                case  0: break;
                case  1: newDir = WD_FORWRITE; break;
            }
            break;
        }

        if (newDir != -1) { direction = newDir; }
    }

    if (parkmoreOnGround(0))
    {
        if (type == WB_DODGE) { wallBounce(type, direction); }
        terminate;
    }

    if (mask == 0) { mask = 1; }

    GiveInventory(wallCheckers[direction], 1);
    Delay(1);

    if (CheckInventory("CanWallBounce") & mask)
    {
        //wallBounce(type, direction);
    }

    Delay(1);
    TakeInventory("CanWallBounce", 0x7FFFFFFF);
}


script PARKMORE_LEDGEWALL (int mode)
{
    int pln = PlayerNumber();
    int curX, curY, curZ, curAngle, newZ;
    int maxLeft, maxRight;
    int highest, highestTID;
    int i, j, k, l;
    int heightTID = unusedTID(40000, 50000);

    curX = GetActorX(0);
    curY = GetActorY(0);
    curZ = GetActorZ(0);
	
	
	//Checks For Classic Mode or CVARs
	if((GetCvar("donotclimb") == 1)||(GetCvar("bd_classicmonsters") == 1) ||(GetCvar("bd_TraditionalMode") == 1) || (CheckInventory("GoFatality") == 1))
	{
		terminate;
	}
	/*
	if (CheckInventory("Kicking") || CheckInventory("DoPunch") || CheckInventory("GoWeaponSpecialAbility") || CheckInventory("DoHealBackpack") || CheckInventory("DoSwarmPod")|| CheckInventory("Taunting") || CheckInventory("Salute1") || CheckInventory("Salute2") || CheckInventory("Reloading") || CheckInventory("Unloading") || CheckInventory("DoGrenade")|| CheckInventory("DoMine") || CheckInventory("DoElecPod"))
	{
		terminate;
	}*/
    if (parkmoreOnGround(0) || grabbing[pln]) { terminate; }

    switch (mode)
    {
      default:
        GiveInventory("ParkmoreCheckGrab", 1);
        break;

      case LW_WALL:
        GiveInventory("OpenGrab", 1);
        GiveInventory("ParkmoreCheckWallGrab", 1);
        break;
    }

    Delay(1);

    if (grabbing[pln] || GetActorVelZ(0) >= 0 ||
        GetActorZ(0) - GetActorFloorZ(0) < 12.0)
    {
        TakeInventory("OpenGrab", 0x7FFFFFFF);
        TakeInventory("CanGrab", 0x7FFFFFFF);
        terminate;
    }

    if (CheckInventory("OpenGrab") && CheckInventory("CanGrab"))
    {
        if (mode == LW_WALL)
        {
            //ACS_ExecuteAlways(PARKMORE_WALLHOLD, 0, 0,0,0);
            terminate;
        }
        
        curX -= (8 * cos(curAngle));
        curY -= (8 * sin(curAngle));
        newZ = curZ+64.0;
        curAngle = GetActorAngle(0);
        
        i = 4 * cos(curAngle);
        j = 4 * sin(curAngle);
        
        for (k = 0; k < CACOUNT; k++) { Thing_Remove(heightTID+k); }
        
        while (ThingCounts(heightTID, heightTID+CACOUNT) == 0)
        {
            newZ += 8.0;
            
            if ((newZ - 512.0) > curZ)
            {
                TakeInventory("OpenGrab", 0x7FFFFFFF);
                TakeInventory("CanGrab", 0x7FFFFFFF);
                terminate;
            }
            
            for (k = 0; k < CACOUNT; k++)
            {
                Thing_Remove(heightTID+k);
                l = k+3;
                Spawn("ParkmoreHeightFinder", curX + (i*l), curY + (j*l),
                        newZ, heightTID+k);
                PlaceOnFloor(heightTID+k);
            }
        }
        
        // we got here, so one of them spawned
        highest = GetActorZ(0);
        highestTID = 0;
        
        for (i = 0; i < CACOUNT; i++)
        {
            j = heightTID + (CACOUNT-(i+1));
            
            if (GetActorZ(j) > highest)
            {
                highest = GetActorZ(j);
                if (highestTID) { Thing_Remove(highestTID); }
                highestTID = j;
            }
            else
            {
                Thing_Remove(j);
            }
        }
        
        if (highestTID == 0)
        {
            TakeInventory("OpenGrab", 0x7FFFFFFF);
            TakeInventory("CanGrab", 0x7FFFFFFF);
            terminate;
        }
        
        heightTID = highestTID;
		GiveInventory("HeightTIDIndicator", heightTID);
        ACS_ExecuteAlways(PARKMORE_LEDGEHOLD, 0, heightTID,0,0);
    }
    
    Delay(1);

    TakeInventory("OpenGrab", 0x7FFFFFFF);
    TakeInventory("CanGrab", 0x7FFFFFFF);
    terminate;
}

script PARKMORE_LEDGEHOLD (int heightTID)
{
    int pln = PlayerNumber();
    int oldSpeed, instantZ;
    int curX, curY, curZ, newZ;
    int curAngle;
    int maxLeft, maxRight;
    int ledgeMag, ledgeAngle;
    int ledgeX,  ledgeY;
    int ledgeMove;  // does two things, because of the 19 int max
    int floorHeight, floorOldHeight;
    int origDistance;
    int i;
    
    curAngle = GetActorAngle(0);

    grabbing[pln] = 1;
    TakeInventory("KickTrail", 1);
    oldSpeed = GetActorProperty(0, APROP_Speed);
    SetActorProperty(0, APROP_Speed, 0.0);
    SetActorProperty(0, APROP_Gravity, 0);
    SetActorVelocity(0, 24*cos(curAngle),24*sin(curAngle),9.0, 0, 1);

    newZ = GetActorZ(heightTID) - 36.0;

    Delay(1);
    SetActorVelocity(0, 0,0,0, 0, 1);

    curX = GetActorX(0);
    curY = GetActorY(0);
    curZ = GetActorZ(0);

    floorHeight = GetActorFloorZ(heightTID);

    ledgeX       = GetActorX(heightTID) - curX;
    ledgeY       = GetActorY(heightTID) - curY;
    origDistance = magnitudeTwo(ftoi(ledgeX), ftoi(ledgeY));

    i =  0;
    i =  (keyDown(BT_FORWARD) << 0);
    i |= (keyDown(BT_BACK)    << 1);
    i |= (keyDown(BT_JUMP)    << 2);

    while (1)
    {
		GiveInventory("Grabbing_A_Ledge", 1);
        floorOldHeight = floorHeight;
        floorHeight = GetActorFloorZ(heightTID);

        if (!PlayerInGame(pln) || isDead(0)) { break; }
        if (GetActorZ(0) - GetActorFloorZ(0) <= 4.0) { break; }
        if (abs(floorOldHeight - floorHeight) > 16.0)
        {
            SetActorVelocity(0, 0,0,0, 0,0);
            break;
        }

        newZ = GetActorZ(heightTID) - 44.0;
        PlaceOnFloor(heightTID);

        if (curZ != newZ)
        {
            if ((abs(curZ - newZ) < 8.0) || instantZ) { curZ = newZ; }
            else { curZ += (8.0 * sign(newZ - curZ)); }
        }
        else { instantZ = 1; }

        curX = GetActorX(0);
        curY = GetActorY(0);

        ledgeX     = GetActorX(heightTID) - curX;
        ledgeY     = GetActorY(heightTID) - curY;
        ledgeMag   = magnitudeTwo(ftoi(ledgeX), ftoi(ledgeY));
        ledgeAngle = VectorAngle(ledgeX, ledgeY);

        maxLeft  = ledgeAngle - 0.25;
        maxRight = ledgeAngle + 0.25;

        curAngle = GetActorAngle(0);
        ledgeMove = 0;
        
        if (maxLeft < 0)
        {
            if (curAngle > (0.5 + maxLeft)) { curAngle -= 1.0; }
        }
        else if (maxRight > 1.0)
        {
            if (curAngle < (maxRight - 0.5)) { curAngle += 1.0; }
        }
        
        if (maxLeft > curAngle)  { ledgeMove = 1; }
        if (maxRight < curAngle) { ledgeMove = 1; }

        SetActorPosition(0, curX, curY, curZ, 0);

        if (curZ - GetActorZ(0) > 16.0)
        {
            Spawn("FingerCrunch", GetActorX(0), GetActorY(0), GetActorZ(0)+24.0);
            break;
        }

        ledgeX /= ledgeMag;
        ledgeY /= ledgeMag;

        SetActorVelocity(0, 24*ledgeX, 24*ledgeY,0, 0, 0);
		GiveInventory("LedgeGrabbingRightNow", 1);
		Delay(9);
		TakeInventory("LedgeGrabbingRightNow", 1);
		for (i = 0; i < 2; i++)
		{
			curZ += 12.0;
			SetActorPosition(0, curX, curY, curZ, 0);
			Delay(1);
		}
		
		SetActorVelocity(0, 2*cos(curAngle),2*sin(curAngle),9.0, 0, 1);
		TakeInventory("Grabbing_A_Ledge", 20);
		break;
       
        

        Delay(1);
    }
    SetActorProperty(0, APROP_Gravity, 1.0);
    SetActorProperty(0, APROP_Speed, oldSpeed);
    Thing_Remove(heightTID);
    grabbing[pln] = 0;
    dontGrab[pln] = 1;
}

script PARKMORE_WALLHOLD (void)
{
    int pln = PlayerNumber();
    int oldSpeed;
    int curX, curY, curZ;
    int origAngle, curAngle;
    int maxLeft, maxRight;
    int facingWall;
    int wallHit = 1, oldWallHit = 1;
    int i;
    
    curAngle = GetActorAngle(0);
    origAngle = curAngle;

    grabbing[pln] = 1;
    TakeInventory("KickTrail", 1);
    oldSpeed = GetActorProperty(0, APROP_Speed);

    SetActorProperty(0, APROP_Speed, 0.0);
    SetActorProperty(0, APROP_Gravity, 0);
    SetActorVelocity(0, 48*cos(curAngle),48*sin(curAngle),9.0, 0, 0);

    Delay(1);

    curAngle = GetActorAngle(0);
    curX = GetActorX(0);
    curY = GetActorY(0);
    curZ = GetActorZ(0);

    while (1)
    {
        if (!PlayerInGame(pln) || isDead(0)) { break; }
        if (GetActorZ(0) - GetActorFloorZ(0) <= 4.0) { break; }

        curX = GetActorX(0);
        curY = GetActorY(0);
        curZ = GetActorZ(0);
        curAngle = GetActorAngle(0);

        maxLeft  = origAngle - 0.25;
        maxRight = origAngle + 0.25;

        curAngle = GetActorAngle(0);
        facingWall = 1;

        oldWallHit  = wallHit;
        wallHit     = CheckInventory("CanGrab");
        TakeInventory("CanGrab", 0x7FFFFFFF);
        TakeInventory("ParkmoreAngleIndicator", 0x7FFFFFFF);
        GiveInventory("ParkmoreAngleIndicator", ftoi(origAngle * 360));
        GiveInventory("ParkmoreCheckWallGrab2", 1);

        if (!(wallHit || oldWallHit)) { break; }
         
        if (maxLeft < 0)
        {
            if (curAngle > (0.5 + maxLeft)) { curAngle -= 1.0; }
        }
        else if (maxRight > 1.0)
        {
            if (curAngle < (maxRight - 0.5)) { curAngle += 1.0; }
        }
        
        if (maxLeft > curAngle)  { facingWall = 0; }
        if (maxRight < curAngle) { facingWall = 0; }

        SetActorPosition(0, curX, curY, curZ, 0);

        if (facingWall) { SetActorVelocity(0, 0,0,-0.4, 0, 0); }
        else            { SetActorVelocity(0, 0,0,-1.6, 0, 0); }

        if ((keyPressed(BT_BACK)    && !facingWall) ||
            (keyPressed(BT_FORWARD) && facingWall))
        {
            break;
        }

        if ((keyPressed(BT_FORWARD) && !facingWall) || keyPressed(BT_JUMP))
        {
           // ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_KICK, WD_FORWARD, 0);
           // addTimer(pln, TIMER_BOUNCED, 2);
            break;
        }

        if (keyPressed(BT_BACK) && facingWall)
        {
           // ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_KICK, WD_BACK, 0);
           // addTimer(pln, TIMER_BOUNCED, 2);
            break;
        }

        Delay(1);
    }

    SetActorProperty(0, APROP_Gravity, 1.0);
    SetActorProperty(0, APROP_Speed, oldSpeed);
    grabbing[pln] = 0;
    dontGrab[pln] = 1;
}


/*
function void MultiJump(int countJump, int force)
{
    int pln = PlayerNumber();
    int jumpHeight = getJumpZ();

    int forward, side, up;
    int forwardx, forwardy, sidex, sidey;
    int velx, vely, velz;
    int angle = GetActorAngle(0);

    if ((force != 1) && (playerJumps[pln] + countJump > MaxJumpCount)) { return; }
    if (playerJumps[pln] == 0) { return; }
    
    forward = keyDown(BT_FORWARD) - keyDown(BT_BACK);
    forward *= cond(keyDown(BT_FORWARD), JUMP_FORWARD, JUMP_BACK);

    side    = keyDown(BT_MOVERIGHT) - keyDown(BT_MOVELEFT);
    side    *= JUMP_SIDE;

    forwardx = FixedMul(cos(angle), forward);
    forwardy = FixedMul(sin(angle), forward);

    sidex = FixedMul(cos(angle-0.25), side);
    sidey = FixedMul(sin(angle-0.25), side);
    
    velx = forwardx + sidex;
    vely = forwardy + sidey;

    playerJumps[pln] += countJump; 

    if (velx || vely)
    {
        SetActorVelocity(0, velx, vely, jumpHeight, 0, 1);
    }
    else
    {
        SetActorVelocity(0, GetActorVelX(0), GetActorVelY(0), FixedMul(jumpHeight, 1.2), 0, 1);
    }
}
*/

function void MultiJump(int countJump, int force)
{
    int pln = PlayerNumber();
    int jumpHeight = getJumpZ();

    if ((force != 1) && (MaxJumpCount >= 0) && (playerJumps[pln] + countJump > MaxJumpCount)) { return; }
    if (playerJumps[pln] == 0) { return; }

    playerJumps[pln] += countJump; 

    SetActorVelocity(0, GetActorVelX(0), GetActorVelY(0), jumpHeight, 0, 1);
}

function void Lunge(int force)
{
    int pln = PlayerNumber();
    int jumpHeight = FixedMul(getJumpZ(), LUNGE_ZMULT);
    int velx, vely, velz;
    int angle = GetActorAngle(0);

    if ((force != 1) && (playerJumps[pln] != 0)) { return; }

    playerJumps[pln] += 1; 

    velX = FixedMul(cos(angle), LUNGE_FORWARD);
    velY = FixedMul(sin(angle), LUNGE_FORWARD);
    velZ = jumpHeight;

    SetActorVelocity(0, velX, velY, velZ, 0, 1);
}

function void HighJump(int force)
{
    int pln = PlayerNumber();
    int jumpHeight = FixedMul(getJumpZ(), HIJUMP_ZMULT);
    int velx, vely, velz;
    int angle = GetActorAngle(0);

    if ((force != 1) && (playerJumps[pln] > 0)) { return; }

    playerJumps[pln] = max(playerJumps[pln]+1, 1);; 

    velX = FixedMul(cos(angle), -HIJUMP_BACK);
    velY = FixedMul(sin(angle), -HIJUMP_BACK);
    velZ = jumpHeight;

   // SetActorVelocity(0, velX, velY, velZ, 0, 1);
   // ACS_ExecuteAlways(PARKMORE_TURN, 0, 180, 6, random(0,1));
}

/*  :DAEMONS
 * The scripts that loop
 */

script PARKMORE_OPEN open
{
    if (GetCVar("parkmore_jumpcount") == 0)
    {
        //ConsoleCommand("set parkmore_jumpcount 2");
        //ConsoleCommand("archivecvar parkmore_jumpcount");
    }

    IsServer = 1;

    int cjumps, oldcjumps;
    
    while (1)
    {
        oldcjumps = cjumps;
        cjumps = GetCVar("parkmore_jumpcount");

        if (cjumps != oldcjumps) { MaxJumpCount = cjumps; }

        Delay(1);
    }
}

function int getTimer(int pln, int which)
{
    return playerTimers[pln][which];
}

function void addTimer(int pln, int which, int add)
{
    if (add) { playerTimers[pln][which] = add; }
}

function void addCTimers(int pln)
{
    int i = max(0, defaultCVar("parkmore_dodgewindow",  8));
    int j = max(0, defaultCVar("parkmore_hijumpwindow", 4));

    addTimer(pln, TIMER_CFORWARD,  keyPressed(BT_FORWARD)   * i);
    addTimer(pln, TIMER_CRIGHT,    keyPressed(BT_MOVERIGHT) * i);
    addTimer(pln, TIMER_CBACK,     keyPressed(BT_BACK)      * i);
    addTimer(pln, TIMER_CLEFT,     keyPressed(BT_MOVELEFT)  * i);
    addTimer(pln, TIMER_HBACK,     keyPressed(BT_BACK)      * j);
}

function int tickTimer(int pln, int timerNum)
{
    int i = max(playerTimers[pln][timerNum]-1, 0);
    playerTimers[pln][timerNum] = i;
    return i;
}

function void tickTimers(int pln)
{
    int i;
    for (i = 0; i < TIMER_COUNT; i++)
    {
        tickTimer(pln, i);
    }
}

function void printTimers(int pln)
{
    int i, j, printstr;
    for (i = 0; i < TIMER_COUNT; i++)
    {
        j = playerTimers[pln][i];
        printStr = StrParam(s:printStr, d:i, s:":", d:!!j, s:"  ");
    }

    Print(s:printStr);
}


script PARKMORE_ENTER enter
{
    int pln = PlayerNumber();
    int ground, wasGround, didSpecial;
    int inWater, wasInWater;
    int i;
    int direction, dDirection;

	//Checks For Classic Mode or CVARs
    while (PlayerInGame(pln))
    {
        if (isDead(0))
        {
            playerJumps[pln] = 0;
            hasKicked[pln] = 0;
            grabbing[pln] = 0;
            dontGrab[pln] = 0;
            TakeInventory("KickTrail", 1);
            Delay(1);
            continue;
        }

        wasGround = ground;
        ground = parkmoreOnGround(0);

        PlayerGrounds[pln][0] = ground;
        PlayerGrounds[pln][1] = wasGround;

        wasInWater = inWater;
        inWater = CheckInventory("WaterIndicator");

        direction = getDirection();

        if (CheckInventory("NoParkour"))
        {
            TakeInventory("KickTrail", 1);
            if (ground)
            {
                playerJumps[pln] = 0;
                hasKicked[pln] = 0;
                grabbing[pln] = 0;
                dontGrab[pln] = 0;
            }
            else
            {
                playerJumps[pln] = max(1, playerJumps[pln]);
            }
            Delay(1);
            continue;
        }

        if (!(getTimer(pln, TIMER_BOUNCED) || wasGround) && keyPressed(BT_JUMP))
        {
            dDirection = -1;

            switch (direction)
            {
              case DIR_NW: dDirection = WD_FORWLEFT;    break;
              case DIR_N:  dDirection = WD_FORWARD;     break;
              case DIR_NE: dDirection = WD_FORWRITE;    break;
              case DIR_SW: dDirection = WD_BACKLEFT;    break;
              case DIR_S:  dDirection = WD_BACK;        break;
              case DIR_SE: dDirection = WD_BACKRITE;    break;
              case DIR_W:  dDirection = WD_LEFT;        break;
              case DIR_E:  dDirection = WD_RIGHT;       break;
            }

            if (dDirection != -1)
            {
                /*ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_KICK, dDirection, 0);
                if (dDirection == WD_FORWARD)
                {
                    ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_KICKUP, WD_KICK, 2);
                }
                addTimer(pln, TIMER_BOUNCED, 2);
				*/
            }
        }

        didSpecial = 0;

        if (ground || inWater)
        {
            playerJumps[pln] = 0;
            hasKicked[pln] = 0;
            grabbing[pln] = 0;
            dontGrab[pln] = 0;
        }
        else
        {
            if (keyPressed(BT_JUMP) && !DidSpecials[pln] && !grabbing[pln])
            {
                //MultiJump(1, 0);
            }

            playerJumps[pln] = max(1, playerJumps[pln]);

            if (!(ground || wasGround))
            {
                if (keyDown(BT_CROUCH) && !grabbing[pln] && !dontGrab[pln])
                {
                    ACS_ExecuteAlways(PARKMORE_LEDGEWALL, 0, LW_WALL,0,0);
                }
                else if ((GetActorVelZ(0) < 0 ) && !grabbing[pln] && !dontGrab[pln])
                {
                    ACS_ExecuteAlways(PARKMORE_LEDGEWALL, 0, LW_LEDGE,0,0);
                }
            }
        }

        tickTimer(pln, TIMER_BOUNCED);
        DidSpecials[pln] = max(0, DidSpecials[pln]-1);

        Delay(1);
    }
}

script PARKMORE_ENTER2 enter clientside
{
    int pln = PlayerNumber();
    int dodgeDir, pukeStr;
    int ground, wasGround;
    int myLock = ClientEnterLocks[pln] + 1;

    ClientEnterLocks[pln] = myLock;
	
    while (ClientEnterLocks[pln] == myLock)
    {
        dodgeDir = -1;

        wasGround = ground;
        ground = parkmoreOnGround(0);

        CPlayerGrounds[pln][0] = ground;
        CPlayerGrounds[pln][1] = wasGround;

        if (!getTimer(pln, TIMER_DIDDODGE))
        {
            if (keyPressed(BT_MOVELEFT) && getTimer(pln, TIMER_CLEFT))
            {
                dodgeDir = WD_LEFT;
            }
            else if (keyPressed(BT_FORWARD) && getTimer(pln, TIMER_CFORWARD))
            {
                dodgeDir = WD_FORWARD;
            }
            else if (keyPressed(BT_MOVERIGHT) && getTimer(pln, TIMER_CRIGHT))
            {
                dodgeDir = WD_RIGHT;
            }
            else if (keyPressed(BT_BACK) && getTimer(pln, TIMER_CBACK))
            {
                dodgeDir = WD_BACK;
            }

            if (dodgeDir != -1)
            {
                addTimer(pln, TIMER_DIDDODGE, 2);

                /*if (IsServer)  // is serverside anyway, let's not go through hoops
                {
                    ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_DODGE, dodgeDir, 0);
                }*/
               // ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_DODGE, dodgeDir, 0);
                //else
                
                if (!IsServer)
                {
                    pukeStr = StrParam(s:"puke -", d:PARKMORE_REQUESTDODGE, s:" ", d:dodgeDir);
                    //ConsoleCommand(pukeStr);
                }
            }
        }

        if (keyPressed(BT_JUMP))
        {
            if (getTimer(pln, TIMER_HBACK) > 0) 
            {
                if (CPlayerGrounds[pln][1])
                {
                    playerJumps[pln]--;
                    HighJump(0);
                    DidSpecials[pln] = 2;
                }
                
                if (!IsServer)
                {
                    pukeStr = StrParam(s:"puke -", d:PARKMORE_REQUESTDODGE, s:" 0 1");
                    //ConsoleCommand(pukeStr);
                }
            }
        }

        tickTimer(pln, TIMER_CFORWARD);
        tickTimer(pln, TIMER_CRIGHT);
        tickTimer(pln, TIMER_CBACK);
        tickTimer(pln, TIMER_CLEFT);
        tickTimer(pln, TIMER_HBACK);
        addCTimers(pln);

        tickTimer(pln, TIMER_DIDDODGE);

        Delay(1);
    }

}

script PARKMORE_REQUESTDODGE (int direction, int hijump) net
{
    int pln;

    if (hijump)
    {
        if (PlayerGrounds[pln][1])
        {
            playerJumps[pln]--;
            HighJump(0);
            DidSpecials[pln] = 2;
        }
    }
    else
    {
       // ACS_ExecuteAlways(PARKMORE_WALLBOUNCE, 0, WB_DODGE, direction, 0);
    }
}



/*  :USER
 * The customisable crap
 */
script PARKMORE_ASSORTED (int type, int a1, int a2)
{
    int pln = PlayerNumber();
    int x,y,z, ang, offset, tid;
    int i, j;

    switch (type)
    {
      case 0:
        x = GetActorX(0);
        y = GetActorY(0);
        z = GetActorZ(0);

        for (i = 0; i < a2; i++)
        {
            ang = random(0.0, 1.0);
            
            j = sqrt(itof(a1)/8);
            offset = random(0.0, j);
            offset = quad(1.0, 0.0, 0.0, offset);
            offset *= randSign();
            offset += itof(a1);
         
            Spawn("ParkmoreHeightTrail", x+FixedMul(offset,cos(ang)), y+FixedMul(offset,sin(ang)), z, tid);
        }
        break;

      case 1:
        SetResultValue(CheckInventory("ParkmoreAngleIndicator"));
        break;
    }
}
