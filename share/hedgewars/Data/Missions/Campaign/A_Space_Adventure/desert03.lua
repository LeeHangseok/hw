------------------- ABOUT ----------------------
--
-- Hero has to use the rc plane end perform some
-- flying tasks

HedgewarsScriptLoad("/Scripts/Locale.lua")
HedgewarsScriptLoad("/Scripts/Animate.lua")
HedgewarsScriptLoad("/Missions/Campaign/A_Space_Adventure/global_functions.lua")

-- globals
local missionName = loc("Precise flying")
local challengeObjectives = loc("Use the rc plane and destroy the all the targets").."|"..
	loc("Each time you destroy your level targets you'll get teleported to the next level").."|"..
	loc("You'll have only one rc plane at the start of the mission").."|"..
	loc("During the game you can get new plane by getting the weapon crates")
local currentTarget = 1
-- hogs
local hero = {
	name = loc("Hog Solo"),
	x = 100,
	y = 170
}
-- teams
local teamA = {
	name = loc("Hog Solo"),
	color = tonumber("38D61C",16) -- green
}
-- creates & targets
local rcCrates = {
	{ x = 1680, y = 240},
	{ x = 2810, y = 720},
	{ x = 2440, y = 660},
	{ x = 256, y = 1090},
}
local targets = {
	{ x = 2070, y = 410},
	{ x = 3880, y = 1430},
	{ x = 4000, y = 1430},
	{ x = 2190, y = 1160},
	{ x = 2190, y = 1460},
	{ x = 2110, y = 1700},
	{ x = 2260, y = 1700},
	{ x = 2085, y = 1330},
	{ x = 156, y = 1400},
	{ x = 324, y = 1400},
	{ x = 660, y = 1310},
	{ x = 1200, y = 1310},
	{ x = 1700, y = 1310},
}

-------------- LuaAPI EVENT HANDLERS ------------------

function onGameInit()
	GameFlags = gfOneClanMode
	Seed = 1
	TurnTime = -1
	CaseFreq = 0
	MinesNum = 0
	MinesTime = 1
	Explosives = 0
	Map = "desert03_map"
	Theme = "Desert"
	
	-- Hog Solo
	AddTeam(teamA.name, teamA.color, "Bone", "Island", "HillBilly", "cm_birdy")
	hero.gear = AddHog(hero.name, 0, 1, "war_desertgrenadier1")
	AnimSetGearPosition(hero.gear, hero.x, hero.y)
	
	initCheckpoint("desert03")
	
	AnimInit()
	--AnimationSetup()
end

function onGameStart()
	AnimWait(hero.gear, 3000)
	FollowGear(hero.gear)
	ShowMission(missionName, loc("Challenge Objectives"), challengeObjectives, -amSkip, 0)

	AddEvent(onHeroDeath, {hero.gear}, heroDeath, {hero.gear}, 0)
	AddEvent(onLose, {hero.gear}, lose, {hero.gear}, 0)

	-- original crates and targets
	SpawnAmmoCrate(rcCrates[1].x, rcCrates[1].y, amRCPlane)
	targets[1].gear = AddGear(targets[1].x, targets[1].y, gtTarget, 0, 0, 0, 0)
	
	-- hero ammo
	AddAmmo(hero.gear, amRCPlane, 1)

	SendHealthStatsOff()
end

function onGameTick()
	AnimUnWait()
	if ShowAnimation() == false then
		return
	end
	ExecuteAfterAnimations()
	CheckEvents()
end

function onGameTick20()
	checkTargetsDestroied()
end

function onAmmoStoreInit()
	SetAmmo(amNothing, 0, 0, 0, 0)
	SetAmmo(amRCPlane, 0, 0, 0, 1)
end

function onPrecise()
	if GameTime > 3000 then
		SetAnimSkip(true)   
	end
end

-------------- EVENTS ------------------

function onHeroDeath(gear)
	if not GetHealth(hero.gear) then
		return true
	end
	return false
end

function onLose(gear)
	if GetHealth(hero.gear) and currentTarget < 4 and GetAmmoCount(hero.gear, amRCPlane) == 0 then
		return true
	end
	return false
end

-------------- ACTIONS ------------------

function heroDeath(gear)
	gameOver()
end

function lose(gear)
	gameOver()
end

----------------- Other Functions -----------------

function checkTargetsDestroied()
	if currentTarget == 1 then
		if not GetHealth(targets[1].gear) then
			AddCaption(loc("Level 1 clear!"))
			SetGearPosition(hero.gear, 3590, 90)
			currentTarget = 2
			setTargets(currentTarget)
		end
	elseif currentTarget == 2 then
		if not (GetHealth(targets[2].gear) or GetHealth(targets[3].gear))  then
			AddCaption(loc("Level 2 clear!"))
			SetGearPosition(hero.gear, 1110, 580)
			currentTarget = 3
			setTargets(currentTarget)
		end
	elseif currentTarget == 3 then
		
	else
		win()
	end
end

function setTargets(ct)
	if ct == 2 then
		SpawnAmmoCrate(rcCrates[2].x, rcCrates[2].y, amRCPlane)
		for i=2,3 do
			targets[i].gear = AddGear(targets[i].x, targets[i].y, gtTarget, 0, 0, 0, 0)
		end
	elseif ct == 3 then
		SpawnAmmoCrate(rcCrates[3].x, rcCrates[3].y, amRCPlane)
		SpawnAmmoCrate(rcCrates[3].x, rcCrates[3].y, amRCPlane)
		SpawnAmmoCrate(rcCrates[4].x, rcCrates[4].y, amNothing)
		for i=4,13 do
			targets[i].gear = AddGear(targets[i].x, targets[i].y, gtTarget, 0, 0, 0, 0)
		end
	end
end

function win()
	EndGame()
end

function gameOver()
	SendStat('siGameResult', loc("Hog Solo lost, try again!")) --1
	SendStat('siCustomAchievement', loc("You have to destroy all the targets")) --11		
	SendStat('siCustomAchievement', loc("You will fail if you run out of ammo and there are still targets available")) --11		
	SendStat('siCustomAchievement', loc("Read the Challenge Objectives from within the mission for more details")) --11		
	SendStat('siPlayerKills','0',teamA.name)
	EndGame()
end
