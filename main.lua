--creator: Tempos & Caldnoc
local modinNimi = RegisterMod("inquisition",1)

local game = Game()

local theSaw = Isaac.GetItemIdByName( "The Saw" ) 
local theSawEntity = Isaac.GetEntityTypeByName( "TheSaw" )
local theSawEntityVariant = Isaac.GetEntityVariantByName("TheSaw")

local rnd = RNG()
local rndInt
local spawned = false
local hitChance
local proc = 20
local familiar = nil

local whip = Isaac.GetItemIdByName("Cat-o-nine-tails")
local guillotine = Isaac.GetItemIdByName("Guillotine")
local itemCount = 0
local items = {tongueTearer, book, wheel, hereticsFork, theSaw, whip, quillotine}
local isInquisitor = false

--passive items
local tongueTearer = Isaac.GetItemIdByName("Tongue Tearer") 
local broomstick = Isaac.GetItemIdByName("Broomstick")
local hereticsFork = Isaac.GetItemIdByName("Heretic's Fork")

--active items
local book = Isaac.GetItemIdByName( "Malleus Maleficarum" )
local wheel = Isaac.GetItemIdByName( "Wheel" )

--costumes
local costumeBroomstick = Isaac.GetCostumeIdByPath("gfx/characters/broomstick.anm2")
local costumeTransform = Isaac.GetCostumeIdByPath("gfx/characters/inquisitor.anm2")
--modinNimi.COSTUME_BLUE_BROOMSTICK = Isaac.GetCostumeIdByPath("gfx/characters/blue_broomstick.anm2")	--blue
--modinNimi.COSTUME_GRAY_BROOMSTICK = Isaac.GetCostumeIdByPath("gfx/characters/gray_broomstick.anm2")	--gray
--modinNimi.COSTUME_BLACK_BROOMSTICK = Isaac.GetCostumeIdByPath("gfx/characters/black_broomstick.anm2")	--black
--local costumeHereticsFork = Isaac.GetCostumeIdByPath("gfx/characters/hereticsfork.anm2")


--local Challenges = {
--	CHALLENGE_WITCHHUNT = Isaac.GetChallengeIdByName("Witch Hunt")
--	CHALLENGE_BEWITCHED = Isaac.GetChallengeIdByName("Be witched")
--}

--local holding = false		--wheel



local MIN_TEAR_DELAY = 5
--local costume = Isaac.GetCostumeIdByPath("gfx/characters/Tempos_TongueTearer.anm2")
--local costumeAdded = false
local tearBonus = 1


function modinNimi:pickupPassiveItem(player, flag)
	
	local player = Isaac.GetPlayer(0)
		
	--SAW
	if player:HasCollectible(theSaw) then
		if flag == CacheFlag.CACHE_FAMILIARS and spawned == false then
			familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, theSawEntityVariant, 0, player.Position, Vector(0,0), player)
			spawned = true
		end
	else
		spawned = false
	end
	
	--BROOMSTICK
	if player:HasCollectible(broomstick) then
		if flag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
			--if (player.GetPlayerType() == 4) then	--Blue Baby
			--blue costume
			--end
			--elseif (player.GetPlayerType() == 10 or 7) then 	--The Lost, Azazel
			--no costume change
			--end
			--elseif (player.GetPlayerType() == 14 or 15) then 	--Keeper, Apollyon
			--gray costume 
			--end
			--elseif (player.GetPlayerType() == 12 or 13) then --Black Judas, Lilith
			--black costume
			--end
			--else
			--basic costume
			player:AddNullCostume(costumeBroomstick)
			--end
		end
	end
	
	--HERETIC'S FORK
	if player:HasCollectible(hereticsFork) then
		if flag==CacheFlag.CACHE_SHOTSPEED then
			player.Damage = player.Damage + 1
			player.ShotSpeed = player.ShotSpeed - 0.4
			player:AddNullCostume(costumeHereticsFork)
		end
	end
			
	
	--TONGUE TEARER
	if player:HasCollectible(tongueTearer) then --check if player has the item
		if flag==CacheFlag.CACHE_DAMAGE then
			if (player.MaxFireDelay >= (MIN_TEAR_DELAY + tearBonus)) then 
				player.MaxFireDelay = player.MaxFireDelay - tearBonus
			end
			if (player:GetPlayerType() == 3) then --jos player on judas, niin spawnaa judas' tongue, jotain player.PlayerType()==PLAYER_JUDAS
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_JUDAS_TONGUE , player.Position, Vector(0,0), player) --jos if on totta niin spawnaa judas' tongue
			else --spawnaa TRINKET_LUCKY_TOE
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_LUCKY_TOE, player.Position, Vector(0,0), player)
			end
			--joku snipetisnapeti soundi?
		end
			--if costumeAdded == false then
				--player:AddNullCostume(costume) --visual olis tyyliin, isaacin suusta valuu vähän verta
				--costumeAdded = true
			--end
		
	--else 
		--costumeAdded = false
	end
	
	--INQUISITOR TRANSFORM
	if not isInquisitor then
		
		for k,v in pairs(items) do
			if player:HasCollectible(v) then
				itemCount = itemCount + 1
			end
		end  
		if itemCount >= 2 then
				player:AnimateHappy()
				isInquisitor = true
				player:AddHearts(1)
				player:AddNullCostume(costumeTransform)
		end
	end
	
	
