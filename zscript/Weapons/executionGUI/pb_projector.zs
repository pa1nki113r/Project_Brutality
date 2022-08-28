// Projector class from target spy mod, because I'm terrible with coding graphics and OpenGL - Pa1n

/*	kd:
	
	Here's how to do projections and deprojections. You'd use the subclasses
	to do anything worthwhile. You may project world to screen and backwards.
	
	*/

class pb_ProjScreen {
	
	// kd: Screen info
	protected vector2				resolution;
	protected vector2				origin;
	protected vector2				tan_fov_2;
	protected double				pixel_stretch;
	protected double				aspect_ratio;
	
	// kd: Setup calls which you'll need to call at least once.
	void CacheResolution () {
		CacheCustomResolution((Screen.GetWidth(), Screen.GetHeight()) );
	}
	
	void CacheCustomResolution (vector2 new_resolution) {
		
		// kd: This is for convenience and converting normal <-> screen pos.
		resolution = new_resolution;
		
		// kd: This isn't really necessary but I kinda like it.
		pixel_stretch = level.pixelstretch;
		
		// kd: Get the aspect ratio. 5:4 is handled just like 4:3... I GUESS
		// this'll do.
		aspect_ratio = max(4.0 / 3, Screen.GetAspectRatio());
	}
	
	double AspectRatio () const {
		return aspect_ratio;
	}
	
	// kd: Once you know you got screen info, you can call this whenever your
	// fov changes. Like CacheFov(player.fov) will do.
	void CacheFov (double hor_fov = 90) {
	
		// kd: This holds: aspect ratio = tan(horizontal fov) / tan(ver fov).
		// gzd always uses hor fov, but the fov only holds in 4:3 (in a 4:3 box
		// in your screen centre), so we just extend it.
		tan_fov_2.x	= tan(hor_fov / 2) * aspect_ratio / (4.0 / 3);
		tan_fov_2.y	= tan_fov_2.x / aspect_ratio;
	}
	
	// kd: Also need some view info. Angle is yaw, pitch, roll in world format
	// so positive pitch is up. Call one of the following functions.
	protected vector3				view_ang;
	protected vector3				view_pos;
	
	
	// GL Stuff, who tf plays PB in software renderer anyway? - Pa1n
	protected vector3				forw_unit;
	protected vector3				right_unit;
	protected vector3				down_unit;
	
	ui void OrientForRenderOverlay (RenderEvent event) {
		Reorient(
			event.viewpos, (
			event.viewangle,
			event.viewpitch,
			event.viewroll));
	}
	
	
// 	virtual void Reorient (vector3 world_view_pos, vector3 world_ang) {
// 		view_ang = world_ang;
// 		view_pos = world_view_pos;
// 	}
	
	void Reorient (vector3 world_view_pos, vector3 world_ang) {
	
		// kd: Pitch is a weird gzd joke. It's probably to compensate looking
		// speed and all. After that, you see what makes this fast.
		world_ang.y = VectorAngle(
			cos(world_ang.y),
			sin(world_ang.y) * pixel_stretch);
		
		
// 		super.Reorient(world_view_pos, world_ang);
		view_ang = world_ang;
		view_pos = world_view_pos;
		
		let cosang	= cos(world_ang.x);
		let cosvang	= cos(world_ang.y);
		let cosrang	= cos(world_ang.z);
		let sinang	= sin(world_ang.x);
		let sinvang	= sin(world_ang.y);
		let sinrang	= sin(world_ang.z);
		
		let right_no_roll	= (
			sinang,
		-	cosang,
			0);
		
		let down_no_roll	= (
		-	sinvang * cosang,
		-	sinvang * sinang,
		-	cosvang);
		
		forw_unit = (
			cosvang * cosang,
			cosvang * sinang,
		-	sinvang);
		
		down_unit	= cosrang * down_no_roll	- sinrang * right_no_roll;
		right_unit	= cosrang * right_no_roll	+ sinrang * down_no_roll;
	}
	
	
	// kd: Projection handling. These get called to make stuff a little faster,
	// since you may wanna project many many times.
	protected vector3				forw_in;
	protected vector3				right_in;
	protected vector3				down_in;
	
	protected vector3				forw_out;
	protected vector3				right_out;
	protected vector3				down_out;
	
	
	
	// kd: Now we can do projections and such (position in the level, go to
	// your screen).
	protected double				depth;
	protected vector2				proj_pos;
	protected vector3				diff;
	void BeginProjection () {
		forw_in		= forw_unit;
		right_in	= right_unit / tan_fov_2.x;
		down_in		= down_unit  / tan_fov_2.y;
		
		forw_in.z	*= pixel_stretch;
		right_in.z	*= pixel_stretch;
		down_in.z	*= pixel_stretch;
	}
	
