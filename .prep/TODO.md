# Art
- A better plasma shot ✅
- An enemy  ✅
- Exhaust animation for player ship ✅
- Shield ✅

# Gameplay & Engine

- Add shield Visuals
- In-Game GUI
	- Status info
		- Health bar ✅
		- Shield bar ✅
		- Armour bar ✅
		- Energy bar
	- Radar system / enemy locator
- End of run
	- Warp out animation
	- End screen
	- End logic
- Scoring
	- Score animation on hit
	- Score tracking in script ✅
	- Score display ✅
- Pickups
	- New items
	- Current run boosts (HP etc)


## Cleanup & Maintenance
- Convert plasma gun to gun module ✅

## Bugs
 - Enemies die instantly ✅
 - Pause related
	 - Timer keeps going after pause
	 - Player sprite keeps rotating after pause

- Timer related
	- Timer keeps going after pause
	- Timer doesn't reset
	- Timer is based on total time since game started, this is just wrong
		- Need a unique timer for in-run time that can be paused and reset