end



--[[
function modinNimi:spawnItem()                               -- Main function that contains all the code

    local itemIdNumber = 511                            -- The integer value of the item you wish to spawn (1-510 for default items) 
                                                    -- 511 is normally the id if you have added one new item (gives a random item if you don't have any modded items)

    local game = Game()                                         -- The game
    local level = game:GetLevel()                               -- The level which we get from the game
    local player = Isaac.GetPlayer(0)                           -- The player
    local pos = Isaac.GetFreeNearPosition(player.Position, 80)                                                      -- Find an empty space near the player
    if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 then                      -- Only if on the first floor and only on the first frame           
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemIdNumber, pos, pos, player)     -- Spawn an item pedestal with the correct item in the spot from earlier
    end
end
]]

--WHEEL
function modinNimi:use_wheel()
	local player = Isaac.GetPlayer(0)
	player:AnimateCollectible(wheel, "LiftItem", "Idle")	
	holding = true
end


function modinNimi:onDamage()
	holding = false
end

-- if wheel CollidesWithGrid() do fallingAnimation left/right/up/down and despawn wheel

--MALLEUS MALEFICARUM
function modinNimi:use_book( )
	local player = Isaac.GetPlayer(0)
	
	player:AnimateCollectible(book, "UseItem", "Idle")	
	--player:GetEffects():AddCollectibleEffect(257, false)	-- Fire Mind 257
	
	--for _, entity in pairs(Isaac.GetRoomEntitities()) do
	--	if entity.Type == EntityType.ENTITY_TEAR then
	--		local TearData == entity:GetData()
	--		local Tear = entity:ToTear()
	--Tear:ChangeVariant(5)	--Fire Mind visual
			Tear.TearFlags = TearFlags.FLAG_BURN
	--Tear.CollisionDamage = Tear.CollisionDamage + 2
		--end
	--end
	
	
	--local entities = Isaac.GetRoomEntities()
		--for i = 1, #entities do
		--	if (entities[i]:IsVulnerableEnemy()) then
		--	entities[i]:AddBurn(EntityRef(player), 124, 150)
		--	end
		--end
		
		return true
end


local function onFamiliarUpdate(_, fam)
	
	local player = Isaac.GetPlayer(0)
	local sprite = familiar:GetSprite()
	fam:FollowPosition(player.Position)
	--Isaac.RenderText("positiot eri!" , 100, 90, 0, 75, 75, 255) --printti debuggia varten
	--Isaac.RenderText("rng nro: " ..rndInt, 100, 90, 0, 75, 75, 255) --printti debuggia varten
	if sprite:IsFinished("Sawing") then
		sprite:Play(sprite:GetDefaultAnimationName(), true)
	end
	
	if (player.FrameCount % 60 == 0) then
		local entities = Isaac.GetRoomEntities()
		local vulnerables = {}
		
		for i = 1, #entities do
			if (entities[i]:IsVulnerableEnemy() and not(entities[i]:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT))) then
				vulnerables[#vulnerables+1] = entities[i]
			end
		end
		hitChance = rnd:RandomInt(100)
		--Isaac.RenderText("taulukon index: " ..#vulnerables, 100, 100, 0, 75, 75, 255) --printti debuggia varten
		if (player.Luck * 5 + hitChance > proc) then
			if #vulnerables > 0 then
				if #vulnerables == 1 then
					vulnerables[1]:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
					vulnerables[1]:TakeDamage(2, DamageFlag.DAMAGE_FAKE, EntityRef(vulnerables[1]),0)
				else
					rndInt = rnd:RandomInt(#vulnerables-1)
					--Isaac.RenderText("rng nro: " ..rndInt, 100, 90, 0, 75, 75, 255) --printti debuggia varten
					vulnerables[rndInt+1]:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
					vulnerables[rndInt+1]:TakeDamage(2, DamageFlag.DAMAGE_FAKE, EntityRef(vulnerables[rndInt+1]),0)
				end
				
				sprite:Play("Sawing", true)
			end
		end
	end
end

--modinNimi:AddCallback(ModCallbacks.MC_POST_UPDATE, modinNimi.spawnItem)          -- Actually sets it up so the function will be called, it's called too often but oh well

modinNimi:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, modinNimi.pickupPassiveItem)

modinNimi:AddCallback(ModCallbacks.MC_USE_ITEM, modinNimi.use_book, book)
modinNimi:AddCallback(ModCallbacks.MC_USE_ITEM, modinNimi.use_wheel, wheel)

modinNimi:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, onInit, theSawEntityVariant)
modinNimi:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, onFamiliarUpdate, theSawEntityVariant)

modinNimi:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, modinNimi.onDamage, EntityType.ENTITY_PLAYER)