	void ProjectWorldPos (vector3 world_pos) {
		diff			= levellocals.vec3diff(view_pos, world_pos);
		proj_pos		= (diff dot right_in, diff dot down_in);
		depth			= diff dot forw_in;
	}
	
	
	void ProjectActorPos (Actor mo, vector3 offset, double t) {
		let inter_pos	= mo.prev + t * (mo.pos - mo.prev);
		diff			= levellocals.vec3diff(view_pos, inter_pos + offset);
		proj_pos		= (diff dot right_in, diff dot down_in);
		depth			= diff dot forw_in;
	}
	
	void ProjectActorPosPortal (Actor mo, vector3 offset, double t) {
		let inter_pos	= mo.prev + t * levellocals.vec3diff(mo.prev, mo.pos);
		diff			= levellocals.vec3diff(view_pos, inter_pos + offset);
		proj_pos		= (diff dot right_in, diff dot down_in);
		depth			= diff dot forw_in;
	}
	
	vector2 ProjectToNormal () const {
		return proj_pos / depth;
	}
	
	vector2 ProjectToScreen () const {
		let normal_pos = proj_pos / depth + (1, 1);
		
		return 0.5 * (
			normal_pos.x * resolution.x,
			normal_pos.y * resolution.y);
	}
	
	vector2 ProjectToCustom (
	vector2	origin,
	vector2	resolution) const {
		let normal_pos = proj_pos / depth + (1, 1);
		
		return origin + 0.5 * (
			normal_pos.x * resolution.x,
			normal_pos.y * resolution.y);
	}
	
	bool IsInFront () const {
		return 0 < depth;
	}
	
	bool IsInScreen () const {
		if(	proj_pos.x < -depth || depth < proj_pos.x ||
			proj_pos.y < -depth || depth < proj_pos.y) {
			return false;
		}
		
		return true;
	}
	
	// kd: Deprojection (point on screen, go into the world):
	void BeginDeprojection () {
		
		// kd: Same deal as above, but reversed. This time, we're compensating
		// for what we rightfully assume is a projected position.
		forw_out	= forw_unit;
		right_out	= right_unit * tan_fov_2.x;
		down_out	= down_unit  * tan_fov_2.y;
		
		forw_out.z	/= pixel_stretch;
		right_out.z /= pixel_stretch;
		down_out.z	/= pixel_stretch;
	}
	
	vector3 DeprojectNormalToDiff (
		vector2	normal_pos,
		double	depth) const {
			return depth * (
				forw_out +
				normal_pos.x * right_out +
				normal_pos.y * down_out);
	}
	
	vector3 DeprojectScreenToDiff (
		vector2	screen_pos,
		double	depth) const {
		
			// kd: Same thing...
			let normal_pos = 2 * (
				screen_pos.x / resolution.x,
				screen_pos.y / resolution.y) - (1, 1);
			
			return depth * (
				forw_out +
				normal_pos.x * right_out +
				normal_pos.y * down_out);
		}
		
		virtual vector3 DeprojectCustomToDiff (
		vector2	origin,
		vector2	resolution,
		vector2	screen_pos,
		double	depth = 1) const {
			return (0, 0, 0);
	}
	
	// kd: A normal position is in the -1 <= x, y <= 1 range on your screen.
	// This will be your screen no matter the resolution:
	
	/*
	
	(-1, -1) --	---	---	(0, -1) ---	---	---	---	(1, -1)
	|												|
	|												|
	|												|
	(-1, 0)				(0, 0)					(1, 0)
	|												|
	|												|
	|												|
	(-1, 1)	---	---	---	(0, 1)	---	---	---	---	(1, 1)
	
	*/
	
	// So this scales such a position back into your drawing resolution.
	
	vector2 NormalToScreen (vector2 normal_pos) const {
		normal_pos = 0.5 * (normal_pos + (1, 1));
		return (
			normal_pos.x * resolution.x,
			normal_pos.y * resolution.y);
	}
	
	// kd: And this brings a screen position to normal. Make sure the resolution
	// is the same for your cursor.
	
	vector2 ScreenToNormal (vector2 screen_pos) const {
		screen_pos = (
			screen_pos.x / resolution.x,
			screen_pos.y / resolution.y);
		return 2 * screen_pos - (1, 1);
	}
	
	// kd: Other interesting stuff.
	
	vector3 Difference () const {
		return diff;
	}
	
	double Distance () const {
		return diff.length();
	}
}
