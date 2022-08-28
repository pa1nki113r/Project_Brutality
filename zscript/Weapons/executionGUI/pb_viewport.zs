// Just going to borrow this from target spy because... magic - Pa1n
// Still compatible with TS, just need the viewport and projector lib

/*	kd:
	
	This helps repositioning the view port for stuff like screen blocks. It's a
	little more than that, cuz it can also determine stuff like, "is this scene
	position in the viewport?" Cuz the scene doesn't necessarily match the
	viewport.
	
	Well yea... see the examples. Imagine how annoying it is to even get this
	idea to begin with.
	
	*/

struct pb_Viewport {
	
	private vector2					scene_origin;
	private vector2					scene_size;
	
	private vector2					viewport_origin;
	private vector2					viewport_bound;
	private vector2					viewport_size;

	private double					scene_aspect;
	private double					viewport_aspect;
	
	private double					scale_f;
	private vector2					scene_to_viewport;
	
	ui void FromHud () const {
		scene_aspect = Screen.GetAspectRatio();
		
		vector2 hud_origin;
		vector2 hud_size;
		
		[hud_origin.x, hud_origin.y, hud_size.x, hud_size.y] =
			Screen.GetViewWindow();
		
		let window_resolution = (
			Screen.GetWidth(),
			Screen.GetHeight());
		
		let window_to_normal = (
			1.0 / window_resolution.x,
			1.0 / window_resolution.y);
		
		viewport_origin = (
			window_to_normal.x * hud_origin.x,
			window_to_normal.y * hud_origin.y);
		
		viewport_size = (
			window_to_normal.x * hud_size.x,
			window_to_normal.y * hud_size.y);
		
		viewport_aspect = hud_size.x / hud_size.y;
		
		viewport_bound = viewport_origin + viewport_size;
		
		// kd: The scene is what is actually rendered. It's not always the same
		// as the viewport. When the statusbar comes into play, the scene is
		// obscured by the viewport being too small.
		
		// Example: Compare screenblocks 11 against screenblocks 10 in unmodded
		// Doom. You will notice that the scaling of the 3d world is the same,
		// but it's moved up by half the height of the statusbar.
		
		// That makes this viewport stuff kinda really annoying to deal with.
		
		// Also statusbar.getsomethingfromstatusbar, really really nice naming.
		
		let statusbar_height =
			(window_resolution.y - Statusbar.GetTopOfStatusbar()) / window_resolution.y;
		
		scale_f = hud_size.x / window_resolution.x;
		
		scene_aspect = Screen.GetAspectRatio();
		
		let offset = 10 < screenblocks ? 0 : 0.5 * statusbar_height;
		
		scene_size = (
			scale_f,
			scale_f);
		
		scene_origin = viewport_origin - (0, 0.5 * (scene_size.y - viewport_size.y));
		
		scene_to_viewport = (
			viewport_size.x / scene_size.x,
			viewport_size.y / scene_size.y);
	}
	
	// kd: Is the scene pos (normal, just like projected normal) inside the
	// view port? If yes, it's visible in the 3d world, even through resizing.
	bool IsInside (vector2 scene_pos) const {
		let normal_pos = scene_origin + (
			scene_size.x * 0.5 * (1 + scene_pos.x),
			scene_size.y * 0.5 * (1 + scene_pos.y));
		
		if(	normal_pos.x < viewport_origin.x || viewport_bound.x < normal_pos.x ||
			normal_pos.y < viewport_origin.y || viewport_bound.y < normal_pos.y) {
			return false;
		}
		
		return true;
	}
	
	// kd: Use these for drawing (and make sure the aspect ratios match).
	vector2 SceneToCustom (vector2 scene_pos, vector2 resolution) const {
		let normal_pos = 0.5 * (
			(scene_pos.x + 1) * scene_size.x,
			(scene_pos.y + 1) * scene_size.y);
		
		return (
			(scene_origin.x + normal_pos.x) * resolution.x,
			(scene_origin.y + normal_pos.y) * resolution.y);
	}
	
	vector2 SceneToWindow (vector2 scene_pos) const {
		return SceneToCustom(
			scene_pos,
			(Screen.GetWidth(), Screen.GetHeight()) );
	}
	
	vector2 ViewportToCustom (vector2 viewport_pos, vector2 resolution) const {
		let normal_pos = 0.5 * (
			(viewport_pos.x + 1) * viewport_size.x,
			(viewport_pos.y + 1) * viewport_size.y);
			
		
		return (
			(viewport_origin.x + normal_pos.x) * resolution.x,
			(viewport_origin.y + normal_pos.y) * resolution.y);
	}
	
	vector2 ViewportToWindow (vector2 viewport_pos) const {
		return ViewportToCustom(
			viewport_pos,
			(Screen.GetWidth(), Screen.GetHeight()) );
	}
	
	double Scale () const {
		return scale_f;
	}
}