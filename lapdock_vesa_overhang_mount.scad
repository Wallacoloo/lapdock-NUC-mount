//all measurements in mm

// quality settings
fs=1.5; // cylinder circumferential length of each side

// lock portion shaped like:
//
// +----->
// |     x
// v y
//   ___
//  /   \
// |     | lock_open_radius
//  \   /
//   | |
//   | | lock_height
//   | |
//   \_/ lock_radius

// V2 has lock_offset_y = 6 for the side bracket, 60 for the top/bottom brackets
// V3 has lock_offset_y = 2 for the side bracket, 45 for the top/bottom brackets
lock_offset_y    = 2;
lock_radius      = 2.3;
lock_height      = 8;
lock_open_radius = 5;
// thickness of lock portion
lock_depth       = 3.5;
// thickness of portion that has to close inside lapdock
lock_depth_inner = 1.3;
// padding to allow for the screw head fitting between lock and LCD
screw_head_depth = 2.5;
screw_head_rad   = 3.7;
lock_pad_x       = 5;
lock_pad_y       = 5;
// thickness of the lapdock LCD
screen_depth     = 7;
clip_height      = 10;

plate_w = 2*lock_open_radius+2*lock_pad_x;
plate_l = 2*lock_open_radius+lock_height+2*lock_radius+2*lock_pad_y;

module lock_plate()
{
    screw_head_overhang = screw_head_rad-lock_radius;
    difference() {
        cube([plate_w, plate_l, lock_depth]);
        translate([plate_w/2,lock_pad_y+lock_radius,-1])
            cylinder($fs=fs, h=lock_depth+2, r=lock_radius);
        translate([plate_w/2,plate_l-lock_pad_y-lock_open_radius,-1]) 
            cylinder($fs=fs, h=lock_depth+2, r=lock_open_radius);
        translate([plate_w/2-lock_radius,lock_pad_y+lock_radius,-1])
            cube([2*lock_radius, lock_height+lock_radius+lock_open_radius, lock_depth+2]);
        translate([lock_pad_x, lock_pad_y-screw_head_overhang, lock_depth-screw_head_depth])
            cube([lock_open_radius*2, lock_height+2*lock_radius+2*lock_open_radius+2*screw_head_overhang, screw_head_depth+1]);
    }
    translate([0, plate_l, 0]) cube([plate_w, lock_offset_y, lock_depth]);
}

module clip()
{
    outer_rad = screen_depth/2+lock_depth;
    inner_rad = screen_depth/2;
    difference() {
        union() {
            translate([0,plate_l+lock_offset_y,outer_rad]) difference() {
                rotate([90, 0, 90]) difference() {
                    cylinder($fs=fs, h=plate_w, r=screen_depth/2+lock_depth);
                    translate([0,0,-1]) cylinder($fs=fs, h=plate_w+2, r=inner_rad);
                }
                translate([-1,-outer_rad,-outer_rad]) cube([plate_w+2, outer_rad, outer_rad*2]);
            }
            translate([0, plate_l+lock_offset_y, 2*outer_rad])
            rotate([180, 0, 0])
                cube([plate_w, clip_height, lock_depth]);
        }
        // cut off the top portion of the clip so the lapdock can close
        translate([-1, -1000, outer_rad+inner_rad+lock_depth_inner]) cube([plate_w+2, 2000, lock_depth]);
    }
}

module vesa_clip()
{
	union() {
		lock_plate();
        clip();
	}
}

vesa_clip();