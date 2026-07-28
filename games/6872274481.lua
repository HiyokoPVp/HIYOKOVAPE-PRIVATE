-- hiyoko vape ver 3.0 fixed
local canDebug = true

local run = function(func)
	if shared.vapesmooth then
		task.wait()
	end
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})

local getAccountTier = function(fuck)
	if fuck == game.Players.LocalPlayer then
		return 999999

	else
		return 1
	end	
end	



local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local guiService = cloneref(game:GetService('GuiService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))
local lightingService = cloneref(game:GetService('Lighting'))
local isnetworkowner = identifyexecutor and table.find({'Volcano', 'Nihon'}, ({identifyexecutor()})[1]) and isnetworkowner or function()
	return true
end
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset
local canDebug = true

local store = {
	attackReach = 0,
	attackReachUpdate = tick(),
	damageBlockFail = tick(),
	hand = {},
	inventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
	inventories = {},
	matchState = 0,
	queueType = 'bedwars_test',
	tools = {}
}
local Reach = {}
local HitBoxes = {}
local InfiniteFly = {}
local TrapDisabler
local AntiFallPart
local bedwars, remotes, sides, oldinvrender, oldSwing = {}, {}, {}

local function addBlur(parent)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('newvape/assets/new/blur.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent
	return blur
end

local kitImageIds = {
	['none'] = "rbxassetid://16493320215",
	["random"] = "rbxassetid://79773209697352",
	["cowgirl"] = "rbxassetid://9155462968",
	["davey"] = "rbxassetid://9155464612",
	["warlock"] = "rbxassetid://15186338366",
	["ember"] = "rbxassetid://9630017904",
	["black_market_trader"] = "rbxassetid://18922642482",
	["yeti"] = "rbxassetid://9166205917",
	["scarab"] = "rbxassetid://137137517627492",
	["defender"] = "rbxassetid://131690429591874",
	["cactus"] = "rbxassetid://104436517801089",
	["oasis"] = "rbxassetid://120283205213823",
	["berserker"] = "rbxassetid://90258047545241",
	["sword_shield"] = "rbxassetid://131690429591874",
	["airbender"] = "rbxassetid://74712750354593",
	["gun_blade"] = "rbxassetid://138231219644853",
	["frost_hammer_kit"] = "rbxassetid://11838567073",
	["spider_queen"] = "rbxassetid://95237509752482",
	["archer"] = "rbxassetid://9224796984",
	["axolotl"] = "rbxassetid://9155466713",
	["baker"] = "rbxassetid://9155463919",
	["barbarian"] = "rbxassetid://9166207628",
	["builder"] = "rbxassetid://9155463708",
	["necromancer"] = "rbxassetid://11343458097",
	["cyber"] = "rbxassetid://9507126891",
	["sorcerer"] = "rbxassetid://97940108361528",
	["bigman"] = "rbxassetid://9155467211",
	["spirit_assassin"] = "rbxassetid://10406002412",
	["farmer_cletus"] = "rbxassetid://9155466936",
	["ice_queen"] = "rbxassetid://9155466204",
	["grim_reaper"] = "rbxassetid://9155467410",
	["spirit_gardener"] = "rbxassetid://132108376114488",
	["hannah"] = "rbxassetid://10726577232",
	["shielder"] = "rbxassetid://9155464114",
	["summoner"] = "rbxassetid://18922378956",
	["glacial_skater"] = "rbxassetid://84628060516931",
	["dragon_sword"] = "rbxassetid://16215630104",
	["lumen"] = "rbxassetid://9630018371",
	["flower_bee"] = "rbxassetid://101569742252812",
	["jellyfish"] = "rbxassetid://18129974852",
	["melody"] = "rbxassetid://9155464915",
	["mimic"] = "rbxassetid://14783283296",
	["miner"] = "rbxassetid://9166208461",
	["nazar"] = "rbxassetid://18926951849",
	["seahorse"] = "rbxassetid://11902552560",
	["elk_master"] = "rbxassetid://15714972287",
	["rebellion_leader"] = "rbxassetid://18926409564",
	["void_hunter"] = "rbxassetid://122370766273698",
	["taliyah"] = "rbxassetid://13989437601",
	["angel"] = "rbxassetid://9166208240",
	["harpoon"] = "rbxassetid://18250634847",
	["void_walker"] = "rbxassetid://78915127961078",
	["spirit_summoner"] = "rbxassetid://95760990786863",
	["triple_shot"] = "rbxassetid://9166208149",
	["void_knight"] = "rbxassetid://73636326782144",
	["regent"] = "rbxassetid://9166208904",
	["vulcan"] = "rbxassetid://9155465543",
	["owl"] = "rbxassetid://12509401147",
	["dasher"] = "rbxassetid://9155467645",
	["disruptor"] = "rbxassetid://11596993583",
	["wizard"] = "rbxassetid://13353923546",
	["aery"] = "rbxassetid://9155463221",
	["agni"] = "rbxassetid://17024640133",
	["alchemist"] = "rbxassetid://9155462512",
	["spearman"] = "rbxassetid://9166207341",
	["beekeeper"] = "rbxassetid://9312831285",
	["falconer"] = "rbxassetid://17022941869",
	["bounty_hunter"] = "rbxassetid://9166208649",
	["blood_assassin"] = "rbxassetid://12520290159",
	["battery"] = "rbxassetid://10159166528",
	["steam_engineer"] = "rbxassetid://15380413567",
	["vesta"] = "rbxassetid://9568930198",
	["beast"] = "rbxassetid://9155465124",
	["dino_tamer"] = "rbxassetid://9872357009",
	["drill"] = "rbxassetid://12955100280",
	["elektra"] = "rbxassetid://13841413050",
	["fisherman"] = "rbxassetid://9166208359",
	["queen_bee"] = "rbxassetid://12671498918",
	["card"] = "rbxassetid://13841410580",
	["frosty"] = "rbxassetid://9166208762",
	["gingerbread_man"] = "rbxassetid://9155464364",
	["ghost_catcher"] = "rbxassetid://9224802656",
	["tinker"] = "rbxassetid://17025762404",
	["ignis"] = "rbxassetid://13835258938",
	["oil_man"] = "rbxassetid://9166206259",
	["jade"] = "rbxassetid://9166306816",
	["dragon_slayer"] = "rbxassetid://10982192175",
	["paladin"] = "rbxassetid://11202785737",
	["pinata"] = "rbxassetid://10011261147",
	["merchant"] = "rbxassetid://9872356790",
	["metal_detector"] = "rbxassetid://9378298061",
	["slime_tamer"] = "rbxassetid://15379766168",
	["nyoka"] = "rbxassetid://17022941410",
	["midnight"] = "rbxassetid://9155462763",
	["pyro"] = "rbxassetid://9155464770",
	["raven"] = "rbxassetid://9166206554",
	["santa"] = "rbxassetid://9166206101",
	["sheep_herder"] = "rbxassetid://9155465730",
	["smoke"] = "rbxassetid://9155462247",
	["spirit_catcher"] = "rbxassetid://9166207943",
	["star_collector"] = "rbxassetid://9872356516",
	["styx"] = "rbxassetid://17014536631",
	["block_kicker"] = "rbxassetid://15382536098",
	["trapper"] = "rbxassetid://9166206875",
	["hatter"] = "rbxassetid://12509388633",
	["ninja"] = "rbxassetid://15517037848",
	["jailor"] = "rbxassetid://11664116980",
	["warrior"] = "rbxassetid://9166207008",
	["mage"] = "rbxassetid://10982191792",
	["void_dragon"] = "rbxassetid://10982192753",
	["cat"] = "rbxassetid://15350740470",
	["wind_walker"] = "rbxassetid://9872355499",
	['skeleton'] = "rbxassetid://120123419412119",
	['winter_lady'] = "rbxassetid://83274578564074",
	['soul_broker'] = 'rbxassetid://130409166262430'
}


local function collection(tags, module, customadd, customremove)
	tags = typeof(tags) ~= 'table' and {tags} or tags
	local objs, connections = {}, {}

	for _, tag in tags do
		table.insert(connections, collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			if customadd then
				customadd(objs, v, tag)
				return
			end
			table.insert(objs, v)
		end))
		table.insert(connections, collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if customremove then
				customremove(objs, v, tag)
				return
			end
			v = table.find(objs, v)
			if v then
				table.remove(objs, v)
			end
		end))

		for _, v in collectionService:GetTagged(tag) do
			if customadd then
				customadd(objs, v, tag)
				continue
			end
			table.insert(objs, v)
		end
	end

	local cleanFunc = function(self)
		for _, v in connections do
			v:Disconnect()
		end
		table.clear(connections)
		table.clear(objs)
		table.clear(self)
	end
	if module then
		module:Clean(cleanFunc)
	end
	return objs, cleanFunc
end

local function getBestArmor(slot)
	local closest, mag = nil, 0

	for _, item in store.inventory.inventory.items do
		local meta = item and bedwars.ItemMeta[item.itemType] or {}

		if meta.armor and meta.armor.slot == slot then
			local newmag = (meta.armor.damageReductionMultiplier or 0)

			if newmag > mag then
				closest, mag = item, newmag
			end
		end
	end

	return closest
end

local function getBow()
	local bestBow, bestBowSlot, bestBowDamage = nil, nil, 0
	for slot, item in store.inventory.inventory.items do
		local bowMeta = bedwars.ItemMeta[item.itemType].projectileSource
		if bowMeta and table.find(bowMeta.ammoItemTypes, 'arrow') then
			local bowDamage = bedwars.ProjectileMeta[bowMeta.projectileType('arrow')].combat.damage or 0
			if bowDamage > bestBowDamage then
				bestBow, bestBowSlot, bestBowDamage = item, slot, bowDamage
			end
		end
	end
	return bestBow, bestBowSlot
end

local function getItem(itemName, inv, find)
    for slot, item in (inv or store.inventory.inventory.items) do
        if find and item.itemType:find(itemName) or item.itemType == itemName then -- ★部分一致も許可
            return item, slot
        end
    end
    return nil
end

local function getRoactRender(func)
	return debug.getupvalue(debug.getupvalue(debug.getupvalue(func, 3).render, 2).render, 1)
end

local function getSword()
    local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
    for slot, item in store.inventory.inventory.items do
        local swordMeta = bedwars.ItemMeta[item.itemType].sword
        if swordMeta then
            local swordDamage = swordMeta.damage or 0
            if swordDamage > bestSwordDamage then
                bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
            end
        end
    end
    
    
    if not bestSword then
        return {itemType = "wood_sword", amount = 0}, 0
    end
    
    return bestSword, bestSwordSlot
end

local function getTool(breakType)
	local bestTool, bestToolSlot, bestToolDamage = nil, nil, 0
	for slot, item in store.inventory.inventory.items do
		local toolMeta = bedwars.ItemMeta[item.itemType].breakBlock
		if toolMeta then
			local toolDamage = toolMeta[breakType] or 0
			if toolDamage > bestToolDamage then
				bestTool, bestToolSlot, bestToolDamage = item, slot, toolDamage
			end
		end
	end
	return bestTool, bestToolSlot
end

local function getWool()
	for _, wool in (inv or store.inventory.inventory.items) do
		if wool.itemType:find('wool') then
			return wool and wool.itemType, wool and wool.amount
		end
	end
end

local function getStrength(plr)
	if not plr.Player then
		return 0
	end

	local strength = 0
	for _, v in (store.inventories[plr.Player] or {items = {}}).items do
		local itemmeta = bedwars.ItemMeta[v.itemType]
		if itemmeta and itemmeta.sword and itemmeta.sword.damage > strength then
			strength = itemmeta.sword.damage
		end
	end

	return strength
end

local function getPlacedBlock(pos)
	if not pos then
		return
	end
	local roundedPosition = bedwars.BlockController:getBlockPosition(pos)
	return bedwars.BlockController:getStore():getBlockAt(roundedPosition), roundedPosition
end

local function getBlocksInPoints(s, e)
	local blocks, list = bedwars.BlockController:getStore(), {}
	for x = s.X, e.X do
		for y = s.Y, e.Y do
			for z = s.Z, e.Z do
				local vec = Vector3.new(x, y, z)
				if blocks:getBlockAt(vec) then
					table.insert(list, vec * 3)
				end
			end
		end
	end
	return list
end

local function getNearGround(range)
	range = Vector3.new(3, 3, 3) * (range or 10)
	local localPosition, mag, closest = entitylib.character.RootPart.Position, 60
	local blocks = getBlocksInPoints(bedwars.BlockController:getBlockPosition(localPosition - range), bedwars.BlockController:getBlockPosition(localPosition + range))

	for _, v in blocks do
		if not getPlacedBlock(v + Vector3.new(0, 3, 0)) then
			local newmag = (localPosition - v).Magnitude
			if newmag < mag then
				mag, closest = newmag, v + Vector3.new(0, 3, 0)
			end
		end
	end

	table.clear(blocks)
	return closest
end

local function getShieldAttribute(char)
	local returned = 0
	for name, val in char:GetAttributes() do
		if name:find('Shield') and type(val) == 'number' and val > 0 then
			returned += val
		end
	end
	return returned
end

local function getSpeed()
	local multi, increase, modifiers = 0, true, bedwars.SprintController:getMovementStatusModifier():getModifiers()

	for v in modifiers do
		local val = v.constantSpeedMultiplier and v.constantSpeedMultiplier or 0
		if val and val > math.max(multi, 1) then
			increase = false
			multi = val - (0.06 * math.round(val))
		end
	end

	for v in modifiers do
		multi += math.max((v.moveSpeedMultiplier or 0) - 1, 0)
	end

	if multi > 0 and increase then
		multi += 0.16 + (0.02 * math.round(multi))
	end

	return 20 * (multi + 1)
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do
		ind += 1
	end
	return ind
end

local function hotbarSwitch(slot)
	if slot and store.inventory.hotbarSlot ~= slot then
		bedwars.Store:dispatch({
			type = 'InventorySelectHotbarSlot',
			slot = slot
		})
		vapeEvents.InventoryChanged.Event:Wait()
		return true
	end
	return false
end

local function isFriend(plr, recolor)
	if vape.Categories.Friends.Options['Use friends'].Enabled then
		local friend = table.find(vape.Categories.Friends.ListEnabled, plr.Name) and true
		if recolor then
			friend = friend and vape.Categories.Friends.Options['Recolor visuals'].Enabled
		end
		return friend
	end
	return nil
end

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...) return
	vape:CreateNotification(...)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

local function roundPos(vec)
	return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
end

local function switchItem(tool, delayTime)
    delayTime = delayTime or 0.05
    local check = lplr.Character and lplr.Character:FindFirstChild('HandInvItem') or nil
    if check and check.Value ~= tool and tool.Parent ~= nil then
        task.spawn(function()
            bedwars.Client:Get(remotes.EquipItem):CallServerAsync({hand = tool})
        end)
        check.Value = tool
        if delayTime > 0 then
            task.wait(delayTime)
        end
        return true
    end
end

local function waitForChildOfType(obj, name, timeout, prop)
	local check, returned = tick() + timeout
	repeat
		returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
		if returned and returned.Name ~= 'UpperTorso' or check < tick() then
			break
		end
		task.wait()
	until false
	return returned
end

local frictionTable, oldfrict = {}, {}
local frictionConnection
local frictionState

local function modifyVelocity(v)
	if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' and not oldfrict[v] then
		oldfrict[v] = v.CustomPhysicalProperties or 'none'
		v.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.2, 0.5, 1, 1)
	end
end

local function updateVelocity(force)
	local newState = getTableSize(frictionTable) > 0
	if frictionState ~= newState or force then
		if frictionConnection then
			frictionConnection:Disconnect()
		end
		if newState then
			if entitylib.isAlive then
				for _, v in entitylib.character.Character:GetDescendants() do
					modifyVelocity(v)
				end
				frictionConnection = entitylib.character.Character.DescendantAdded:Connect(modifyVelocity)
			end
		else
			for i, v in oldfrict do
				i.CustomPhysicalProperties = v ~= 'none' and v or nil
			end
			table.clear(oldfrict)
		end
	end
	frictionState = newState
end

local kitorder = {
	hannah = 5,
	spirit_assassin = 4,
	dasher = 3,
	jade = 2,
	regent = 1
}

local sortmethods = {
	Damage = function(a, b)
		return a.Entity.Character:GetAttribute('LastDamageTakenTime') < b.Entity.Character:GetAttribute('LastDamageTakenTime')
	end,
	Threat = function(a, b)
		return getStrength(a.Entity) > getStrength(b.Entity)
	end,
	Kit = function(a, b)
		return (a.Entity.Player and kitorder[a.Entity.Player:GetAttribute('PlayingAsKit')] or 0) > (b.Entity.Player and kitorder[b.Entity.Player:GetAttribute('PlayingAsKit')] or 0)
	end,
	Health = function(a, b)
		return a.Entity.Health < b.Entity.Health
	end,
	Angle = function(a, b)
		local selfrootpos = entitylib.character.RootPart.Position
		local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
		local angle = math.acos(localfacing:Dot(((a.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
		local angle2 = math.acos(localfacing:Dot(((b.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
		return angle < angle2
	end
}

run(function()
	local oldstart = entitylib.start
	local function customEntity(ent)
		if ent:HasTag('inventory-entity') and not ent:HasTag('Monster') then
			return
		end

		entitylib.addEntity(ent, nil, ent:HasTag('Drone') and function(self)
			local droneplr = playersService:GetPlayerByUserId(self.Character:GetAttribute('PlayerUserId'))
			return not droneplr or lplr:GetAttribute('Team') ~= droneplr:GetAttribute('Team')
		end or function(self)
			return lplr:GetAttribute('Team') ~= self.Character:GetAttribute('Team')
		end)
	end

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in collectionService:GetTagged('entity') do
				customEntity(ent)
			end
			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('entity'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('entity'):Connect(function(ent)
				entitylib.removeEntity(ent)
			end))
		end
	end

	entitylib.addPlayer = function(plr)
		if plr.Character then
			entitylib.refreshEntity(plr.Character, plr)
		end
		entitylib.PlayerConnections[plr] = {
			plr.CharacterAdded:Connect(function(char)
				entitylib.refreshEntity(char, plr)
			end),
			plr.CharacterRemoving:Connect(function(char)
				entitylib.removeEntity(char, plr == lplr)
			end),
			plr:GetAttributeChangedSignal('Team'):Connect(function()
				for _, v in entitylib.List do
					if v.Targetable ~= entitylib.targetCheck(v) then
						entitylib.refreshEntity(v.Character, v.Player)
					end
				end

				if plr == lplr then
					entitylib.start()
				else
					entitylib.refreshEntity(plr.Character, plr)
				end
			end)
		}
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum, humrootpart, head
			if plr then
				hum = waitForChildOfType(char, 'Humanoid', 10)
				humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
				head = char:WaitForChild('Head', 10) or humrootpart
			else
				hum = {HipHeight = 0.5}
				humrootpart = waitForChildOfType(char, 'PrimaryPart', 10, true)
				head = humrootpart
			end
			local updateobjects = plr and plr ~= lplr and {
				char:WaitForChild('ArmorInvItem_0', 5),
				char:WaitForChild('ArmorInvItem_1', 5),
				char:WaitForChild('ArmorInvItem_2', 5),
				char:WaitForChild('HandInvItem', 5)
			} or {}

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = (char:GetAttribute('Health') or 100) + getShieldAttribute(char),
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					Jumps = 0,
					JumpTick = tick(),
					Jumping = false,
					LandTick = tick(),
					MaxHealth = char:GetAttribute('MaxHealth') or 100,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entity.AirTime = tick()
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
					table.insert(entitylib.Connections, char.AttributeChanged:Connect(function(attr)
						vapeEvents.AttributeChanged:Fire(attr)
					end))
				else
					entity.Targetable = entitylib.targetCheck(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = (char:GetAttribute('Health') or 100) + getShieldAttribute(char)
							entity.MaxHealth = char:GetAttribute('MaxHealth') or 100
							entitylib.Events.EntityUpdated:Fire(entity)
						end))
					end

					for _, v in updateobjects do
						table.insert(entity.Connections, v:GetPropertyChangedSignal('Value'):Connect(function()
							task.delay(0.1, function()
								if bedwars.getInventory then
									store.inventories[plr] = bedwars.getInventory(plr)
									entitylib.Events.EntityUpdated:Fire(entity)
								end
							end)
						end))
					end

					if plr then
						local anim = char:FindFirstChild('Animate')
						if anim then
							pcall(function()
								anim = anim.jump:FindFirstChildWhichIsA('Animation').AnimationId
								table.insert(entity.Connections, hum.Animator.AnimationPlayed:Connect(function(playedanim)
									if playedanim.Animation.AnimationId == anim then
										entity.JumpTick = tick()
										entity.Jumps += 1
										entity.LandTick = tick() + 1
										entity.Jumping = entity.Jumps > 1
									end
								end))
							end)
						end

						task.delay(0.1, function()
							if bedwars.getInventory then
								store.inventories[plr] = bedwars.getInventory(plr)
							end
						end)
					end
					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end

				table.insert(entity.Connections, char.ChildRemoved:Connect(function(part)
					if part == humrootpart or part == hum or part == head then
						if part == humrootpart and hum.RootPart then
							humrootpart = hum.RootPart
							entity.RootPart = hum.RootPart
							entity.HumanoidRootPart = hum.RootPart
							return
						end
						entitylib.removeEntity(char, plr == lplr)
					end
				end))
			end
			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.getUpdateConnections = function(ent)
		local char = ent.Character
		local tab = {
			char:GetAttributeChangedSignal('Health'),
			char:GetAttributeChangedSignal('MaxHealth'),
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}

		if ent.Player then
			table.insert(tab, ent.Player:GetAttributeChangedSignal('PlayingAsKit'))
		end

		for name, val in char:GetAttributes() do
			if name:find('Shield') and type(val) == 'number' then
				table.insert(tab, char:GetAttributeChangedSignal(name))
			end
		end

		return tab
	end

	entitylib.targetCheck = function(ent)
		if ent.TeamCheck then
			return ent:TeamCheck()
		end
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		return lplr:GetAttribute('Team') ~= ent.Player:GetAttribute('Team')
	end
	vape:Clean(entitylib.Events.LocalAdded:Connect(updateVelocity))
end)
entitylib.start()
local function safeGetProto(func, index)
	if not func then return nil end
	local success, proto = pcall(debug.getproto, func, index) -- ★debug.getproto に修正
	if success then
		return proto
	else
		return nil
	end
end
run(function()
	local KnitInit, Knit
	repeat
    KnitInit, Knit = pcall(function()
       return require(replicatedStorage.rbxts_include.node_modules["@easy-games"].knit.src).KnitClient
    end)
		if KnitInit then break end
		task.wait()
	until KnitInit

	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end

	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local InventoryUtil = require(replicatedStorage.TS.inventory['inventory-util']).InventoryUtil
	local Client = require(replicatedStorage.TS.remotes).default.Client
	local OldGet, OldBreak = Client.Get

	bedwars = setmetatable({
		SummonerKitBalance = require(replicatedStorage.TS.games.bedwars.kit.kits.summoner['summoner-kit-balance']).SummonerKitBalance,
		SharedConstants = require(replicatedStorage.TS['shared-constants']),		
		AbilityController = Flamework.resolveDependency('@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController'),
		AnimationType = require(replicatedStorage.TS.animation['animation-type']).AnimationType,
		AnimationUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out['shared'].util['animation-util']).AnimationUtil,
		AppController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.controllers['app-controller']).AppController,
		BedBreakEffectMeta = require(replicatedStorage.TS.locker['bed-break-effect']['bed-break-effect-meta']).BedBreakEffectMeta,
		BedwarsKitMeta = require(replicatedStorage.TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta,
		BlockBreaker = Knit.Controllers.BlockBreakController.blockBreaker,
		BlockController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out).BlockEngine,
		BlockEngine = require(lplr.PlayerScripts.TS.lib['block-engine']['client-block-engine']).ClientBlockEngine,
		BlockPlacer = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.client.placement['block-placer']).BlockPlacer,
		BowConstantsTable = debug.getupvalue(Knit.Controllers.ProjectileController.enableBeam, 8),
		ClickHold = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.ui.lib.util['click-hold']).ClickHold,
		Client = Client,
		ClientConstructor = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts'].net.out.client),
		ClientDamageBlock = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.shared.remotes).BlockEngineRemotes.Client,
		CombatConstant = require(replicatedStorage.TS.combat['combat-constant']).CombatConstant,
		DamageIndicator = Knit.Controllers.DamageIndicatorController.spawnDamageIndicator,
		DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.global.locker['kill-effect'].effects['default-kill-effect']),
		EmoteType = require(replicatedStorage.TS.locker.emote['emote-type']).EmoteType,
		GameAnimationUtil = require(replicatedStorage.TS.animation['animation-util']).GameAnimationUtil,
		getIcon = function(item, showinv)
			local itemmeta = bedwars.ItemMeta[item.itemType]
			return itemmeta and showinv and itemmeta.image or ''
		end,
		getInventory = function(plr)
			local suc, res = pcall(function()
				return InventoryUtil.getInventory(plr)
			end)
			return suc and res or {
				items = {},
				armor = {}
			}
		end,
		HudAliveCount = require(lplr.PlayerScripts.TS.controllers.global['top-bar'].ui.game['hud-alive-player-counts']).HudAlivePlayerCounts,
		ItemMeta = debug.getupvalue(require(replicatedStorage.TS.item['item-meta']).getItemMeta, 1),
		KillEffectMeta = require(replicatedStorage.TS.locker['kill-effect']['kill-effect-meta']).KillEffectMeta,
		KillFeedController = Flamework.resolveDependency('client/controllers/game/kill-feed/kill-feed-controller@KillFeedController'),
		Knit = Knit,
		KnockbackUtil = require(replicatedStorage.TS.damage['knockback-util']).KnockbackUtil,
		MageKitUtil = require(replicatedStorage.TS.games.bedwars.kit.kits.mage['mage-kit-util']).MageKitUtil,
		NametagController = Knit.Controllers.NametagController,
		PartyController = Flamework.resolveDependency('@easy-games/lobby:client/controllers/party-controller@PartyController'),
		ProjectileMeta = require(replicatedStorage.TS.projectile['projectile-meta']).ProjectileMeta,
		QueryUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil,
		QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui['queue-card']).QueueCard,
		QueueMeta = require(replicatedStorage.TS.game['queue-meta']).QueueMeta,
		Roact = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts']['roact'].src),
		RuntimeLib = require(replicatedStorage['rbxts_include'].RuntimeLib),
		SoundList = require(replicatedStorage.TS.sound['game-sound']).GameSound,
		SoundManager = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).SoundManager,
		Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
		TeamUpgradeMeta = debug.getupvalue(require(replicatedStorage.TS.games.bedwars['team-upgrade']['team-upgrade-meta']).getTeamUpgradeMetaForQueue, 6),
		UILayers = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).UILayers,
		VisualizerUtils = require(lplr.PlayerScripts.TS.lib.visualizer['visualizer-utils']).VisualizerUtils,
		WeldTable = require(replicatedStorage.TS.util['weld-util']).WeldUtil,
		WinEffectMeta = require(replicatedStorage.TS.locker['win-effect']['win-effect-meta']).WinEffectMeta,
		ZapNetworking = require(lplr.PlayerScripts.TS.lib.network)
	}, {
		__index = function(self, ind)
			rawset(self, ind, Knit.Controllers[ind])
			return rawget(self, ind)
		end
	})

		local function createMethodHook(object, method)
		local original = object[method]
		local hooks, order = {}, 0
		local wrapper
		
		local function sync()
			if #hooks > 0 then
				object[method] = wrapper
			elseif object[method] == wrapper then
				object[method] = original
			end
		end
		
		wrapper = function(...)
			local index = 0
			local function nextHook(...)
				index += 1
				local hook = hooks[index]
				if hook then
					return hook.Callback(nextHook, ...)
				end
				return original(...)
			end
			return nextHook(...)
		end
		
		return {
			Add = function(_, id, priority, callback)
				for i = #hooks, 1, -1 do
					if hooks[i].Id == id then
						table.remove(hooks, i)
					end
				end
				
				order += 1
				local entry = {
					Id = id,
					Priority = priority or 100,
					Order = order,
					Callback = callback
				}
				
				table.insert(hooks, entry)
				table.sort(hooks, function(a, b)
					return a.Priority == b.Priority and a.Order < b.Order or a.Priority < b.Priority
				end)
				sync()
				
				return function()
					for i = #hooks, 1, -1 do
						if hooks[i] == entry then
							table.remove(hooks, i)
						end
					end
					sync()
				end
			end,
			Destroy = function()
				table.clear(hooks)
				sync()
			end
		}
	end
	
	bedwars.ProjectileLaunchHook = createMethodHook(bedwars.ProjectileController, 'calculateImportantLaunchValues')

	local remoteNames = {
		AfkStatus = safeGetProto(Knit.Controllers.AfkController.KnitStart, 1),
		AttackEntity = Knit.Controllers.SwordController.sendServerRequest,
		BeePickup = Knit.Controllers.BeeNetController.trigger,
		CannonAim = safeGetProto(Knit.Controllers.CannonController.startAiming, 5),
		CannonLaunch = Knit.Controllers.CannonHandController.launchSelf,
		ConsumeBattery = safeGetProto(Knit.Controllers.BatteryController.onKitLocalActivated, 1),
		ConsumeItem = safeGetProto(Knit.Controllers.ConsumeController.onEnable, 1),
		ConsumeSoul = Knit.Controllers.GrimReaperController.consumeSoul,
		ConsumeTreeOrb = safeGetProto(Knit.Controllers.EldertreeController.createTreeOrbInteraction, 1),
		DepositPinata = safeGetProto(safeGetProto(Knit.Controllers.PiggyBankController.KnitStart, 2), 5),
		DragonBreath = safeGetProto(Knit.Controllers.VoidDragonController.onKitLocalActivated, 5),
		DragonEndFly = safeGetProto(Knit.Controllers.VoidDragonController.flapWings, 1),
		DragonFly = Knit.Controllers.VoidDragonController.flapWings,
		DropItem = Knit.Controllers.ItemDropController.dropItemInHand,
		EquipItem = safeGetProto(require(replicatedStorage.TS.entity.entities['inventory-entity']).InventoryEntity.equipItem, 4),
		FireProjectile = debug.getupvalue(Knit.Controllers.ProjectileController.launchProjectileWithValues, 2),
		GroundHit = Knit.Controllers.FallDamageController.KnitStart,
		GuitarHeal = Knit.Controllers.GuitarController.performHeal,
		HannahKill = safeGetProto(Knit.Controllers.HannahController.registerExecuteInteractions, 1),
		HarvestCrop = safeGetProto(safeGetProto(Knit.Controllers.CropController.KnitStart, 4), 1),
		KaliyahPunch = safeGetProto(Knit.Controllers.DragonSlayerController.onKitLocalActivated, 1),
		MageSelect = safeGetProto(Knit.Controllers.MageController.registerTomeInteraction, 1),
		MinerDig = safeGetProto(Knit.Controllers.MinerController.setupMinerPrompts, 1),
		PickupItem = Knit.Controllers.ItemDropController.checkForPickup,
		PickupMetal = safeGetProto(Knit.Controllers.HiddenMetalController.onKitLocalActivated, 4),
		ReportPlayer = require(lplr.PlayerScripts.TS.controllers.global.report['report-controller']).default.reportPlayer,
		ResetCharacter = safeGetProto(Knit.Controllers.ResetController.createBindable, 1),
		SpawnRaven = safeGetProto(Knit.Controllers.RavenController.KnitStart, 1),
		SummonerClawAttack = Knit.Controllers.SummonerClawHandController.attack,
		WarlockTarget = safeGetProto(Knit.Controllers.WarlockStaffController.KnitStart, 2)
	}

	local function dumpRemote(tab)
		local ind
		for i, v in tab do
			if v == 'Client' then
				ind = i
				break
			end
		end
		return ind and tab[ind + 1] or ''
	end

for i, v in remoteNames do
	if type(v) == "function" then -- ここなおした
		local remote = dumpRemote(debug.getconstants(v))
		if remote == '' then
			notif('Vape', 'Failed to grab remote ('..i..')', 10, 'alert')
		end
		remotes[i] = remote
	else
		remotes[i] = ''
		notif('Vape', 'Failed to grab remote ('..i..'): Not a function', 10, 'alert')
	end
end

	OldBreak = bedwars.BlockController.isBlockBreakable

	Client.Get = function(self, remoteName)
		local call = OldGet(self, remoteName)

		if remoteName == remotes.AttackEntity then
			return {
				instance = call.instance,
				SendToServer = function(_, attackTable, ...)
					local suc, plr = pcall(function()
						return playersService:GetPlayerFromCharacter(attackTable.entityInstance)
					end)

					local selfpos = attackTable.validate.selfPosition.value
					local targetpos = attackTable.validate.targetPosition.value
					store.attackReach = ((selfpos - targetpos).Magnitude * 100) // 1 / 100
					store.attackReachUpdate = tick() + 1

					if Reach.Enabled or HitBoxes.Enabled then
						attackTable.validate.raycast = attackTable.validate.raycast or {}
						attackTable.validate.selfPosition.value += CFrame.lookAt(selfpos, targetpos).LookVector * math.max((selfpos - targetpos).Magnitude - 14.399, 0)
					end

					if suc and plr then
						if not select(2, whitelist:get(plr)) then return end
					end

					return call:SendToServer(attackTable, ...)
				end
			}
		elseif remoteName == 'StepOnSnapTrap' and TrapDisabler.Enabled then
			return {SendToServer = function() end}
		end

		return call
	end

	bedwars.BlockController.isBlockBreakable = function(self, breakTable, plr)
		local obj = bedwars.BlockController:getStore():getBlockAt(breakTable.blockPosition)

		if obj and obj.Name == 'bed' then
			for _, plr in playersService:GetPlayers() do
				if obj:GetAttribute('Team'..(plr:GetAttribute('Team') or 0)..'NoBreak') and not select(2, whitelist:get(plr)) then
					return false
				end
			end
		end

		return OldBreak(self, breakTable, plr)
	end

	local cache, blockhealthbar = {}, {blockHealth = -1, breakingBlockPosition = Vector3.zero}
	store.blockPlacer = bedwars.BlockPlacer.new(bedwars.BlockEngine, 'wool_white')

	local function getBlockHealth(block, blockpos)
		local blockdata = bedwars.BlockController:getStore():getBlockData(blockpos)
		return (blockdata and (blockdata:GetAttribute('1') or blockdata:GetAttribute('Health')) or block:GetAttribute('Health'))
	end

	local function getBlockHits(block, blockpos)
		if not block then return 0 end
		local breaktype = bedwars.ItemMeta[block.Name].block.breakType
		local tool = store.tools[breaktype]
		tool = tool and bedwars.ItemMeta[tool.itemType].breakBlock[breaktype] or 2
		return getBlockHealth(block, bedwars.BlockController:getBlockPosition(blockpos)) / tool
	end

	--[[
		Pathfinding using a luau version of dijkstra's algorithm
		Source: https://stackoverflow.com/questions/39355587/speeding-up-dijkstras-algorithm-to-solve-a-3d-maze
	]]
	local function calculatePath(target, blockpos)
		if cache[blockpos] then
			return unpack(cache[blockpos])
		end
		local visited, unvisited, distances, air, path = {}, {{0, blockpos}}, {[blockpos] = 0}, {}, {}

		for _ = 1, 10000 do
			local _, node = next(unvisited)
			if not node then break end
			table.remove(unvisited, 1)
			visited[node[2]] = true

			for _, side in sides do
				side = node[2] + side
				if visited[side] then continue end

				local block = getPlacedBlock(side)
				if not block or block:GetAttribute('NoBreak') or block == target then
					if not block then
						air[node[2]] = true
					end
					continue
				end

				local curdist = getBlockHits(block, side) + node[1]
				if curdist < (distances[side] or math.huge) then
					table.insert(unvisited, {curdist, side})
					distances[side] = curdist
					path[side] = node[2]
				end
			end
		end

		local pos, cost = nil, math.huge
		for node in air do
			if distances[node] < cost then
				pos, cost = node, distances[node]
			end
		end

		if pos then
			cache[blockpos] = {
				pos,
				cost,
				path
			}
			return pos, cost, path
		end
	end

	bedwars.placeBlock = function(pos, item)
		if getItem(item) then
			store.blockPlacer.blockType = item
			return store.blockPlacer:placeBlock(bedwars.BlockController:getBlockPosition(pos))
		end
	end

	bedwars.breakBlock = function(block, effects, anim, customHealthbar)
		if lplr:GetAttribute('DenyBlockBreak') or not entitylib.isAlive or InfiniteFly.Enabled then return end
		local handler = bedwars.BlockController:getHandlerRegistry():getHandler(block.Name)
		local cost, pos, target, path = math.huge

		for _, v in (handler and handler:getContainedPositions(block) or {block.Position / 3}) do
			local dpos, dcost, dpath = calculatePath(block, v * 3)
			if dpos and dcost < cost then
				cost, pos, target, path = dcost, dpos, v * 3, dpath
			end
		end

		if pos then
			if (entitylib.character.RootPart.Position - pos).Magnitude > 30 then return end
			local dblock, dpos = getPlacedBlock(pos)
			if not dblock then return end

			if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.4 then
				local breaktype = bedwars.ItemMeta[dblock.Name].block.breakType
				local tool = store.tools[breaktype]
				if tool then
					switchItem(tool.tool)
				end
			end

			if blockhealthbar.blockHealth == -1 or dpos ~= blockhealthbar.breakingBlockPosition then
				blockhealthbar.blockHealth = getBlockHealth(dblock, dpos)
				blockhealthbar.breakingBlockPosition = dpos
			end

			bedwars.ClientDamageBlock:Get('DamageBlock'):CallServerAsync({
				blockRef = {blockPosition = dpos},
				hitPosition = pos,
				hitNormal = Vector3.FromNormalId(Enum.NormalId.Top)
			}):andThen(function(result)
				if result then
					if result == 'cancelled' then
						store.damageBlockFail = tick() + 1
						return
					end

					if effects then
						local blockdmg = (blockhealthbar.blockHealth - (result == 'destroyed' and 0 or getBlockHealth(dblock, dpos)))
						customHealthbar = customHealthbar or bedwars.BlockBreaker.updateHealthbar
						customHealthbar(bedwars.BlockBreaker, {blockPosition = dpos}, blockhealthbar.blockHealth, dblock:GetAttribute('MaxHealth'), blockdmg, dblock)
						blockhealthbar.blockHealth = math.max(blockhealthbar.blockHealth - blockdmg, 0)

						if blockhealthbar.blockHealth <= 0 then
							bedwars.BlockBreaker.breakEffect:playBreak(dblock.Name, dpos, lplr)
							bedwars.BlockBreaker.healthbarMaid:DoCleaning()
							blockhealthbar.breakingBlockPosition = Vector3.zero
						else
							bedwars.BlockBreaker.breakEffect:playHit(dblock.Name, dpos, lplr)
						end
					end

					if anim then
						local animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
						bedwars.ViewmodelController:playAnimation(15)
						task.wait(0.3)
						animation:Stop()
						animation:Destroy()
					end
				end
			end)

			if effects then
				return pos, path, target
			end
		end
	end

	for _, v in Enum.NormalId:GetEnumItems() do
		table.insert(sides, Vector3.FromNormalId(v) * 3)
	end

	local function updateStore(new, old)
		if new.Bedwars ~= old.Bedwars then
			store.equippedKit = new.Bedwars.kit ~= 'none' and new.Bedwars.kit or ''
		end

		if new.Game ~= old.Game then
			store.matchState = new.Game.matchState
			store.queueType = new.Game.queueType or 'bedwars_test'
		end

		if new.Inventory ~= old.Inventory then
			local newinv = (new.Inventory and new.Inventory.observedInventory or {inventory = {}})
			local oldinv = (old.Inventory and old.Inventory.observedInventory or {inventory = {}})
			store.inventory = newinv

			if newinv ~= oldinv then
				vapeEvents.InventoryChanged:Fire()
			end

			if newinv.inventory.items ~= oldinv.inventory.items then
				vapeEvents.InventoryAmountChanged:Fire()
				store.tools.sword = getSword()
				for _, v in {'stone', 'wood', 'wool'} do
					store.tools[v] = getTool(v)
				end
			end

			if newinv.inventory.hand ~= oldinv.inventory.hand then
				local currentHand, toolType = new.Inventory.observedInventory.inventory.hand, ''
				if currentHand then
					local handData = bedwars.ItemMeta[currentHand.itemType]
					toolType = handData.sword and 'sword' or handData.block and 'block' or currentHand.itemType:find('bow') and 'bow'
				end

				store.hand = {
					tool = currentHand and currentHand.tool,
					amount = currentHand and currentHand.amount or 0,
					toolType = toolType
				}
			end
		end
	end

	local storeChanged = bedwars.Store.changed:connect(updateStore)
	updateStore(bedwars.Store:getState(), {})

	for _, event in {'MatchEndEvent', 'EntityDeathEvent', 'BedwarsBedBreak', 'BalloonPopped', 'AngelProgress', 'GrapplingHookFunctions'} do
		if not vape.Connections then return end
		bedwars.Client:WaitFor(event):andThen(function(connection)
			vape:Clean(connection:Connect(function(...)
				vapeEvents[event]:Fire(...)
			end))
		end)
	end

	vape:Clean(bedwars.ZapNetworking.EntityDamageEventZap.On(function(...)
		vapeEvents.EntityDamageEvent:Fire({
			entityInstance = ...,
			damage = select(2, ...),
			damageType = select(3, ...),
			fromPosition = select(4, ...),
			fromEntity = select(5, ...),
			knockbackMultiplier = select(6, ...),
			knockbackId = select(7, ...),
			disableDamageHighlight = select(13, ...)
		})
	end))

	for _, event in {'PlaceBlockEvent', 'BreakBlockEvent'} do
		vape:Clean(bedwars.ZapNetworking[event..'Zap'].On(function(...)
			local data = {
				blockRef = {
					blockPosition = ...,
				},
				player = select(5, ...)
			}
			for i, v in cache do
				if ((data.blockRef.blockPosition * 3) - v[1]).Magnitude <= 30 then
					table.clear(v[3])
					table.clear(v)
					cache[i] = nil
				end
			end
			vapeEvents[event]:Fire(data)
		end))
	end

	store.blocks = collection('block', gui)
	store.shop = collection({'BedwarsItemShop', 'TeamUpgradeShopkeeper'}, gui, function(tab, obj)
		table.insert(tab, {
			Id = obj.Name,
			RootPart = obj,
			Shop = obj:HasTag('BedwarsItemShop'),
			Upgrades = obj:HasTag('TeamUpgradeShopkeeper')
		})
	end)
	store.enchant = collection({'enchant-table', 'broken-enchant-table'}, gui, nil, function(tab, obj, tag)
		if obj:HasTag('enchant-table') and tag == 'broken-enchant-table' then return end
		obj = table.find(tab, obj)
		if obj then
			table.remove(tab, obj)
		end
	end)

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	local mapname = 'Unknown'
	sessioninfo:AddItem('Map', 0, function()
		return mapname
	end, false)

	task.delay(1, function()
		games:Increment()
	end)

	task.spawn(function()
		pcall(function()
			repeat task.wait() until store.matchState ~= 0 or vape.Loaded == nil
			if vape.Loaded == nil then return end
			mapname = workspace:WaitForChild('Map', 5):WaitForChild('Worlds', 5):GetChildren()[1].Name
			mapname = string.gsub(string.split(mapname, '_')[2] or mapname, '-', '') or 'Blank'
		end)
	end)

	vape:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
		if bedTable.player and bedTable.player.UserId == lplr.UserId then
			beds:Increment()
		end
	end))

	vape:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winTable)
		if (bedwars.Store:getState().Game.myTeam or {}).id == winTable.winningTeamId or lplr.Neutral then
			wins:Increment()
		end
	end))

	vape:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
		local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
		local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
		if not killed or not killer then return end

		if killed ~= lplr and killer == lplr then
			kills:Increment()
		end
	end))

	task.spawn(function()
		repeat
			if entitylib.isAlive then
				entitylib.character.AirTime = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entitylib.character.AirTime
			end

			for _, v in entitylib.List do
				v.LandTick = math.abs(v.RootPart.Velocity.Y) < 0.1 and v.LandTick or tick()
				if (tick() - v.LandTick) > 0.2 and v.Jumps ~= 0 then
					v.Jumps = 0
					v.Jumping = false
				end
			end
			task.wait()
		until vape.Loaded == nil
	end)

	pcall(function()
		if getthreadidentity and setthreadidentity then
			local old = getthreadidentity()
			setthreadidentity(2)

			bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
			bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
			bedwars.Shop.getShopItem('iron_sword', lplr)

			setthreadidentity(old)
			store.shopLoaded = true
		else
			task.spawn(function()
				repeat
					task.wait(0.1)
				until vape.Loaded == nil or bedwars.AppController:isAppOpen('BedwarsItemShopApp')

				bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
				bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
				store.shopLoaded = true
			end)
		end
	end)

	vape:Clean(function()
		Client.Get = OldGet
		bedwars.BlockController.isBlockBreakable = OldBreak
		store.blockPlacer:disable()
		for _, v in vapeEvents do
			v:Destroy()
		end
		for _, v in cache do
			table.clear(v[3])
			table.clear(v)
		end
		table.clear(store.blockPlacer)
		table.clear(vapeEvents)
		table.clear(bedwars)
		table.clear(store)
		table.clear(cache)
		table.clear(sides)
		table.clear(remotes)
		storeChanged:disconnect()
		storeChanged = nil
	end)
end)

for _, v in {'AntiRagdoll', 'TriggerBot', 'SilentAim', 'AutoRejoin', 'Rejoin', 'Disabler', 'Timer', 'ServerHop', 'MouseTP', 'MurderMystery'} do
	vape:Remove(v)
end
run(function()
    local AimAssist
    local Mode
    local Targets
    local Sort
    local AimPart
    local AimSpeed
    local Shake
    local Distance
    local AngleSlider
    local StrafeIncrease
    local BlockBreak
    local KillauraTarget
    local PriorityKillauraTarget
    local ClickAim
    local Mouse
    local Limit
    
    -- 追加されたオプションの変数
    local OnlyEnableFirstPerson
    local AlwaysAimAssist
    local GuiCheck -- ★ 新規追加

    local RandomCCRadius
    local RandomCCSpeed
    local RandomCCHitChance

    local function ease(t)
        return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
    end

    local cache = {}
    local function getMousePosition()
        if inputService.TouchEnabled then
            return gameCamera.ViewportSize / 2
        end
        return inputService.GetMouseLocation(inputService)
    end
    
    -- 1人称視点かどうかを判定する関数
    local function isFirstPerson()
        return (gameCamera.Focus.p - gameCamera.CFrame.p).Magnitude < 0.6
    end

    -- ★ GUIチェック用フラグ（PostSimulation内で毎フレーム更新）
    local isGuiOpen = false

    local function getAim(ent)
        if AimPart.Value == 'Closest' then
            if not cache[ent.Character] then
                cache[ent.Character] = ent.Character:GetChildren()
            end
            local localPosition, magnitude, part = getMousePosition(), 9e9, nil
            for _, v in cache[ent.Character] do
                if v and v:IsA('BasePart') then
                    local position, vis = gameCamera.WorldToViewportPoint(gameCamera, v.Position)

                    if vis then
                        local mag = (localPosition - Vector2.new(position.x, position.y)).Magnitude

                        if mag < magnitude then
                            magnitude = mag
                            part = v
                        end
                    end
                end
            end
            if part then
                return part.Position
            end
        end
        return ent.RootPart.Position
    end

    local started, lasttarget = 0, nil
    local randomOffset = Vector3.new(0, 0, 0)
    local lastOffsetUpdate = 0
    local hitTimer = 0
    
    local aimfuncs = {
        Simple = function(localcframe, ent, fps)
            local rng = Random.new()
            return localcframe:Lerp(CFrame.lookAt(localcframe.p, getAim(ent) + Vector3.new(
                (rng:NextNumber() - 0.5) * Shake.Value * fps,
                (rng:NextNumber() - 0.5) * Shake.Value * fps,
                (rng:NextNumber() - 0.5) * Shake.Value * fps
            )), (AimSpeed.Value + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 0)) * fps) 
        end,
        Adaptive = function(localcframe, ent, fps)
            local prog, rng = ease(math.min(tick() - started, 1)), Random.new()
            local speed = (AimSpeed.Value * 0.1 * prog) + (1 - prog) + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 5)
            return localcframe:Lerp(CFrame.lookAt(localcframe.p, getAim(ent) + Vector3.new(
                (rng:NextNumber() - 0.5) * Shake.Value * fps,
                (rng:NextNumber() - 0.5) * Shake.Value * fps,
                (rng:NextNumber() - 0.5) * Shake.Value * fps
            )), speed * fps) 
        end,
        RandomCC = function(localcframe, ent, fps)
            local rng = Random.new()
            local currentTime = tick()
            
            if currentTime - lastOffsetUpdate > (0.3 + rng:NextNumber() * 0.5) then
                local radius = RandomCCRadius.Value / 10
                randomOffset = Vector3.new(
                    (rng:NextNumber() - 0.5) * radius * 2,
                    (rng:NextNumber() - 0.5) * radius * 2,
                    (rng:NextNumber() - 0.5) * radius * 2
                )
                lastOffsetUpdate = currentTime
                hitTimer = currentTime + (2 + rng:NextNumber() * 3) 
            end
            
            local targetPos = getAim(ent)
            local finalOffset = randomOffset
            
            if currentTime >= hitTimer and rng:NextNumber() * 100 < RandomCCHitChance.Value then
                finalOffset = Vector3.new(
                    (rng:NextNumber() - 0.5) * 0.1,
                    (rng:NextNumber() - 0.5) * 0.1,
                    (rng:NextNumber() - 0.5) * 0.1
                )
                hitTimer = currentTime + (1.5 + rng:NextNumber() * 2.5)
            end
            
            local speed = (RandomCCSpeed.Value * 0.1) + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 0.5 or 0)
            
            return localcframe:Lerp(CFrame.lookAt(localcframe.p, targetPos + finalOffset + Vector3.new(
                (rng:NextNumber() - 0.5) * Shake.Value * fps * 0.5,
                (rng:NextNumber() - 0.5) * Shake.Value * fps * 0.5,
                (rng:NextNumber() - 0.5) * Shake.Value * fps * 0.5
            )), speed * fps)
        end
    }

    local function GetTarget()
        if lasttarget then
            local localPosition = entitylib.character.RootPart.Position
            if not lasttarget or not lasttarget.RootPart or not lasttarget.Humanoid or not lasttarget.Humanoid.Health or lasttarget.Humanoid.Health <= 0 then
                return false
            end
            if (localPosition - lasttarget.RootPart.Position).Magnitude > Distance.Value then
                return false
            end
            if Targets.Walls.Enabled and entitylib.Wallcheck(localPosition, lasttarget.RootPart.Position, Targets.Walls.Enabled) then
                return false
            end
            return lasttarget
        end

        return false
    end

    local function getAttackData()
        if not entitylib.isAlive then return false end
        -- ★ GuiCheckの判定（UILayerとgameProcessedEventのフラグを確認）
        if GuiCheck.Enabled and isGuiOpen then return false end
        if Mouse.Enabled and not inputService:IsMouseButtonPressed(0) and (tick() - bedwars.SwordController.lastSwing) > 0.15 then return false end
        if ClickAim.Enabled and (tick() - bedwars.SwordController.lastSwing) > 0.3 then return false end
        if BlockBreak.Enabled and (tick() - store.lastHit) < 0.3 then return false end
        if Limit.Enabled and store.hand.toolType ~= 'sword' then return false end

        if PriorityKillauraTarget.Enabled and store.KillauraTarget then
            local ent = store.KillauraTarget
            if ent and ent.RootPart and ent.Humanoid and ent.Humanoid.Health > 0 then
                started = tick()
                lasttarget = ent
                return ent
            end
        end

        if (tick() - started) > 1 or not lasttarget or not lasttarget.Parent or not lasttarget.Humanoid or lasttarget.Humanoid.Health <= 0 then
            local ent = GetTarget() or KillauraTarget.Enabled and store.KillauraTarget or entitylib.EntityPosition({
                Range = Distance.Value,
                Part = 'RootPart',
                Wallcheck = Targets.Walls.Enabled,
                Players = Targets.Players.Enabled,
                NPCs = Targets.NPCs.Enabled,
                Sort = sortmethods[Sort.Value]
            })
            if ent then
                started = tick()
            end
            lasttarget = ent
        end
        return lasttarget
    end
    
    AimAssist = vape.Categories.Combat:CreateModule({
        Name = 'AimAssist',
        Function = function(callback)
            if callback then
                -- ★ gameProcessedEvent を捕捉するためのUserInputServiceのイベント接続
                local inputBeganConnection
                inputBeganConnection = inputService.InputBegan:Connect(function(input, gameProcessed)
                    if GuiCheck.Enabled then
                        isGuiOpen = gameProcessed
                    else
                        isGuiOpen = false
                    end
                end)

                AimAssist:Clean(runService.PostSimulation:Connect(function(dt)
                    -- ★ 毎フレーム、インベントリやショップUIが開いているかをチェック
                    if GuiCheck.Enabled then
                        if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) or isGuiOpen then
                            return
                        end
                    end

                    local isFirst = isFirstPerson()
                    
                    -- OnlyEnableFirstPersonチェック
                    if OnlyEnableFirstPerson.Enabled and not isFirst then 
                        return 
                    end

                    local ent = getAttackData()
                    local rng = Random.new()

                    if ent then
                        -- ターゲットが存在する場合のエイム処理
                        local delta = (ent.RootPart.Position - entitylib.character.RootPart.Position)
                        local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                        local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                        if angle >= (math.rad(AngleSlider.Value) / 2) then return end
                        targetinfo.Targets[ent] = tick() + 1
                        
                        if isFirst then
                            -- 1人称時は従来のCamera CFrame書き換え
                            gameCamera.CFrame = aimfuncs[Mode.Value](gameCamera.CFrame, ent, dt)
                        else
                            -- 3人称時はmousemoverelを使用
                            local targetPos = getAim(ent)
                            local screenPos, vis = gameCamera:WorldToViewportPoint(targetPos)
                            if vis then
                                local mousePos = getMousePosition()
                                local moveX = (screenPos.X - mousePos.X) * (AimSpeed.Value / 20)
                                local moveY = (screenPos.Y - mousePos.Y) * (AimSpeed.Value / 20)
                                
                                -- Shake値の適用
                                if Shake.Value > 0 then
                                    moveX = moveX + (rng:NextNumber() - 0.5) * Shake.Value
                                    moveY = moveY + (rng:NextNumber() - 0.5) * Shake.Value
                                end
                                
                                if typeof(mousemoverel) == "function" then
                                    mousemoverel(moveX, moveY)
                                end
                            end
                        end
                    elseif AlwaysAimAssist.Enabled and Shake.Value > 0 then
                        -- ターゲットがおらず、AlwaysAimAssistがオンの場合のカメラ微揺れ処理
                        local shakeX = (rng:NextNumber() - 0.5) * Shake.Value * dt * 10
                        local shakeY = (rng:NextNumber() - 0.5) * Shake.Value * dt * 10
                        
                        if isFirst then
                            gameCamera.CFrame = gameCamera.CFrame * CFrame.Angles(math.rad(shakeY), math.rad(shakeX), 0)
                        else
                            if typeof(mousemoverel) == "function" then
                                mousemoverel(shakeX * 5, shakeY * 5)
                            end
                        end
                    end
                end))

                -- クリーンアップ時にイベント接続を解除
                AimAssist:Clean(function()
                    if inputBeganConnection then inputBeganConnection:Disconnect() end
                    isGuiOpen = false
                end)
            end
        end,
        Tooltip = 'Smoothly aims to closest valid target with sword'
    })
    local modes = {}
    for i in aimfuncs do
        table.insert(modes, i)
    end
    Mode = AimAssist:CreateDropdown({
        Name = 'Mode',
        List = modes,
        Tooltip = 'Simple - Smooth aiming\nAdaptive - Advanced tracking\nRandomCC - Random aim around target (anti-detection)',
        Default = modes[1]
    })
    Targets = AimAssist:CreateTargets({
        Players = true,
        Walls = true
    })
    local methods = {'Damage', 'Distance'}
    for i in sortmethods do
        if not table.find(methods, i) then
            table.insert(methods, i)
        end
    end
    ClickAim = AimAssist:CreateToggle({
        Name = 'Click aim',
        Default = true
    })
    Mouse = AimAssist:CreateToggle({Name = 'Require mouse down'})
    StrafeIncrease = AimAssist:CreateToggle({Name = 'Strafe increase'})
    BlockBreak = AimAssist:CreateToggle({Name = 'Check block break'})
    KillauraTarget = AimAssist:CreateToggle({Name = 'Use killaura target'})
    PriorityKillauraTarget = AimAssist:CreateToggle({
        Name = 'Priority killaura target',
        Tooltip = 'Always aims at killaura target when available, ignoring all other targets'
    })
    
    -- 新しいトグルボタンの追加
    OnlyEnableFirstPerson = AimAssist:CreateToggle({
        Name = 'Only enable first person',
        Tooltip = 'Only activates AimAssist when in first person view',
        Default = false
    })
    AlwaysAimAssist = AimAssist:CreateToggle({
        Name = 'Always AimAssist',
        Tooltip = 'Simulates a constant idle hand shake even without targets',
        Default = false
    })
    -- ★ GuiCheckトグルのGUI要素を追加
    GuiCheck = AimAssist:CreateToggle({
        Name = 'GuiCheck',
        Tooltip = 'Disables AimAssist when Bedwars main UI or chat/menus are open',
        Default = false
    })

    AimSpeed = AimAssist:CreateSlider({
        Name = 'Aim speed',
        Min = 1,
        Max = 20,
        Default = 6
    })
    Distance = AimAssist:CreateSlider({
        Name = 'Distance',
        Min = 1,
        Max = 30,
        Default = 30,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })
    Shake = AimAssist:CreateSlider({
        Name = 'Shake',
        Min = 0,
        Max = 100,
        Default = 0,
        Tooltip = 'Adds random jitter to simulate human aim'
    })
    AngleSlider = AimAssist:CreateSlider({
        Name = 'Max angle',
        Min = 1,
        Max = 360,
        Default = 70
    })
   
    RandomCCRadius = AimAssist:CreateSlider({
        Name = 'RandomCC radius',
        Min = 1,
        Max = 50,
        Default = 15,
        Tooltip = 'How far to aim around the target (RandomCC mode only)'
    })
    RandomCCSpeed = AimAssist:CreateSlider({
        Name = 'RandomCC speed',
        Min = 1,
        Max = 30,
        Default = 8,
        Tooltip = 'Aim speed for RandomCC mode'
    })
    RandomCCHitChance = AimAssist:CreateSlider({
        Name = 'RandomCC hit %',
        Min = 5,
        Max = 95,
        Default = 35,
        Suffix = '%',
        Tooltip = 'Chance to actually aim at target (lower = more legit)'
    })
    Limit = AimAssist:CreateToggle({
        Name = 'Limit to items',
        Tooltip = 'Only attacks when sword is held'
    })
    Sort = AimAssist:CreateDropdown({
        Name = 'Target mode',
        List = methods,
        Default = 'Angle'
    })
    AimPart = AimAssist:CreateDropdown({
        Name = 'Target area',
        List = {'Center', 'Closest'},
        Default = 'Center'
    })
end)
	
	
run(function()
	local AutoClicker
	local CPS
	local BlockCPS = {}
	local Thread
	
	local function AutoClick()
		if Thread then
			task.cancel(Thread)
		end
	
		Thread = task.delay(1 / 7, function()
			repeat
				if not bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
					local blockPlacer = bedwars.BlockPlacementController.blockPlacer
					if store.hand.toolType == 'block' and blockPlacer then
						if (workspace:GetServerTimeNow() - bedwars.BlockCpsController.lastPlaceTimestamp) >= ((1 / 12) * 0.5) then
							local mouseinfo = blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
							if mouseinfo and mouseinfo.placementPosition == mouseinfo.placementPosition then
								task.spawn(blockPlacer.placeBlock, blockPlacer, mouseinfo.placementPosition)
							end
						end
					elseif store.hand.toolType == 'sword' then
						bedwars.SwordController:swingSwordAtMouse()
					end
				end
	
				task.wait(1 / (store.hand.toolType == 'block' and BlockCPS or CPS).GetRandomValue())
			until not AutoClicker.Enabled
		end)
	end
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				AutoClicker:Clean(inputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						AutoClick()
					end
				end))
	
				AutoClicker:Clean(inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Thread then
						task.cancel(Thread)
						Thread = nil
					end
				end))
	
				if inputService.TouchEnabled then
					pcall(function()
						AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Down:Connect(AutoClick))
						AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Up:Connect(function()
							if Thread then
								task.cancel(Thread)
								Thread = nil
							end
						end))
					end)
				end
			else
				if Thread then
					task.cancel(Thread)
					Thread = nil
				end
			end
		end,
		Tooltip = 'Hold attack button to automatically click'
	})
	CPS = AutoClicker:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 9,
		DefaultMin = 7,
		DefaultMax = 7
	})
	AutoClicker:CreateToggle({
		Name = 'Place Blocks',
		Default = true,
		Function = function(callback)
			if BlockCPS.Object then
				BlockCPS.Object.Visible = callback
			end
		end
	})
	BlockCPS = AutoClicker:CreateTwoSlider({
		Name = 'Block CPS',
		Min = 1,
		Max = 12,
		DefaultMin = 12,
		DefaultMax = 12,
		Darker = true
	})
end)
	
run(function()
	local Value
	
	Reach = vape.Categories.Combat:CreateModule({
		Name = 'Reach',
		Function = function(callback)
			bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = callback and Value.Value + 2 or 14.4
		end,
		Tooltip = 'Extends attack reach'
	})
	Value = Reach:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 18,
		Default = 18,
		Function = function(val)
			if Reach.Enabled then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val + 2
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	
run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then 
					pcall(function() 
						lplr.PlayerGui.MobileUI['4'].Visible = false 
					end) 
				end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() 
					task.delay(0.1, function() 
						bedwars.SprintController:stopSprinting() 
					end) 
				end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then 
					pcall(function() 
						lplr.PlayerGui.MobileUI['4'].Visible = true 
					end) 
				end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
run(function()
	local TriggerBot
	local CPS
	local rayParams = RaycastParams.new()
	local BowCheck
	TriggerBot = vape.Categories.Combat:CreateModule({
		Name = 'TriggerBot',
		Function = function(callback)
			if callback then
				repeat
					local doAttack
					if not bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
						if entitylib.isAlive and store.hand.toolType == 'sword' and bedwars.DaoController.chargingMaid == nil then
							local attackRange = bedwars.ItemMeta[store.hand.tool.Name].sword.attackRange
							rayParams.FilterDescendantsInstances = {lplr.Character}
	
							local unit = lplr:GetMouse().UnitRay
							local localPos = entitylib.character.RootPart.Position
							local rayRange = (attackRange or 14.4)
							local ray = bedwars.QueryUtil:raycast(unit.Origin, unit.Direction * 200, rayParams)
							if ray and (localPos - ray.Instance.Position).Magnitude <= rayRange then
								local limit = (attackRange)
								for _, ent in entitylib.List do
									doAttack = ent.Targetable and ray.Instance:IsDescendantOf(ent.Character) and (localPos - ent.RootPart.Position).Magnitude <= rayRange
									if doAttack then
										break
									end
								end
							end
	
							doAttack = doAttack or bedwars.SwordController:getTargetInRegion(attackRange or 3.8 * 3, 0)
							if doAttack then
								bedwars.SwordController:swingSwordAtMouse()
							end
						end
						if BowCheck.Enabled then
							if store.hand.toolType == 'bow'  then
								local attackRange = 23
								rayParams.FilterDescendantsInstances = {lplr.Character}
		
								local unit = lplr:GetMouse().UnitRay
								local localPos = entitylib.character.RootPart.Position
								local rayRange = (attackRange)
								local ray = bedwars.QueryUtil:raycast(unit.Origin, unit.Direction * 200, rayParams)
								if ray and (localPos - ray.Instance.Position).Magnitude <= rayRange then
									local limit = (attackRange)
									for _, ent in entitylib.List do
										doAttack = ent.Targetable and ray.Instance:IsDescendantOf(ent.Character) and (localPos - ent.RootPart.Position).Magnitude <= rayRange
										if doAttack then
											break
										end
									end
								end
		
								doAttack = doAttack or bedwars.SwordController:getTargetInRegion(attackRange or 3.8 * 3, 0)
								if doAttack then
									mouse1click()
								end
							end
						end
					end
	
					task.wait(doAttack and 1 / CPS.GetRandomValue() or 0.016)
				until not TriggerBot.Enabled
			end
		end,
		Tooltip = 'Automatically swings when hovering over a entity'
	})
	CPS = TriggerBot:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 9,
		DefaultMin = 7,
		DefaultMax = 7
	})
	BowCheck = TriggerBot:CreateToggle({Name='Bow Check'})
end)
	
run(function()
	local Velocity
	local Horizontal
	local Vertical
	local Chance
	local TargetCheck
	local rand, old = Random.new()
	
	Velocity = vape.Categories.Combat:CreateModule({
		Name = 'Velocity',
		Function = function(callback)
			if callback then
				old = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
					if rand:NextNumber(0, 100) > Chance.Value then return end
					local check = (not TargetCheck.Enabled) or entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true
					})
	
					if check then
						knockback = knockback or {}
						if Horizontal.Value == 0 and Vertical.Value == 0 then return end
						knockback.horizontal = (knockback.horizontal or 1) * (Horizontal.Value / 100)
						knockback.vertical = (knockback.vertical or 1) * (Vertical.Value / 100)
					end
					
					return old(root, mass, dir, knockback, ...)
				end
			else
				bedwars.KnockbackUtil.applyKnockback = old
			end
		end,
		Tooltip = 'Reduces knockback taken'
	})
	Horizontal = Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Vertical = Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Chance = Velocity:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	TargetCheck = Velocity:CreateToggle({Name = 'Only when targeting'})
end)
	
local AntiFallDirection
run(function()
	local AntiFall
	local Mode
	local Material
	local Color
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true

	local function getLowGround()
		local mag = math.huge
		for _, pos in bedwars.BlockController:getStore():getAllBlockPositions() do
			pos = pos * 3
			if pos.Y < mag and not getPlacedBlock(pos + Vector3.new(0, 3, 0)) then
				mag = pos.Y
			end
		end
		return mag
	end

	AntiFall = vape.Categories.Blatant:CreateModule({
		Name = 'AntiFall',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.matchState ~= 0 or (not AntiFall.Enabled)
				if not AntiFall.Enabled then return end

				local pos, debounce = getLowGround(), tick()
				if pos ~= math.huge then
					AntiFallPart = Instance.new('Part')
					AntiFallPart.Size = Vector3.new(10000, 1, 10000)
					AntiFallPart.Transparency = 1 - Color.Opacity
					AntiFallPart.Material = Enum.Material[Material.Value]
					AntiFallPart.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
					AntiFallPart.Position = Vector3.new(0, pos - 2, 0)
					AntiFallPart.CanCollide = Mode.Value == 'Collide'
					AntiFallPart.Anchored = true
					AntiFallPart.CanQuery = false
					AntiFallPart.Parent = workspace
					AntiFall:Clean(AntiFallPart)
					AntiFall:Clean(AntiFallPart.Touched:Connect(function(touched)
						if touched.Parent == lplr.Character and entitylib.isAlive and debounce < tick() then
							debounce = tick() + 0.1
							if Mode.Value == 'Normal' then
								local top = getNearGround()
								if top then
									local lastTeleport = lplr:GetAttribute('LastTeleported')
									local connection
									connection = runService.PreSimulation:Connect(function()
										if vape.Modules.Fly.Enabled or vape.Modules.InfiniteFly.Enabled or vape.Modules.LongJump.Enabled then
											connection:Disconnect()
											AntiFallDirection = nil
											return
										end

										if entitylib.isAlive and lplr:GetAttribute('LastTeleported') == lastTeleport then
											local delta = ((top - entitylib.character.RootPart.Position) * Vector3.new(1, 0, 1))
											local root = entitylib.character.RootPart
											AntiFallDirection = delta.Unit == delta.Unit and delta.Unit or Vector3.zero
											root.Velocity *= Vector3.new(1, 0, 1)
											rayCheck.FilterDescendantsInstances = {gameCamera, lplr.Character}
											rayCheck.CollisionGroup = root.CollisionGroup

											local ray = workspace:Raycast(root.Position, AntiFallDirection, rayCheck)
											if ray then
												for _ = 1, 10 do
													local dpos = roundPos(ray.Position + ray.Normal * 1.5) + Vector3.new(0, 3, 0)
													if not getPlacedBlock(dpos) then
														top = Vector3.new(top.X, pos.Y, top.Z)
														break
													end
												end
											end

											root.CFrame += Vector3.new(0, top.Y - root.Position.Y, 0)
											if not frictionTable.Speed then
												root.AssemblyLinearVelocity = (AntiFallDirection * getSpeed()) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
											end

											if delta.Magnitude < 1 then
												connection:Disconnect()
												AntiFallDirection = nil
											end
										else
											connection:Disconnect()
											AntiFallDirection = nil
										end
									end)
									AntiFall:Clean(connection)
								end
							elseif Mode.Value == 'Velocity' then
								entitylib.character.RootPart.Velocity = Vector3.new(entitylib.character.RootPart.Velocity.X, 100, entitylib.character.RootPart.Velocity.Z)
							end
						end
					end))
				end
			else
				AntiFallDirection = nil
			end
		end,
		Tooltip = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.'
	})
	Mode = AntiFall:CreateDropdown({
		Name = 'Move Mode',
		List = {'Normal', 'Collide', 'Velocity'},
		Function = function(val)
			if AntiFallPart then
				AntiFallPart.CanCollide = val == 'Collide'
			end
		end,
	Tooltip = 'Normal - Smoothly moves you towards the nearest safe point\nVelocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
	})
	local materials = {'ForceField'}
	for _, v in Enum.Material:GetEnumItems() do
		if v.Name ~= 'ForceField' then
			table.insert(materials, v.Name)
		end
	end
	Material = AntiFall:CreateDropdown({
		Name = 'Material',
		List = materials,
		Function = function(val)
			if AntiFallPart then
				AntiFallPart.Material = Enum.Material[val]
			end
		end
	})
	Color = AntiFall:CreateColorSlider({
		Name = 'Color',
		DefaultOpacity = 0.5,
		Function = function(h, s, v, o)
			if AntiFallPart then
				AntiFallPart.Color = Color3.fromHSV(h, s, v)
				AntiFallPart.Transparency = 1 - o
			end
		end
	})
end)
	
run(function()
	local FastBreak
	local Time
	
	FastBreak = vape.Categories.Blatant:CreateModule({
		Name = 'FastBreak',
		Function = function(callback)
			if callback then
				repeat
					bedwars.BlockBreakController.blockBreaker:setCooldown(Time.Value)
					task.wait(0.1)
				until not FastBreak.Enabled
			else
				bedwars.BlockBreakController.blockBreaker:setCooldown(0.3)
			end
		end,
		Tooltip = 'Decreases block hit cooldown'
	})
	Time = FastBreak:CreateSlider({
		Name = 'Break speed',
		Min = 0,
		Max = 0.3,
		Default = 0.25,
		Decimal = 100,
		Suffix = 'seconds'
	})
end)
	
local Fly
local LongJump
run(function()
	local Value
	local VerticalValue
	local WallCheck
	local PopBalloons
	local TP
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local up, down, old = 0, 0

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			frictionTable.Fly = callback or nil
			updateVelocity()
			if callback then
				up, down, old = 0, 0, bedwars.BalloonController.deflateBalloon
				bedwars.BalloonController.deflateBalloon = function() end
				local tpTick, tpToggle, oldy = tick(), true

				if lplr.Character and (lplr.Character:GetAttribute('InflatedBalloons') or 0) == 0 and getItem('balloon') then
					bedwars.BalloonController:inflateBalloon()
				end
				Fly:Clean(vapeEvents.AttributeChanged.Event:Connect(function(changed)
					if changed == 'InflatedBalloons' and (lplr.Character:GetAttribute('InflatedBalloons') or 0) == 0 and getItem('balloon') then
						bedwars.BalloonController:inflateBalloon()
					end
				end))
				Fly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive and not InfiniteFly.Enabled and isnetworkowner(entitylib.character.RootPart) then
						local flyAllowed = (lplr.Character:GetAttribute('InflatedBalloons') and lplr.Character:GetAttribute('InflatedBalloons') > 0) or store.matchState == 2
						local mass = (1.5 + (flyAllowed and 6 or 0) * (tick() % 0.4 < 0.2 and -1 or 1)) + ((up + down) * VerticalValue.Value)
						local root, moveDirection = entitylib.character.RootPart, entitylib.character.Humanoid.MoveDirection
						local velo = getSpeed()
						local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera, AntiFallPart}
						rayCheck.CollisionGroup = root.CollisionGroup

						if WallCheck.Enabled then
							local ray = workspace:Raycast(root.Position, destination, rayCheck)
							if ray then
								destination = ((ray.Position + ray.Normal) - root.Position)
							end
						end

						if not flyAllowed then
							if tpToggle then
								local airleft = (tick() - entitylib.character.AirTime)
								if airleft > 2 then
									if not oldy then
										local ray = workspace:Raycast(root.Position, Vector3.new(0, -1000, 0), rayCheck)
										if ray and TP.Enabled then
											tpToggle = false
											oldy = root.Position.Y
											tpTick = tick() + 0.11
											root.CFrame = CFrame.lookAlong(Vector3.new(root.Position.X, ray.Position.Y + entitylib.character.HipHeight, root.Position.Z), root.CFrame.LookVector)
										end
									end
								end
							else
								if oldy then
									if tpTick < tick() then
										local newpos = Vector3.new(root.Position.X, oldy, root.Position.Z)
										root.CFrame = CFrame.lookAlong(newpos, root.CFrame.LookVector)
										tpToggle = true
										oldy = nil
									else
										mass = 0
									end
								end
							end
						end

						root.CFrame += destination
						root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, mass, 0)
					end
				end))
				Fly:Clean(inputService.InputBegan:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							up = 1
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							down = -1
						end
					end
				end))
				Fly:Clean(inputService.InputEnded:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						up = 0
					elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
						down = 0
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						Fly:Clean(jumpButton:GetPropertyChangedSignal('ImageRectOffset'):Connect(function()
							up = jumpButton.ImageRectOffset.X == 146 and 1 or 0
						end))
					end)
				end
			else
				bedwars.BalloonController.deflateBalloon = old
				if PopBalloons.Enabled and entitylib.isAlive and (lplr.Character:GetAttribute('InflatedBalloons') or 0) > 0 then
					for _ = 1, 3 do
						bedwars.BalloonController:deflateBalloon()
					end
				end
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 23,
		Default = 23,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	VerticalValue = Fly:CreateSlider({
		Name = 'Vertical Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	WallCheck = Fly:CreateToggle({
		Name = 'Wall Check',
		Default = true
	})
	PopBalloons = Fly:CreateToggle({
		Name = 'Pop Balloons',
		Default = true
	})
	TP = Fly:CreateToggle({
		Name = 'TP Down',
		Default = true
	})
end)
	
run(function()
	local Mode
	local Expand
	local objects, set = {}
	
	local function createHitbox(ent)
		if ent.Targetable and ent.Player then
			local hitbox = Instance.new('Part')
			hitbox.Size = Vector3.new(3, 6, 3) + Vector3.one * (Expand.Value / 5)
			hitbox.Position = ent.RootPart.Position
			hitbox.CanCollide = false
			hitbox.Massless = true
			hitbox.Transparency = 1
			hitbox.Parent = ent.Character
			local weld = Instance.new('Motor6D')
			weld.Part0 = hitbox
			weld.Part1 = ent.RootPart
			weld.Parent = hitbox
			objects[ent] = hitbox
		end
	end
	
	HitBoxes = vape.Categories.Blatant:CreateModule({
		Name = 'HitBoxes',
		Function = function(callback)
			if callback then
				if Mode.Value == 'Sword' then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, (Expand.Value / 3))
					set = true
				else
					HitBoxes:Clean(entitylib.Events.EntityAdded:Connect(createHitbox))
					HitBoxes:Clean(entitylib.Events.EntityRemoving:Connect(function(ent)
						if objects[ent] then
							objects[ent]:Destroy()
							objects[ent] = nil
						end
					end))
					for _, ent in entitylib.List do
						createHitbox(ent)
					end
				end
			else
				if set then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, 3.8)
					set = nil
				end
				for _, part in objects do
					part:Destroy()
				end
				table.clear(objects)
			end
		end,
		Tooltip = 'Expands attack hitbox'
	})
	Mode = HitBoxes:CreateDropdown({
		Name = 'Mode',
		List = {'Sword', 'Player'},
		Function = function()
			if HitBoxes.Enabled then
				HitBoxes:Toggle()
				HitBoxes:Toggle()
			end
		end,
		Tooltip = 'Sword - Increases the range around you to hit entities\nPlayer - Increases the players hitbox'
	})
	Expand = HitBoxes:CreateSlider({
		Name = 'Expand amount',
		Min = 0,
		Max = 14.4,
		Default = 14.4,
		Decimal = 10,
		Function = function(val)
			if HitBoxes.Enabled then
				if Mode.Value == 'Sword' then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, (val / 3))
				else
					for _, part in objects do
						part.Size = Vector3.new(3, 6, 3) + Vector3.one * (val / 5)
					end
				end
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	
run(function()
	vape.Categories.Blatant:CreateModule({
		Name = 'KeepSprint',
		Function = function(callback)
			debug.setconstant(bedwars.SprintController.startSprinting, 5, callback and 'blockSprinting' or 'blockSprint')
			bedwars.SprintController:stopSprinting()
		end,
		Tooltip = 'Lets you sprint with a speed potion.'
	})
end)
	
local Attacking
run(function()
	local Killaura
	local Targets
	local Sort
	local SwingRange
	local AttackRange
	local ChargeTime
	local UpdateRate
	local AngleSlider
	local MaxTargets
	local Mouse
	local Swing
	local GUI
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Face
	local Animation
	local AnimationMode
	local AnimationSpeed
	local AnimationTween
	local Limit
	local AirhitChance
	local AttackableCheck
	local LegitAura = {}
	
	-- 追加: Ignore Player関連の変数
	local IgnorePlayer
	local IgnoredList
	local IgnoreRange

	local Particles, Boxes = {}, {}
	local anims, AnimDelay, AnimTween, armC0 = vape.Libraries.auraanims, tick()
	local AttackRemote = {FireServer = function() end}
	task.spawn(function()
		AttackRemote = bedwars.Client:Get(remotes.AttackEntity).instance
	end)
	
	local function getAttackData()
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end
		if GUI.Enabled then
			if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end
		end
		if AttackableCheck.Enabled then
			local stunnedUntil = (lplr.Character and lplr.Character:GetAttribute('StunnedUntilTime') or 0) - workspace:GetServerTimeNow()
			if stunnedUntil > 0 then return false end
		end
		local sword = Limit.Enabled and store.hand or store.tools.sword
		if not sword or not sword.tool then return false end
		local meta = bedwars.ItemMeta[sword.tool.Name]
		if Limit.Enabled then
			if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
		end
		if LegitAura.Enabled then
			if (tick() - bedwars.SwordController.lastSwing) > 0.15 then return false end
		end
		return sword, meta
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = Limit.Enabled
					end)
				end
				if Animation.Enabled and not (identifyexecutor and table.find({'Argon', 'Delta','Codex','Krampus','Solara','Xeno'}, ({identifyexecutor()})[1])) then
					local fake = {
						Controllers = {
							ViewmodelController = {
								isVisible = function()
									return not Attacking
								end,
								playAnimation = function(...)
									if not Attacking then
										bedwars.ViewmodelController:playAnimation(select(2, ...))
									end
								end
							}
						}
					}
					task.spawn(function()
						local started = false
						repeat
							if Attacking then
								if not armC0 then
									armC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
								end
								local first = not started
								started = true
								if AnimationMode.Value == 'Random' then
									anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
								end
								for _, v in anims[AnimationMode.Value] do
									AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / AnimationSpeed.Value, Enum.EasingStyle.Linear), {
										C0 = armC0 * v.CFrame
									})
									AnimTween:Play()
									AnimTween.Completed:Wait()
									first = false
									if (not Killaura.Enabled) or (not Attacking) then break end
								end
							elseif started then
								started = false
								AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
									C0 = armC0
								})
								AnimTween:Play()
							end
							if not started then
								task.wait(1 / UpdateRate.Value)
							end
						until (not Killaura.Enabled) or (not Animation.Enabled)
					end)
				end
				local swingCooldown = 0
				repeat
					local attacked, sword, meta = {}, getAttackData()
					Attacking = false
					store.KillauraTarget = nil
					if sword then
						local plrs = entitylib.AllPosition({
							Range = SwingRange.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = MaxTargets.Value,
							Sort = sortmethods[Sort.Value]
						})
						if #plrs > 0 then
							switchItem(sword.tool, 0)
							local selfpos = entitylib.character.RootPart.Position
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
							for _, v in plrs do
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end
								
								local targetHRP = v.Character and v.Character:FindFirstChild('HumanoidRootPart')
								if targetHRP then
									local rayResult = workspace:Raycast(
										targetHRP.Position,
										Vector3.new(0, -5, 0),
										RaycastParams.new()
									)
									local isInAir = rayResult == nil
									if isInAir then
										local chance = AirhitChance.Value
										if chance < 100 then
											if math.random(1, 100) > chance then continue end
										end
									end
								end
								
								-- 変更点: IgnorePlayerの処理
								local currentAttackRange = AttackRange.Value
								if IgnorePlayer and IgnorePlayer.Enabled and v.Player then
									local playerName = v.Player.Name
									if table.find(IgnoredList.ListEnabled, playerName) then
										currentAttackRange = IgnoreRange.Value
									end
								end

								table.insert(attacked, {
									Entity = v,
									Check = delta.Magnitude > currentAttackRange and BoxSwingColor or BoxAttackColor
								})
								targetinfo.Targets[v] = tick() + 1
								if not Attacking then
									Attacking = true
									store.KillauraTarget = v
									if not Swing.Enabled and AnimDelay < tick() and not LegitAura.Enabled then
										AnimDelay = tick() + (meta.sword.respectAttackSpeedForEffects and meta.sword.attackSpeed or math.max(ChargeTime.Value, 0.11))
										bedwars.SwordController:playSwordEffect(meta, false)
										if meta.displayName:find(' Scythe') then
											bedwars.ScytheController:playLocalAnimation()
										end
										if vape.ThreadFix then
											setthreadidentity(8)
										end
									end
								end
								
								-- 変更点: currentAttackRangeを使用
								if delta.Magnitude > currentAttackRange then continue end
								if delta.Magnitude < 14.4 and (tick() - swingCooldown) < math.max(ChargeTime.Value, 0.02) then continue end
								
								local actualRoot = v.Character.PrimaryPart
								if actualRoot then
									local dir = CFrame.lookAt(selfpos, actualRoot.Position).LookVector
									local pos = selfpos + dir * math.max(delta.Magnitude - 14.399, 0)
									swingCooldown = tick()
									bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
									store.attackReach = (delta.Magnitude * 100) // 1 / 100
									store.attackReachUpdate = tick() + 1
									if delta.Magnitude < 14.4 and ChargeTime.Value > 0.11 then
										AnimDelay = tick()
									end
									AttackRemote:FireServer({
										weapon = sword.tool,
										chargedAttack = {chargeRatio = 0},
										lastSwingServerTimeDelta = 0.5,
										entityInstance = v.Character,
										validate = {
											raycast = {
												cameraPosition = {value = pos},
												cursorDirection = {value = dir}
											},
											targetPosition = {value = actualRoot.Position},
											selfPosition = {value = pos}
										}
									})
								end
							end
						end
					end
					
					for i, v in Boxes do
						v.Adornee = attacked[i] and attacked[i].Entity.RootPart or nil
						if v.Adornee then
							v.Color3 = Color3.fromHSV(attacked[i].Check.Hue, attacked[i].Check.Sat, attacked[i].Check.Value)
							v.Transparency = 1 - attacked[i].Check.Opacity
						end
					end
					for i, v in Particles do
						v.Position = attacked[i] and attacked[i].Entity.RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
						v.Parent = attacked[i] and gameCamera or nil
					end
					if Face.Enabled and attacked[1] then
						local vec = attacked[1].Entity.RootPart.Position * Vector3.new(1, 0, 1)
						entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y + 0.001, vec.Z))
					end
					task.wait(1 / UpdateRate.Value)
				until not Killaura.Enabled
			else
				store.KillauraTarget = nil
				for _, v in Boxes do
					v.Adornee = nil
				end
				for _, v in Particles do
					v.Parent = nil
				end
				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = true
					end)
				end
				Attacking = false
				if armC0 then
					AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
						C0 = armC0
					})
					AnimTween:Play()
				end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	
	Targets = Killaura:CreateTargets({
		Players = true,
		NPCs = true
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	
	SwingRange = Killaura:CreateSlider({
		Name = 'Swing range',
		Min = 1,
		Max = 22,
		Default = 14,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AttackRange = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 22,
		Default = 14,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	ChargeTime = Killaura:CreateSlider({
		Name = 'Swing time',
		Min = 0,
		Max = 0.5,
		Default = 0.42,
		Decimal = 100
	})
	AngleSlider = Killaura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 360
	})
	UpdateRate = Killaura:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	MaxTargets = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 5,
		Default = 5
	})
	AirhitChance = Killaura:CreateSlider({
		Name = 'Airhit chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	Sort = Killaura:CreateDropdown({
		Name = 'Target Mode',
		List = methods
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
	Swing = Killaura:CreateToggle({Name = 'No Swing'})
	GUI = Killaura:CreateToggle({Name = 'GUI check'})
	AttackableCheck = Killaura:CreateToggle({
		Name = 'Attackable check',
		Tooltip = ''
	})
	
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
			BoxSwingColor.Object.Visible = callback
			BoxAttackColor.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local box = Instance.new('BoxHandleAdornment')
					box.Adornee = nil
					box.AlwaysOnTop = true
					box.Size = Vector3.new(3, 5, 3)
					box.CFrame = CFrame.new(0, -0.5, 0)
					box.ZIndex = 0
					box.Parent = vape.gui
					Boxes[i] = box
				end
			else
				for _, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
	})
	
	BoxSwingColor = Killaura:CreateColorSlider({
		Name = 'Target Color',
		Darker = true,
		DefaultHue = 0.6,
		DefaultOpacity = 0.5,
		Visible = false
	})
	BoxAttackColor = Killaura:CreateColorSlider({
		Name = 'Attack Color',
		Darker = true,
		DefaultOpacity = 0.5,
		Visible = false
	})
	
	Killaura:CreateToggle({
		Name = 'Target particles',
		Function = function(callback)
			ParticleTexture.Object.Visible = callback
			ParticleColor1.Object.Visible = callback
			ParticleColor2.Object.Visible = callback
			ParticleSize.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local part = Instance.new('Part')
					part.Size = Vector3.new(2, 4, 2)
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.CanQuery = false
					part.Parent = Killaura.Enabled and gameCamera or nil
					local particles = Instance.new('ParticleEmitter')
					particles.Brightness = 1.5
					particles.Size = NumberSequence.new(ParticleSize.Value)
					particles.Shape = Enum.ParticleEmitterShape.Sphere
					particles.Texture = ParticleTexture.Value
					particles.Transparency = NumberSequence.new(0)
					particles.Lifetime = NumberRange.new(0.4)
					particles.Speed = NumberRange.new(16)
					particles.Rate = 128
					particles.Drag = 16
					particles.ShapePartial = 1
					particles.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
					})
					particles.Parent = part
					Particles[i] = part
				end
			else
				for _, v in Particles do
					v:Destroy()
				end
				table.clear(Particles)
			end
		end
	})
	
	ParticleTexture = Killaura:CreateTextBox({
		Name = 'Texture',
		Default = 'rbxassetid://14736249347',
		Function = function()
			for _, v in Particles do
				v.ParticleEmitter.Texture = ParticleTexture.Value
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor1 = Killaura:CreateColorSlider({
		Name = 'Color Begin',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor2 = Killaura:CreateColorSlider({
		Name = 'Color End',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleSize = Killaura:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	
	Face = Killaura:CreateToggle({Name = 'Face target'})
	Animation = Killaura:CreateToggle({
		Name = 'Custom Animation',
		Function = function(callback)
			AnimationMode.Object.Visible = callback
			AnimationTween.Object.Visible = callback
			AnimationSpeed.Object.Visible = callback
			if Killaura.Enabled then
				Killaura:Toggle()
				Killaura:Toggle()
			end
		end
	})
	local animnames = {}
	for i in anims do
		table.insert(animnames, i)
	end
	AnimationMode = Killaura:CreateDropdown({
		Name = 'Animation Mode',
		List = animnames,
		Darker = true,
		Visible = false
	})
	AnimationSpeed = Killaura:CreateSlider({
		Name = 'Animation Speed',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10,
		Darker = true,
		Visible = false
	})
	AnimationTween = Killaura:CreateToggle({
		Name = 'No Tween',
		Darker = true,
		Visible = false
	})
	Limit = Killaura:CreateToggle({
		Name = 'Limit to items',
		Function = function(callback)
			if inputService.TouchEnabled and Killaura.Enabled then
				pcall(function()
					lplr.PlayerGui.MobileUI['2'].Visible = callback
				end)
			end
		end,
		Tooltip = 'Only attacks when the sword is held'
	})
	LegitAura = Killaura:CreateToggle({
		Name = 'Swing only',
		Tooltip = 'Only attacks while swinging manually'
	})
	
	-- 追加: Ignore Player UI要素
	IgnorePlayer = Killaura:CreateToggle({
		Name = 'Ignore Player',
		Tooltip = 'Enables ignoring specific players or changing their attack range',
		Function = function(callback)
			if IgnoredList then IgnoredList.Object.Visible = callback end
			if IgnoreRange then IgnoreRange.Object.Visible = callback end
		end
	})
	IgnoredList = Killaura:CreateTextList({
		Name = 'Ignored Players',
		Placeholder = 'PlayerName',
		Darker = true,
		Visible = false
	})
	IgnoreRange = Killaura:CreateSlider({
		Name = 'Ignore Range',
		Min = 0,
		Max = 22,
		Default = 0,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end,
		Darker = true,
		Visible = false,
		Tooltip = 'Attack range for ignored players. Set to 0 to completely ignore them.'
	})
end)
	
run(function()
	local Value
	local CameraDir
	local start
	local JumpTick, JumpSpeed, Direction = tick(), 0
	local projectileRemote = {InvokeServer = function() end}
	task.spawn(function()
		projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
	end)
	
	local function launchProjectile(item, pos, proj, speed, dir)
		if not pos then return end
	
		pos = pos - dir * 0.1
		local shootPosition = (CFrame.lookAlong(pos, Vector3.new(0, -speed, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ)))
		switchItem(item.tool, 0)
		task.wait(0.1)
		bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta[proj], proj, proj, shootPosition.Position, '', shootPosition.LookVector * speed, {drawDurationSeconds = 1})
		if projectileRemote:InvokeServer(item.tool, proj, proj, shootPosition.Position, pos, shootPosition.LookVector * speed, httpService:GenerateGUID(true), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045) then
			local shoot = bedwars.ItemMeta[item.itemType].projectileSource.launchSound
			shoot = shoot and shoot[math.random(1, #shoot)] or nil
			if shoot then
				bedwars.SoundManager:playSound(shoot)
			end
		end
	end
	
	local LongJumpMethods = {
		cannon = function(_, pos, dir)
			pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
			local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
			bedwars.placeBlock(rounded, 'cannon', false)
	
			task.delay(0, function()
				local block, blockpos = getPlacedBlock(rounded)
				if block and block.Name == 'cannon' and (entitylib.character.RootPart.Position - block.Position).Magnitude < 20 then
					local breaktype = bedwars.ItemMeta[block.Name].block.breakType
					local tool = store.tools[breaktype]
					if tool then
						switchItem(tool.tool)
					end
	
					bedwars.Client:Get(remotes.CannonAim):SendToServer({
						cannonBlockPos = blockpos,
						lookVector = dir
					})
	
					local broken = 0.1
					if bedwars.BlockController:calculateBlockDamage(lplr, {blockPosition = blockpos}) < block:GetAttribute('Health') then
						broken = 0.4
						bedwars.breakBlock(block, true, true)
					end
	
					task.delay(broken, function()
						for _ = 1, 3 do
							local call = bedwars.Client:Get(remotes.CannonLaunch):CallServer({cannonBlockPos = blockpos})
							if call then
								bedwars.breakBlock(block, true, true)
								JumpSpeed = 5.25 * Value.Value
								JumpTick = tick() + 2.3
								Direction = Vector3.new(dir.X, 0, dir.Z).Unit
								break
							end
							task.wait(0.1)
						end
					end)
				end
			end)
		end,
		cat = function(_, _, dir)
			LongJump:Clean(vapeEvents.CatPounce.Event:Connect(function()
				JumpSpeed = 4 * Value.Value
				JumpTick = tick() + 2.5
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
				entitylib.character.RootPart.Velocity = Vector3.zero
			end))
	
			if not bedwars.AbilityController:canUseAbility('CAT_POUNCE') then
				repeat task.wait() until bedwars.AbilityController:canUseAbility('CAT_POUNCE') or not LongJump.Enabled
			end
	
			if bedwars.AbilityController:canUseAbility('CAT_POUNCE') and LongJump.Enabled then
				bedwars.AbilityController:useAbility('CAT_POUNCE')
			end
		end,
		fireball = function(item, pos, dir)
			launchProjectile(item, pos, 'fireball', 60, dir)
		end,
		grappling_hook = function(item, pos, dir)
			launchProjectile(item, pos, 'grappling_hook_projectile', 140, dir)
		end,
		jade_hammer = function(item, _, dir)
			if not bedwars.AbilityController:canUseAbility(item.itemType..'_jump') then
				repeat task.wait() until bedwars.AbilityController:canUseAbility(item.itemType..'_jump') or not LongJump.Enabled
			end
	
			if bedwars.AbilityController:canUseAbility(item.itemType..'_jump') and LongJump.Enabled then
				bedwars.AbilityController:useAbility(item.itemType..'_jump')
				JumpSpeed = 1.4 * Value.Value
				JumpTick = tick() + 2.5
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
			end
		end,
		tnt = function(item, pos, dir)
			pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
			local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
			start = Vector3.new(rounded.X, start.Y, rounded.Z) + (dir * (item.itemType == 'pirate_gunpowder_barrel' and 2.6 or 0.2))
			bedwars.placeBlock(rounded, item.itemType, false)
		end,
		wood_dao = function(item, pos, dir)
			if (lplr.Character:GetAttribute('CanDashNext') or 0) > workspace:GetServerTimeNow() or not bedwars.AbilityController:canUseAbility('dash') then
				repeat task.wait() until (lplr.Character:GetAttribute('CanDashNext') or 0) < workspace:GetServerTimeNow() and bedwars.AbilityController:canUseAbility('dash') or not LongJump.Enabled
			end
	
			if LongJump.Enabled then
				bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
				switchItem(item.tool, 0.1)
				replicatedStorage['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].useAbility:FireServer('dash', {
					direction = dir,
					origin = pos,
					weapon = item.itemType
				})
				JumpSpeed = 4.5 * Value.Value
				JumpTick = tick() + 2.4
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
			end
		end
	}
	for _, v in {'stone_dao', 'iron_dao', 'diamond_dao', 'emerald_dao'} do
		LongJumpMethods[v] = LongJumpMethods.wood_dao
	end
	LongJumpMethods.void_axe = LongJumpMethods.jade_hammer
	LongJumpMethods.siege_tnt = LongJumpMethods.tnt
	LongJumpMethods.pirate_gunpowder_barrel = LongJumpMethods.tnt
	
	LongJump = vape.Categories.Blatant:CreateModule({
		Name = 'LongJump',
		Function = function(callback)
			frictionTable.LongJump = callback or nil
			updateVelocity()
			if callback then
				LongJump:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and damageTable.fromEntity == lplr.Character and (not damageTable.knockbackMultiplier or not damageTable.knockbackMultiplier.disabled) then
						local knockbackBoost = bedwars.KnockbackUtil.calculateKnockbackVelocity(Vector3.one, 1, {
							vertical = 0,
							horizontal = (damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal or 1)
						}).Magnitude * 1.1
	
						if knockbackBoost >= JumpSpeed then
							local pos = damageTable.fromPosition and Vector3.new(damageTable.fromPosition.X, damageTable.fromPosition.Y, damageTable.fromPosition.Z) or damageTable.fromEntity and damageTable.fromEntity.PrimaryPart.Position
							if not pos then return end
							local vec = (entitylib.character.RootPart.Position - pos)
							JumpSpeed = knockbackBoost
							JumpTick = tick() + 2.5
							Direction = Vector3.new(vec.X, 0, vec.Z).Unit
						end
					end
				end))
				LongJump:Clean(vapeEvents.GrapplingHookFunctions.Event:Connect(function(dataTable)
					if dataTable.hookFunction == 'PLAYER_IN_TRANSIT' then
						local vec = entitylib.character.RootPart.CFrame.LookVector
						JumpSpeed = 2.5 * Value.Value
						JumpTick = tick() + 2.5
						Direction = Vector3.new(vec.X, 0, vec.Z).Unit
					end
				end))
	
				start = entitylib.isAlive and entitylib.character.RootPart.Position or nil
				LongJump:Clean(runService.PreSimulation:Connect(function(dt)
					local root = entitylib.isAlive and entitylib.character.RootPart or nil
	
					if root and isnetworkowner(root) then
						if JumpTick > tick() then
							root.AssemblyLinearVelocity = Direction * (getSpeed() + ((JumpTick - tick()) > 1.1 and JumpSpeed or 0)) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
							if entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air and not start then
								root.AssemblyLinearVelocity += Vector3.new(0, dt * (workspace.Gravity - 23), 0)
							else
								root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 15, root.AssemblyLinearVelocity.Z)
							end
							start = nil
						else
							if start then
								root.CFrame = CFrame.lookAlong(start, root.CFrame.LookVector)
							end
							root.AssemblyLinearVelocity = Vector3.zero
							JumpSpeed = 0
						end
					else
						start = nil
					end
				end))
	
				if store.hand and LongJumpMethods[store.hand.tool.Name] then
					task.spawn(LongJumpMethods[store.hand.tool.Name], getItem(store.hand.tool.Name), start, (CameraDir.Enabled and gameCamera or entitylib.character.RootPart).CFrame.LookVector)
					return
				end
	
				for i, v in LongJumpMethods do
					local item = getItem(i)
					if item or store.equippedKit == i then
						task.spawn(v, item, start, (CameraDir.Enabled and gameCamera or entitylib.character.RootPart).CFrame.LookVector)
						break
					end
				end
			else
				JumpTick = tick()
				Direction = nil
				JumpSpeed = 0
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Lets you jump farther'
	})
	Value = LongJump:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 37,
		Default = 37,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	CameraDir = LongJump:CreateToggle({
		Name = 'Camera Direction'
	})
end)
	
run(function()
	local NoFall
	local Mode
	local rayParams = RaycastParams.new()
	local groundHit
	task.spawn(function()
		groundHit = bedwars.Client:Get(remotes.GroundHit).instance
	end)
	
	NoFall = vape.Categories.Blatant:CreateModule({
		Name = 'NoFall',
		Function = function(callback)
			if callback then
				local tracked = 0
				if Mode.Value == 'Gravity' then
					local extraGravity = 0
					NoFall:Clean(runService.PreSimulation:Connect(function(dt)
						if entitylib.isAlive then
							local root = entitylib.character.RootPart
							if root.AssemblyLinearVelocity.Y < -85 then
								rayParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
								rayParams.CollisionGroup = root.CollisionGroup
	
								local rootSize = root.Size.Y / 2 + entitylib.character.HipHeight
								local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, (tracked * 0.1) - rootSize, 0), rayParams)
								if not ray then
									root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -86, root.AssemblyLinearVelocity.Z)
									root.CFrame += Vector3.new(0, extraGravity * dt, 0)
									extraGravity += -workspace.Gravity * dt
								end
							else
								extraGravity = 0
							end
						end
					end))
				else
					repeat
						if entitylib.isAlive then
							local root = entitylib.character.RootPart
							tracked = entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air and math.min(tracked, root.AssemblyLinearVelocity.Y) or 0
	
							if tracked < -85 then
								if Mode.Value == 'Packet' then
									groundHit:FireServer(nil, Vector3.new(0, tracked, 0), workspace:GetServerTimeNow())
								else
									rayParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
									rayParams.CollisionGroup = root.CollisionGroup
	
									local rootSize = root.Size.Y / 2 + entitylib.character.HipHeight
									if Mode.Value == 'Teleport' then
										local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, -1000, 0), rayParams)
										if ray then
											root.CFrame -= Vector3.new(0, root.Position.Y - (ray.Position.Y + rootSize), 0)
										end
									else
										local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, (tracked * 0.1) - rootSize, 0), rayParams)
										if ray then
											tracked = 0
											root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -80, root.AssemblyLinearVelocity.Z)
										end
									end
								end
							end
						end
	
						task.wait(0.03)
					until not NoFall.Enabled
				end
			end
		end,
		Tooltip = 'Prevents taking fall damage.'
	})
	Mode = NoFall:CreateDropdown({
		Name = 'Mode',
		List = {'Packet', 'Gravity', 'Teleport', 'Bounce'},
		Function = function()
			if NoFall.Enabled then
				NoFall:Toggle()
				NoFall:Toggle()
			end
		end
	})
end)
	
run(function()
	local old
	
	vape.Categories.Blatant:CreateModule({
		Name = 'NoSlowdown',
		Function = function(callback)
			local modifier = bedwars.SprintController:getMovementStatusModifier()
			if callback then
				old = modifier.addModifier
				modifier.addModifier = function(self, tab)
					if tab.moveSpeedMultiplier then
						tab.moveSpeedMultiplier = math.max(tab.moveSpeedMultiplier, 1)
					end
					return old(self, tab)
				end
	
				for i in modifier.modifiers do
					if (i.moveSpeedMultiplier or 1) < 1 then
						modifier:removeModifier(i)
					end
				end
			else
				modifier.addModifier = old
				old = nil
			end
		end,
		Tooltip = 'Prevents slowing down when using items.'
	})
end)
	
run(function()
	local Prediction
	local AutoCharge
	local TargetPart
	local Targets
	local FOV
	local Sort
	local OtherProjectiles
	local Blacklist
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Include
	rayCheck.FilterDescendantsInstances = {workspace:FindFirstChild('Map')}
	local launchHook, oldd

	local function getMousePosition()
		if inputService.TouchEnabled then
			return gameCamera.ViewportSize / 2
		end
		return inputService.GetMouseLocation(inputService)
	end

	local function getPosition(ent, proj)
		if TargetPart.Value == 'Closest' then
			local localPosition, magnitude, part = getMousePosition(), 9e9, nil
			for _, v in ent:GetChildren() do
				if pcall(function() return v.Position end) then
					local position, vis = gameCamera.WorldToViewportPoint(gameCamera, v.Position)

					if vis then
						local mag = (localPosition - Vector2.new(position.x, position.y)).Magnitude

						if mag < magnitude then
							magnitude = mag
							part = v
						end
					end
				end
			end
			return part and part.Position or ent.PrimaryPart.Position
		elseif TargetPart.Value == 'Dynamic' then
			local tool = store.hand.tool
			if tool and tool.Name:find('headhunter') then
				return ent.Head.Position
			end
			return ent.PrimaryPart.Position
		end
		return 
	end
	
	local ProjectileAimbot; ProjectileAimbot = vape.Categories.Blatant:CreateModule({
		Name = 'Projectile Aimbot',
		Function = function(callback)
			if callback then
				oldd = bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition
				launchHook = bedwars.ProjectileLaunchHook:Add('ProjectileAimbot', 100, function(nextLaunch, ...)
					local self, projmeta, worldmeta, origin, shootpos = ...
					local plr = entitylib.EntityMouse({
						Part = 'RootPart',
						Range = FOV.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled,
						Sort = sortmethods[Sort.Value or 'Distance'],
						Origin = entitylib.isAlive and (shootpos or entitylib.character.RootPart.Position) or Vector3.zero
					})
	
					if plr then
						local pos = shootpos or self:getLaunchPosition(origin)
						if not pos then
							return nextLaunch(...)
						end
	
						if (not OtherProjectiles.Enabled) and not projmeta.projectile:find('arrow') then
							return nextLaunch(...)
						end
	
						if table.find(Blacklist.ListEnabled or {}, ((projmeta.projectile == 'glue_trap' or projmeta.projectile == 'glue_projectile') and 'gloop' or projmeta.projectile)) then
							return nextLaunch(...)
						end

						local meta = projmeta:getProjectileMeta()
						local lifetime = (worldmeta and meta.predictionLifetimeSec or meta.lifetimeSec or 3)
						local gravity = (meta.gravitationalAcceleration or 196.2) * projmeta.gravityMultiplier
						local projSpeed = (meta.launchVelocity or 100)
						local offsetpos = pos + (projmeta.projectile == 'owl_projectile' and Vector3.zero or projmeta.fromPositionOffset)
						local balloons = plr.Character:GetAttribute('InflatedBalloons')
						local playerGravity = workspace.Gravity
	
						if balloons and balloons > 0 then
							playerGravity = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
						end
	
						if plr.Character.PrimaryPart:FindFirstChild('rbxassetid://8200754399') then
							playerGravity = 6
						end
	
						if plr.Player and plr.Player:GetAttribute('IsOwlTarget') then
							for _, owl in collectionService:GetTagged('Owl') do
								if owl:GetAttribute('Target') == plr.Player.UserId and owl:GetAttribute('Status') == 2 then
									playerGravity = 0
								end
							end
						end
	
						local targetpos = getPosition(plr.Character) or plr[TargetPart.Value].Position
						local newlook = CFrame.new(offsetpos, targetpos) * CFrame.new(projmeta.projectile == 'owl_projectile' and Vector3.zero or Vector3.new(bedwars.BowConstantsTable.RelX, bedwars.BowConstantsTable.RelY, bedwars.BowConstantsTable.RelZ))
						local v = plr.RootPart.Velocity
						local newv = v:Lerp(plr.RootPart.Velocity, 0.5)
						pos = entitylib.character.RootPart.Position
						local ps = math.min(lplr:GetNetworkPing(), 0.5)
						if ps > 0.06 then
							targetpos = targetpos + (v * ps)
						end
						local calc = prediction.SolveTrajectory(newlook.p, projSpeed * Prediction.Value, gravity, targetpos, projmeta.projectile == 'telepearl' and Vector3.zero or newv, playerGravity, plr.HipHeight, plr.Jumping and 42.6 or nil, rayCheck)
						if calc then
							targetinfo.Targets[plr] = tick() + 1
							return {
								initialVelocity = CFrame.new(newlook.Position, calc).LookVector * (projSpeed * (AutoCharge.Enabled and 1 or projmeta.velocityMultiplier)),
								positionFrom = offsetpos,
								deltaT = lifetime,
								gravitationalAcceleration = gravity,
								drawDurationSeconds = AutoCharge.Enabled and 5 or projmeta.drawDurationSeconds
							}
						end
					end
	
					return nextLaunch(...)
				end)

				bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = function(...)
					local origin, dir = select(2, ...)
					local plr = entitylib.EntityMouse({
						Part = 'RootPart',
						Range = FOV.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled,
						Sort = sortmethods[Sort.Value or 'Distance'],
						Origin = origin
					})

					if plr then
						local calc = prediction.SolveTrajectory(origin, 100, 20, plr[TargetPart.Value].Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil)

						if calc then
							for i, v in debug.getstack(2) do
								if v == dir then
									debug.setstack(2, i, CFrame.lookAt(origin, calc).LookVector)
								end
							end
						end
					end

					return oldd(...)
				end
			else
				bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = oldd
				if launchHook then
					launchHook()
					launchHook = nil
				end
			end
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	Targets = ProjectileAimbot:CreateTargets({
		Players = true,
		Walls = true
	})
	TargetPart = ProjectileAimbot:CreateDropdown({
		Name = 'Part',
		List = {'RootPart', 'Head', 'Dynamic', 'Closest'}
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	Sort = ProjectileAimbot:CreateDropdown({
		Name = 'Target Mode',
		List = methods,
		Default = 'Distance'
	})
	Prediction = ProjectileAimbot:CreateSlider({
		Name = 'Prediction',
		Min = 0.1,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
	FOV = ProjectileAimbot:CreateSlider({
		Name = 'FOV',
		Min = 1,
		Max = 1000,
		Default = 1000
	})
	AutoCharge = ProjectileAimbot:CreateToggle({
		Name = 'Auto Charge',
		Default = true,
		Tooltip = 'Fully charges your bow, Allowing your projectile to deal more damage'
	})
	OtherProjectiles = ProjectileAimbot:CreateToggle({
		Name = 'Other Projectiles',
		Default = true,
		Function = function(call)
			if Blacklist and Blacklist.Object then
				Blacklist.Object.Visible = call
			end
		end
	})
	Blacklist = ProjectileAimbot:CreateTextList({
		Name = 'Blacklist',
		Default = {'gloop'},
		Darker = true,
		Placeholder = 'projectile'
	})
end)
	
run(function()
local ProjectileAura
local Targets
local Range
local List
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Include
local projectileRemote = {InvokeServer = function() end}
local FireDelays = {}
task.spawn(function()
	projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
end)

local function getAmmo(check)
	for _, item in store.inventory.inventory.items do
		if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
			return item.itemType
		end
	end
end

local function getProjectiles()
	local items = {}
	for _, item in store.inventory.inventory.items do
		local proj = bedwars.ItemMeta[item.itemType].projectileSource
		local ammo = proj and getAmmo(proj)
		if ammo and table.find(List.ListEnabled, ammo) then
			table.insert(items, {
				item,
				ammo,
				proj.projectileType(ammo),
				proj
			})
		end
	end
	return items
end

ProjectileAura = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAura',
	Function = function(callback)
		if callback then
			repeat
				if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.5 then
					local ent = entitylib.EntityPosition({
						Part = 'RootPart',
						Range = Range.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled
					})

					if ent then
						local pos = entitylib.character.RootPart.Position
						for _, data in getProjectiles() do
							local item, ammo, projectile, itemMeta = unpack(data)
							if (FireDelays[item.itemType] or 0) < tick() then
								rayCheck.FilterDescendantsInstances = {workspace.Map}
								local meta = bedwars.ProjectileMeta[projectile]
								local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
								local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, ent.Jumping and 42.6 or nil, rayCheck)
								if calc then
									targetinfo.Targets[ent] = tick() + 1
									local switched = switchItem(item.tool)

									task.spawn(function()
										local dir, id = CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
										local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
										bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
										local res = projectileRemote:InvokeServer(item.tool, ammo, projectile, shootPosition, pos, dir * projSpeed, id, {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
										if not res then
											FireDelays[item.itemType] = tick()
										else
											local shoot = itemMeta.launchSound
											shoot = shoot and shoot[math.random(1, #shoot)] or nil
											if shoot then
												bedwars.SoundManager:playSound(shoot)
											end
										end
									end)

									FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
									if switched then
										task.wait(0.05)
									end
								end
							end
						end
					end
				end
				task.wait(0.1)
			until not ProjectileAura.Enabled
		end
	end,
	Tooltip = 'Shoots people around you'
})
Targets = ProjectileAura:CreateTargets({
	Players = true,
	Walls = true
})
List = ProjectileAura:CreateTextList({
	Name = 'Projectiles',
	Default = {'arrow', 'snowball'}
})
Range = ProjectileAura:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 50,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
end)

	
run(function()
	local Speed
	local Value
	local WallCheck
	local AutoJump
	local AlwaysJump
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	
	Speed = vape.Categories.Blatant:CreateModule({
		Name = 'Speed',
		Function = function(callback)
			frictionTable.Speed = callback or nil
			updateVelocity()
			pcall(function()
				debug.setconstant(bedwars.WindWalkerController.updateSpeed, 7, callback and 'constantSpeedMultiplier' or 'moveSpeedMultiplier')
			end)
	
			if callback then
				Speed:Clean(runService.PreSimulation:Connect(function(dt)
					bedwars.StatefulEntityKnockbackController.lastImpulseTime = callback and math.huge or time()
					if entitylib.isAlive and not Fly.Enabled and not InfiniteFly.Enabled and not LongJump.Enabled and isnetworkowner(entitylib.character.RootPart) then
						local state = entitylib.character.Humanoid:GetState()
						if state == Enum.HumanoidStateType.Climbing then return end
	
						local root, velo = entitylib.character.RootPart, getSpeed()
						local moveDirection = AntiFallDirection or entitylib.character.Humanoid.MoveDirection
						local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)
	
						if WallCheck.Enabled then
							rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
							rayCheck.CollisionGroup = root.CollisionGroup
							local ray = workspace:Raycast(root.Position, destination, rayCheck)
							if ray then
								destination = ((ray.Position + ray.Normal) - root.Position)
							end
						end
	
						root.CFrame += destination
						root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
						if AutoJump.Enabled and (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed) and moveDirection ~= Vector3.zero and (Attacking or AlwaysJump.Enabled) then
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end))
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Increases your movement with various methods.'
	})
	Value = Speed:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 23,
		Default = 23,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	WallCheck = Speed:CreateToggle({
		Name = 'Wall Check',
		Default = true
	})
	AutoJump = Speed:CreateToggle({
		Name = 'AutoJump',
		Function = function(callback)
			AlwaysJump.Object.Visible = callback
		end
	})
	AlwaysJump = Speed:CreateToggle({
		Name = 'Always Jump',
		Visible = false,
		Darker = true
	})
end)
	
run(function()
	local BedESP
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function Added(bed)
		if not BedESP.Enabled then return end
		local BedFolder = Instance.new('Folder')
		BedFolder.Parent = Folder
		Reference[bed] = BedFolder
		local parts = bed:GetChildren()
		table.sort(parts, function(a, b)
			return a.Name > b.Name
		end)
	
		for _, part in parts do
			if part:IsA('BasePart') and part.Name ~= 'Blanket' then
				local handle = Instance.new('BoxHandleAdornment')
				handle.Size = part.Size + Vector3.new(.01, .01, .01)
				handle.AlwaysOnTop = true
				handle.ZIndex = 2
				handle.Visible = true
				handle.Adornee = part
				handle.Color3 = part.Color
				if part.Name == 'Legs' then
					handle.Color3 = Color3.fromRGB(167, 112, 64)
					handle.Size = part.Size + Vector3.new(.01, -1, .01)
					handle.CFrame = CFrame.new(0, -0.4, 0)
					handle.ZIndex = 0
				end
				handle.Parent = BedFolder
			end
		end
	
		table.clear(parts)
	end
	
	BedESP = vape.Categories.Render:CreateModule({
		Name = 'BedESP',
		Function = function(callback)
			if callback then
				BedESP:Clean(collectionService:GetInstanceAddedSignal('bed'):Connect(function(bed)
					task.delay(0.2, Added, bed)
				end))
				BedESP:Clean(collectionService:GetInstanceRemovedSignal('bed'):Connect(function(bed)
					if Reference[bed] then
						Reference[bed]:Destroy()
						Reference[bed] = nil
					end
				end))
				for _, bed in collectionService:GetTagged('bed') do
					Added(bed)
				end
			else
				Folder:ClearAllChildren()
				table.clear(Reference)
			end
		end,
		Tooltip = 'Render Beds through walls'
	})
end)
	
run(function()
	local Health
	
	Health = vape.Categories.Render:CreateModule({
		Name = 'Health',
		Function = function(callback)
			if callback then
				local label = Instance.new('TextLabel')
				label.Size = UDim2.fromOffset(100, 20)
				label.Position = UDim2.new(0.5, 6, 0.5, 30)
				label.BackgroundTransparency = 1
				label.AnchorPoint = Vector2.new(0.5, 0)
				label.Text = entitylib.isAlive and math.round(lplr.Character:GetAttribute('Health'))..' ❤️' or ''
				label.TextColor3 = entitylib.isAlive and Color3.fromHSV((lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) / 2.8, 0.86, 1) or Color3.new()
				label.TextSize = 18
				label.Font = Enum.Font.Arial
				label.Parent = vape.gui
				Health:Clean(label)
				Health:Clean(vapeEvents.AttributeChanged.Event:Connect(function()
					label.Text = entitylib.isAlive and math.round(lplr.Character:GetAttribute('Health'))..' ❤️' or ''
					label.TextColor3 = entitylib.isAlive and Color3.fromHSV((lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) / 2.8, 0.86, 1) or Color3.new()
				end))
			end
		end,
		Tooltip = 'Displays your health in the center of your screen.'
	})
end)
	
run(function()
	local KitESP
	local Background
	local Color = {}
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local ESPKits = {
		alchemist = {'alchemist_ingedients', 'wild_flower'},
		beekeeper = {'bee', 'bee'},
		bigman = {'treeOrb', 'natures_essence_1'},
		ghost_catcher = {'ghost', 'ghost_orb'},
		metal_detector = {'hidden-metal', 'iron'},
		sheep_herder = {'SheepModel', 'purple_hay_bale'},
		sorcerer = {'alchemy_crystal', 'wild_flower'},
		star_collector = {'stars', 'crit_star'}
	}
	
	local function Added(v, icon)
		local billboard = Instance.new('BillboardGui')
		billboard.Parent = Folder
		billboard.Name = icon
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.AlwaysOnTop = true
		billboard.ClipsDescendants = false
		billboard.Adornee = v
		local blur = addBlur(billboard)
		blur.Visible = Background.Enabled
		local image = Instance.new('ImageLabel')
		image.Size = UDim2.fromOffset(36, 36)
		image.Position = UDim2.fromScale(0.5, 0.5)
		image.AnchorPoint = Vector2.new(0.5, 0.5)
		image.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		image.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
		image.BorderSizePixel = 0
		image.Image = bedwars.getIcon({itemType = icon}, true)
		image.Parent = billboard
		local uicorner = Instance.new('UICorner')
		uicorner.CornerRadius = UDim.new(0, 4)
		uicorner.Parent = image
		Reference[v] = billboard
	end
	
	local function addKit(tag, icon)
		KitESP:Clean(collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			Added(v.PrimaryPart, icon)
		end))
		KitESP:Clean(collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if Reference[v.PrimaryPart] then
				Reference[v.PrimaryPart]:Destroy()
				Reference[v.PrimaryPart] = nil
			end
		end))
		for _, v in collectionService:GetTagged(tag) do
			Added(v.PrimaryPart, icon)
		end
	end
	
	KitESP = vape.Categories.Render:CreateModule({
		Name = 'KitESP',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.equippedKit ~= '' or (not KitESP.Enabled)
				local kit = KitESP.Enabled and ESPKits[store.equippedKit] or nil
				if kit then
					addKit(kit[1], kit[2])
				end
			else
				Folder:ClearAllChildren()
				table.clear(Reference)
			end
		end,
		Tooltip = 'ESP for certain kit related objects'
	})
	Background = KitESP:CreateToggle({
		Name = 'Background',
		Function = function(callback)
			if Color.Object then Color.Object.Visible = callback end
			for _, v in Reference do
				v.ImageLabel.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
				v.Blur.Visible = callback
			end
		end,
		Default = true
	})
	Color = KitESP:CreateColorSlider({
		Name = 'Background Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			for _, v in Reference do
				v.ImageLabel.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.ImageLabel.BackgroundTransparency = 1 - opacity
			end
		end,
		Darker = true
	})
end)
	
run(function()
    -- =========================================================
    -- [1] 設定・定数定義
    -- =========================================================
    local RESOURCE_CONFIG = {
        { name = "Iron",    key = "iron",    color = Color3.fromRGB(200, 200, 200) },
        { name = "Gold",    key = "gold",    color = Color3.fromRGB(255, 215, 0)   },
        { name = "Diamond", key = "diamond", color = Color3.fromRGB(85, 200, 255)  },
        { name = "Emerald", key = "emerald", color = Color3.fromRGB(0, 255, 100)   }
    }

    local EQUIPMENT_SLOTS = {'Hand', 'Helmet', 'Chestplate', 'Boots', 'Kit'}
    local Strings, Sizes, Reference = {}, {}, {}
    local Folder = Instance.new('Folder')
    Folder.Parent = vape.gui
    local methodused

    -- =========================================================
    -- [2] リソース集計ロジック (ShowThemResource参考)
    -- =========================================================
    local function countPlayerResources(plr)
        local counts = { Iron = 0, Gold = 0, Diamond = 0, Emerald = 0 }
        if not plr then return counts end

        -- インベントリ参照
        local invFolder = replicatedStorage:FindFirstChild("Inventories")
        if invFolder then
            local plrFolder = invFolder:FindFirstChild(plr.Name)
            if plrFolder then
                for _, item in plrFolder:GetChildren() do
                    local lowerName = item.Name:lower()
                    local amount = item:GetAttribute("Amount") or 1
                    for _, res in RESOURCE_CONFIG do
                        if lowerName == res.key or lowerName:find(res.key, 1, true) then
                            counts[res.name] += amount
                            break
                        end
                    end
                end
            end
        end

        -- チェスト参照
        for _, chest in collectionService:GetTagged("chest") do
            if chest:GetAttribute("PlacedByUserId") == plr.UserId then
                local chestVal = chest:FindFirstChild("ChestFolderValue")
                local chestFolder = chestVal and chestVal.Value
                if chestFolder and chestFolder:IsA("Folder") then
                    for _, item in chestFolder:GetChildren() do
                        local lowerName = item.Name:lower()
                        local amount = item:GetAttribute("Amount") or 1
                        for _, res in RESOURCE_CONFIG do
                            if lowerName == res.key or lowerName:find(res.key, 1, true) then
                                counts[res.name] += amount
                                break
                            end
                        end
                    end
                end
            end
        end
        return counts
    end

    -- =========================================================
    -- [3] Normalモード用: リソースアイコンUI管理
    -- =========================================================
    local function removeResourceIcons(nametag)
        for _, child in nametag:GetChildren() do
            if child.Name:match("^ResIcon_") or child.Name:match("^ResText_") then
                child:Destroy()
            end
        end
    end

    local function updateResourceIcons(ent, nametag, baseWidth)
        if not DisplayResource or not DisplayResource.Enabled or not ent.Player then
            removeResourceIcons(nametag)
            return
        end

        local counts = countPlayerResources(ent.Player)
        local offsetX = baseWidth + 6
        local hasResource = false

        for _, res in RESOURCE_CONFIG do
            local count = counts[res.name]
            if count > 0 then
                hasResource = true
                local iconId = "ResIcon_" .. res.name
                local textId = "ResText_" .. res.name

                local icon = nametag:FindFirstChild(iconId)
                local text = nametag:FindFirstChild(textId)

                if not icon then
                    icon = Instance.new("ImageLabel")
                    icon.Name = iconId
                    icon.Size = UDim2.fromOffset(16, 16)
                    icon.BackgroundTransparency = 1
                    icon.Image = bedwars.getIcon and bedwars.getIcon({ itemType = res.key }, true) or ""
                    icon.Parent = nametag
                end
                if not text then
                    text = Instance.new("TextLabel")
                    text.Name = textId
                    text.Size = UDim2.fromOffset(30, 16)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = res.color
                    text.TextSize = 12
                    text.Font = Enum.Font.GothamBold
                    text.TextXAlignment = Enum.TextXAlignment.Left
                    text.TextStrokeTransparency = 0.5
                    text.Parent = nametag
                end

                icon.Position = UDim2.fromOffset(offsetX, 2)
                text.Position = UDim2.fromOffset(offsetX + 18, 2)
                text.Text = tostring(count)
                offsetX += 46
            else
                local icon = nametag:FindFirstChild("ResIcon_" .. res.name)
                local text = nametag:FindFirstChild("ResText_" .. res.name)
                if icon then icon:Destroy() end
                if text then text:Destroy() end
            end
        end

        if not hasResource then removeResourceIcons(nametag) end
    end

    -- =========================================================
    -- [4] Drawingモード用: リソーステキスト生成
    -- =========================================================
    local function getResourceDrawingText(ent)
        if not DisplayResource or not DisplayResource.Enabled or not ent.Player then return "" end
        local counts = countPlayerResources(ent.Player)
        local parts = {}
        for _, res in RESOURCE_CONFIG do
            if counts[res.name] > 0 then
                table.insert(parts, string.format("%s:%d", res.key:sub(1, 2):upper(), counts[res.name]))
            end
        end
        return #parts > 0 and " [" .. table.concat(parts, " ") .. "]" or ""
    end

    -- =========================================================
    -- [5] 既存機能ヘルパー (Kit / Enchant / Equipment)
    -- =========================================================
    local function getKitMeta(player)
        local kit = player:GetAttribute('PlayingAsKits') or player:GetAttribute('PlayingAsKit') or 'none'
        return bedwars.BedwarsKitMeta[kit] or bedwars.BedwarsKitMeta.none, kit
    end

    local function getEnchantImages(player)
        local images = {}
        local ok, hud = pcall(function()
            return player.PlayerGui:WaitForChild('StatusEffectHudScreen', 0.1):WaitForChild('StatusEffectHud', 0.1)
        end)
        if not ok or not hud then return images end
        for _, child in hud:GetChildren() do
            if child:IsA('ImageLabel') and child.Image ~= '' then
                table.insert(images, child.Image)
            end
        end
        return images
    end

    local function updateKitIcon(ent, nametag)
        if not KitDisplay.Enabled or not ent.Player then return end
        local kitMeta = getKitMeta(ent.Player)
        local icon = nametag:FindFirstChild('KitDisplayIcon') or Instance.new('ImageLabel')
        icon.Name = 'KitDisplayIcon'
        icon.Size = UDim2.fromOffset(24, 24)
        icon.Position = UDim2.new(1, 4, 0, -4)
        icon.BackgroundTransparency = 1
        icon.Image = (kitMeta and kitMeta.renderImage) or kitImageIds['none'] or ''
        icon.Parent = nametag
    end

    local function removeKitIcon(nametag)
        local icon = nametag:FindFirstChild('KitDisplayIcon')
        if icon then icon:Destroy() end
    end

    local function getKitText(ent)
        if not KitDisplay.Enabled or not ent.Player then return '' end
        local _, kit = getKitMeta(ent.Player)
        if not kit or kit == 'none' or kit == '' then return '' end
        return ' <' .. kit:gsub('_', ' ') .. '>'
    end

    local function updateEnchantIcons(ent, nametag)
        if not EnchantDisplay.Enabled or not ent.Player then return end
        for _, child in nametag:GetChildren() do
            if child.Name:sub(1, 12) == 'EnchantIcon_' then child:Destroy() end
        end
        local images = getEnchantImages(ent.Player)
        for i, img in images do
            local icon = Instance.new('ImageLabel')
            icon.Name = 'EnchantIcon_' .. i
            icon.Size = UDim2.fromOffset(20, 20)
            icon.Position = UDim2.fromOffset((i - 1) * 22, nametag.AbsoluteSize.Y + 2)
            icon.BackgroundTransparency = 1
            icon.Image = img
            icon.Parent = nametag
        end
    end

    local function removeEnchantIcons(nametag)
        for _, child in nametag:GetChildren() do
            if child.Name:sub(1, 12) == 'EnchantIcon_' then child:Destroy() end
        end
    end

    local function getEnchantText(ent)
        if not EnchantDisplay.Enabled or not ent.Player then return '' end
        local count = #getEnchantImages(ent.Player)
        return count > 0 and ' [E:' .. count .. ']' or ''
    end

    local function updateEquipmentIcons(ent, nametag)
        if not Equipment.Enabled or not ent.Player then return end
        local _, kit = getKitMeta(ent.Player)
        local inventory = store.inventories[ent.Player]
        if not inventory then return end
        nametag.Hand.Image = bedwars.getIcon(inventory.hand or {itemType = ''}, true)
        nametag.Helmet.Image = bedwars.getIcon(inventory.armor[4] or {itemType = ''}, true)
        nametag.Chestplate.Image = bedwars.getIcon(inventory.armor[5] or {itemType = ''}, true)
        nametag.Boots.Image = bedwars.getIcon(inventory.armor[6] or {itemType = ''}, true)
        nametag.Kit.Image = kit and kit ~= 'none' and bedwars.BedwarsKitMeta[kit] and bedwars.BedwarsKitMeta[kit].renderImage or ''
    end

    local function getEquipmentText(ent)
        if not Equipment.Enabled or not ent.Player then return '' end
        local inventory = store.inventories[ent.Player]
        if not inventory then return '' end
        local _, kit = getKitMeta(ent.Player)
        local parts = {}
        if inventory.hand and inventory.hand.itemType ~= '' then table.insert(parts, inventory.hand.itemType) end
        if kit and kit ~= 'none' then table.insert(parts, kit) end
        return #parts > 0 and (' [' .. table.concat(parts, '|') .. ']') or ''
    end

    -- =========================================================
    -- [6] NameTags コアロジック (Added / Removed / Updated / Loop)
    -- =========================================================
    local Added = {
        Normal = function(ent)
            if not Targets.Players.Enabled and ent.Player then return end
            if not Targets.NPCs.Enabled and ent.NPC then return end
            if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end

            local nametag = Instance.new('TextLabel')
            Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true) .. (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name

            if Health.Enabled then
                local hColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
                Strings[ent] = Strings[ent] .. ' <font color="rgb(' .. math.floor(hColor.R*255) .. ',' .. math.floor(hColor.G*255) .. ',' .. math.floor(hColor.B*255) .. ')">' .. math.round(ent.Health) .. '</font>'
            end
            if Distance.Enabled then
                Strings[ent] = '<font color="rgb(85,255,85)">[</font><font color="rgb(255,255,255)">%s</font><font color="rgb(85,255,85)">]</font> ' .. Strings[ent]
            end

            if Equipment.Enabled and ent.Player then
                for i, slot in EQUIPMENT_SLOTS do
                    local icon = Instance.new('ImageLabel')
                    icon.Name = slot
                    icon.Size = UDim2.fromOffset(30, 30)
                    icon.Position = UDim2.fromOffset(-60 + (i * 30), -30)
                    icon.BackgroundTransparency = 1
                    icon.Image = ''
                    icon.Parent = nametag
                end
                updateEquipmentIcons(ent, nametag)
            end

            nametag.TextSize = 14 * Scale.Value
            nametag.FontFace = FontOption.Value
            local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
            nametag.Name = ent.Player and ent.Player.Name or ent.Character.Name
            nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
            nametag.AnchorPoint = Vector2.new(0.5, 1)
            nametag.BackgroundColor3 = Color3.new()
            nametag.BackgroundTransparency = Background.Value
            nametag.BorderSizePixel = 0
            nametag.Visible = false
            nametag.Text = Strings[ent]
            nametag.TextColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
            nametag.RichText = true
            nametag.Parent = Folder
            Reference[ent] = nametag

            if KitDisplay.Enabled and ent.Player then updateKitIcon(ent, nametag) end
            if EnchantDisplay.Enabled and ent.Player then updateEnchantIcons(ent, nametag) end
            updateResourceIcons(ent, nametag, size.X + 8)
        end,

        Drawing = function(ent)
            if not Targets.Players.Enabled and ent.Player then return end
            if not Targets.NPCs.Enabled and ent.NPC then return end
            if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end

            local nametag = {}
            nametag.BG = Drawing.new('Square')
            nametag.BG.Filled = true
            nametag.BG.Transparency = 1 - Background.Value
            nametag.BG.Color = Color3.new()
            nametag.BG.ZIndex = 1

            nametag.Text = Drawing.new('Text')
            nametag.Text.Size = 15 * Scale.Value
            nametag.Text.Font = 0
            nametag.Text.ZIndex = 2

            Strings[ent] = ent.Player and whitelist:tag(ent.Player, true) .. (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
            if Health.Enabled then Strings[ent] = Strings[ent] .. ' ' .. math.round(ent.Health) end
            if Equipment.Enabled then Strings[ent] = Strings[ent] .. getEquipmentText(ent) end
            if KitDisplay.Enabled then Strings[ent] = Strings[ent] .. getKitText(ent) end
            if EnchantDisplay.Enabled then Strings[ent] = Strings[ent] .. getEnchantText(ent) end
            Strings[ent] = Strings[ent] .. getResourceDrawingText(ent)

            if Distance.Enabled then
                Strings[ent] = '[%s] ' .. Strings[ent]
                nametag.Text.Text = entitylib.isAlive and string.format(Strings[ent], math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude)) or string.format(Strings[ent], 0)
            else
                nametag.Text.Text = Strings[ent]
            end

            nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
            nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
            Reference[ent] = nametag
        end
    }

    local Removed = {
        Normal = function(ent)
            local v = Reference[ent]
            if v then Reference[ent], Strings[ent], Sizes[ent] = nil, nil, nil; v:Destroy() end
        end,
        Drawing = function(ent)
            local v = Reference[ent]
            if v then
                Reference[ent], Strings[ent], Sizes[ent] = nil, nil, nil
                for _, obj in v do pcall(function() obj.Visible = false; obj:Remove() end) end
            end
        end
    }

    local Updated = {
        Normal = function(ent)
            local nametag = Reference[ent]
            if not nametag then return end
            Sizes[ent] = nil

            Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true) .. (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
            if Health.Enabled then
                local hColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
                Strings[ent] = Strings[ent] .. ' <font color="rgb(' .. math.floor(hColor.R*255) .. ',' .. math.floor(hColor.G*255) .. ',' .. math.floor(hColor.B*255) .. ')">' .. math.round(ent.Health) .. '</font>'
            end
            if Distance.Enabled then
                Strings[ent] = '<font color="rgb(85,255,85)">[</font><font color="rgb(255,255,255)">%s</font><font color="rgb(85,255,85)">]</font> ' .. Strings[ent]
            end

            if Equipment.Enabled and ent.Player then
                if not nametag:FindFirstChild('Hand') then
                    for i, slot in EQUIPMENT_SLOTS do
                        local icon = Instance.new('ImageLabel')
                        icon.Name = slot; icon.Size = UDim2.fromOffset(30, 30)
                        icon.Position = UDim2.fromOffset(-60 + (i * 30), -30)
                        icon.BackgroundTransparency = 1; icon.Image = ''; icon.Parent = nametag
                    end
                end
                updateEquipmentIcons(ent, nametag)
            elseif not Equipment.Enabled and ent.Player then
                for _, slot in EQUIPMENT_SLOTS do local ic = nametag:FindFirstChild(slot); if ic then ic:Destroy() end end
            end

            if KitDisplay.Enabled and ent.Player then updateKitIcon(ent, nametag) else removeKitIcon(nametag) end
            if EnchantDisplay.Enabled and ent.Player then updateEnchantIcons(ent, nametag) else removeEnchantIcons(nametag) end

            local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
            nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
            nametag.Text = Strings[ent]
            updateResourceIcons(ent, nametag, size.X + 8)
        end,

        Drawing = function(ent)
            local nametag = Reference[ent]
            if not nametag then return end
            if vape.ThreadFix then setthreadidentity(8) end
            Sizes[ent] = nil

            Strings[ent] = ent.Player and whitelist:tag(ent.Player, true) .. (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
            if Health.Enabled then Strings[ent] = Strings[ent] .. ' ' .. math.round(ent.Health) end
            if Equipment.Enabled then Strings[ent] = Strings[ent] .. getEquipmentText(ent) end
            if KitDisplay.Enabled then Strings[ent] = Strings[ent] .. getKitText(ent) end
            if EnchantDisplay.Enabled then Strings[ent] = Strings[ent] .. getEnchantText(ent) end
            Strings[ent] = Strings[ent] .. getResourceDrawingText(ent)

            if Distance.Enabled then
                Strings[ent] = '[%s] ' .. Strings[ent]
                nametag.Text.Text = entitylib.isAlive and string.format(Strings[ent], math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude)) or string.format(Strings[ent], 0)
            else
                nametag.Text.Text = Strings[ent]
            end
            nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
            nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
        end
    }

    local ColorFunc = {
        Normal = function(h, s, v) local c = Color3.fromHSV(h, s, v); for i, v in Reference do v.TextColor3 = entitylib.getEntityColor(i) or c end end,
        Drawing = function(h, s, v) local c = Color3.fromHSV(h, s, v); for i, v in Reference do v.Text.Color = entitylib.getEntityColor(i) or c end end
    }

    local Loop = {
        Normal = function()
            for ent, nametag in Reference do
                if DistanceCheck.Enabled then
                    local dist = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
                    if dist < DistanceLimit.ValueMin or dist > DistanceLimit.ValueMax then nametag.Visible = false; continue end
                end

                -- リソース定期更新 (1秒間隔)
                if DisplayResource.Enabled and ent.Player then
                    local now = tick()
                    if not ent.LastResUpdate or now - ent.LastResUpdate > 1 then
                        ent.LastResUpdate = now
                        local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
                        updateResourceIcons(ent, nametag, size.X + 8)
                    end
                end

                local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
                nametag.Visible = headVis
                if not headVis then continue end

                if Distance.Enabled then
                    local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
                    if Sizes[ent] ~= mag then
                        nametag.Text = string.format(Strings[ent], mag)
                        local ize = getfontsize(removeTags(nametag.Text), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
                        nametag.Size = UDim2.fromOffset(ize.X + 8, ize.Y + 7)
                        Sizes[ent] = mag
                    end
                end
                nametag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
            end
        end,

        Drawing = function()
            for ent, nametag in Reference do
                if DistanceCheck.Enabled then
                    local dist = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
                    if dist < DistanceLimit.ValueMin or dist > DistanceLimit.ValueMax then nametag.Text.Visible = false; nametag.BG.Visible = false; continue end
                end

                if DisplayResource.Enabled and ent.Player then
                    local now = tick()
                    if not ent.LastResUpdate or now - ent.LastResUpdate > 1 then
                        ent.LastResUpdate = now
                        Updated.Drawing(ent)
                    end
                end

                local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
                nametag.Text.Visible = headVis; nametag.BG.Visible = headVis
                if not headVis then continue end

                if Distance.Enabled then
                    local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
                    if Sizes[ent] ~= mag then
                        nametag.Text.Text = string.format(Strings[ent], mag)
                        nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
                        Sizes[ent] = mag
                    end
                end
                nametag.BG.Position = Vector2.new(headPos.X - (nametag.BG.Size.X / 2), headPos.Y - nametag.BG.Size.Y)
                nametag.Text.Position = nametag.BG.Position + Vector2.new(4, 3)
            end
        end
    }

    -- =========================================================
    -- [7] モジュール定義 & UIトグル
    -- =========================================================
    NameTags = vape.Categories.Render:CreateModule({
        Name = 'NameTags',
        Function = function(callback)
            if callback then
                methodused = DrawingToggle.Enabled and 'Drawing' or 'Normal'
                if Removed[methodused] then NameTags:Clean(entitylib.Events.EntityRemoved:Connect(Removed[methodused])) end
                if Added[methodused] then
                    for _, v in entitylib.List do if Reference[v] then Removed[methodused](v) end; Added[methodused](v) end
                    NameTags:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
                        if Reference[ent] then Removed[methodused](ent) end; Added[methodused](ent)
                    end))
                end
                if Updated[methodused] then
                    NameTags:Clean(entitylib.Events.EntityUpdated:Connect(Updated[methodused]))
                    for _, v in entitylib.List do Updated[methodused](v) end
                end
                if ColorFunc[methodused] then NameTags:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function() ColorFunc[methodused](Color.Hue, Color.Sat, Color.Value) end)) end
                if Loop[methodused] then NameTags:Clean(runService.RenderStepped:Connect(Loop[methodused])) end
            else
                if Removed[methodused] then for i in Reference do Removed[methodused](i) end end
            end
        end,
        Tooltip = 'Renders nametags on entities through walls.'
    })

    Targets = NameTags:CreateTargets({ Players = true, Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    FontOption = NameTags:CreateFont({ Name = 'Font', Blacklist = 'Arial', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    Color = NameTags:CreateColorSlider({ Name = 'Player Color', Function = function(h, s, v) if NameTags.Enabled and ColorFunc[methodused] then ColorFunc[methodused](h, s, v) end end })
    Scale = NameTags:CreateSlider({ Name = 'Scale', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end, Default = 1, Min = 0.1, Max = 1.5, Decimal = 10 })
    Background = NameTags:CreateSlider({ Name = 'Transparency', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end, Default = 0.5, Min = 0, Max = 1, Decimal = 10 })
    Health = NameTags:CreateToggle({ Name = 'Health', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    Distance = NameTags:CreateToggle({ Name = 'Distance', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    Equipment = NameTags:CreateToggle({ Name = 'Equipment', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    KitDisplay = NameTags:CreateToggle({ Name = 'Kit Display', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    EnchantDisplay = NameTags:CreateToggle({ Name = 'Enchant Display', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    
    DisplayResource = NameTags:CreateToggle({
        Name = 'Display Resource',
        Tooltip = 'Shows Iron, Gold, Diamond, Emerald with icons next to names',
        Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end
    })

    DisplayName = NameTags:CreateToggle({ Name = 'Use Displayname', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end, Default = true })
    Teammates = NameTags:CreateToggle({ Name = 'Priority Only', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end, Default = true })
    DrawingToggle = NameTags:CreateToggle({ Name = 'Drawing', Function = function() if NameTags.Enabled then NameTags:Toggle(); NameTags:Toggle() end end })
    DistanceCheck = NameTags:CreateToggle({ Name = 'Distance Check', Function = function(cb) DistanceLimit.Object.Visible = cb end })
    DistanceLimit = NameTags:CreateTwoSlider({ Name = 'Player Distance', Min = 0, Max = 256, DefaultMin = 0, DefaultMax = 64, Darker = true, Visible = false })
end)
	
run(function()
	local StorageESP
	local List
	local Background
	local Color = {}
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function nearStorageItem(item)
		for _, v in List.ListEnabled do
			if item:find(v) then return v end
		end
	end
	
	local function refreshAdornee(v)
		local chest = v.Adornee:FindFirstChild('ChestFolderValue')
		chest = chest and chest.Value or nil
		if not chest then
			v.Enabled = false
			return
		end
	
		local chestitems = chest and chest:GetChildren() or {}
		for _, obj in v.Frame:GetChildren() do
			if obj:IsA('ImageLabel') and obj.Name ~= 'Blur' then
				obj:Destroy()
			end
		end
	
		v.Enabled = false
		local alreadygot = {}
		for _, item in chestitems do
			if not alreadygot[item.Name] and (table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name)) then
				alreadygot[item.Name] = true
				v.Enabled = true
				local blockimage = Instance.new('ImageLabel')
				blockimage.Size = UDim2.fromOffset(32, 32)
				blockimage.BackgroundTransparency = 1
				blockimage.Image = bedwars.getIcon({itemType = item.Name}, true)
				blockimage.Parent = v.Frame
			end
		end
		table.clear(chestitems)
	end
	
	local function Added(v)
		local chest = v:WaitForChild('ChestFolderValue', 3)
		if not (chest and StorageESP.Enabled) then return end
		chest = chest.Value
		local billboard = Instance.new('BillboardGui')
		billboard.Parent = Folder
		billboard.Name = 'chest'
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.AlwaysOnTop = true
		billboard.ClipsDescendants = false
		billboard.Adornee = v
		local blur = addBlur(billboard)
		blur.Visible = Background.Enabled
		local frame = Instance.new('Frame')
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		frame.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
		frame.Parent = billboard
		local layout = Instance.new('UIListLayout')
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 4)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			billboard.Size = UDim2.fromOffset(math.max(layout.AbsoluteContentSize.X + 4, 36), 36)
		end)
		layout.Parent = frame
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		Reference[v] = billboard
		StorageESP:Clean(chest.ChildAdded:Connect(function(item)
			if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
				refreshAdornee(billboard)
			end
		end))
		StorageESP:Clean(chest.ChildRemoved:Connect(function(item)
			if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
				refreshAdornee(billboard)
			end
		end))
		task.spawn(refreshAdornee, billboard)
	end
	
	StorageESP = vape.Categories.Render:CreateModule({
		Name = 'StorageESP',
		Function = function(callback)
			if callback then
				StorageESP:Clean(collectionService:GetInstanceAddedSignal('chest'):Connect(Added))
				for _, v in collectionService:GetTagged('chest') do
					task.spawn(Added, v)
				end
			else
				table.clear(Reference)
				Folder:ClearAllChildren()
			end
		end,
		Tooltip = 'Displays items in chests'
	})
	List = StorageESP:CreateTextList({
		Name = 'Item',
		Function = function()
			for _, v in Reference do
				task.spawn(refreshAdornee, v)
			end
		end
	})
	Background = StorageESP:CreateToggle({
		Name = 'Background',
		Function = function(callback)
			if Color.Object then Color.Object.Visible = callback end
			for _, v in Reference do
				v.Frame.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
				v.Blur.Visible = callback
			end
		end,
		Default = true
	})
	Color = StorageESP:CreateColorSlider({
		Name = 'Background Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			for _, v in Reference do
				v.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.Frame.BackgroundTransparency = 1 - opacity
			end
		end,
		Darker = true
	})
end)
	
run(function()
	local AutoBalloon
	
	AutoBalloon = vape.Categories.Utility:CreateModule({
		Name = 'AutoBalloon',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.matchState ~= 0 or (not AutoBalloon.Enabled)
				if not AutoBalloon.Enabled then return end
	
				local lowestpoint = math.huge
				for _, v in store.blocks do
					local point = (v.Position.Y - (v.Size.Y / 2)) - 50
					if point < lowestpoint then 
						lowestpoint = point 
					end
				end
	
				repeat
					if entitylib.isAlive then
						if entitylib.character.RootPart.Position.Y < lowestpoint and (lplr.Character:GetAttribute('InflatedBalloons') or 0) < 3 then
							local balloon = getItem('balloon')
							if balloon then
								for _ = 1, 3 do 
									bedwars.BalloonController:inflateBalloon() 
								end
							end
							task.wait(0.1)
						end
					end
					task.wait(0.1)
				until not AutoBalloon.Enabled
			end
		end,
		Tooltip = 'Inflates when you fall into the void'
	})
end)
	
run(function()
	local AutoKit
	local Legit
	local Toggles = {}
	
	local function kitCollection(id, func, range, specific)
		local objs = type(id) == 'table' and id or collection(id, AutoKit)
		repeat
			if entitylib.isAlive then
				local localPosition = entitylib.character.RootPart.Position
				for _, v in objs do
					if not AutoKit.Enabled then break end
					local part = not v:IsA('Model') and v or v.PrimaryPart
					if part and (part.Position - localPosition).Magnitude <= (not Legit.Enabled and specific and math.huge or range) then
						func(v)
					end
				end
			end
			task.wait(0.1)
		until not AutoKit.Enabled
	end
	
	local AutoKitFunctions = {
		battery = function()
			repeat
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for i, v in bedwars.BatteryEffectsController.liveBatteries do
						if (v.position - localPosition).Magnitude <= 10 then
							local BatteryInfo = bedwars.BatteryEffectsController:getBatteryInfo(i)
							if not BatteryInfo or BatteryInfo.activateTime >= workspace:GetServerTimeNow() or BatteryInfo.consumeTime + 0.1 >= workspace:GetServerTimeNow() then continue end
							BatteryInfo.consumeTime = workspace:GetServerTimeNow()
							bedwars.Client:Get(remotes.ConsumeBattery):SendToServer({batteryId = i})
						end
					end
				end
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		beekeeper = function()
			kitCollection('bee', function(v)
				bedwars.Client:Get(remotes.BeePickup):SendToServer({beeId = v:GetAttribute('BeeId')})
			end, 18, false)
		end,
		bigman = function()
			kitCollection('treeOrb', function(v)
				if bedwars.Client:Get(remotes.ConsumeTreeOrb):CallServer({treeOrbSecret = v:GetAttribute('TreeOrbSecret')}) then
					v:Destroy()
				end
			end, 12, false)
		end,
		block_kicker = function()
			local old = bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition
			bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = function(...)
				local origin, dir = select(2, ...)
				local plr = entitylib.EntityMouse({
					Part = 'RootPart',
					Range = 1000,
					Origin = origin,
					Players = true,
					Wallcheck = true
				})
	
				if plr then
					local calc = prediction.SolveTrajectory(origin, 100, 20, plr.RootPart.Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil)
	
					if calc then
						for i, v in debug.getstack(2) do
							if v == dir then
								debug.setstack(2, i, CFrame.lookAt(origin, calc).LookVector)
							end
						end
					end
				end
	
				return old(...)
			end
	
			AutoKit:Clean(function()
				bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = old
			end)
		end,
		catrewrite = function()
			local old = bedwars.CatController.leap
			bedwars.CatController.leap = function(...)
				vapeEvents.CatPounce:Fire()
				return old(...)
			end
	
			AutoKit:Clean(function()
				bedwars.CatController.leap = old
			end)
		end,
		davey = function()
			local old = bedwars.CannonHandController.launchSelf
			bedwars.CannonHandController.launchSelf = function(...)
				local res = {old(...)}
				local _, block = ...
	
				if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
					task.spawn(bedwars.breakBlock, block, false, nil, true)
				end
	
				return unpack(res)
			end
	
			AutoKit:Clean(function()
				bedwars.CannonHandController.launchSelf = old
			end)
		end,
		dragon_slayer = function()
			kitCollection('KaliyahPunchInteraction', function(v)
				bedwars.DragonSlayerController:deleteEmblem(v)
				bedwars.DragonSlayerController:playPunchAnimation(Vector3.zero)
				bedwars.Client:Get(remotes.KaliyahPunch):SendToServer({
					target = v
				})
			end, 18, true)
		end,
		farmer_cletus = function()
			kitCollection('HarvestableCrop', function(v)
				if bedwars.Client:Get(remotes.HarvestCrop):CallServer({position = bedwars.BlockController:getBlockPosition(v.Position)}) then
					bedwars.GameAnimationUtil:playAnimation(lplr.Character, bedwars.AnimationType.PUNCH)
					bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
				end
			end, 10, false)
		end,
		fisherman = function()
			local old = bedwars.FishingMinigameController.startMinigame
			bedwars.FishingMinigameController.startMinigame = function(_, _, result)
				result({win = true})
			end
	
			AutoKit:Clean(function()
				bedwars.FishingMinigameController.startMinigame = old
			end)
		end,
		jailor = function()
			kitCollection('jailor_soul', function(v)
				bedwars.JailorController:collectEntity(lplr, v, 'JailorSoul')
			end, 20, false)
		end,
		grim_reaper = function()
			kitCollection(bedwars.GrimReaperController.soulsByPosition, function(v)
				if entitylib.isAlive and lplr.Character:GetAttribute('Health') <= (lplr.Character:GetAttribute('MaxHealth') / 4) and (not lplr.Character:GetAttribute('GrimReaperChannel')) then
					bedwars.Client:Get(remotes.ConsumeSoul):CallServer({
						secret = v:GetAttribute('GrimReaperSoulSecret')
					})
				end
			end, 120, false)
		end,
		melody = function()
			repeat
				local mag, hp, ent = 30, math.huge, nil
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for _, v in entitylib.List do
						if v.Player and v.Player:GetAttribute('Team') == lplr:GetAttribute('Team') then
							local newmag = (localPosition - v.RootPart.Position).Magnitude
							if newmag <= mag and v.Health < hp and v.Health < v.MaxHealth then
								mag, hp, ent = newmag, v.Health, v
							end
						end
					end
				end
	
				if ent and getItem('guitar') then
					bedwars.Client:Get(remotes.GuitarHeal):SendToServer({
						healTarget = ent.Character
					})
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		metal_detector = function()
			kitCollection('hidden-metal', function(v)
				bedwars.Client:Get(remotes.PickupMetal):SendToServer({
					id = v:GetAttribute('Id')
				})
			end, 20, false)
		end,
		miner = function()
			kitCollection('petrified-player', function(v)
				bedwars.Client:Get(remotes.MinerDig):SendToServer({
					petrifyId = v:GetAttribute('PetrifyId')
				})
			end, 6, true)
		end,
		pinata = function()
			kitCollection(lplr.Name..':pinata', function(v)
				if getItem('candy') then
					bedwars.Client:Get(remotes.DepositPinata):CallServer(v)
				end
			end, 6, true)
		end,
		spirit_assassin = function()
			kitCollection('EvelynnSoul', function(v)
				bedwars.SpiritAssassinController:useSpirit(lplr, v)
			end, 120, true)
		end,
		star_collector = function()
			kitCollection('stars', function(v)
				bedwars.StarCollectorController:collectEntity(lplr, v, v.Name)
			end, 20, false)
		end,
		summoner = function()
			repeat
				local plr = entitylib.EntityPosition({
					Range = 31,
					Part = 'RootPart',
					Players = true,
					Sort = sortmethods.Health
				})
	
				if plr and (not Legit.Enabled or (lplr.Character:GetAttribute('Health') or 0) > 0) then
					local localPosition = entitylib.character.RootPart.Position
					local shootDir = CFrame.lookAt(localPosition, plr.RootPart.Position).LookVector
					localPosition += shootDir * math.max((localPosition - plr.RootPart.Position).Magnitude - 16, 0)
	
					bedwars.Client:Get(remotes.SummonerClawAttack):SendToServer({
						position = localPosition,
						direction = shootDir,
						clientTime = workspace:GetServerTimeNow()
					})
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		void_dragon = function()
			local oldflap = bedwars.VoidDragonController.flapWings
			local flapped
	
			bedwars.VoidDragonController.flapWings = function(self)
				if not flapped and bedwars.Client:Get(remotes.DragonFly):CallServer() then
					local modifier = bedwars.SprintController:getMovementStatusModifier():addModifier({
						blockSprint = true,
						constantSpeedMultiplier = 2
					})
					self.SpeedMaid:GiveTask(modifier)
					self.SpeedMaid:GiveTask(function()
						flapped = false
					end)
					flapped = true
				end
			end
	
			AutoKit:Clean(function()
				bedwars.VoidDragonController.flapWings = oldflap
			end)
	
			repeat
				if bedwars.VoidDragonController.inDragonForm then
					local plr = entitylib.EntityPosition({
						Range = 30,
						Part = 'RootPart',
						Players = true
					})
	
					if plr then
						bedwars.Client:Get(remotes.DragonBreath):SendToServer({
							player = lplr,
							targetPoint = plr.RootPart.Position
						})
					end
				end
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		warlock = function()
			local lastTarget
			repeat
				if store.hand.tool and store.hand.tool.Name == 'warlock_staff' then
					local plr = entitylib.EntityPosition({
						Range = 30,
						Part = 'RootPart',
						Players = true,
						NPCs = true
					})
	
					if plr and plr.Character ~= lastTarget then
						if not bedwars.Client:Get(remotes.WarlockTarget):CallServer({
							target = plr.Character
						}) then
							plr = nil
						end
					end
	
					lastTarget = plr and plr.Character
				else
					lastTarget = nil
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		wizard = function()
			repeat
				local ability = lplr:GetAttribute('WizardAbility')
				if ability and bedwars.AbilityController:canUseAbility(ability) then
					local plr = entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true,
						Sort = sortmethods.Health
					})
	
					if plr then
						bedwars.AbilityController:useAbility(ability, newproxy(true), {target = plr.RootPart.Position})
					end
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end
	}
	
	AutoKit = vape.Categories.Utility:CreateModule({
		Name = 'Auto Kit',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.equippedKit ~= '' and store.matchState ~= 0 or (not AutoKit.Enabled)
				if AutoKit.Enabled and AutoKitFunctions[store.equippedKit] and Toggles[store.equippedKit].Enabled then
					AutoKitFunctions[store.equippedKit]()
				end
			end
		end,
		Tooltip = 'Automatically uses kit abilities.'
	})
	Legit = AutoKit:CreateToggle({Name = 'Legit Range'})
	local sortTable = {}
	for i in AutoKitFunctions do
		table.insert(sortTable, i)
	end
	pcall(function()
		table.sort(sortTable, function(a, b)
			return bedwars.BedwarsKitMeta[a].name < bedwars.BedwarsKitMeta[b].name
		end)
	end)
	for _, v in sortTable do
		pcall(function()
			Toggles[v] = AutoKit:CreateToggle({
				Name = bedwars.BedwarsKitMeta[v].name,
				Default = true
			})
		end)
	end
end) -- test
	
run(function()
	local AutoPearl
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local projectileRemote = {InvokeServer = function() end}
	task.spawn(function()
		projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
	end)
	
	local function firePearl(pos, spot, item)
		switchItem(item.tool)
		local meta = bedwars.ProjectileMeta.telepearl
		local calc = prediction.SolveTrajectory(pos, meta.launchVelocity, meta.gravitationalAcceleration, spot, Vector3.zero, workspace.Gravity, 0, 0)
	
		if calc then
			local dir = CFrame.lookAt(pos, calc).LookVector * meta.launchVelocity
			bedwars.ProjectileController:createLocalProjectile(meta, 'telepearl', 'telepearl', pos, nil, dir, {drawDurationSeconds = 1})
			projectileRemote:InvokeServer(item.tool, 'telepearl', 'telepearl', pos, pos, dir, httpService:GenerateGUID(true), {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
		end
	
		if store.hand then
			switchItem(store.hand.tool)
		end
	end
	
	AutoPearl = vape.Categories.Utility:CreateModule({
		Name = 'AutoPearl',
		Function = function(callback)
			if callback then
				local check
				repeat
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						local pearl = getItem('telepearl')
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera, AntiFallPart}
						rayCheck.CollisionGroup = root.CollisionGroup
	
						if pearl and root.Velocity.Y < -100 and not workspace:Raycast(root.Position, Vector3.new(0, -200, 0), rayCheck) then
							if not check then
								check = true
								local ground = getNearGround(20)
	
								if ground then
									firePearl(root.Position, ground, pearl)
								end
							end
						else
							check = false
						end
					end
					task.wait(0.1)
				until not AutoPearl.Enabled
			end
		end,
		Tooltip = 'Automatically throws a pearl onto nearby ground after\nfalling a certain distance.'
	})
end)
	
run(function()
	local AutoPlay
	local Random
	
	local function isEveryoneDead()
		return #bedwars.Store:getState().Party.members <= 0
	end
	
	local function joinQueue()
		if not bedwars.Store:getState().Game.customMatch and bedwars.Store:getState().Party.leader.userId == lplr.UserId and bedwars.Store:getState().Party.queueState == 0 then
			if Random.Enabled then
				local listofmodes = {}
				for i, v in bedwars.QueueMeta do
					if not v.disabled and not v.voiceChatOnly and not v.rankCategory then 
						table.insert(listofmodes, i) 
					end
				end
				bedwars.QueueController:joinQueue(listofmodes[math.random(1, #listofmodes)])
			else
				bedwars.QueueController:joinQueue(store.queueType)
			end
		end
	end
	
	AutoPlay = vape.Categories.Utility:CreateModule({
		Name = 'AutoPlay',
		Function = function(callback)
			if callback then
				AutoPlay:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill and deathTable.entityInstance == lplr.Character and isEveryoneDead() and store.matchState ~= 2 then
						joinQueue()
					end
				end))
				AutoPlay:Clean(vapeEvents.MatchEndEvent.Event:Connect(joinQueue))
			end
		end,
		Tooltip = 'Automatically queues after the match ends.'
	})
	Random = AutoPlay:CreateToggle({
		Name = 'Random',
		Tooltip = 'Chooses a random mode'
	})
end)
	
run(function()
    local AutoShoot
    local Targets
    local Check
    local Range
    local Projectiles
    local Delay
    local Next
    local Rate
    
    local function getAmmo(check)
    	for _, item in store.inventory.inventory.items do
    		if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
    			return item.itemType
    		end
    	end
    	return
    end
    
    local function getProjectiles()
    	local items = {}
    	for _, item in store.inventory.inventory.items do
    		local proj = bedwars.ItemMeta[item.itemType].projectileSource
    		local ammo = proj and getAmmo(proj)
    		if ammo and table.find(Projectiles.ListEnabled, ammo) then
    			table.insert(items, {
    				item,
    				ammo,
    				proj.projectileType(ammo),
    				proj,
    			})
    		end
    	end
    	return items
    end
    
    local FireRate = {}
    
    local function getAttackData()
    	local hand = store.hand
    	if not hand or not hand.tool then
    		return
    	end
    
    	local meta = bedwars.ItemMeta[hand.tool.Name]
    	if not meta or not meta.projectileSource then
    		return
    	end
    
    	if (FireRate[hand.tool.Name] or 0) > tick() then
    		return
    	end
    
    	local ammo = getAmmo(meta.projectileSource)
    	local frosty = hand.tool.Name:find('frost_staff')
    	if not ammo and not frosty then
    		return
    	end
    
    	if frosty then
    		ammo = hand.tool.Name:gsub('frost_staff', 'frosty_snowball')
    	end
    
    	local callback = canDebug and meta.projectileType or function(res)
    		return 'arrow'
    	end
    
    	return hand, meta, ammo, callback(ammo)
    end
    
    local function shootFunc(ignore)
    	if not inputService.MouseEnabled or ignore then
    		local proj, meta, ammo, projectile = getAttackData()
    
    		if proj then
    			local projmeta = bedwars.ProjectileMeta[ammo]
    			local projSpeed = projmeta.launchVelocity
    
    			local selfpos = entitylib.character.RootPart.Position
    			local calc = selfpos + gameCamera.CFrame.LookVector * 50
    			local ent = ignore and entitylib.EntityPosition({
                    Part = 'RootPart',
                    Range = 1000,
                    Players = true,
                    NPCs = true,
                    Wallcheck = true,
                }) or nil
    			if ent then
    				calc = prediction.SolveTrajectory(
    					selfpos,
    					projSpeed,
    					meta.gravitationalAcceleration or 196.2,
    					Vector3.new(ent.RootPart.Velocity.X, 0, ent.RootPart.Velocity.Z),
    					workspace.Gravity,
    					ent.HipHeight,
    					nil,
    					RaycastParams.new(),
    					nil,
    					lplr:GetNetworkPing()
    				)
    			end
    
    			local dir = CFrame.lookAt(selfpos, calc).LookVector
    			local shootPosition, id = (CFrame.new(selfpos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX,-bedwars.BowConstantsTable.RelY,-bedwars.BowConstantsTable.RelZ))).Position,
    				httpService:GenerateGUID(true)
    
    			--bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
    			bedwars.Client:Get(remotes.FireProjectile):CallServerAsync(proj.tool, ammo, projectile, shootPosition, selfpos, dir * projSpeed, id, {
                    drawDurationSeconds = 1,
                    shotId = httpService:GenerateGUID(false),
                }, workspace:GetServerTimeNow() - 0.045):andThen(function(res)
                    if res then
                        res.Parent = replicatedStorage
                    end
                end)
    			local shoot = meta.projectileSource.launchSound
    			shoot = shoot and shoot[math.random(1, #shoot)] or nil
    			if shoot then
    				bedwars.SoundManager:playSound(shoot)
    			end
    		end
    	else
    		mouse1click()
    	end
    end
    
    AutoShoot = vape.Categories.Utility:CreateModule({
    	Name = 'Auto Shoot',
    	Function = function(call)
    		if call then
    			local start = tick()
    			repeat
    				if store.hand.toolType == 'sword' then
    					if (tick() - bedwars.SwordController.lastSwing) < 0.29 and (not Check.Enabled or entitylib.EntityPosition({
    						Range = Range.Value,
                            Wallcheck = Targets.Walls.Enabled or nil,
                            Part = 'RootPart',
                            Players = Targets.Players.Enabled,
                            NPCs = Targets.NPCs.Enabled
    					})) then
    						if tick() > start then
    							for _, data in getProjectiles() do
    								if (FireRate[data[1].itemType] or 0) < tick() then
    									local hotbar, old = getHotbar(data[1].tool), store.hand.tool and getHotbar(store.hand.tool) or 0
    									if hotbar and old and hotbarSwitch(hotbar) then
    										local ignore = vape.Modules['Silent Aura'].Enabled or not inputService.MouseEnabled
    										task.wait(Delay.Value)
    										shootFunc()
    										if vape.Modules['Auto Clicker'].Enabled and not ignore then
    											task.delay(runService.PostSimulation:Wait(), mouse1press)
    										end
    										task.wait(Delay.Value)
    										FireRate[data[1].itemType] = tick() + (data[4].fireDelaySec + Rate:GetRandomValue())
    										hotbarSwitch(old)
    										task.wait(Next.Value)
    										if (tick() - bedwars.SwordController.lastSwing) > 0.29 then
    											break
    										end
    									end
    								end
    							end
    						end
    					else
    						start = tick() + 0.75
    					end
    				end
    				task.wait(0.1)
    			until not AutoShoot.Enabled
    		end
    	end,
        Tooltip = 'Automatically swaps to another projectile source while swinging ur sword'
    })
    
    Targets = AutoShoot:CreateTargets({Walls = true, Darker = true})
    Check = AutoShoot:CreateToggle({
    	Name = 'Target Check',
    	Default = true,
    	Function = function(callback)
    		Targets.Object.Visible = callback
    		pcall(function()
    			Range.Object.Visible = callback
    		end)
    	end
    })
    Range = AutoShoot:CreateSlider({
    	Name = 'Range',
    	Min = 1,
    	Max = 80,
    	Default = 65,
    	Darker = true,
    	Suffix = function(val)
    		return val <= 1 and 'stud' or 'studs'
    	end
    })
    Projectiles = AutoShoot:CreateTextList({
    	Name = 'Projectiles',
    	Default = {'arrow'},
    	Placeholder = 'projectile'
    })
    Rate = AutoShoot:CreateTwoSlider({
    	Name = 'Fire Rate',
    	Min = 0,
    	Max = 1,
    	DefaultMin = 0.05,
    	DefaultMax = 0.12,
    	Decimal = 100
    })
    Next = AutoShoot:CreateSlider({
    	Name = 'Change Delay',
    	Min = 0,
    	Max = 1,
    	Decimal = 100,
    	Suffix = 'seconds',
    	Default = 0.75
    })
    Delay = AutoShoot:CreateSlider({
    	Name = 'Delay',
    	Min = 0,
    	Max = 1,
    	Decimal = 100,
    	Suffix = 'seconds',
    	Default = 0.05
    })
end)
	
run(function()
	local AutoToxic
	local GG
	local Toggles, Lists, said, dead = {}, {}, {}
	
	local function sendMessage(name, obj, default)
		local tab = Lists[name].ListEnabled
		local custommsg = #tab > 0 and tab[math.random(1, #tab)] or default
		if not custommsg then return end
		if #tab > 1 and custommsg == said[name] then
			repeat 
				task.wait() 
				custommsg = tab[math.random(1, #tab)] 
			until custommsg ~= said[name]
		end
		said[name] = custommsg
	
		custommsg = custommsg and custommsg:gsub('<obj>', obj or '') or ''
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
		else
			replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, 'All')
		end
	end
	
	AutoToxic = vape.Categories.Utility:CreateModule({
		Name = 'AutoToxic',
		Function = function(callback)
			if callback then
				AutoToxic:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
					if Toggles.BedDestroyed.Enabled and bedTable.brokenBedTeam.id == lplr:GetAttribute('Team') then
						sendMessage('BedDestroyed', (bedTable.player.DisplayName or bedTable.player.Name), 'how dare you >:( | <obj>')
					elseif Toggles.Bed.Enabled and bedTable.player.UserId == lplr.UserId then
						local team = bedwars.QueueMeta[store.queueType].teams[tonumber(bedTable.brokenBedTeam.id)]
						sendMessage('Bed', team and team.displayName:lower() or 'white', 'nice bed lul | <obj>')
					end
				end))
				AutoToxic:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill then
						local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
						local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
						if not killed or not killer then return end
						if killed == lplr then
							if (not dead) and killer ~= lplr and Toggles.Death.Enabled then
								dead = true
								sendMessage('Death', (killer.DisplayName or killer.Name), 'my gaming chair subscription expired :( | <obj>')
							end
						elseif killer == lplr and Toggles.Kill.Enabled then
							sendMessage('Kill', (killed.DisplayName or killed.Name), 'vxp on top | <obj>')
						end
					end
				end))
				AutoToxic:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winstuff)
					if GG.Enabled then
						if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('gg')
						else
							replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('gg', 'All')
						end
					end
					
					local myTeam = bedwars.Store:getState().Game.myTeam
					if myTeam and myTeam.id == winstuff.winningTeamId or lplr.Neutral then
						if Toggles.Win.Enabled then 
							sendMessage('Win', nil, 'yall garbage') 
						end
					end
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	GG = AutoToxic:CreateToggle({
		Name = 'AutoGG',
		Default = true
	})
	for _, v in {'Kill', 'Death', 'Bed', 'BedDestroyed', 'Win'} do
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false
		})
	end
end)
	
run(function()
	local AutoVoidDrop
	local OwlCheck
	
	AutoVoidDrop = vape.Categories.Utility:CreateModule({
		Name = 'AutoVoidDrop',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.matchState ~= 0 or (not AutoVoidDrop.Enabled)
				if not AutoVoidDrop.Enabled then return end
	
				local lowestpoint = math.huge
				for _, v in store.blocks do
					local point = (v.Position.Y - (v.Size.Y / 2)) - 50
					if point < lowestpoint then
						lowestpoint = point
					end
				end
	
				repeat
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						if root.Position.Y < lowestpoint and (lplr.Character:GetAttribute('InflatedBalloons') or 0) <= 0 and not getItem('balloon') then
							if not OwlCheck.Enabled or not root:FindFirstChild('OwlLiftForce') then
								for _, item in {'iron', 'diamond', 'emerald', 'gold'} do
									item = getItem(item)
									if item then
										item = bedwars.Client:Get(remotes.DropItem):CallServer({
											item = item.tool,
											amount = item.amount
										})
	
										if item then
											item:SetAttribute('ClientDropTime', tick() + 100)
										end
									end
								end
							end
						end
					end
	
					task.wait(0.1)
				until not AutoVoidDrop.Enabled
			end
		end,
		Tooltip = 'Drops resources when you fall into the void'
	})
	OwlCheck = AutoVoidDrop:CreateToggle({
		Name = 'Owl check',
		Default = true,
		Tooltip = 'Refuses to drop items if being picked up by an owl'
	})
end)
	
run(function()
	local MissileTP
	
	MissileTP = vape.Categories.Utility:CreateModule({
		Name = 'MissileTP',
		Function = function(callback)
			if callback then
				MissileTP:Toggle()
				local plr = entitylib.EntityMouse({
					Range = 1000,
					Players = true,
					Part = 'RootPart'
				})
	
				if getItem('guided_missile') and plr then
					local projectile = bedwars.RuntimeLib.await(bedwars.GuidedProjectileController.fireGuidedProjectile:CallServerAsync('guided_missile'))
					if projectile then
						local projectilemodel = projectile.model
						if not projectilemodel.PrimaryPart then
							projectilemodel:GetPropertyChangedSignal('PrimaryPart'):Wait()
						end
	
						local bodyforce = Instance.new('BodyForce')
						bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
						bodyforce.Name = 'AntiGravity'
						bodyforce.Parent = projectilemodel.PrimaryPart
	
						repeat
							projectile.model:SetPrimaryPartCFrame(CFrame.lookAlong(plr.RootPart.CFrame.p, gameCamera.CFrame.LookVector))
							task.wait(0.1)
						until not projectile.model or not projectile.model.Parent
					else
						notif('MissileTP', 'Missile on cooldown.', 3)
					end
				end
			end
		end,
		Tooltip = 'Spawns and teleports a missile to a player\nnear your mouse.'
	})
end)
	
run(function()
	local PickupRange
	local Range
	local Network
	local Lower
	
	PickupRange = vape.Categories.Utility:CreateModule({
		Name = 'PickupRange',
		Function = function(callback)
			if callback then
				local items = collection('ItemDrop', PickupRange)
				repeat
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
						for _, v in items do
							if tick() - (v:GetAttribute('ClientDropTime') or 0) < 2 then continue end
							if isnetworkowner(v) and Network.Enabled and entitylib.character.Humanoid.Health > 0 then 
								v.CFrame = CFrame.new(localPosition - Vector3.new(0, 3, 0)) 
							end
							
							if (localPosition - v.Position).Magnitude <= Range.Value then
								if Lower.Enabled and (localPosition.Y - v.Position.Y) < (entitylib.character.HipHeight - 1) then continue end
								task.spawn(function()
									bedwars.Client:Get(remotes.PickupItem):CallServerAsync({
										itemDrop = v
									}):andThen(function(suc)
										if suc and bedwars.SoundList then
											bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
											local sound = bedwars.ItemMeta[v.Name].pickUpOverlaySound
											if sound then
												bedwars.SoundManager:playSound(sound, {
													position = v.Position,
													volumeMultiplier = 0.9
												})
											end
										end
									end)
								end)
							end
						end
					end
					task.wait(0.1)
				until not PickupRange.Enabled
			end
		end,
		Tooltip = 'Picks up items from a farther distance'
	})
	Range = PickupRange:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 10,
		Default = 10,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	Network = PickupRange:CreateToggle({
		Name = 'Network TP',
		Default = true
	})
	Lower = PickupRange:CreateToggle({Name = 'Feet Check'})
end)
	
run(function()
	local RavenTP
	
	RavenTP = vape.Categories.Utility:CreateModule({
		Name = 'RavenTP',
		Function = function(callback)
			if callback then
				RavenTP:Toggle()
				local plr = entitylib.EntityMouse({
					Range = 1000,
					Players = true,
					Part = 'RootPart'
				})
	
				if getItem('raven') and plr then
					bedwars.Client:Get(remotes.SpawnRaven):CallServerAsync():andThen(function(projectile)
						if projectile then
							local bodyforce = Instance.new('BodyForce')
							bodyforce.Force = Vector3.new(0, projectile.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
							bodyforce.Parent = projectile.PrimaryPart
	
							if plr then
								task.spawn(function()
									for _ = 1, 20 do
										if plr.RootPart and projectile then
											projectile:SetPrimaryPartCFrame(CFrame.lookAlong(plr.RootPart.Position, gameCamera.CFrame.LookVector))
										end
										task.wait(0.05)
									end
								end)
								task.wait(0.3)
								bedwars.RavenController:detonateRaven()
							end
						end
					end)
				end
			end
		end,
		Tooltip = 'Spawns and teleports a raven to a player\nnear your mouse.'
	})
end)
	
run(function()
	local Scaffold
	local Expand
	local Tower
	local Downwards
	local Diagonal
	local LimitItem
	local Mouse
	local adjacent, lastpos, label = {}, Vector3.zero
	
	for x = -3, 3, 3 do
		for y = -3, 3, 3 do
			for z = -3, 3, 3 do
				local vec = Vector3.new(x, y, z)
				if vec ~= Vector3.zero then
					table.insert(adjacent, vec)
				end
			end
		end
	end
	
	local function nearCorner(poscheck, pos)
		local startpos = poscheck - Vector3.new(3, 3, 3)
		local endpos = poscheck + Vector3.new(3, 3, 3)
		local check = poscheck + (pos - poscheck).Unit * 100
		return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
	end
	
	local function blockProximity(pos)
		local mag, returned = 60
		local tab = getBlocksInPoints(bedwars.BlockController:getBlockPosition(pos - Vector3.new(21, 21, 21)), bedwars.BlockController:getBlockPosition(pos + Vector3.new(21, 21, 21)))
		for _, v in tab do
			local blockpos = nearCorner(v, pos)
			local newmag = (pos - blockpos).Magnitude
			if newmag < mag then
				mag, returned = newmag, blockpos
			end
		end
		table.clear(tab)
		return returned
	end
	
	local function checkAdjacent(pos)
		for _, v in adjacent do
			if getPlacedBlock(pos + v) then
				return true
			end
		end
		return false
	end
	
	local function getScaffoldBlock()
		if store.hand.toolType == 'block' then
			return store.hand.tool.Name, store.hand.amount
		elseif (not LimitItem.Enabled) then
			local wool, amount = getWool()
			if wool then
				return wool, amount
			else
				for _, item in store.inventory.inventory.items do
					if bedwars.ItemMeta[item.itemType].block then
						return item.itemType, item.amount
					end
				end
			end
		end
	
		return nil, 0
	end
	
	Scaffold = vape.Categories.Utility:CreateModule({
		Name = 'Scaffold',
		Function = function(callback)
			if label then
				label.Visible = callback
			end
	
			if callback then
				repeat
					if entitylib.isAlive then
						local wool, amount = getScaffoldBlock()
	
						if Mouse.Enabled then
							if not inputService:IsMouseButtonPressed(0) then
								wool = nil
							end
						end
	
						if label then
							amount = amount or 0
							label.Text = amount..' <font color="rgb(170, 170, 170)">(Scaffold)</font>'
							label.TextColor3 = Color3.fromHSV((amount / 128) / 2.8, 0.86, 1)
						end
	
						if wool then
							local root = entitylib.character.RootPart
							if Tower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and (not inputService:GetFocusedTextBox()) then
								root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
							end
	
							for i = Expand.Value, 1, -1 do
								local currentpos = roundPos(root.Position - Vector3.new(0, entitylib.character.HipHeight + (Downwards.Enabled and inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + entitylib.character.Humanoid.MoveDirection * (i * 3))
								if Diagonal.Enabled then
									if math.abs(math.round(math.deg(math.atan2(-entitylib.character.Humanoid.MoveDirection.X, -entitylib.character.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
										local dt = (lastpos - currentpos)
										if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
											currentpos = lastpos
										end
									end
								end
	
								local block, blockpos = getPlacedBlock(currentpos)
								if not block then
									blockpos = checkAdjacent(blockpos * 3) and blockpos * 3 or blockProximity(currentpos)
									if blockpos then
										task.spawn(bedwars.placeBlock, blockpos, wool, false)
									end
								end
								lastpos = currentpos
							end
						end
					end
	
					task.wait(0.03)
				until not Scaffold.Enabled
			else
				Label = nil
			end
		end,
		Tooltip = 'Helps you make bridges/scaffold walk.'
	})
	Expand = Scaffold:CreateSlider({
		Name = 'Expand',
		Min = 1,
		Max = 6
	})
	Tower = Scaffold:CreateToggle({
		Name = 'Tower',
		Default = true
	})
	Downwards = Scaffold:CreateToggle({
		Name = 'Downwards',
		Default = true
	})
	Diagonal = Scaffold:CreateToggle({
		Name = 'Diagonal',
		Default = true
	})
	LimitItem = Scaffold:CreateToggle({Name = 'Limit to items'})
	Mouse = Scaffold:CreateToggle({Name = 'Require mouse down'})
	Count = Scaffold:CreateToggle({
		Name = 'Block Count',
		Function = function(callback)
			if callback then
				label = Instance.new('TextLabel')
				label.Size = UDim2.fromOffset(100, 20)
				label.Position = UDim2.new(0.5, 6, 0.5, 60)
				label.BackgroundTransparency = 1
				label.AnchorPoint = Vector2.new(0.5, 0)
				label.Text = '0'
				label.TextColor3 = Color3.new(0, 1, 0)
				label.TextSize = 18
				label.RichText = true
				label.Font = Enum.Font.Arial
				label.Visible = Scaffold.Enabled
				label.Parent = vape.gui
			else
				label:Destroy()
				label = nil
			end
		end
	})
end)
	
run(function()
	local ShopTierBypass
	local tiered, nexttier = {}, {}
	
	ShopTierBypass = vape.Categories.Utility:CreateModule({
		Name = 'ShopTierBypass',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.shopLoaded or not ShopTierBypass.Enabled
				if ShopTierBypass.Enabled then
					for _, v in bedwars.Shop.ShopItems do
						tiered[v] = v.tiered
						nexttier[v] = v.nextTier
						v.nextTier = nil
						v.tiered = nil
					end
				end
			else
				for i, v in tiered do
					i.tiered = v
				end
				for i, v in nexttier do
					i.nextTier = v
				end
				table.clear(nexttier)
				table.clear(tiered)
			end
		end,
		Tooltip = 'Lets you buy things like armor early.'
	})
end)
	
run(function()
	local StaffDetector
	local Mode
	local Clans
	local Party
	local Profile
	local Users
	local blacklistedclans = {'gg', 'gg2', 'DV', 'DV2'}
	local blacklisteduserids = {1502104539, 3826146717, 4531785383, 1049767300, 4926350670, 653085195, 184655415, 2752307430, 5087196317, 5744061325, 1536265275}
	local joined = {}
	
	local function getRole(plr, id)
		local suc, res = pcall(function()
			return plr:GetRankInGroup(id)
		end)
		if not suc then
			notif('StaffDetector', res, 30, 'alert')
		end
		return suc and res or 0
	end
	
	local function staffFunction(plr, checktype)
		if not vape.Loaded then
			repeat task.wait() until vape.Loaded
		end
	
		notif('StaffDetector', 'Staff Detected ('..checktype..'): '..plr.Name..' ('..plr.UserId..')', 60, 'alert')
		whitelist.customtags[plr.Name] = {{text = 'GAME STAFF', color = Color3.new(1, 0, 0)}}
	
		if Party.Enabled and not checktype:find('clan') then
			bedwars.PartyController:leaveParty()
		end
	
		if Mode.Value == 'Uninject' then
			task.spawn(function()
				vape:Uninject()
			end)
			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'StaffDetector',
				Text = 'Staff Detected ('..checktype..')\n'..plr.Name..' ('..plr.UserId..')',
				Duration = 60,
			})
		elseif Mode.Value == 'Requeue' then
			bedwars.QueueController:joinQueue(store.queueType)
		elseif Mode.Value == 'Profile' then
			vape.Save = function() end
			if vape.Profile ~= Profile.Value then
				vape:Load(true, Profile.Value)
			end
		elseif Mode.Value == 'AutoConfig' then
			local safe = {'AutoClicker', 'Reach', 'Sprint', 'HitFix', 'StaffDetector'}
			vape.Save = function() end
			for i, v in vape.Modules do
				if not (table.find(safe, i) or v.Category == 'Render') then
					if v.Enabled then
						v:Toggle()
					end
					v:SetBind('')
				end
			end
		end
	end
	
	local function checkFriends(list)
		for _, v in list do
			if joined[v] then
				return joined[v]
			end
		end
		return nil
	end
	
	local function checkJoin(plr, connection)
		if not plr:GetAttribute('Team') and plr:GetAttribute('Spectator') and not bedwars.Store:getState().Game.customMatch then
			connection:Disconnect()
			local tab, pages = {}, playersService:GetFriendsAsync(plr.UserId)
			for _ = 1, 4 do
				for _, v in pages:GetCurrentPage() do
					table.insert(tab, v.Id)
				end
				if pages.IsFinished then break end
				pages:AdvanceToNextPageAsync()
			end
	
			local friend = checkFriends(tab)
			if not friend then
				staffFunction(plr, 'impossible_join')
				return true
			else
				notif('StaffDetector', string.format('Spectator %s joined from %s', plr.Name, friend), 20, 'warning')
			end
		end
	end
	
	local function playerAdded(plr)
		joined[plr.UserId] = plr.Name
		if plr == lplr then return end
	
		if table.find(blacklisteduserids, plr.UserId) or table.find(Users.ListEnabled, tostring(plr.UserId)) then
			staffFunction(plr, 'blacklisted_user')
		elseif getRole(plr, 5774246) >= 100 then
			staffFunction(plr, 'staff_role')
		else
			local connection
			connection = plr:GetAttributeChangedSignal('Spectator'):Connect(function()
				checkJoin(plr, connection)
			end)
			StaffDetector:Clean(connection)
			if checkJoin(plr, connection) then
				return
			end
	
			if not plr:GetAttribute('ClanTag') then
				plr:GetAttributeChangedSignal('ClanTag'):Wait()
			end
	
			if table.find(blacklistedclans, plr:GetAttribute('ClanTag')) and vape.Loaded and Clans.Enabled then
				connection:Disconnect()
				staffFunction(plr, 'blacklisted_clan_'..plr:GetAttribute('ClanTag'):lower())
			end
		end
	end
	
	StaffDetector = vape.Categories.Utility:CreateModule({
		Name = 'StaffDetector',
		Function = function(callback)
			if callback then
				StaffDetector:Clean(playersService.PlayerAdded:Connect(playerAdded))
				for _, v in playersService:GetPlayers() do
					task.spawn(playerAdded, v)
				end
			else
				table.clear(joined)
			end
		end,
		Tooltip = 'Detects people with a staff rank ingame'
	})
	Mode = StaffDetector:CreateDropdown({
		Name = 'Mode',
		List = {'Uninject', 'Profile', 'Requeue', 'AutoConfig', 'Notify'},
		Function = function(val)
			if Profile.Object then
				Profile.Object.Visible = val == 'Profile'
			end
		end
	})
	Clans = StaffDetector:CreateToggle({
		Name = 'Blacklist clans',
		Default = true
	})
	Party = StaffDetector:CreateToggle({
		Name = 'Leave party'
	})
	Profile = StaffDetector:CreateTextBox({
		Name = 'Profile',
		Default = 'default',
		Darker = true,
		Visible = false
	})
	Users = StaffDetector:CreateTextList({
		Name = 'Users',
		Placeholder = 'player (userid)'
	})
	
	task.spawn(function()
		repeat task.wait(1) until vape.Loaded or vape.Loaded == nil
		if vape.Loaded and not StaffDetector.Enabled then
			StaffDetector:Toggle()
		end
	end)
end)
	
run(function()
	TrapDisabler = vape.Categories.Utility:CreateModule({
		Name = 'TrapDisabler',
		Tooltip = 'Disables Snap Traps'
	})
end)
	
run(function()
	vape.Categories.World:CreateModule({
		Name = 'Anti-AFK',
		Function = function(callback)
			if callback then
				for _, v in getconnections(lplr.Idled) do
					v:Disconnect()
				end
	
				for _, v in getconnections(runService.Heartbeat) do
					if type(v.Function) == 'function' and table.find(debug.getconstants(v.Function), remotes.AfkStatus) then
						v:Disconnect()
					end
				end
	
				bedwars.Client:Get(remotes.AfkStatus):SendToServer({
					afk = false
				})
			end
		end,
		Tooltip = 'Lets you stay ingame without getting kicked'
	})
end)
	
run(function()
	local AutoSuffocate
	local Range
	local LimitItem
	
	local function fixPosition(pos)
		return bedwars.BlockController:getBlockPosition(pos) * 3
	end
	
	AutoSuffocate = vape.Categories.World:CreateModule({
		Name = 'AutoSuffocate',
		Function = function(callback)
			if callback then
				repeat
					local item = store.hand.toolType == 'block' and store.hand.tool.Name or not LimitItem.Enabled and getWool()
	
					if item then
						local plrs = entitylib.AllPosition({
							Part = 'RootPart',
							Range = Range.Value,
							Players = true
						})
	
						for _, ent in plrs do
							local needPlaced = {}
	
							for _, side in Enum.NormalId:GetEnumItems() do
								side = Vector3.fromNormalId(side)
								if side.Y ~= 0 then continue end
	
								side = fixPosition(ent.RootPart.Position + side * 2)
								if not getPlacedBlock(side) then
									table.insert(needPlaced, side)
								end
							end
	
							if #needPlaced < 3 then
								table.insert(needPlaced, fixPosition(ent.Head.Position))
								table.insert(needPlaced, fixPosition(ent.RootPart.Position - Vector3.new(0, 1, 0)))
	
								for _, pos in needPlaced do
									if not getPlacedBlock(pos) then
										task.spawn(bedwars.placeBlock, pos, item)
										break
									end
								end
							end
						end
					end
	
					task.wait(0.09)
				until not AutoSuffocate.Enabled
			end
		end,
		Tooltip = 'Places blocks on nearby confined entities'
	})
	Range = AutoSuffocate:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 20,
		Default = 20,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	LimitItem = AutoSuffocate:CreateToggle({
		Name = 'Limit to Items',
		Default = true
	})
end)
	
run(function()
	local AutoTool
	local old, event
	
	local function switchHotbarItem(block)
		if block and not block:GetAttribute('NoBreak') and not block:GetAttribute('Team'..(lplr:GetAttribute('Team') or 0)..'NoBreak') then
			local tool, slot = store.tools[bedwars.ItemMeta[block.Name].block.breakType], nil
			if tool then
				for i, v in store.inventory.hotbar do
					if v.item and v.item.itemType == tool.itemType then slot = i - 1 break end
				end
	
				if hotbarSwitch(slot) then
					if inputService:IsMouseButtonPressed(0) then 
						event:Fire() 
					end
					return true
				end
			end
		end
	end
	
	AutoTool = vape.Categories.World:CreateModule({
		Name = 'AutoTool',
		Function = function(callback)
			if callback then
				event = Instance.new('BindableEvent')
				AutoTool:Clean(event)
				AutoTool:Clean(event.Event:Connect(function()
					contextActionService:CallFunction('block-break', Enum.UserInputState.Begin, newproxy(true))
				end))
				old = bedwars.BlockBreaker.hitBlock
				bedwars.BlockBreaker.hitBlock = function(self, maid, raycastparams, ...)
					local block = self.clientManager:getBlockSelector():getMouseInfo(1, {ray = raycastparams})
					if switchHotbarItem(block and block.target and block.target.blockInstance or nil) then return end
					return old(self, maid, raycastparams, ...)
				end
			else
				bedwars.BlockBreaker.hitBlock = old
				old = nil
			end
		end,
		Tooltip = 'Automatically selects the correct tool'
	})
end)
	
run(function()
	local BedProtector
	
	local function getBedNear()
		local localPosition = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
		for _, v in collectionService:GetTagged('bed') do
			if (localPosition - v.Position).Magnitude < 20 and v:GetAttribute('Team'..(lplr:GetAttribute('Team') or -1)..'NoBreak') then
				return v
			end
		end
	end
	
	local function getBlocks()
		local blocks = {}
		for _, item in store.inventory.inventory.items do
			local block = bedwars.ItemMeta[item.itemType].block
			if block then
				table.insert(blocks, {item.itemType, block.health})
			end
		end
		table.sort(blocks, function(a, b) 
			return a[2] > b[2]
		end)
		return blocks
	end
	
	local function getPyramid(size, grid)
		local positions = {}
		for h = size, 0, -1 do
			for w = h, 0, -1 do
				table.insert(positions, Vector3.new(w, (size - h), ((h + 1) - w)) * grid)
				table.insert(positions, Vector3.new(w * -1, (size - h), ((h + 1) - w)) * grid)
				table.insert(positions, Vector3.new(w, (size - h), (h - w) * -1) * grid)
				table.insert(positions, Vector3.new(w * -1, (size - h), (h - w) * -1) * grid)
			end
		end
		return positions
	end
	
	BedProtector = vape.Categories.World:CreateModule({
		Name = 'BedProtector',
		Function = function(callback)
			if callback then
				local bed = getBedNear()
				bed = bed and bed.Position or nil
				if bed then
					for i, block in getBlocks() do
						for _, pos in getPyramid(i, 3) do
							if not BedProtector.Enabled then break end
							if getPlacedBlock(bed + pos) then continue end
							bedwars.placeBlock(bed + pos, block[1], false)
						end
					end
					if BedProtector.Enabled then 
						BedProtector:Toggle() 
					end
				else
					notif('BedProtector', 'Unable to locate bed', 5)
					BedProtector:Toggle()
				end
			end
		end,
		Tooltip = 'Automatically places strong blocks around the bed.'
	})
end)
	
run(function()
	local ChestSteal
	local Range
	local Open
	local Skywars
	local Delays = {}
	
	local function lootChest(chest)
		chest = chest and chest.Value or nil
		local chestitems = chest and chest:GetChildren() or {}
		if #chestitems > 1 and (Delays[chest] or 0) < tick() then
			Delays[chest] = tick() + 0.2
			bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(chest)
	
			for _, v in chestitems do
				if v:IsA('Accessory') then
					task.spawn(function()
						pcall(function()
							bedwars.Client:GetNamespace('Inventory'):Get('ChestGetItem'):CallServer(chest, v)
						end)
					end)
				end
			end
	
			bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(nil)
		end
	end
	
	ChestSteal = vape.Categories.World:CreateModule({
		Name = 'ChestSteal',
		Function = function(callback)
			if callback then
				local chests = collection('chest', ChestSteal)
				repeat task.wait() until store.queueType ~= 'bedwars_test'
				if (not Skywars.Enabled) or store.queueType:find('skywars') then
					repeat
						if entitylib.isAlive and store.matchState ~= 2 then
							if Open.Enabled then
								if bedwars.AppController:isAppOpen('ChestApp') then
									lootChest(lplr.Character:FindFirstChild('ObservedChestFolder'))
								end
							else
								local localPosition = entitylib.character.RootPart.Position
								for _, v in chests do
									if (localPosition - v.Position).Magnitude <= Range.Value then
										lootChest(v:FindFirstChild('ChestFolderValue'))
									end
								end
							end
						end
						task.wait(0.1)
					until not ChestSteal.Enabled
				end
			end
		end,
		Tooltip = 'Grabs items from near chests.'
	})
	Range = ChestSteal:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 18,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
	Skywars = ChestSteal:CreateToggle({
		Name = 'Only Skywars',
		Function = function()
			if ChestSteal.Enabled then
				ChestSteal:Toggle()
				ChestSteal:Toggle()
			end
		end,
		Default = true
	})
end)
	
run(function()
	local Schematica
	local File
	local Mode
	local Transparency
	local parts, guidata, poschecklist = {}, {}, {}
	local point1, point2
	
	for x = -3, 3, 3 do
		for y = -3, 3, 3 do
			for z = -3, 3, 3 do
				if Vector3.new(x, y, z) ~= Vector3.zero then
					table.insert(poschecklist, Vector3.new(x, y, z))
				end
			end
		end
	end
	
	local function checkAdjacent(pos)
		for _, v in poschecklist do
			if getPlacedBlock(pos + v) then return true end
		end
		return false
	end
	
	local function getPlacedBlocksInPoints(s, e)
		local list, blocks = {}, bedwars.BlockController:getStore()
		for x = (e.X > s.X and s.X or e.X), (e.X > s.X and e.X or s.X) do
			for y = (e.Y > s.Y and s.Y or e.Y), (e.Y > s.Y and e.Y or s.Y) do
				for z = (e.Z > s.Z and s.Z or e.Z), (e.Z > s.Z and e.Z or s.Z) do
					local vec = Vector3.new(x, y, z)
					local block = blocks:getBlockAt(vec)
					if block and block:GetAttribute('PlacedByUserId') == lplr.UserId then
						list[vec] = block
					end
				end
			end
		end
		return list
	end
	
	local function loadMaterials()
		for _, v in guidata do 
			v:Destroy() 
		end
		local suc, read = pcall(function() 
			return isfile(File.Value) and httpService:JSONDecode(readfile(File.Value)) 
		end)
	
		if suc and read then
			local items = {}
			for _, v in read do 
				items[v[2]] = (items[v[2]] or 0) + 1 
			end
			
			for i, v in items do
				local holder = Instance.new('Frame')
				holder.Size = UDim2.new(1, 0, 0, 32)
				holder.BackgroundTransparency = 1
				holder.Parent = Schematica.Children
				local icon = Instance.new('ImageLabel')
				icon.Size = UDim2.fromOffset(24, 24)
				icon.Position = UDim2.fromOffset(4, 4)
				icon.BackgroundTransparency = 1
				icon.Image = bedwars.getIcon({itemType = i}, true)
				icon.Parent = holder
				local text = Instance.new('TextLabel')
				text.Size = UDim2.fromOffset(100, 32)
				text.Position = UDim2.fromOffset(32, 0)
				text.BackgroundTransparency = 1
				text.Text = (bedwars.ItemMeta[i] and bedwars.ItemMeta[i].displayName or i)..': '..v
				text.TextXAlignment = Enum.TextXAlignment.Left
				text.TextColor3 = uipallet.Text
				text.TextSize = 14
				text.FontFace = uipallet.Font
				text.Parent = holder
				table.insert(guidata, holder)
			end
			table.clear(read)
			table.clear(items)
		end
	end
	
	local function save()
		if point1 and point2 then
			local tab = getPlacedBlocksInPoints(point1, point2)
			local savetab = {}
			point1 = point1 * 3
			for i, v in tab do
				i = bedwars.BlockController:getBlockPosition(CFrame.lookAlong(point1, entitylib.character.RootPart.CFrame.LookVector):PointToObjectSpace(i * 3)) * 3
				table.insert(savetab, {
					{
						x = i.X, 
						y = i.Y, 
						z = i.Z
					}, 
					v.Name
				})
			end
			point1, point2 = nil, nil
			writefile(File.Value, httpService:JSONEncode(savetab))
			notif('Schematica', 'Saved '..getTableSize(tab)..' blocks', 5)
			loadMaterials()
			table.clear(tab)
			table.clear(savetab)
		else
			local mouseinfo = bedwars.BlockBreaker.clientManager:getBlockSelector():getMouseInfo(0)
			if mouseinfo and mouseinfo.target then
				if point1 then
					point2 = mouseinfo.target.blockRef.blockPosition
					notif('Schematica', 'Selected position 2, toggle again near position 1 to save it', 3)
				else
					point1 = mouseinfo.target.blockRef.blockPosition
					notif('Schematica', 'Selected position 1', 3)
				end
			end
		end
	end
	
	local function load(read)
		local mouseinfo = bedwars.BlockBreaker.clientManager:getBlockSelector():getMouseInfo(0)
		if mouseinfo and mouseinfo.target then
			local position = CFrame.new(mouseinfo.placementPosition * 3) * CFrame.Angles(0, math.rad(math.round(math.deg(math.atan2(-entitylib.character.RootPart.CFrame.LookVector.X, -entitylib.character.RootPart.CFrame.LookVector.Z)) / 45) * 45), 0)
	
			for _, v in read do
				local blockpos = bedwars.BlockController:getBlockPosition((position * CFrame.new(v[1].x, v[1].y, v[1].z)).p) * 3
				if parts[blockpos] then continue end
				local handler = bedwars.BlockController:getHandlerRegistry():getHandler(v[2]:find('wool') and getWool() or v[2])
				if handler then
					local part = handler:place(blockpos / 3, 0)
					part.Transparency = Transparency.Value
					part.CanCollide = false
					part.Anchored = true
					part.Parent = workspace
					parts[blockpos] = part
				end
			end
			table.clear(read)
	
			repeat
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for i, v in parts do
						if (i - localPosition).Magnitude < 60 and checkAdjacent(i) then
							if not Schematica.Enabled then break end
							if not getItem(v.Name) then continue end
							bedwars.placeBlock(i, v.Name, false)
							task.delay(0.1, function()
								local block = getPlacedBlock(i)
								if block then
									v:Destroy()
									parts[i] = nil
								end
							end)
						end
					end
				end
				task.wait()
			until getTableSize(parts) <= 0
	
			if getTableSize(parts) <= 0 and Schematica.Enabled then
				notif('Schematica', 'Finished building', 5)
				Schematica:Toggle()
			end
		end
	end
	
	Schematica = vape.Categories.World:CreateModule({
		Name = 'Schematica',
		Function = function(callback)
			if callback then
				if not File.Value:find('.json') then
					notif('Schematica', 'Invalid file', 3)
					Schematica:Toggle()
					return
				end
	
				if Mode.Value == 'Save' then
					save()
					Schematica:Toggle()
				else
					local suc, read = pcall(function() 
						return isfile(File.Value) and httpService:JSONDecode(readfile(File.Value)) 
					end)
	
					if suc and read then
						load(read)
					else
						notif('Schematica', 'Missing / corrupted file', 3)
						Schematica:Toggle()
					end
				end
			else
				for _, v in parts do 
					v:Destroy() 
				end
				table.clear(parts)
			end
		end,
		Tooltip = 'Save and load placements of buildings'
	})
	File = Schematica:CreateTextBox({
		Name = 'File',
		Function = function()
			loadMaterials()
			point1, point2 = nil, nil
		end
	})
	Mode = Schematica:CreateDropdown({
		Name = 'Mode',
		List = {'Load', 'Save'}
	})
	Transparency = Schematica:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Default = 0.7,
		Decimal = 10,
		Function = function(val)
			for _, v in parts do 
				v.Transparency = val 
			end
		end
	})
end)
	
run(function()
	local ArmorSwitch
	local Mode
	local Targets
	local Range
	
	ArmorSwitch = vape.Categories.Inventory:CreateModule({
		Name = 'ArmorSwitch',
		Function = function(callback)
			if callback then
				if Mode.Value == 'Toggle' then
					repeat
						local state = entitylib.EntityPosition({
							Part = 'RootPart',
							Range = Range.Value,
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Wallcheck = Targets.Walls.Enabled
						}) and true or false
	
						for i = 0, 2 do
							if (store.inventory.inventory.armor[i + 1] ~= 'empty') ~= state and ArmorSwitch.Enabled then
								bedwars.Store:dispatch({
									type = 'InventorySetArmorItem',
									item = store.inventory.inventory.armor[i + 1] == 'empty' and state and getBestArmor(i) or nil,
									armorSlot = i
								})
								vapeEvents.InventoryChanged.Event:Wait()
							end
						end
						task.wait(0.1)
					until not ArmorSwitch.Enabled
				else
					ArmorSwitch:Toggle()
					for i = 0, 2 do
						bedwars.Store:dispatch({
							type = 'InventorySetArmorItem',
							item = store.inventory.inventory.armor[i + 1] == 'empty' and getBestArmor(i) or nil,
							armorSlot = i
						})
						vapeEvents.InventoryChanged.Event:Wait()
					end
				end
			end
		end,
		Tooltip = 'Puts on / takes off armor when toggled for baiting.'
	})
	Mode = ArmorSwitch:CreateDropdown({
		Name = 'Mode',
		List = {'Toggle', 'On Key'}
	})
	Targets = ArmorSwitch:CreateTargets({
		Players = true,
		NPCs = true
	})
	Range = ArmorSwitch:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	
run(function()
	local AutoBank
	local UIToggle
	local UI
	local Chests
	local Items = {}
	
	local function addItem(itemType, shop)
		local item = Instance.new('ImageLabel')
		item.Image = bedwars.getIcon({itemType = itemType}, true)
		item.Size = UDim2.fromOffset(32, 32)
		item.Name = itemType
		item.BackgroundTransparency = 1
		item.LayoutOrder = #UI:GetChildren()
		item.Parent = UI
		local itemtext = Instance.new('TextLabel')
		itemtext.Name = 'Amount'
		itemtext.Size = UDim2.fromScale(1, 1)
		itemtext.BackgroundTransparency = 1
		itemtext.Text = ''
		itemtext.TextColor3 = Color3.new(1, 1, 1)
		itemtext.TextSize = 16
		itemtext.TextStrokeTransparency = 0.3
		itemtext.Font = Enum.Font.Arial
		itemtext.Parent = item
		Items[itemType] = {Object = itemtext, Type = shop}
	end
	
	local function refreshBank(echest)
		for i, v in Items do
			local item = echest:FindFirstChild(i)
			v.Object.Text = item and item:GetAttribute('Amount') or ''
		end
	end
	
	local function nearChest()
		if entitylib.isAlive then
			local pos = entitylib.character.RootPart.Position
			for _, chest in Chests do
				if (chest.Position - pos).Magnitude < 20 then
					return true
				end
			end
		end
	end
	
	local function handleState()
		local chest = replicatedStorage.Inventories:FindFirstChild(lplr.Name..'_personal')
		if not chest then return end
	
		local mapCF = workspace.MapCFrames:FindFirstChild((lplr:GetAttribute('Team') or 1)..'_spawn')
		if mapCF and (entitylib.character.RootPart.Position - mapCF.Value.Position).Magnitude < 80 then
			for _, v in chest:GetChildren() do
				local item = Items[v.Name]
				if item then
					task.spawn(function()
						bedwars.Client:GetNamespace('Inventory'):Get('ChestGetItem'):CallServer(chest, v)
						refreshBank(chest)
					end)
				end
			end
		else
			for _, v in store.inventory.inventory.items do
				local item = Items[v.itemType]
				if item then
					task.spawn(function()
						bedwars.Client:GetNamespace('Inventory'):Get('ChestGiveItem'):CallServer(chest, v.tool)
						refreshBank(chest)
					end)
				end
			end
		end
	end
	
	AutoBank = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBank',
		Function = function(callback)
			if callback then
				Chests = collection('personal-chest', AutoBank)
				UI = Instance.new('Frame')
				UI.Size = UDim2.new(1, 0, 0, 32)
				UI.Position = UDim2.fromOffset(0, -240)
				UI.BackgroundTransparency = 1
				UI.Visible = UIToggle.Enabled
				UI.Parent = vape.gui
				AutoBank:Clean(UI)
				local Sort = Instance.new('UIListLayout')
				Sort.FillDirection = Enum.FillDirection.Horizontal
				Sort.HorizontalAlignment = Enum.HorizontalAlignment.Center
				Sort.SortOrder = Enum.SortOrder.LayoutOrder
				Sort.Parent = UI
				addItem('iron', true)
				addItem('gold', true)
				addItem('diamond', false)
				addItem('emerald', true)
				addItem('void_crystal', true)
	
				repeat
					local hotbar = lplr.PlayerGui:FindFirstChild('hotbar')
					hotbar = hotbar and hotbar['1']:FindFirstChild('HotbarHealthbarContainer')
					if hotbar then
						UI.Position = UDim2.fromOffset(0, (hotbar.AbsolutePosition.Y + guiService:GetGuiInset().Y) - 40)
					end
	
					local newState = nearChest()
					if newState then
						handleState()
					end
	
					task.wait(0.1)
				until (not AutoBank.Enabled)
			else
				table.clear(Items)
			end
		end,
		Tooltip = 'Automatically puts resources in ender chest'
	})
	UIToggle = AutoBank:CreateToggle({
		Name = 'UI',
		Function = function(callback)
			if AutoBank.Enabled then
				UI.Visible = callback
			end
		end,
		Default = true
	})
end)
	
run(function()
    local AutoBuy
    local Sword
    local Armor
    local Bow
    local Wool
    local Upgrades
    local TierCheck
    local BedwarsCheck
    local GUI
    local SmartCheck
    local Custom = {}
    local CustomPost = {}
    local UpgradeToggles = {}
    local Functions, id = {}, {}
    local Callbacks = {Custom, Functions, CustomPost}
    local npctick = tick()

    -- ============================================================
    -- ティア定義テーブル
    -- ============================================================
    local swords = {
        'wood_sword',
        'stone_sword',
        'iron_sword',
        'diamond_sword',
        'emerald_sword'
    }

    local armors = {
        'none',
        'leather_chestplate',
        'iron_chestplate',
        'diamond_chestplate',
        'emerald_chestplate'
    }

    local axes = {
        'none',
        'wood_axe',
        'stone_axe',
        'iron_axe',
        'diamond_axe'
    }

    local pickaxes = {
        'none',
        'wood_pickaxe',
        'stone_pickaxe',
        'iron_pickaxe',
        'diamond_pickaxe'
    }

    -- ============================================================
    -- ヘルパー関数
    -- ============================================================

    local function getShopNPC()
        local shop, items, upgrades, newid = nil, false, false, nil
        if entitylib.isAlive then
            local localPosition = entitylib.character.RootPart.Position
            for _, v in store.shop do
                if (v.RootPart.Position - localPosition).Magnitude <= 20 then
                    shop = v.Upgrades or v.Shop or nil
                    upgrades = upgrades or v.Upgrades
                    items = items or v.Shop
                    newid = v.Shop and v.Id or newid
                end
            end
        end
        return shop, items, upgrades, newid
    end

    local function canBuy(item, currencytable, amount)
        amount = amount or 1
        if not item then return false end
        if not item.currency or not item.price then return false end
        if not currencytable[item.currency] then
            local currency = getItem(item.currency)
            currencytable[item.currency] = currency and currency.amount or 0
        end
        if item.ignoredByKit and table.find(item.ignoredByKit, store.equippedKit or '') then
            return false
        end
        if item.lockedByForge or item.disabled then
            return false
        end
        if item.require and item.require.teamUpgrade then
            if (bedwars.Store:getState().Bedwars.teamUpgrades[item.require.teamUpgrade.upgradeId] or -1)
                < item.require.teamUpgrade.lowestTierIndex then
                return false
            end
        end
        return currencytable[item.currency] >= (item.price * amount)
    end

    -- nilガード強化版 buyItem
    local function buyItem(item, currencytable)
        if not id then return end
        if not item then return end
        if not item.itemType or not item.currency or not item.price then return end

        local meta = bedwars.ItemMeta[item.itemType]
        notif('AutoBuy', 'Bought ' .. (meta and meta.displayName or item.itemType), 3)

        local remote = bedwars.Client:Get('BedwarsPurchaseItem')
        if not remote then
            notif('AutoBuy', 'Remote not found: BedwarsPurchaseItem', 3)
            return
        end

        if type(remote.CallServerAsync) ~= 'function' then
            if type(remote.SendToServer) == 'function' then
                remote:SendToServer({
                    shopItem = item,
                    shopId = id
                })
            end
            currencytable[item.currency] -= item.price
            return
        end

        local promise = remote:CallServerAsync({
            shopItem = item,
            shopId = id
        })

        if promise and type(promise.andThen) == 'function' then
            promise:andThen(function(suc)
                if suc then
                    bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
                    bedwars.Store:dispatch({
                        type = 'BedwarsAddItemPurchased',
                        itemType = item.itemType
                    })
                    bedwars.BedwarsShopController.alreadyPurchasedMap[item.itemType] = true
                end
            end)
        end

        currencytable[item.currency] -= item.price
    end

    -- getShopItem を安全に呼ぶラッパー
    local function safeGetShopItem(itemType)
        if not bedwars.Shop or type(bedwars.Shop.getShopItem) ~= 'function' then
            return nil
        end
        local ok, result = pcall(bedwars.Shop.getShopItem, itemType, lplr)
        return ok and result or nil
    end

    local function buyUpgrade(upgradeType, currencytable)
        if not Upgrades.Enabled then return end
        local upgrade = bedwars.TeamUpgradeMeta[upgradeType]
        if not upgrade then return end
        local currentUpgrades = bedwars.Store:getState().Bedwars.teamUpgrades[lplr:GetAttribute('Team')] or {}
        local currentTier = (currentUpgrades[upgradeType] or 0) + 1
        local bought = false
        for i = currentTier, #upgrade.tiers do
            local tier = upgrade.tiers[i]
            if tier.availableOnlyInQueue and not table.find(tier.availableOnlyInQueue, store.queueType) then
                continue
            end
            if canBuy({currency = 'diamond', price = tier.cost}, currencytable) then
                notif('AutoBuy', 'Bought ' .. (upgrade.name == 'Armor' and 'Protection' or upgrade.name) .. ' ' .. i, 3)
                local remote = bedwars.Client:Get('RequestPurchaseTeamUpgrade')
                if remote and type(remote.CallServerAsync) == 'function' then
                    remote:CallServerAsync(upgradeType)
                end
                currencytable.diamond -= tier.cost
                bought = true
            else
                break
            end
        end
        return bought
    end

    local function buyTool(tool, tools, currencytable)
        local bought, buyable = false
        tool = tool
            and table.find(tools, tool.itemType)
            and table.find(tools, tool.itemType) + 1
            or math.huge
        for i = tool, #tools do
            local v = safeGetShopItem(tools[i])
            if canBuy(v, currencytable) then
                if SmartCheck.Enabled and bedwars.ItemMeta[tools[i]].breakBlock and i > 2 then
                    if Armor.Enabled then
                        local currentarmor = store.inventory.inventory.armor[2]
                        currentarmor = currentarmor and currentarmor ~= 'empty' and currentarmor.itemType or 'none'
                        if (table.find(armors, currentarmor) or 3) < 3 then break end
                    end
                    if Sword.Enabled then
                        if store.tools.sword and (table.find(swords, store.tools.sword.itemType) or 2) < 2 then
                            break
                        end
                    end
                end
                bought = true
                buyable = v
            end
            if TierCheck.Enabled and v and v.nextTier then break end
        end
        if buyable then
            buyItem(buyable, currencytable)
        end
        return bought
    end

    -- ============================================================
    -- AutoBuy モジュール本体
    -- ============================================================
    AutoBuy = vape.Categories.Inventory:CreateModule({
        Name = 'AutoBuy',
        Function = function(callback)
            if callback then
                repeat task.wait() until store.queueType ~= 'bedwars_test'
                if BedwarsCheck.Enabled and not store.queueType:find('bedwars') then return end

                local lastupgrades
                AutoBuy:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(function()
                    if (npctick - tick()) > 1 then npctick = tick() end
                end))

                repeat
                    local npc, shop, upgrades, newid = getShopNPC()
                    id = newid

                    if GUI.Enabled then
                        if not (bedwars.AppController:isAppOpen('BedwarsItemShopApp')
                            or bedwars.AppController:isAppOpen('TeamUpgradeApp')) then
                            npc = nil
                        end
                    end

                    if npc and lastupgrades ~= upgrades then
                        if (npctick - tick()) > 1 then npctick = tick() end
                        lastupgrades = upgrades
                    end

                    if npc and npctick <= tick() and store.matchState ~= 2 and store.shopLoaded then
                        local currencytable = {}
                        local waitcheck
                        for _, tab in Callbacks do
                            for _, cb in tab do
                                if type(cb) == 'function' and cb(currencytable, shop, upgrades) then
                                    waitcheck = true
                                end
                            end
                        end
                        npctick = tick() + (waitcheck and 0.4 or math.huge)
                    end

                    task.wait(0.1)
                until not AutoBuy.Enabled
            else
                npctick = tick()
            end
        end,
        Tooltip = 'Automatically buys items when you go near the shop'
    })

    -- ============================================================
    -- [1] Armor
    -- ============================================================
    Armor = AutoBuy:CreateToggle({
        Name = 'Buy Armor',
        Function = function(callback)
            npctick = tick()
            Functions[1] = callback and function(currencytable, shop)
                if not shop then return end
                local currentarmor = store.inventory.inventory.armor[2] ~= 'empty'
                    and store.inventory.inventory.armor[2]
                    or getBestArmor(1)
                currentarmor = currentarmor and currentarmor.itemType or 'none'
                return buyTool({itemType = currentarmor}, armors, currencytable)
            end or nil
        end,
        Default = true
    })

    -- ============================================================
    -- [2] Sword
    -- ============================================================
    Sword = AutoBuy:CreateToggle({
        Name = 'Buy Sword',
        Function = function(callback)
            npctick = tick()
            Functions[2] = callback and function(currencytable, shop)
                if not shop then return end
                if store.equippedKit == 'dasher' then
                    swords = {
                        [1] = 'wood_dao',
                        [2] = 'stone_dao',
                        [3] = 'iron_dao',
                        [4] = 'diamond_dao',
                        [5] = 'emerald_dao'
                    }
                elseif store.equippedKit == 'ice_queen' then
                    swords[5] = 'ice_sword'
                elseif store.equippedKit == 'ember' then
                    swords[5] = 'infernal_saber'
                elseif store.equippedKit == 'lumen' then
                    swords[5] = 'light_sword'
                end
                return buyTool(store.tools.sword, swords, currencytable)
            end or nil
        end
    })

    -- ============================================================
    -- [3] Axe
    -- ============================================================
    AutoBuy:CreateToggle({
        Name = 'Buy Axe',
        Function = function(callback)
            npctick = tick()
            Functions[3] = callback and function(currencytable, shop)
                if not shop then return end
                return buyTool(store.tools.wood or {itemType = 'none'}, axes, currencytable)
            end or nil
        end
    })

    -- ============================================================
    -- [4] Pickaxe
    -- ============================================================
    AutoBuy:CreateToggle({
        Name = 'Buy Pickaxe',
        Function = function(callback)
            npctick = tick()
            Functions[4] = callback and function(currencytable, shop)
                if not shop then return end
                return buyTool(store.tools.stone, pickaxes, currencytable)
            end or nil
        end
    })

    -- ============================================================
    -- [50] Bow  (Bow → Arrows(96) → Crossbow → Arrows(96))
    -- ============================================================
    Bow = AutoBuy:CreateToggle({
        Name = 'Buy Bow',
        Function = function(callback)
            npctick = tick()
            Functions[50] = callback and function(currencytable, shop)
                if not shop then return end
                local bought = false

                local hasBow = getItem('wood_bow')
                local hasCrossbow = getItem('wood_crossbow')
                    or getItem('tactical_crossbow')
                    or getItem('headhunter')

                -- 1) Bow (24 iron) — crossbow所持時はスキップ（ダウングレード防止）
                if not hasBow and not hasCrossbow then
                    local bow = safeGetShopItem('wood_bow')
                    if bow and canBuy(bow, currencytable) then
                        buyItem(bow, currencytable)
                        bought = true
                    end
                end

                -- 2) Arrows: 目標96個、鉄が足りないなら買える分だけ
                local arrow = safeGetShopItem('arrow')
                if arrow then
                    local arrowItem = getItem('arrow')
                    local currentArrows = arrowItem and arrowItem.amount or 0
                    local needed = 96 - currentArrows
                    if needed > 0 then
                        local perBuy = arrow.amount or 8
                        local buysNeeded = math.ceil(needed / perBuy)
                        -- 鉄残高を確認（currencytableにまだ無ければ取得）
                        if currencytable.iron == nil then
                            local ironItem = getItem('iron')
                            currencytable.iron = ironItem and ironItem.amount or 0
                        end
                        local affordable = math.floor(currencytable.iron / arrow.price)
                        local buys = math.min(buysNeeded, affordable)
                        for _ = 1, buys do
                            buyItem(arrow, currencytable)
                            bought = true
                        end
                    end
                end

                -- 3) Crossbow (7 emerald)
                if not hasCrossbow then
                    local cb = safeGetShopItem('wood_crossbow')
                    if cb and canBuy(cb, currencytable) then
                        buyItem(cb, currencytable)
                        bought = true
                    end
                end

                -- 4) Arrows again: 目標96個、買える分だけ
                if arrow then
                    local arrowItem = getItem('arrow')
                    local currentArrows = arrowItem and arrowItem.amount or 0
                    local needed = 96 - currentArrows
                    if needed > 0 then
                        local perBuy = arrow.amount or 8
                        local buysNeeded = math.ceil(needed / perBuy)
                        if currencytable.iron == nil then
                            local ironItem = getItem('iron')
                            currencytable.iron = ironItem and ironItem.amount or 0
                        end
                        local affordable = math.floor(currencytable.iron / arrow.price)
                        local buys = math.min(buysNeeded, affordable)
                        for _ = 1, buys do
                            buyItem(arrow, currencytable)
                            bought = true
                        end
                    end
                end

                return bought
            end or nil
        end
    })

    -- ============================================================
    -- [51] Wool  (64個以上でスキップ / チームカラー自動対応)
    -- ============================================================
    Wool = AutoBuy:CreateToggle({
        Name = 'Buy Wool',
        Function = function(callback)
            npctick = tick()
            Functions[51] = callback and function(currencytable, shop)
                if not shop then return end

                local teamWool = 'wool_white'
                if bedwars.Shop and type(bedwars.Shop.getTeamWool) == 'function' then
                    teamWool = bedwars.Shop.getTeamWool(lplr:GetAttribute('Team')) or 'wool_white'
                end

                local woolItem = getItem(teamWool, nil, true)
                local currentWool = woolItem and woolItem.amount or 0

                -- 64個以上あるなら買わない
                if currentWool < 64 then
                    local wool = safeGetShopItem(teamWool)
                    if wool and canBuy(wool, currencytable) then
                        buyItem(wool, currencytable)
                        return true
                    end
                end

                return false
            end or nil
        end
    })

    -- ============================================================
    -- Upgrades
    -- ============================================================
    Upgrades = AutoBuy:CreateToggle({
        Name = 'Buy Upgrades',
        Function = function(callback)
            for _, v in UpgradeToggles do
                v.Object.Visible = callback
            end
        end,
        Default = true
    })

    local count = 0
    for i, v in bedwars.TeamUpgradeMeta do
        local toggleCount = count
        table.insert(UpgradeToggles, AutoBuy:CreateToggle({
            Name = 'Buy ' .. (v.name == 'Armor' and 'Protection' or v.name),
            Function = function(callback)
                npctick = tick()
                Functions[5 + toggleCount + (v.name == 'Armor' and 20 or 0)] =
                    callback and function(currencytable, shop, upgrades)
                        if not upgrades then return end
                        if v.disabledInQueue and table.find(v.disabledInQueue, store.queueType) then
                            return
                        end
                        return buyUpgrade(i, currencytable)
                    end or nil
            end,
            Darker = true,
            Default = (i == 'ARMOR' or i == 'DAMAGE')
        }))
        count += 1
    end

    -- ============================================================
    -- 共通オプション
    -- ============================================================
    TierCheck = AutoBuy:CreateToggle({Name = 'Tier Check'})

    BedwarsCheck = AutoBuy:CreateToggle({
        Name = 'Only Bedwars',
        Function = function()
            if AutoBuy.Enabled then
                AutoBuy:Toggle()
                AutoBuy:Toggle()
            end
        end,
        Default = true
    })

    GUI = AutoBuy:CreateToggle({Name = 'GUI check'})

    SmartCheck = AutoBuy:CreateToggle({
        Name = 'Smart check',
        Default = true,
        Tooltip = 'Buys iron armor before iron axe'
    })

    -- ============================================================
    -- Custom TextList
    -- ============================================================
    AutoBuy:CreateTextList({
        Name = 'Item',
        Placeholder = 'priority/item/amount/after',
        Function = function(list)
            table.clear(Custom)
            table.clear(CustomPost)
            for _, entry in list do
                local tab = entry:split('/')
                local ind = tonumber(tab[1])
                if ind then
                    (tab[4] and CustomPost or Custom)[ind] = function(currencytable, shop)
                        if not shop then return end
                        local itemType = tab[2]
                        if itemType == 'wool_white'
                            and bedwars.Shop
                            and type(bedwars.Shop.getTeamWool) == 'function' then
                            itemType = bedwars.Shop.getTeamWool(lplr:GetAttribute('Team')) or itemType
                        end
                        local v = safeGetShopItem(itemType)
                        if v then
                            local item = getItem(itemType)
                            item = (item and tonumber(tab[3]) - item.amount or tonumber(tab[3])) // v.amount
                            if item > 0 and canBuy(v, currencytable, item) then
                                for _ = 1, item do
                                    buyItem(v, currencytable)
                                end
                                return true
                            end
                        end
                    end
                end
            end
        end
    })
end)
	
run(function()
	local AutoConsume
	local Health
	local SpeedPotion
	local Apple
	local ShieldPotion
	
	local function consumeCheck(attribute)
		if entitylib.isAlive then
			if SpeedPotion.Enabled and (not attribute or attribute == 'StatusEffect_speed') then
				local speedpotion = getItem('speed_potion')
				if speedpotion and (not lplr.Character:GetAttribute('StatusEffect_speed')) then
					for _ = 1, 4 do
						if bedwars.Client:Get(remotes.ConsumeItem):CallServer({item = speedpotion.tool}) then break end
					end
				end
			end
	
			if Apple.Enabled and (not attribute or attribute:find('Health')) then
				if (lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) <= (Health.Value / 100) then
					local apple = getItem('orange') or (not lplr.Character:GetAttribute('StatusEffect_golden_apple') and getItem('golden_apple')) or getItem('apple')
					
					if apple then
						bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
							item = apple.tool
						})
					end
				end
			end
	
			if ShieldPotion.Enabled and (not attribute or attribute:find('Shield')) then
				if (lplr.Character:GetAttribute('Shield_POTION') or 0) == 0 then
					local shield = getItem('big_shield') or getItem('mini_shield')
	
					if shield then
						bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
							item = shield.tool
						})
					end
				end
			end
		end
	end
	
	AutoConsume = vape.Categories.Inventory:CreateModule({
		Name = 'AutoConsume',
		Function = function(callback)
			if callback then
				AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
				AutoConsume:Clean(vapeEvents.AttributeChanged.Event:Connect(function(attribute)
					if attribute:find('Shield') or attribute:find('Health') or attribute == 'StatusEffect_speed' then
						consumeCheck(attribute)
					end
				end))
				consumeCheck()
			end
		end,
		Tooltip = 'Automatically heals for you when health or shield is under threshold.'
	})
	Health = AutoConsume:CreateSlider({
		Name = 'Health Percent',
		Min = 1,
		Max = 99,
		Default = 70,
		Suffix = '%'
	})
	SpeedPotion = AutoConsume:CreateToggle({
		Name = 'Speed Potions',
		Default = true
	})
	Apple = AutoConsume:CreateToggle({
		Name = 'Apple',
		Default = true
	})
	ShieldPotion = AutoConsume:CreateToggle({
		Name = 'Shield Potions',
		Default = true
	})
end)
	
run(function()
	local AutoHotbar
	local Mode
	local Clear
	local List
	local Active
	
	local function CreateWindow(self)
		local selectedslot = 1
		local window = Instance.new('Frame')
		window.Name = 'HotbarGUI'
		window.Size = UDim2.fromOffset(660, 465)
		window.Position = UDim2.fromScale(0.5, 0.5)
		window.BackgroundColor3 = uipallet.Main
		window.AnchorPoint = Vector2.new(0.5, 0.5)
		window.Visible = false
		window.Parent = vape.gui.ScaledGui
		local title = Instance.new('TextLabel')
		title.Name = 'Title'
		title.Size = UDim2.new(1, -10, 0, 20)
		title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 12)
		title.BackgroundTransparency = 1
		title.Text = 'AutoHotbar'
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = uipallet.Text
		title.TextSize = 13
		title.FontFace = uipallet.Font
		title.Parent = window
		local divider = Instance.new('Frame')
		divider.Name = 'Divider'
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Position = UDim2.fromOffset(0, 40)
		divider.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		divider.BorderSizePixel = 0
		divider.Parent = window
		addBlur(window)
		local modal = Instance.new('TextButton')
		modal.Text = ''
		modal.BackgroundTransparency = 1
		modal.Modal = true
		modal.Parent = window
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 5)
		corner.Parent = window
		local close = Instance.new('ImageButton')
		close.Name = 'Close'
		close.Size = UDim2.fromOffset(24, 24)
		close.Position = UDim2.new(1, -35, 0, 9)
		close.BackgroundColor3 = Color3.new(1, 1, 1)
		close.BackgroundTransparency = 1
		close.Image = getcustomasset('newvape/assets/new/close.png')
		close.ImageColor3 = color.Light(uipallet.Text, 0.2)
		close.ImageTransparency = 0.5
		close.AutoButtonColor = false
		close.Parent = window
		close.MouseEnter:Connect(function()
			close.ImageTransparency = 0.3
			tween:Tween(close, TweenInfo.new(0.2), {
				BackgroundTransparency = 0.6
			})
		end)
		close.MouseLeave:Connect(function()
			close.ImageTransparency = 0.5
			tween:Tween(close, TweenInfo.new(0.2), {
				BackgroundTransparency = 1
			})
		end)
		close.MouseButton1Click:Connect(function()
			window.Visible = false
			vape.gui.ScaledGui.ClickGui.Visible = true
		end)
		local closecorner = Instance.new('UICorner')
		closecorner.CornerRadius = UDim.new(1, 0)
		closecorner.Parent = close
		local bigslot = Instance.new('Frame')
		bigslot.Size = UDim2.fromOffset(110, 111)
		bigslot.Position = UDim2.fromOffset(11, 71)
		bigslot.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		bigslot.Parent = window
		local bigslotcorner = Instance.new('UICorner')
		bigslotcorner.CornerRadius = UDim.new(0, 4)
		bigslotcorner.Parent = bigslot
		local bigslotstroke = Instance.new('UIStroke')
		bigslotstroke.Color = color.Light(uipallet.Main, 0.034)
		bigslotstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		bigslotstroke.Parent = bigslot
		local slotnum = Instance.new('TextLabel')
		slotnum.Size = UDim2.fromOffset(80, 20)
		slotnum.Position = UDim2.fromOffset(25, 200)
		slotnum.BackgroundTransparency = 1
		slotnum.Text = 'SLOT 1'
		slotnum.TextColor3 = color.Dark(uipallet.Text, 0.1)
		slotnum.TextSize = 12
		slotnum.FontFace = uipallet.Font
		slotnum.Parent = window
		for i = 1, 9 do
			local slotbkg = Instance.new('TextButton')
			slotbkg.Name = 'Slot'..i
			slotbkg.Size = UDim2.fromOffset(51, 52)
			slotbkg.Position = UDim2.fromOffset(89 + (i * 55), 382)
			slotbkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
			slotbkg.Text = ''
			slotbkg.AutoButtonColor = false
			slotbkg.Parent = window
			local slotimage = Instance.new('ImageLabel')
			slotimage.Size = UDim2.fromOffset(32, 32)
			slotimage.Position = UDim2.new(0.5, -16, 0.5, -16)
			slotimage.BackgroundTransparency = 1
			slotimage.Image = ''
			slotimage.Parent = slotbkg
			local slotcorner = Instance.new('UICorner')
			slotcorner.CornerRadius = UDim.new(0, 4)
			slotcorner.Parent = slotbkg
			local slotstroke = Instance.new('UIStroke')
			slotstroke.Color = color.Light(uipallet.Main, 0.04)
			slotstroke.Thickness = 2
			slotstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			slotstroke.Enabled = i == selectedslot
			slotstroke.Parent = slotbkg
			slotbkg.MouseEnter:Connect(function()
				slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
			end)
			slotbkg.MouseLeave:Connect(function()
				slotbkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
			end)
			slotbkg.MouseButton1Click:Connect(function()
				window['Slot'..selectedslot].UIStroke.Enabled = false
				selectedslot = i
				slotstroke.Enabled = true
				slotnum.Text = 'SLOT '..selectedslot
			end)
			slotbkg.MouseButton2Click:Connect(function()
				local obj = self.Hotbars[self.Selected]
				if obj then
					window['Slot'..i].ImageLabel.Image = ''
					obj.Hotbar[tostring(i)] = nil
					obj.Object['Slot'..i].Image = '	'
				end
			end)
		end
		local searchbkg = Instance.new('Frame')
		searchbkg.Size = UDim2.fromOffset(496, 31)
		searchbkg.Position = UDim2.fromOffset(142, 80)
		searchbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		searchbkg.Parent = window
		local search = Instance.new('TextBox')
		search.Size = UDim2.new(1, -10, 0, 31)
		search.Position = UDim2.fromOffset(10, 0)
		search.BackgroundTransparency = 1
		search.Text = ''
		search.PlaceholderText = ''
		search.TextXAlignment = Enum.TextXAlignment.Left
		search.TextColor3 = uipallet.Text
		search.TextSize = 12
		search.FontFace = uipallet.Font
		search.ClearTextOnFocus = false
		search.Parent = searchbkg
		local searchcorner = Instance.new('UICorner')
		searchcorner.CornerRadius = UDim.new(0, 4)
		searchcorner.Parent = searchbkg
		local searchicon = Instance.new('ImageLabel')
		searchicon.Size = UDim2.fromOffset(14, 14)
		searchicon.Position = UDim2.new(1, -26, 0, 8)
		searchicon.BackgroundTransparency = 1
		searchicon.Image = getcustomasset('newvape/assets/new/search.png')
		searchicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		searchicon.Parent = searchbkg
		local children = Instance.new('ScrollingFrame')
		children.Name = 'Children'
		children.Size = UDim2.fromOffset(500, 240)
		children.Position = UDim2.fromOffset(144, 122)
		children.BackgroundTransparency = 1
		children.BorderSizePixel = 0
		children.ScrollBarThickness = 2
		children.ScrollBarImageTransparency = 0.75
		children.CanvasSize = UDim2.new()
		children.Parent = window
		local windowlist = Instance.new('UIGridLayout')
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.FillDirectionMaxCells = 9
		windowlist.CellSize = UDim2.fromOffset(51, 52)
		windowlist.CellPadding = UDim2.fromOffset(4, 3)
		windowlist.Parent = children
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / vape.guiscale.Scale)
		end)
		table.insert(vape.Windows, window)
	
		local function createitem(id, image)
			local slotbkg = Instance.new('TextButton')
			slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			slotbkg.Text = ''
			slotbkg.AutoButtonColor = false
			slotbkg.Parent = children
			local slotimage = Instance.new('ImageLabel')
			slotimage.Size = UDim2.fromOffset(32, 32)
			slotimage.Position = UDim2.new(0.5, -16, 0.5, -16)
			slotimage.BackgroundTransparency = 1
			slotimage.Image = image
			slotimage.Parent = slotbkg
			local slotcorner = Instance.new('UICorner')
			slotcorner.CornerRadius = UDim.new(0, 4)
			slotcorner.Parent = slotbkg
			slotbkg.MouseEnter:Connect(function()
				slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
			end)
			slotbkg.MouseLeave:Connect(function()
				slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end)
			slotbkg.MouseButton1Click:Connect(function()
				local obj = self.Hotbars[self.Selected]
				if obj then
					window['Slot'..selectedslot].ImageLabel.Image = image
					obj.Hotbar[tostring(selectedslot)] = id
					obj.Object['Slot'..selectedslot].Image = image
				end
			end)
		end
	
		local function indexSearch(text)
			for _, v in children:GetChildren() do
				if v:IsA('TextButton') then
					v:ClearAllChildren()
					v:Destroy()
				end
			end
	
			if text == '' then
				for _, v in {'diamond_sword', 'diamond_pickaxe', 'diamond_axe', 'shears', 'wood_bow', 'wool_white', 'fireball', 'apple', 'iron', 'gold', 'diamond', 'emerald'} do
					createitem(v, bedwars.ItemMeta[v].image)
				end
				return
			end
	
			for i, v in bedwars.ItemMeta do
				if text:lower() == i:lower():sub(1, text:len()) then
					if not v.image then continue end
					createitem(i, v.image)
				end
			end
		end
	
		search:GetPropertyChangedSignal('Text'):Connect(function()
			indexSearch(search.Text)
		end)
		indexSearch('')
	
		return window
	end
	
	vape.Components.HotbarList = function(optionsettings, children, api)
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		local optionapi = {
			Type = 'HotbarList',
			Hotbars = {},
			Selected = 1
		}
		local hotbarlist = Instance.new('TextButton')
		hotbarlist.Name = 'HotbarList'
		hotbarlist.Size = UDim2.fromOffset(220, 40)
		hotbarlist.BackgroundColor3 = optionsettings.Darker and (children.BackgroundColor3 == color.Dark(uipallet.Main, 0.02) and color.Dark(uipallet.Main, 0.04) or color.Dark(uipallet.Main, 0.02)) or children.BackgroundColor3
		hotbarlist.Text = ''
		hotbarlist.BorderSizePixel = 0
		hotbarlist.AutoButtonColor = false
		hotbarlist.Parent = children
		local textbkg = Instance.new('Frame')
		textbkg.Name = 'BKG'
		textbkg.Size = UDim2.new(1, -20, 0, 31)
		textbkg.Position = UDim2.fromOffset(10, 4)
		textbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		textbkg.Parent = hotbarlist
		local textbkgcorner = Instance.new('UICorner')
		textbkgcorner.CornerRadius = UDim.new(0, 4)
		textbkgcorner.Parent = textbkg
		local textbutton = Instance.new('TextButton')
		textbutton.Name = 'HotbarList'
		textbutton.Size = UDim2.new(1, -2, 1, -2)
		textbutton.Position = UDim2.fromOffset(1, 1)
		textbutton.BackgroundColor3 = uipallet.Main
		textbutton.Text = ''
		textbutton.AutoButtonColor = false
		textbutton.Parent = textbkg
		textbutton.MouseEnter:Connect(function()
			tween:Tween(textbkg, TweenInfo.new(0.2), {
				BackgroundColor3 = color.Light(uipallet.Main, 0.14)
			})
		end)
		textbutton.MouseLeave:Connect(function()
			tween:Tween(textbkg, TweenInfo.new(0.2), {
				BackgroundColor3 = color.Light(uipallet.Main, 0.034)
			})
		end)
		local textbuttoncorner = Instance.new('UICorner')
		textbuttoncorner.CornerRadius = UDim.new(0, 4)
		textbuttoncorner.Parent = textbutton
		local textbuttonicon = Instance.new('ImageLabel')
		textbuttonicon.Size = UDim2.fromOffset(12, 12)
		textbuttonicon.Position = UDim2.fromScale(0.5, 0.5)
		textbuttonicon.AnchorPoint = Vector2.new(0.5, 0.5)
		textbuttonicon.BackgroundTransparency = 1
		textbuttonicon.Image = getcustomasset('newvape/assets/new/add.png')
		textbuttonicon.ImageColor3 = Color3.fromHSV(0.46, 0.96, 0.52)
		textbuttonicon.Parent = textbutton
		local childrenlist = Instance.new('Frame')
		childrenlist.Size = UDim2.new(1, 0, 1, -40)
		childrenlist.Position = UDim2.fromOffset(0, 40)
		childrenlist.BackgroundTransparency = 1
		childrenlist.Parent = hotbarlist
		local windowlist = Instance.new('UIListLayout')
		windowlist.SortOrder = Enum.SortOrder.LayoutOrder
		windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
		windowlist.Padding = UDim.new(0, 3)
		windowlist.Parent = childrenlist
		windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			hotbarlist.Size = UDim2.fromOffset(220, math.min(43 + windowlist.AbsoluteContentSize.Y / vape.guiscale.Scale, 603))
		end)
		textbutton.MouseButton1Click:Connect(function()
			optionapi:AddHotbar()
		end)
		optionapi.Window = CreateWindow(optionapi)
	
		function optionapi:Save(savetab)
			local hotbars = {}
			for _, v in self.Hotbars do
				table.insert(hotbars, v.Hotbar)
			end
			savetab.HotbarList = {
				Selected = self.Selected,
				Hotbars = hotbars
			}
		end
	
		function optionapi:Load(savetab)
			for _, v in self.Hotbars do
				v.Object:ClearAllChildren()
				v.Object:Destroy()
				table.clear(v.Hotbar)
			end
			table.clear(self.Hotbars)
			for _, v in savetab.Hotbars do
				self:AddHotbar(v)
			end
			self.Selected = savetab.Selected or 1
		end
	
		function optionapi:AddHotbar(data)
			local hotbardata = {Hotbar = data or {}}
			table.insert(self.Hotbars, hotbardata)
			local hotbar = Instance.new('TextButton')
			hotbar.Size = UDim2.fromOffset(200, 27)
			hotbar.BackgroundColor3 = table.find(self.Hotbars, hotbardata) == self.Selected and color.Light(uipallet.Main, 0.034) or uipallet.Main
			hotbar.Text = ''
			hotbar.AutoButtonColor = false
			hotbar.Parent = childrenlist
			hotbardata.Object = hotbar
			local hotbarcorner = Instance.new('UICorner')
			hotbarcorner.CornerRadius = UDim.new(0, 4)
			hotbarcorner.Parent = hotbar
			for i = 1, 9 do
				local slot = Instance.new('ImageLabel')
				slot.Name = 'Slot'..i
				slot.Size = UDim2.fromOffset(17, 18)
				slot.Position = UDim2.fromOffset(-7 + (i * 18), 5)
				slot.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
				slot.Image = hotbardata.Hotbar[tostring(i)] and bedwars.getIcon({itemType = hotbardata.Hotbar[tostring(i)]}, true) or ''
				slot.BorderSizePixel = 0
				slot.Parent = hotbar
			end
			hotbar.MouseButton1Click:Connect(function()
				local ind = table.find(optionapi.Hotbars, hotbardata)
				if ind == optionapi.Selected then
					vape.gui.ScaledGui.ClickGui.Visible = false
					optionapi.Window.Visible = true
					for i = 1, 9 do
						optionapi.Window['Slot'..i].ImageLabel.Image = hotbardata.Hotbar[tostring(i)] and bedwars.getIcon({itemType = hotbardata.Hotbar[tostring(i)]}, true) or ''
					end
				else
					if optionapi.Hotbars[optionapi.Selected] then
						optionapi.Hotbars[optionapi.Selected].Object.BackgroundColor3 = uipallet.Main
					end
					hotbar.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
					optionapi.Selected = ind
				end
			end)
			local close = Instance.new('ImageButton')
			close.Name = 'Close'
			close.Size = UDim2.fromOffset(16, 16)
			close.Position = UDim2.new(1, -23, 0, 6)
			close.BackgroundColor3 = Color3.new(1, 1, 1)
			close.BackgroundTransparency = 1
			close.Image = getcustomasset('newvape/assets/new/closemini.png')
			close.ImageColor3 = color.Light(uipallet.Text, 0.2)
			close.ImageTransparency = 0.5
			close.AutoButtonColor = false
			close.Parent = hotbar
			local closecorner = Instance.new('UICorner')
			closecorner.CornerRadius = UDim.new(1, 0)
			closecorner.Parent = close
			close.MouseEnter:Connect(function()
				close.ImageTransparency = 0.3
				tween:Tween(close, TweenInfo.new(0.2), {
					BackgroundTransparency = 0.6
				})
			end)
			close.MouseLeave:Connect(function()
				close.ImageTransparency = 0.5
				tween:Tween(close, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				})
			end)
			close.MouseButton1Click:Connect(function()
				local ind = table.find(self.Hotbars, hotbardata)
				local obj = self.Hotbars[self.Selected]
				local obj2 = self.Hotbars[ind]
				if obj and obj2 then
					obj2.Object:ClearAllChildren()
					obj2.Object:Destroy()
					table.remove(self.Hotbars, ind)
					ind = table.find(self.Hotbars, obj)
					self.Selected = table.find(self.Hotbars, obj) or 1
				end
			end)
		end
	
		api.Options.HotbarList = optionapi
	
		return optionapi
	end
	
	local function getBlock()
		local clone = table.clone(store.inventory.inventory.items)
		table.sort(clone, function(a, b)
			return a.amount < b.amount
		end)
	
		for _, item in clone do
			local block = bedwars.ItemMeta[item.itemType].block
			if block and not block.seeThrough then
				return item
			end
		end
	end
	
	local function getCustomItem(v)
		if v == 'diamond_sword' then
			local sword = store.tools.sword
			v = sword and sword.itemType or 'wood_sword'
		elseif v == 'diamond_pickaxe' then
			local pickaxe = store.tools.stone
			v = pickaxe and pickaxe.itemType or 'wood_pickaxe'
		elseif v == 'diamond_axe' then
			local axe = store.tools.wood
			v = axe and axe.itemType or 'wood_axe'
		elseif v == 'wood_bow' then
			local bow = getBow()
			v = bow and bow.itemType or 'wood_bow'
		elseif v == 'wool_white' then
			local block = getBlock()
			v = block and block.itemType or 'wool_white'
		end
	
		return v
	end
	
	local function findItemInTable(tab, item)
		for slot, v in tab do
			if item.itemType == getCustomItem(v) then
				return tonumber(slot)
			end
		end
	end
	
	local function findInHotbar(item)
		for i, v in store.inventory.hotbar do
			if v.item and v.item.itemType == item.itemType then
				return i - 1, v.item
			end
		end
	end
	
	local function findInInventory(item)
		for _, v in store.inventory.inventory.items do
			if v.itemType == item.itemType then
				return v
			end
		end
	end
	
	local function dispatch(...)
		bedwars.Store:dispatch(...)
		vapeEvents.InventoryChanged.Event:Wait()
	end
	
	local function sortCallback()
		if Active then return end
		Active = true
		local items = (List.Hotbars[List.Selected] and List.Hotbars[List.Selected].Hotbar or {})
	
		for _, v in store.inventory.inventory.items do
			local slot = findItemInTable(items, v)
			if slot then
				local olditem = store.inventory.hotbar[slot]
				if olditem.item and olditem.item.itemType == v.itemType then continue end
				if olditem.item then
					dispatch({
						type = 'InventoryRemoveFromHotbar',
						slot = slot - 1
					})
				end
	
				local newslot = findInHotbar(v)
				if newslot then
					dispatch({
						type = 'InventoryRemoveFromHotbar',
						slot = newslot
					})
					if olditem.item then
						dispatch({
							type = 'InventoryAddToHotbar',
							item = findInInventory(olditem.item),
							slot = newslot
						})
					end
				end
	
				dispatch({
					type = 'InventoryAddToHotbar',
					item = findInInventory(v),
					slot = slot - 1
				})
			elseif Clear.Enabled then
				local newslot = findInHotbar(v)
				if newslot then
				   	dispatch({
						type = 'InventoryRemoveFromHotbar',
						slot = newslot
					})
				end
			end
		end
	
		Active = false
	end
	
	AutoHotbar = vape.Categories.Inventory:CreateModule({
		Name = 'AutoHotbar',
		Function = function(callback)
			if callback then
				task.spawn(sortCallback)
				if Mode.Value == 'On Key' then
					AutoHotbar:Toggle()
					return
				end
	
				AutoHotbar:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(sortCallback))
			end
		end,
		Tooltip = 'Automatically arranges hotbar to your liking.'
	})
	Mode = AutoHotbar:CreateDropdown({
		Name = 'Activation',
		List = {'Toggle', 'On Key'},
		Function = function()
			if AutoHotbar.Enabled then
				AutoHotbar:Toggle()
				AutoHotbar:Toggle()
			end
		end
	})
	Clear = AutoHotbar:CreateToggle({Name = 'Clear Hotbar'})
	List = AutoHotbar:CreateHotbarList({})
end)
	
run(function()
	local Value
	local oldclickhold, oldshowprogress
	
	local FastConsume = vape.Categories.Inventory:CreateModule({
		Name = 'FastConsume',
		Function = function(callback)
			if callback then
				oldclickhold = bedwars.ClickHold.startClick
				oldshowprogress = bedwars.ClickHold.showProgress
				bedwars.ClickHold.startClick = function(self)
					self.startedClickTime = tick()
					local handle = self:showProgress()
					local clicktime = self.startedClickTime
					bedwars.RuntimeLib.Promise.defer(function()
						task.wait(self.durationSeconds * (Value.Value / 40))
						if handle == self.handle and clicktime == self.startedClickTime and self.closeOnComplete then
							self:hideProgress()
							if self.onComplete then self.onComplete() end
							if self.onPartialComplete then self.onPartialComplete(1) end
							self.startedClickTime = -1
						end
					end)
				end
	
				bedwars.ClickHold.showProgress = function(self)
					local roact = debug.getupvalue(oldshowprogress, 1)
					local countdown = roact.mount(roact.createElement('ScreenGui', {}, { roact.createElement('Frame', {
						[roact.Ref] = self.wrapperRef,
						Size = UDim2.new(),
						Position = UDim2.fromScale(0.5, 0.55),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 0.8
					}, { roact.createElement('Frame', {
						[roact.Ref] = self.progressRef,
						Size = UDim2.fromScale(0, 1),
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 0.5
					}) }) }), lplr:FindFirstChild('PlayerGui'))
	
					self.handle = countdown
					local sizetween = tweenService:Create(self.wrapperRef:getValue(), TweenInfo.new(0.1), {
						Size = UDim2.fromScale(0.11, 0.005)
					})
					local countdowntween = tweenService:Create(self.progressRef:getValue(), TweenInfo.new(self.durationSeconds * (Value.Value / 100), Enum.EasingStyle.Linear), {
						Size = UDim2.fromScale(1, 1)
					})
	
					sizetween:Play()
					countdowntween:Play()
					table.insert(self.tweens, countdowntween)
					table.insert(self.tweens, sizetween)
					
					return countdown
				end
			else
				bedwars.ClickHold.startClick = oldclickhold
				bedwars.ClickHold.showProgress = oldshowprogress
				oldclickhold = nil
				oldshowprogress = nil
			end
		end,
		Tooltip = 'Use/Consume items quicker.'
	})
	Value = FastConsume:CreateSlider({
		Name = 'Multiplier',
		Min = 0,
		Max = 100
	})
end)
	
run(function()
	local FastDrop
	
	FastDrop = vape.Categories.Inventory:CreateModule({
		Name = 'FastDrop',
		Function = function(callback)
			if callback then
				repeat
					if entitylib.isAlive and (not store.inventory.opened) and (inputService:IsKeyDown(Enum.KeyCode.H) or inputService:IsKeyDown(Enum.KeyCode.Backspace)) and inputService:GetFocusedTextBox() == nil then
						task.spawn(bedwars.ItemDropController.dropItemInHand)
						task.wait()
					else
						task.wait(0.1)
					end
				until not FastDrop.Enabled
			end
		end,
		Tooltip = 'Drops items fast when you hold Q'
	})
end)
	
run(function()
	local BedPlates
	local Background
	local Color = {}
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function scanSide(self, start, tab)
		for _, side in sides do
			for i = 1, 15 do
				local block = getPlacedBlock(start + (side * i))
				if not block or block == self then break end
				if not block:GetAttribute('NoBreak') and not table.find(tab, block.Name) then
					table.insert(tab, block.Name)
				end
			end
		end
	end
	
	local function refreshAdornee(v)
		for _, obj in v.Frame:GetChildren() do
			if obj:IsA('ImageLabel') and obj.Name ~= 'Blur' then
				obj:Destroy()
			end
		end
	
		local start = v.Adornee.Position
		local alreadygot = {}
		scanSide(v.Adornee, start, alreadygot)
		scanSide(v.Adornee, start + Vector3.new(0, 0, 3), alreadygot)
		table.sort(alreadygot, function(a, b)
			return (bedwars.ItemMeta[a].block and bedwars.ItemMeta[a].block.health or 0) > (bedwars.ItemMeta[b].block and bedwars.ItemMeta[b].block.health or 0)
		end)
		v.Enabled = #alreadygot > 0
	
		for _, block in alreadygot do
			local blockimage = Instance.new('ImageLabel')
			blockimage.Size = UDim2.fromOffset(32, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars.getIcon({itemType = block}, true)
			blockimage.Parent = v.Frame
		end
	end
	
	local function Added(v)
		local billboard = Instance.new('BillboardGui')
		billboard.Parent = Folder
		billboard.Name = 'bed'
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.AlwaysOnTop = true
		billboard.ClipsDescendants = false
		billboard.Adornee = v
		local blur = addBlur(billboard)
		blur.Visible = Background.Enabled
		local frame = Instance.new('Frame')
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		frame.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
		frame.Parent = billboard
		local layout = Instance.new('UIListLayout')
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 4)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			billboard.Size = UDim2.fromOffset(math.max(layout.AbsoluteContentSize.X + 4, 36), 36)
		end)
		layout.Parent = frame
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		Reference[v] = billboard
		refreshAdornee(billboard)
	end
	
	local function refreshNear(data)
		data = data.blockRef.blockPosition * 3
		for i, v in Reference do
			if (data - i.Position).Magnitude <= 30 then
				refreshAdornee(v)
			end
		end
	end
	
	BedPlates = vape.Categories.Minigames:CreateModule({
		Name = 'BedPlates',
		Function = function(callback)
			if callback then
				for _, v in collectionService:GetTagged('bed') do 
					task.spawn(Added, v) 
				end
				BedPlates:Clean(vapeEvents.PlaceBlockEvent.Event:Connect(refreshNear))
				BedPlates:Clean(vapeEvents.BreakBlockEvent.Event:Connect(refreshNear))
				BedPlates:Clean(collectionService:GetInstanceAddedSignal('bed'):Connect(Added))
				BedPlates:Clean(collectionService:GetInstanceRemovedSignal('bed'):Connect(function(v)
					if Reference[v] then
						Reference[v]:Destroy()
						Reference[v]:ClearAllChildren()
						Reference[v] = nil
					end
				end))
			else
				table.clear(Reference)
				Folder:ClearAllChildren()
			end
		end,
		Tooltip = 'Displays blocks over the bed'
	})
	Background = BedPlates:CreateToggle({
		Name = 'Background',
		Function = function(callback)
			if Color.Object then 
				Color.Object.Visible = callback 
			end
			for _, v in Reference do
				v.Frame.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
				v.Blur.Visible = callback
			end
		end,
		Default = true
	})
	Color = BedPlates:CreateColorSlider({
		Name = 'Background Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			for _, v in Reference do
				v.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.Frame.BackgroundTransparency = 1 - opacity
			end
		end,
		Darker = true
	})
end)
	
run(function()
	local Breaker
	local Range
	local BreakSpeed
	local UpdateRate
	local Custom
	local Bed
	local LuckyBlock
	local IronOre
	local Effect
	local CustomHealth = {}
	local Animation
	local SelfBreak
	local InstantBreak
	local LimitItem
	local customlist, parts = {}, {}
	
	local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		if block:GetAttribute('NoHealthbar') then return end
		if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
			self.healthbarMaid:DoCleaning()
			self.healthbarBlockRef = blockRef
			local create = bedwars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			self.healthbarPart = part
			bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)
	
			local mounted = bedwars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('newvape/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[bedwars.Roact.Ref] = self.healthbarProgressRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)
	
			self.healthbarMaid:GiveTask(function()
				cleanCheck = false
				self.healthbarBlockRef = nil
				bedwars.Roact.unmount(mounted)
				if self.healthbarPart then
					self.healthbarPart:Destroy()
				end
				self.healthbarPart = nil
			end)
	
			bedwars.RuntimeLib.Promise.delay(5):andThen(function()
				if cleanCheck then
					self.healthbarMaid:DoCleaning()
				end
			end)
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
			Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
		}):Play()
	end
	
	local hit = 0
	
	local function attemptBreak(tab, localPosition)
		if not tab then return end
		for _, v in tab do
			if (v.Position - localPosition).Magnitude < Range.Value and bedwars.BlockController:isBlockBreakable({blockPosition = v.Position / 3}, lplr) then
				if not SelfBreak.Enabled and v:GetAttribute('PlacedByUserId') == lplr.UserId then continue end
				if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then continue end
				if LimitItem.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then continue end
	
				hit += 1
				local target, path, endpos = bedwars.breakBlock(v, Effect.Enabled, Animation.Enabled, CustomHealth.Enabled and customHealthbar or nil, InstantBreak.Enabled)
				if path then
					local currentnode = target
					for _, part in parts do
						part.Position = currentnode or Vector3.zero
						if currentnode then
							part.BoxHandleAdornment.Color3 = currentnode == endpos and Color3.new(1, 0.2, 0.2) or currentnode == target and Color3.new(0.2, 0.2, 1) or Color3.new(0.2, 1, 0.2)
						end
						currentnode = path[currentnode]
					end
				end
	
				task.wait(InstantBreak.Enabled and (store.damageBlockFail > tick() and 4.5 or 0) or BreakSpeed.Value)
	
				return true
			end
		end
	
		return false
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Nuker',
		Function = function(callback)
			if callback then
				for _ = 1, 30 do
					local part = Instance.new('Part')
					part.Anchored = true
					part.CanQuery = false
					part.CanCollide = false
					part.Transparency = 1
					part.Parent = gameCamera
					local highlight = Instance.new('BoxHandleAdornment')
					highlight.Size = Vector3.one
					highlight.AlwaysOnTop = true
					highlight.ZIndex = 1
					highlight.Transparency = 0.5
					highlight.Adornee = part
					highlight.Parent = part
					table.insert(parts, part)
				end
	
				local beds = collection('bed', Breaker)
				local luckyblock = collection('LuckyBlock', Breaker)
				local ironores = collection('iron-ore', Breaker)
				customlist = collection('block', Breaker, function(tab, obj)
					if table.find(Custom.ListEnabled, obj.Name) then
						table.insert(tab, obj)
					end
				end)
	
				repeat
					task.wait(1 / UpdateRate.Value)
					if not Breaker.Enabled then break end
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
	
						if attemptBreak(Bed.Enabled and beds, localPosition) then continue end
						if attemptBreak(customlist, localPosition) then continue end
						if attemptBreak(LuckyBlock.Enabled and luckyblock, localPosition) then continue end
						if attemptBreak(IronOre.Enabled and ironores, localPosition) then continue end
	
						for _, v in parts do
							v.Position = Vector3.zero
						end
					end
				until not Breaker.Enabled
			else
				for _, v in parts do
					v:ClearAllChildren()
					v:Destroy()
				end
				table.clear(parts)
			end
		end,
		Tooltip = 'Break blocks around you automatically'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	BreakSpeed = Breaker:CreateSlider({
		Name = 'Break speed',
		Min = 0,
		Max = 0.3,
		Default = 0.25,
		Decimal = 100,
		Suffix = 'seconds'
	})
	UpdateRate = Breaker:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	Custom = Breaker:CreateTextList({
		Name = 'Custom',
		Function = function()
			if not customlist then return end
			table.clear(customlist)
			for _, obj in store.blocks do
				if table.find(Custom.ListEnabled, obj.Name) then
					table.insert(customlist, obj)
				end
			end
		end
	})
	Bed = Breaker:CreateToggle({
		Name = 'Break Bed',
		Default = true
	})
	LuckyBlock = Breaker:CreateToggle({
		Name = 'Break Lucky Block',
		Default = true
	})
	IronOre = Breaker:CreateToggle({
		Name = 'Break Iron Ore',
		Default = true
	})
	Effect = Breaker:CreateToggle({
		Name = 'Show Healthbar & Effects',
		Function = function(callback)
			if CustomHealth.Object then
				CustomHealth.Object.Visible = callback
			end
		end,
		Default = true
	})
	CustomHealth = Breaker:CreateToggle({
		Name = 'Custom Healthbar',
		Default = true,
		Darker = true
	})
	Animation = Breaker:CreateToggle({Name = 'Animation'})
	SelfBreak = Breaker:CreateToggle({Name = 'Self Break'})
	InstantBreak = Breaker:CreateToggle({Name = 'Instant Break'})
	LimitItem = Breaker:CreateToggle({
		Name = 'Limit to items',
		Tooltip = 'Only breaks when tools are held'
	})
end)
	
run(function()
	local BedBreakEffect
	local Mode
	local List
	local NameToId = {}
	
	BedBreakEffect = vape.Legit:CreateModule({
		Name = 'Bed Break Effect',
		Function = function(callback)
			if callback then
	            BedBreakEffect:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(data)
	                firesignal(bedwars.Client:Get('BedBreakEffectTriggered').instance.OnClientEvent, {
	                    player = data.player,
	                    position = data.bedBlockPosition * 3,
	                    effectType = NameToId[List.Value],
	                    teamId = data.brokenBedTeam.id,
	                    centerBedPosition = data.bedBlockPosition * 3
	                })
	            end))
	        end
		end,
		Tooltip = 'Custom bed break effects'
	})
	local BreakEffectName = {}
	for i, v in bedwars.BedBreakEffectMeta do
		table.insert(BreakEffectName, v.name)
		NameToId[v.name] = i
	end
	table.sort(BreakEffectName)
	List = BedBreakEffect:CreateDropdown({
		Name = 'Effect',
		List = BreakEffectName
	})
end)
	
run(function()
	vape.Legit:CreateModule({
		Name = 'Clean Kit',
		Function = function(callback)
			if callback then
				bedwars.WindWalkerController.spawnOrb = function() end
				local zephyreffect = lplr.PlayerGui:FindFirstChild('WindWalkerEffect', true)
				if zephyreffect then 
					zephyreffect.Visible = false 
				end
			end
		end,
		Tooltip = 'Removes zephyr status indicator'
	})
end)
	
run(function()
	local old
	local Image
	
	local Crosshair = vape.Legit:CreateModule({
		Name = 'Crosshair',
		Function = function(callback)
			if callback then
				old = debug.getconstant(bedwars.ViewmodelController.showCrosshair, 25)
				debug.setconstant(bedwars.ViewmodelController.showCrosshair, 25, Image.Value)
				debug.setconstant(bedwars.ViewmodelController.showCrosshair, 37, Image.Value)
			else
				debug.setconstant(bedwars.ViewmodelController.showCrosshair, 25, old)
				debug.setconstant(bedwars.ViewmodelController.showCrosshair, 37, old)
				old = nil
			end
	
			if bedwars.ViewmodelController.crosshair then
				bedwars.ViewmodelController:hideCrosshair()
				bedwars.ViewmodelController:showCrosshair()
			end
		end,
		Tooltip = 'Custom first person crosshair depending on the image choosen.'
	})
	Image = Crosshair:CreateTextBox({
		Name = 'Image',
		Placeholder = 'image id (roblox)',
		Function = function(enter)
			if enter and Crosshair.Enabled then
				Crosshair:Toggle()
				Crosshair:Toggle()
			end
		end
	})
end)
	
run(function()
	local DamageIndicator
	local FontOption
	local Color
	local Size
	local Anchor
	local Stroke
	local suc, tab = pcall(function()
		return debug.getupvalue(bedwars.DamageIndicator, 2)
	end)
	tab = suc and tab or {}
	local oldvalues, oldfont = {}
	
	DamageIndicator = vape.Legit:CreateModule({
		Name = 'Damage Indicator',
		Function = function(callback)
			if callback then
				oldvalues = table.clone(tab)
				oldfont = debug.getconstant(bedwars.DamageIndicator, 86)
				debug.setconstant(bedwars.DamageIndicator, 86, Enum.Font[FontOption.Value])
				debug.setconstant(bedwars.DamageIndicator, 119, Stroke.Enabled and 'Thickness' or 'Enabled')
				tab.strokeThickness = Stroke.Enabled and 1 or false
				tab.textSize = Size.Value
				tab.blowUpSize = Size.Value
				tab.blowUpDuration = 0
				tab.baseColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				tab.blowUpCompleteDuration = 0
				tab.anchoredDuration = Anchor.Value
			else
				for i, v in oldvalues do
					tab[i] = v
				end
				debug.setconstant(bedwars.DamageIndicator, 86, oldfont)
				debug.setconstant(bedwars.DamageIndicator, 119, 'Thickness')
			end
		end,
		Tooltip = 'Customize the damage indicator'
	})
	local fontitems = {'GothamBlack'}
	for _, v in Enum.Font:GetEnumItems() do
		if v.Name ~= 'GothamBlack' then
			table.insert(fontitems, v.Name)
		end
	end
	FontOption = DamageIndicator:CreateDropdown({
		Name = 'Font',
		List = fontitems,
		Function = function(val)
			if DamageIndicator.Enabled then
				debug.setconstant(bedwars.DamageIndicator, 86, Enum.Font[val])
			end
		end
	})
	Color = DamageIndicator:CreateColorSlider({
		Name = 'Color',
		DefaultHue = 0,
		Function = function(hue, sat, val)
			if DamageIndicator.Enabled then
				tab.baseColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	Size = DamageIndicator:CreateSlider({
		Name = 'Size',
		Min = 1,
		Max = 32,
		Default = 32,
		Function = function(val)
			if DamageIndicator.Enabled then
				tab.textSize = val
				tab.blowUpSize = val
			end
		end
	})
	Anchor = DamageIndicator:CreateSlider({
		Name = 'Anchor',
		Min = 0,
		Max = 1,
		Decimal = 10,
		Function = function(val)
			if DamageIndicator.Enabled then
				tab.anchoredDuration = val
			end
		end
	})
	Stroke = DamageIndicator:CreateToggle({
		Name = 'Stroke',
		Function = function(callback)
			if DamageIndicator.Enabled then
				debug.setconstant(bedwars.DamageIndicator, 119, callback and 'Thickness' or 'Enabled')
				tab.strokeThickness = callback and 1 or false
			end
		end
	})
end)
	
run(function()
	local FOV
	local Value
	local old, old2
	
	FOV = vape.Legit:CreateModule({
		Name = 'FOV',
		Function = function(callback)
			if callback then
				old = bedwars.FovController.setFOV
				old2 = bedwars.FovController.getFOV
				bedwars.FovController.setFOV = function(self) 
					return old(self, Value.Value) 
				end
				bedwars.FovController.getFOV = function() 
					return Value.Value 
				end
			else
				bedwars.FovController.setFOV = old
				bedwars.FovController.getFOV = old2
			end
			
			bedwars.FovController:setFOV(bedwars.Store:getState().Settings.fov)
		end,
		Tooltip = 'Adjusts camera vision'
	})
	Value = FOV:CreateSlider({
		Name = 'FOV',
		Min = 30,
		Max = 120
	})
end)
	
run(function()
	local FPSBoost
	local Kill
	local Visualizer
	local effects, util = {}, {}
	
	FPSBoost = vape.Legit:CreateModule({
		Name = 'FPS Boost',
		Function = function(callback)
			if callback then
				if Kill.Enabled then
					for i, v in bedwars.KillEffectController.killEffects do
						if not i:find('Custom') then
							effects[i] = v
							bedwars.KillEffectController.killEffects[i] = {
								new = function() 
									return {
										onKill = function() end, 
										isPlayDefaultKillEffect = function() 
											return true 
										end
									} 
								end
							}
						end
					end
				end
	
				if Visualizer.Enabled then
					for i, v in bedwars.VisualizerUtils do
						util[i] = v
						bedwars.VisualizerUtils[i] = function() end
					end
				end
	
				repeat task.wait() until store.matchState ~= 0
				if not bedwars.AppController then return end
				bedwars.NametagController.addGameNametag = function() end
				for _, v in bedwars.AppController:getOpenApps() do
					if tostring(v):find('Nametag') then
						bedwars.AppController:closeApp(tostring(v))
					end
				end
			else
				for i, v in effects do 
					bedwars.KillEffectController.killEffects[i] = v 
				end
				for i, v in util do 
					bedwars.VisualizerUtils[i] = v 
				end
				table.clear(effects)
				table.clear(util)
			end
		end,
		Tooltip = 'Improves the framerate by turning off certain effects'
	})
	Kill = FPSBoost:CreateToggle({
		Name = 'Kill Effects',
		Function = function()
			if FPSBoost.Enabled then
				FPSBoost:Toggle()
				FPSBoost:Toggle()
			end
		end,
		Default = true
	})
	Visualizer = FPSBoost:CreateToggle({
		Name = 'Visualizer',
		Function = function()
			if FPSBoost.Enabled then
				FPSBoost:Toggle()
				FPSBoost:Toggle()
			end
		end,
		Default = true
	})
end)
	
run(function()
	local HitColor
	local Color
	local done = {}
	
	HitColor = vape.Legit:CreateModule({
		Name = 'Hit Color',
		Function = function(callback)
			if callback then 
				repeat
					for i, v in entitylib.List do 
						local highlight = v.Character and v.Character:FindFirstChild('_DamageHighlight_')
						if highlight then 
							if not table.find(done, highlight) then 
								table.insert(done, highlight) 
							end
							highlight.FillColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
							highlight.FillTransparency = Color.Opacity
						end
					end
					task.wait(0.1)
				until not HitColor.Enabled
			else
				for i, v in done do 
					v.FillColor = Color3.new(1, 0, 0)
					v.FillTransparency = 0.4
				end
				table.clear(done)
			end
		end,
		Tooltip = 'Customize the hit highlight options'
	})
	Color = HitColor:CreateColorSlider({
		Name = 'Color',
		DefaultOpacity = 0.4
	})
end)
	
run(function()
	vape.Legit:CreateModule({
		Name = 'HitFix',
		Function = function(callback)
			debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 23, callback and 'raycast' or 'Raycast')
			debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, callback and bedwars.QueryUtil or workspace)
		end,
		Tooltip = 'Changes the raycast function to the correct one'
	})
end)
	
run(function()
	local Interface
	local HotbarOpenInventory = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-open-inventory']).HotbarOpenInventory
	local HotbarHealthbar = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar['hotbar-healthbar']).HotbarHealthbar
	local HotbarApp = getRoactRender(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-app']).HotbarApp.render)
	local old, new = {}, {}
	
	vape:Clean(function()
		for _, v in new do
			table.clear(v)
		end
		for _, v in old do
			table.clear(v)
		end
		table.clear(new)
		table.clear(old)
	end)
	
	local function modifyconstant(func, ind, val)
		if not func then return end
		if not old[func] then old[func] = {} end
		if not new[func] then new[func] = {} end
		if not old[func][ind] then
			old[func][ind] = debug.getconstant(func, ind)
		end
		if typeof(old[func][ind]) ~= typeof(val) then return end
		new[func][ind] = val
	
		if Interface.Enabled then
			if val then
				debug.setconstant(func, ind, val)
			else
				debug.setconstant(func, ind, old[func][ind])
				old[func][ind] = nil
			end
		end
	end
	
	Interface = vape.Legit:CreateModule({
		Name = 'Interface',
		Function = function(callback)
			for i, v in (callback and new or old) do
				for i2, v2 in v do
					debug.setconstant(i, i2, v2)
				end
			end
		end,
		Tooltip = 'Customize bedwars UI'
	})
	local fontitems = {'LuckiestGuy'}
	for _, v in Enum.Font:GetEnumItems() do
		if v.Name ~= 'LuckiestGuy' then
			table.insert(fontitems, v.Name)
		end
	end
	Interface:CreateDropdown({
		Name = 'Health Font',
		List = fontitems,
		Function = function(val)
			modifyconstant(HotbarHealthbar.render, 77, val)
		end
	})
	Interface:CreateColorSlider({
		Name = 'Health Color',
		Function = function(hue, sat, val)
			modifyconstant(HotbarHealthbar.render, 16, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
			if Interface.Enabled then
				local hotbar = lplr.PlayerGui:FindFirstChild('hotbar')
				hotbar = hotbar and hotbar:FindFirstChild('HealthbarProgressWrapper', true)
				if hotbar then
					hotbar['1'].BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				end
			end
		end
	})
	Interface:CreateColorSlider({
		Name = 'Hotbar Color',
		DefaultOpacity = 0.8,
		Function = function(hue, sat, val, opacity)
			local func = oldinvrender or HotbarOpenInventory.render
			modifyconstant(debug.getupvalue(HotbarApp, 23).render, 51, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
			modifyconstant(debug.getupvalue(HotbarApp, 23).render, 58, tonumber(Color3.fromHSV(hue, sat, math.clamp(val > 0.5 and val - 0.2 or val + 0.2, 0, 1)):ToHex(), 16))
			modifyconstant(debug.getupvalue(HotbarApp, 23).render, 54, 1 - opacity)
			modifyconstant(debug.getupvalue(HotbarApp, 23).render, 55, math.clamp(1.2 - opacity, 0, 1))
			modifyconstant(func, 31, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
			modifyconstant(func, 32, math.clamp(1.2 - opacity, 0, 1))
			modifyconstant(func, 34, tonumber(Color3.fromHSV(hue, sat, math.clamp(val > 0.5 and val - 0.2 or val + 0.2, 0, 1)):ToHex(), 16))
		end
	})
end)
	
run(function()
	local KillEffect
	local Mode
	local List
	local NameToId = {}
	
	local killeffects = {
		Gravity = function(_, _, char, _)
			char:BreakJoints()
			local highlight = char:FindFirstChildWhichIsA('Highlight')
			local nametag = char:FindFirstChild('Nametag', true)
			if highlight then
				highlight:Destroy()
			end
			if nametag then
				nametag:Destroy()
			end
	
			task.spawn(function()
				local partvelo = {}
				for _, v in char:GetDescendants() do
					if v:IsA('BasePart') then
						partvelo[v.Name] = v.Velocity
					end
				end
				char.Archivable = true
				local clone = char:Clone()
				clone.Humanoid.Health = 100
				clone.Parent = workspace
				game:GetService('Debris'):AddItem(clone, 30)
				char:Destroy()
				task.wait(0.01)
				clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				clone:BreakJoints()
				task.wait(0.01)
				for _, v in clone:GetDescendants() do
					if v:IsA('BasePart') then
						local bodyforce = Instance.new('BodyForce')
						bodyforce.Force = Vector3.new(0, (workspace.Gravity - 10) * v:GetMass(), 0)
						bodyforce.Parent = v
						v.CanCollide = true
						v.Velocity = partvelo[v.Name] or Vector3.zero
					end
				end
			end)
		end,
		Lightning = function(_, _, char, _)
			char:BreakJoints()
			local highlight = char:FindFirstChildWhichIsA('Highlight')
			if highlight then
				highlight:Destroy()
			end
			local startpos = 1125
			local startcf = char.PrimaryPart.CFrame.p - Vector3.new(0, 8, 0)
			local newpos = Vector3.new((math.random(1, 10) - 5) * 2, startpos, (math.random(1, 10) - 5) * 2)
	
			for i = startpos - 75, 0, -75 do
				local newpos2 = Vector3.new((math.random(1, 10) - 5) * 2, i, (math.random(1, 10) - 5) * 2)
				if i == 0 then
					newpos2 = Vector3.zero
				end
				local part = Instance.new('Part')
				part.Size = Vector3.new(1.5, 1.5, 77)
				part.Material = Enum.Material.SmoothPlastic
				part.Anchored = true
				part.Material = Enum.Material.Neon
				part.CanCollide = false
				part.CFrame = CFrame.new(startcf + newpos + ((newpos2 - newpos) * 0.5), startcf + newpos2)
				part.Parent = workspace
				local part2 = part:Clone()
				part2.Size = Vector3.new(3, 3, 78)
				part2.Color = Color3.new(0.7, 0.7, 0.7)
				part2.Transparency = 0.7
				part2.Material = Enum.Material.SmoothPlastic
				part2.Parent = workspace
				game:GetService('Debris'):AddItem(part, 0.5)
				game:GetService('Debris'):AddItem(part2, 0.5)
				bedwars.QueryUtil:setQueryIgnored(part, true)
				bedwars.QueryUtil:setQueryIgnored(part2, true)
				if i == 0 then
					local soundpart = Instance.new('Part')
					soundpart.Transparency = 1
					soundpart.Anchored = true
					soundpart.Size = Vector3.zero
					soundpart.Position = startcf
					soundpart.Parent = workspace
					bedwars.QueryUtil:setQueryIgnored(soundpart, true)
					local sound = Instance.new('Sound')
					sound.SoundId = 'rbxassetid://6993372814'
					sound.Volume = 2
					sound.Pitch = 0.5 + (math.random(1, 3) / 10)
					sound.Parent = soundpart
					sound:Play()
					sound.Ended:Connect(function()
						soundpart:Destroy()
					end)
				end
				newpos = newpos2
			end
		end,
		Delete = function(_, _, char, _)
			char:Destroy()
		end
	}
	
	KillEffect = vape.Legit:CreateModule({
		Name = 'Kill Effect',
		Function = function(callback)
			if callback then
				for i, v in killeffects do
					bedwars.KillEffectController.killEffects['Custom'..i] = {
						new = function()
							return {
								onKill = v,
								isPlayDefaultKillEffect = function()
									return false
								end
							}
						end
					}
				end
				KillEffect:Clean(lplr:GetAttributeChangedSignal('KillEffectType'):Connect(function()
					lplr:SetAttribute('KillEffectType', Mode.Value == 'Bedwars' and NameToId[List.Value] or 'Custom'..Mode.Value)
				end))
				lplr:SetAttribute('KillEffectType', Mode.Value == 'Bedwars' and NameToId[List.Value] or 'Custom'..Mode.Value)
			else
				for i in killeffects do
					bedwars.KillEffectController.killEffects['Custom'..i] = nil
				end
				lplr:SetAttribute('KillEffectType', 'default')
			end
		end,
		Tooltip = 'Custom final kill effects'
	})
	local modes = {'Bedwars'}
	for i in killeffects do
		table.insert(modes, i)
	end
	Mode = KillEffect:CreateDropdown({
		Name = 'Mode',
		List = modes,
		Function = function(val)
			List.Object.Visible = val == 'Bedwars'
			if KillEffect.Enabled then
				lplr:SetAttribute('KillEffectType', val == 'Bedwars' and NameToId[List.Value] or 'Custom'..val)
			end
		end
	})
	local KillEffectName = {}
	for i, v in bedwars.KillEffectMeta do
		table.insert(KillEffectName, v.name)
		NameToId[v.name] = i
	end
	table.sort(KillEffectName)
	List = KillEffect:CreateDropdown({
		Name = 'Bedwars',
		List = KillEffectName,
		Function = function(val)
			if KillEffect.Enabled then
				lplr:SetAttribute('KillEffectType', NameToId[val])
			end
		end,
		Darker = true
	})
end)
	
run(function()
	local ReachDisplay
	local label
	
	ReachDisplay = vape.Legit:CreateModule({
		Name = 'Reach Display',
		Function = function(callback)
			if callback then
				repeat
					label.Text = (store.attackReachUpdate > tick() and store.attackReach or '0.00')..' studs'
					task.wait(0.4)
				until not ReachDisplay.Enabled
			end
		end,
		Size = UDim2.fromOffset(100, 41)
	})
	ReachDisplay:CreateFont({
		Name = 'Font',
		Blacklist = 'Gotham',
		Function = function(val)
			label.FontFace = val
		end
	})
	ReachDisplay:CreateColorSlider({
		Name = 'Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			label.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			label.BackgroundTransparency = 1 - opacity
		end
	})
	label = Instance.new('TextLabel')
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 0.5
	label.TextSize = 15
	label.Font = Enum.Font.Gotham
	label.Text = '0.00 studs'
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundColor3 = Color3.new()
	label.Parent = ReachDisplay.Children
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = label
end)
	
run(function()
	local SongBeats
	local List
	local FOV
	local FOVValue = {}
	local Volume
	local alreadypicked = {}
	local beattick = tick()
	local oldfov, songobj, songbpm, songtween
	
	local function choosesong()
		local list = List.ListEnabled
		if #alreadypicked >= #list then 
			table.clear(alreadypicked) 
		end
	
		if #list <= 0 then
			notif('SongBeats', 'no songs', 10)
			SongBeats:Toggle()
			return
		end
	
		local chosensong = list[math.random(1, #list)]
		if #list > 1 and table.find(alreadypicked, chosensong) then
			repeat 
				task.wait() 
				chosensong = list[math.random(1, #list)] 
			until not table.find(alreadypicked, chosensong) or not SongBeats.Enabled
		end
		if not SongBeats.Enabled then return end
	
		local split = chosensong:split('/')
		if not isfile(split[1]) then
			notif('SongBeats', 'Missing song ('..split[1]..')', 10)
			SongBeats:Toggle()
			return
		end
	
		songobj.SoundId = assetfunction(split[1])
		repeat task.wait() until songobj.IsLoaded or not SongBeats.Enabled
		if SongBeats.Enabled then
			beattick = tick() + (tonumber(split[3]) or 0)
			songbpm = 60 / (tonumber(split[2]) or 50)
			songobj:Play()
		end
	end
	
	SongBeats = vape.Legit:CreateModule({
		Name = 'Song Beats',
		Function = function(callback)
			if callback then
				songobj = Instance.new('Sound')
				songobj.Volume = Volume.Value / 100
				songobj.Parent = workspace
				repeat
					if not songobj.Playing then choosesong() end
					if beattick < tick() and SongBeats.Enabled and FOV.Enabled then
						beattick = tick() + songbpm
						oldfov = math.min(bedwars.FovController:getFOV() * (bedwars.SprintController.sprinting and 1.1 or 1), 120)
						gameCamera.FieldOfView = oldfov - FOVValue.Value
						songtween = tweenService:Create(gameCamera, TweenInfo.new(math.min(songbpm, 0.2), Enum.EasingStyle.Linear), {FieldOfView = oldfov})
						songtween:Play()
					end
					task.wait()
				until not SongBeats.Enabled
			else
				if songobj then
					songobj:Destroy()
				end
				if songtween then
					songtween:Cancel()
				end
				if oldfov then
					gameCamera.FieldOfView = oldfov
				end
				table.clear(alreadypicked)
			end
		end,
		Tooltip = 'Built in mp3 player'
	})
	List = SongBeats:CreateTextList({
		Name = 'Songs',
		Placeholder = 'filepath/bpm/start'
	})
	FOV = SongBeats:CreateToggle({
		Name = 'Beat FOV',
		Function = function(callback)
			if FOVValue.Object then
				FOVValue.Object.Visible = callback
			end
			if SongBeats.Enabled then
				SongBeats:Toggle()
				SongBeats:Toggle()
			end
		end,
		Default = true
	})
	FOVValue = SongBeats:CreateSlider({
		Name = 'Adjustment',
		Min = 1,
		Max = 30,
		Default = 5,
		Darker = true
	})
	Volume = SongBeats:CreateSlider({
		Name = 'Volume',
		Function = function(val)
			if songobj then 
				songobj.Volume = val / 100 
			end
		end,
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
end)
	
run(function()
	local SoundChanger
	local List
	local soundlist = {}
	local old
	
	SoundChanger = vape.Legit:CreateModule({
		Name = 'SoundChanger',
		Function = function(callback)
			if callback then
				old = bedwars.SoundManager.playSound
				bedwars.SoundManager.playSound = function(self, id, ...)
					if soundlist[id] then
						id = soundlist[id]
					end
	
					return old(self, id, ...)
				end
			else
				bedwars.SoundManager.playSound = old
				old = nil
			end
		end,
		Tooltip = 'Change ingame sounds to custom ones.'
	})
	List = SoundChanger:CreateTextList({
		Name = 'Sounds',
		Placeholder = '(DAMAGE_1/ben.mp3)',
		Function = function()
			table.clear(soundlist)
			for _, entry in List.ListEnabled do
				local split = entry:split('/')
				local id = bedwars.SoundList[split[1]]
				if id and #split > 1 then
					soundlist[id] = split[2]:find('rbxasset') and split[2] or isfile(split[2]) and assetfunction(split[2]) or ''
				end
			end
		end
	})
end)
	
run(function()
	local UICleanup
	local OpenInv
	local KillFeed
	local OldTabList
	local HotbarApp = getRoactRender(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-app']).HotbarApp.render)
	local HotbarOpenInventory = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-open-inventory']).HotbarOpenInventory
	local old, new = {}, {}
	local oldkillfeed
	
	vape:Clean(function()
		for _, v in new do
			table.clear(v)
		end
		for _, v in old do
			table.clear(v)
		end
		table.clear(new)
		table.clear(old)
	end)
	
	local function modifyconstant(func, ind, val)
		if not old[func] then old[func] = {} end
		if not new[func] then new[func] = {} end
		if not old[func][ind] then
			local typing = type(old[func][ind])
			if typing == 'function' or typing == 'userdata' then return end
			old[func][ind] = debug.getconstant(func, ind)
		end
		if typeof(old[func][ind]) ~= typeof(val) and val ~= nil then return end
	
		new[func][ind] = val
		if UICleanup.Enabled then
			if val then
				debug.setconstant(func, ind, val)
			else
				debug.setconstant(func, ind, old[func][ind])
				old[func][ind] = nil
			end
		end
	end
	
	UICleanup = vape.Legit:CreateModule({
		Name = 'UI Cleanup',
		Function = function(callback)
			for i, v in (callback and new or old) do
				for i2, v2 in v do
					debug.setconstant(i, i2, v2)
				end
			end
			if callback then
				if OpenInv.Enabled then
					oldinvrender = HotbarOpenInventory.render
					HotbarOpenInventory.render = function()
						return bedwars.Roact.createElement('TextButton', {Visible = false}, {})
					end
				end
	
				if KillFeed.Enabled then
					oldkillfeed = bedwars.KillFeedController.addToKillFeed
					bedwars.KillFeedController.addToKillFeed = function() end
				end
	
				if OldTabList.Enabled then
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
				end
			else
				if oldinvrender then
					HotbarOpenInventory.render = oldinvrender
					oldinvrender = nil
				end
	
				if KillFeed.Enabled then
					bedwars.KillFeedController.addToKillFeed = oldkillfeed
					oldkillfeed = nil
				end
	
				if OldTabList.Enabled then
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
				end
			end
		end,
		Tooltip = 'Cleans up the UI for kits & main'
	})
	UICleanup:CreateToggle({
		Name = 'Resize Health',
		Function = function(callback)
			modifyconstant(HotbarApp, 60, callback and 1 or nil)
			modifyconstant(debug.getupvalue(HotbarApp, 15).render, 30, callback and 1 or nil)
			modifyconstant(debug.getupvalue(HotbarApp, 23).tweenPosition, 16, callback and 0 or nil)
		end,
		Default = true
	})
	UICleanup:CreateToggle({
		Name = 'No Hotbar Numbers',
		Function = function(callback)
			local func = oldinvrender or HotbarOpenInventory.render
			modifyconstant(debug.getupvalue(HotbarApp, 23).render, 90, callback and 0 or nil)
			modifyconstant(func, 71, callback and 0 or nil)
		end,
		Default = true
	})
	OpenInv = UICleanup:CreateToggle({
		Name = 'No Inventory Button',
		Function = function(callback)
			modifyconstant(HotbarApp, 78, callback and 0 or nil)
			if UICleanup.Enabled then
				if callback then
					oldinvrender = HotbarOpenInventory.render
					HotbarOpenInventory.render = function()
						return bedwars.Roact.createElement('TextButton', {Visible = false}, {})
					end
				else
					HotbarOpenInventory.render = oldinvrender
					oldinvrender = nil
				end
			end
		end,
		Default = true
	})
	KillFeed = UICleanup:CreateToggle({
		Name = 'No Kill Feed',
		Function = function(callback)
			if UICleanup.Enabled then
				if callback then
					oldkillfeed = bedwars.KillFeedController.addToKillFeed
					bedwars.KillFeedController.addToKillFeed = function() end
				else
					bedwars.KillFeedController.addToKillFeed = oldkillfeed
					oldkillfeed = nil
				end
			end
		end,
		Default = true
	})
	OldTabList = UICleanup:CreateToggle({
		Name = 'Old Player List',
		Function = function(callback)
			if UICleanup.Enabled then
				starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, callback)
			end
		end,
		Default = true
	})
	UICleanup:CreateToggle({
		Name = 'Fix Queue Card',
		Function = function(callback)
			modifyconstant(bedwars.QueueCard.render, 15, callback and 0.1 or nil)
		end,
		Default = true
	})
end)
	
run(function()
	local Viewmodel
	local Depth
	local Horizontal
	local Vertical
	local NoBob
	local Rots = {}
	local old, oldc1
	
	Viewmodel = vape.Legit:CreateModule({
		Name = 'Viewmodel',
		Function = function(callback)
			local viewmodel = gameCamera:FindFirstChild('Viewmodel')
			if callback then
				old = bedwars.ViewmodelController.playAnimation
				oldc1 = viewmodel and viewmodel.RightHand.RightWrist.C1 or CFrame.identity
				if NoBob.Enabled then
					bedwars.ViewmodelController.playAnimation = function(self, animtype, ...)
						if bedwars.AnimationType and animtype == bedwars.AnimationType.FP_WALK then return end
						return old(self, animtype, ...)
					end
				end
	
				bedwars.InventoryViewmodelController:handleStore(bedwars.Store:getState())
				if viewmodel then
					gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
				end
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -Depth.Value)
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', Horizontal.Value)
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', Vertical.Value)
			else
				bedwars.ViewmodelController.playAnimation = old
				if viewmodel then
					viewmodel.RightHand.RightWrist.C1 = oldc1
				end
	
				bedwars.InventoryViewmodelController:handleStore(bedwars.Store:getState())
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', 0)
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', 0)
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', 0)
				old = nil
			end
		end,
		Tooltip = 'Changes the viewmodel animations'
	})
	Depth = Viewmodel:CreateSlider({
		Name = 'Depth',
		Min = 0,
		Max = 2,
		Default = 0.8,
		Decimal = 10,
		Function = function(val)
			if Viewmodel.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -val)
			end
		end
	})
	Horizontal = Viewmodel:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 2,
		Default = 0.8,
		Decimal = 10,
		Function = function(val)
			if Viewmodel.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', val)
			end
		end
	})
	Vertical = Viewmodel:CreateSlider({
		Name = 'Vertical',
		Min = -0.2,
		Max = 2,
		Default = -0.2,
		Decimal = 10,
		Function = function(val)
			if Viewmodel.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', val)
			end
		end
	})
	for _, name in {'Rotation X', 'Rotation Y', 'Rotation Z'} do
		table.insert(Rots, Viewmodel:CreateSlider({
			Name = name,
			Min = 0,
			Max = 360,
			Function = function(val)
				if Viewmodel.Enabled then
					gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
				end
			end
		}))
	end
	NoBob = Viewmodel:CreateToggle({
		Name = 'No Bobbing',
		Default = true,
		Function = function()
			if Viewmodel.Enabled then
				Viewmodel:Toggle()
				Viewmodel:Toggle()
			end
		end
	})
end)
	
run(function()
	local WinEffect
	local List
	local NameToId = {}
	
	WinEffect = vape.Legit:CreateModule({
		Name = 'WinEffect',
		Function = function(callback)
			if callback then
				WinEffect:Clean(vapeEvents.MatchEndEvent.Event:Connect(function()
					for i, v in getconnections(bedwars.Client:Get('WinEffectTriggered').instance.OnClientEvent) do
						if v.Function then
							v.Function({
								winEffectType = NameToId[List.Value],
								winningPlayer = lplr
							})
						end
					end
				end))
			end
		end,
		Tooltip = 'Allows you to select any clientside win effect'
	})
	local WinEffectName = {}
	for i, v in bedwars.WinEffectMeta do
		table.insert(WinEffectName, v.name)
		NameToId[v.name] = i
	end
	table.sort(WinEffectName)
	List = WinEffect:CreateDropdown({
		Name = 'Effects',
		List = WinEffectName
	})
end)

run(function()
	local FastPlace
	local CPS

	local old = bedwars.SharedConstants.BLOCK_PLACE_CPS

	FastPlace = vape.Categories.World:CreateModule({
		Name = 'Fast Place',
		Alias = {'CPS', 'Block'},
		Tooltip = 'Changes place delay',
		Function = function(call)
			bedwars.SharedConstants.BLOCK_PLACE_CPS = call and CPS.Value or old
		end
	})
	CPS = FastPlace:CreateSlider({
		Name = 'Cps',
		Min = 1,
		Max = 100,
		Default = 13,
		Function = function(val)
			if FastPlace.Enabled then
				bedwars.SharedConstants.BLOCK_PLACE_CPS = val
			end
		end
	})
	FastPlace:CreateButton({
		Name = 'Reset to bedwars cps',
		Function = function()
			CPS:SetValue(12)
		end
	})
end)
run(function()
	local Shaders
	local Lighting = lightingService
	local old = {
		Technology = nil,
		GlobalShadows = nil,
		SS = nil, -- HITLER,
		Bright = nil,
		EC = nil,
		EDS =  nil,
		CT = nil,
		ODA = nil,
		ESS = nil,
	}
	Shaders = vape.Legit:CreateModule({
		Name = "Shaders",
		Function = function(callback)
			if callback then
				pcall(function()
					local RS = replicatedStorage
					local folder = Instance.new("Folder")
					folder.Name = "LightingStuffThingys"
					folder.Parent = RS

					for _, v in ipairs(Lighting:GetChildren()) do
						v.Parent = folder
					end
				end)
				pcall(function()
					old.Technology = Lighting.Technology
					old.GlobalShadows = Lighting.GlobalShadows
					old.SS = Lighting.ShadowSoftness
					old.Bright = Lighting.Brightness
					old.EC = Lighting.ExposureCompensation
					old.EDS = Lighting.EnvironmentDiffuseScale
					old.ESS = Lighting.EnvironmentSpecularScale
					old.CT = Lighting.ClockTime
					old.ODA = Lighting.OutdoorAmbient
					Lighting.GlobalShadows = true
					Lighting.ShadowSoftness = 0.7
					Lighting.Brightness = 1.5
					Lighting.ExposureCompensation = -0.15
					Lighting.EnvironmentDiffuseScale = 0.6
					Lighting.EnvironmentSpecularScale = 0.4
					Lighting.ClockTime = 14
					Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 160)
					Lighting.Technology = Enum.Technology.Future
				end)

				local Bloom = Instance.new("BloomEffect")
				Bloom.Intensity = 0.45
				Bloom.Size = 32
				Bloom.Threshold = 0.9
				Bloom.Parent = Lighting

				local Color = Instance.new("ColorCorrectionEffect")
				Color.Brightness = 0.05
				Color.Contrast = -0.05
				Color.Saturation = 0.12
				Color.TintColor = Color3.fromRGB(255, 242, 230)
				Color.Parent = Lighting

				local DoF = Instance.new("DepthOfFieldEffect")
				DoF.FarIntensity = 0.15
				DoF.NearIntensity = 0
				DoF.FocusDistance = 60
				DoF.InFocusRadius = 50
				DoF.Parent = Lighting

				local Blur = Instance.new("BlurEffect")
				Blur.Size = 2
				Blur.Parent = Lighting

				local Atmosphere = Instance.new("Atmosphere")
				Atmosphere.Density = 0.35
				Atmosphere.Offset = 0.25
				Atmosphere.Glare = 0
				Atmosphere.Haze = 1.2
				Atmosphere.Color = Color3.fromRGB(245, 235, 225)
				Atmosphere.Parent = Lighting
			else
				pcall(function()
					for _, v in ipairs(lightingService:GetChildren()) do
						if v then
							v:Destroy()
						end
					end
					task.wait(0.025)
					local RS = replicatedStorage
					local folder = RS:FindFirstChild("LightingStuffThingys")
					if not folder then return end
					local children = folder:GetChildren()

					for _, v in ipairs(children) do
						v.Parent = Lighting
					end

					folder:Destroy()
				end)
				pcall(function()
					Lighting.Technology = old.Technology
					Lighting.GlobalShadows = old.GlobalShadows
					Lighting.ShadowSoftness = old.SS
					Lighting.Brightness = old.Bright
					Lighting.ExposureCompensation = old.EC
					Lighting.EnvironmentDiffuseScale = old.EDS
					Lighting.EnvironmentSpecularScale = old.ESS
					Lighting.ClockTime = old.CT
					Lighting.OutdoorAmbient = old.ODA
					task.wait(.025)
					old.Technology = nil
					old.GlobalShadows = nil
					old.SS = nil
					old.Bright = nil
					old.EC = nil
					old.EDS = nil
					old.ESS = nil
					old.CT = nil
					old.ODA = nil
				end)
			end
		end
	})
end)

run(function()
	local MouseTP
	local mode
	local pos
	local function getNearestPlayer()
		local character = lplr.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not hrp then return nil end

		local nearestPlayer = nil
		local shortestDistance = math.huge or (2^1024-1)
		local myPos = hrp.Position

		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= lplr then
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")

				if root and hum and hum.Health > 0 then
					local dist = (root.Position - myPos).Magnitude
					if dist < shortestDistance then
						nearestPlayer = player
					end
				end
			end
		end

		return nearestPlayer
	end
	local function Elektra(type)
		if type == "Mouse" then
			local rayCheck = RaycastParams.new()
			rayCheck.RespectCanCollide = true
			local ray = cloneref(lplr:GetMouse()).UnitRay
			rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
			ray = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayCheck)
			position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
			if not position then
				notif('MouseTP', 'No position found.', 5)
				MouseTP:Toggle(false)
				return
			end
			
			if bedwars.AbilityController:canUseAbility('ELECTRIC_DASH') then
				local info = TweenInfo.new(0.72,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
				local tween = tweenService:Create(entitylib.character.RootPart,info,{CFrame = CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector)})
				tween:Play()
				task.wait(0.69)
				bedwars.AbilityController:useAbility('ELECTRIC_DASH')
				MouseTP:Toggle(false)
			end
		else
			local FoundedPLR = getNearestPlayer()
			if FoundedPLR then
				local position = FoundedPLR.Character.HumanoidRootPart.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
				if not position then
					notif('MouseTP', 'No position found.', 5)
					MouseTP:Toggle(false)
					return
				end
				
				if bedwars.AbilityController:canUseAbility('ELECTRIC_DASH') then
					local info = TweenInfo.new(0.72,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
					local tween = tweenService:Create(entitylib.character.RootPart,info,{CFrame = CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector)})
					tween:Play()
					task.wait(0.69)
					bedwars.AbilityController:useAbility('ELECTRIC_DASH')
					MouseTP:Toggle(false)
				end
			end
		end
	end
	
	local function Davey(type)
		if type == "Mouse" then
			local Cannon = getItem("cannon")
			local ray = cloneref(lplr:GetMouse()).UnitRay
			local rayCheck = RaycastParams.new()
			rayCheck.RespectCanCollide = true
			rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
			ray = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayCheck)
			position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)

			if not position then
				notif('MouseTP', 'No position found.', 5,"warning")
				MouseTP:Toggle(false)
				return
			end

				
			if not Cannon then
				notif('MouseTP', 'No cannon found.', 5,"warning")
				MouseTP:Toggle(false)
				return
			end

			if not entitylib.isAlive then
				notif('MouseTP', 'Cannot locate where i am at?', 5,"warning")
				MouseTP:Toggle(false)
				return
			end
			local pos = entitylib.character.RootPart.Position
			pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
			local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
			bedwars.placeBlock(rounded, 'cannon', false)
			local block, blockpos = getPlacedBlock(rounded)
			if block then
				if block.Name == "cannon" then
					if (entitylib.character.RootPart.Position - block.Position).Magnitude < 20 then
						bedwars.Client:Get(remotes.CannonAim):SendToServer({
							cannonBlockPos = blockpos,
							lookVector = position
						})
						local broken = 0.1
						if bedwars.BlockController:calculateBlockDamage(lplr, {blockPosition = blockpos}) < block:GetAttribute('Health') then
							broken = 0.4
							bedwars.breakBlock(block, true, true)
						end
			
						task.delay(broken, function()
							for _ = 1, 3 do
								local call = bedwars.Client:Get(remotes.CannonLaunch):CallServer({cannonBlockPos = blockpos})
								if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
									humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
								if call then
									bedwars.breakBlock(block, true, true)
									break
								end
								task.wait(0.1)
							end
						end)
						MouseTP:Toggle(false)
					end
				end
			end
		else
			local Cannon = getItem("cannon")
			local FoundedPLR = getNearestPlayer()
			if FoundedPLR then
				local position = FoundedPLR.Character.HumanoidRootPart.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
				local old = nil
				if not position then
					notif('MouseTP', 'No position found.', 5)
					MouseTP:Toggle(false)
					return
				end
				if not Cannon then
					notif('MouseTP', 'No cannon found.', 5,"warning")
					MouseTP:Toggle(false)
					return
				end

				if not entitylib.isAlive then
					notif('MouseTP', 'Cannot locate where i am at?', 5,"warning")
					MouseTP:Toggle(false)
					return
				end
				local pos = entitylib.character.RootPart.Position
				pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
				local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
				bedwars.placeBlock(rounded, 'cannon', false)
				local block, blockpos = getPlacedBlock(rounded)
				if block then
					if block.Name == "cannon" then
						if (entitylib.character.RootPart.Position - block.Position).Magnitude < 20 then
							bedwars.Client:Get(remotes.CannonAim):SendToServer({
								cannonBlockPos = blockpos,
								lookVector = position
							})
							local broken = 0.1
							if bedwars.BlockController:calculateBlockDamage(lplr, {blockPosition = blockpos}) < block:GetAttribute('Health') then
								broken = 0.4
								bedwars.breakBlock(block, true, true)
							end
				
							task.delay(broken, function()
								for _ = 1, 3 do
									local call = bedwars.Client:Get(remotes.CannonLaunch):CallServer({cannonBlockPos = blockpos})
									if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
										humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
									end
									if call then
										bedwars.breakBlock(block, true, true)
										break
									end
									task.wait(0.1)
								end
							end)
							MouseTP:Toggle(false)
						end
					end
				end
			end
		end
	end

	local function Yuzi(type)
		if type == "Mouse" then
			local old = nil
			local rayCheck = RaycastParams.new()
			rayCheck.RespectCanCollide = true
			local ray = cloneref(lplr:GetMouse()).UnitRay
			rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
			ray = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayCheck)
			position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
			if not position then
				notif('MouseTP', 'No position found.', 5)
				MouseTP:Toggle(false)
				return
			end
			
			if bedwars.AbilityController:canUseAbility('dash') then
				old = bedwars.YuziController.dashForward
				bedwars.YuziController.dashForward = function(v1,v2)
					local arg = nil
					if v1 then
						arg = v1
					else
						arg = v2
					end
					if entitylib.isAlive then
						entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position,entitylib.character.RootPart.Position + arg * Vector3.new(1, 0, 1))
						entitylib.character.Humanoid.JumpHeight = 0.5
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						entitylib.character.RootPart:ApplyImpulse(CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector))
						bedwars.JumpHeightController:setJumpHeight(cloneref(game:GetService("StarterPlayer")).CharacterJumpHeight)
						bedwars.SoundManager:playSound(bedwars.SoundList.DAO_SLASH)
						local any_playAnimation_result1 = bedwars.GameAnimationUtil:playAnimation(lplr, bedwars.AnimationType.DAO_DASH)
						if any_playAnimation_result1 ~= nil then
							any_playAnimation_result1:AdjustSpeed(2.5)
						end
					end
				end
				bedwars.AbilityController:useAbility('dash',nil,{
					direction = gameCamera.CFrame.LookVector,
					origin = entitylib.character.RootPart.Position,
					weapon = store.hand.tool.Name.itemType,
				})
				task.wait(0.15)
				bedwars.YuziController.dashForward = old
				old = nil
				MouseTP:Toggle(false)
			end
		else
			local FoundedPLR = getNearestPlayer()
			if FoundedPLR then
				local position = FoundedPLR.Character.HumanoidRootPart.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
				local old = nil
				if not position then
					notif('MouseTP', 'No position found.', 5)
					MouseTP:Toggle(false)
					return
				end
				
				if bedwars.AbilityController:canUseAbility('dash') then
					old = bedwars.YuziController.dashForward
					bedwars.YuziController.dashForward = function(v1,v2)
						local arg = nil
						if v1 then
							arg = v1
						else
							arg = v2
						end
						if entitylib.isAlive then
							entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position,entitylib.character.RootPart.Position + arg * Vector3.new(1, 0, 1))
							entitylib.character.Humanoid.JumpHeight = 0.5
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							entitylib.character.RootPart:ApplyImpulse(CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector))
							bedwars.JumpHeightController:setJumpHeight(cloneref(game:GetService("StarterPlayer")).CharacterJumpHeight)
							bedwars.SoundManager:playSound(bedwars.SoundList.DAO_SLASH)
							local any_playAnimation_result1 = bedwars.GameAnimationUtil:playAnimation(lplr, bedwars.AnimationType.DAO_DASH)
							if any_playAnimation_result1 ~= nil then
								any_playAnimation_result1:AdjustSpeed(2.5)
							end
						end
					end
					bedwars.AbilityController:useAbility('dash',nil,{
						direction = gameCamera.CFrame.LookVector,
						origin = entitylib.character.RootPart.Position,
						weapon = store.hand.tool.Name.itemType,
					})
					task.wait(0.15)
					bedwars.YuziController.dashForward = old
					old = nil
					MouseTP:Toggle(false)
				end
			end
		end
	end

	local function Zar(type)
		notif('MouseTP', 'Comming soon!', 8,'warning')
		MouseTP:Toggle(false)
		return
	end

	local function Mouse(type)
		if type == "Mouse" then
			local position
			local rayCheck = RaycastParams.new()
			rayCheck.RespectCanCollide = true
			local ray = cloneref(lplr:GetMouse()).UnitRay
			rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
			ray = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayCheck)
			position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
			entitylib.character.RootPart.CFrame = CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector)
		
			if not position then
				notif('MouseTP', 'No position found.', 5)
				MouseTP:Toggle(false)
				return
			end
		else
			local FoundedPLR = getNearestPlayer()
			if FoundedPLR then
				local position = FoundedPLR.Character.HumanoidRootPart.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
				entitylib.character.RootPart.CFrame = CFrame.lookAlong(position, entitylib.character.RootPart.CFrame.LookVector)
				if not position then
					notif('MouseTP', 'No player found.', 5)
					MouseTP:Toggle(false)
					return
				end
			end
		end
		MouseTP:Toggle(false)
	end

	MouseTP = vape.Categories.Utility:CreateModule({
		Name = 'MouseTP',
		Function = function(callback)
			if not callback then return end
			if callback then
				if mode.Value == "Mouse" then
					Mouse(pos.Value)
				elseif mode.Value == "Kits" then
					if store.equippedKit == "elektra" then
						Elektra(pos.Value)
					elseif store.equippedKit == "davey" then
						Davey(pos.Value)
					elseif store.equippedKit == "dasher" then
						Yuzi(pos.Value)
					elseif store.equippedKit == "gun_blade" then
						Zar(pos.Value)
					else
						vape:CreateNotification("MouseTP", "Current kit is not supported for MouseTP", 4.5, "warning")
						MouseTP:Toggle(false)
						return
					end
				else
					Mouse()
				end
			end
		end,
	})
	mode = MouseTP:CreateDropdown({
		Name = "Mode",
		List = {'Mouse','Kits'}
	})
	pos =  MouseTP:CreateDropdown({
		Name = "Position",
		List = {'Cloeset Player', 'Mouse'}
	})
end)

run(function()
	local KitRender
    local activeConnections = {}
    local kitLabels = {}
    local updateDebounce = {}
    local retryThread = nil
    local playerMonitorThread = nil
    local processedPlayers = {}
    local UpdateRate = 0.2
    KitRender = vape.Categories.Utility:CreateModule({
        Name = "KitRender(broken dont use)",
        Function = function(callback)   
            if callback then
				repeat task.wait(0.08) until isrbxactive()
                local function createKitLabel(parent, kitImage)
                    if kitLabels[parent] then
                        kitLabels[parent]:Destroy()
                    end
                    
                    local kitLabel = Instance.new("ImageLabel")
                    kitLabel.Name = "OnyxKitIcon"
                    kitLabel.Size = UDim2.new(1, 0, 1, 0)
                    kitLabel.Position = UDim2.new(1.1, 0, 0, 0)
                    kitLabel.BackgroundTransparency = 1
                    kitLabel.Image = kitImage
                    kitLabel.Parent = parent
                    
                    kitLabels[parent] = kitLabel
                    return kitLabel
                end
                
                local function setupKitRender(obj)
                    if obj.Name == "PlayerRender" and obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Parent and obj.Parent.Parent.Parent.Parent and obj.Parent.Parent.Parent.Parent.Parent and obj.Parent.Parent.Parent.Parent.Parent.Name == "MatchDraftTeamCardRow" then
                        local Rank = obj.Parent:FindFirstChild('3')
                        if not Rank then return end
                        
                        local userId = string.match(obj.Image, "id=(%d+)")
                        if not userId then return end
                        
                        local id = tonumber(userId)
                        if not id then return end
                        
                        local plr = playersService:GetPlayerByUserId(id)
                        if not plr then return end
                        
                        local loopKey = plr.UserId
                        
                        processedPlayers[loopKey] = true
                        
                        if activeConnections[loopKey] then
                            activeConnections[loopKey]:Disconnect()
                            activeConnections[loopKey] = nil
                        end
                        
                        local function updateKit()
                            if not KitRender.Enabled then return end
                            if not Rank or not Rank.Parent then
                                if activeConnections[loopKey] then
                                    activeConnections[loopKey]:Disconnect()
                                    activeConnections[loopKey] = nil
                                end
                                if kitLabels[Rank] then
                                    kitLabels[Rank]:Destroy()
                                    kitLabels[Rank] = nil
                                end
                                return
                            end
                            
                            local kitName = plr:GetAttribute("PlayingAsKits")
                            if not kitName then
                                kitName = "none"
                            end
                            
                            local render = bedwars.BedwarsKitMeta[kitName] or bedwars.BedwarsKitMeta.none
                            
                            if kitLabels[Rank] then
                                kitLabels[Rank].Image = render.renderImage
                            else
                                createKitLabel(Rank, render.renderImage)
                            end
                        end

                        local function RefreshKitCheck()
                            if not KitRender.Enabled then return end
                            if activeConnections[loopKey] then
                                activeConnections[loopKey]:Disconnect()
                                activeConnections[loopKey] = nil
                            end							
                            if kitLabels[Rank] then
                                kitLabels[Rank]:Destroy()
                                kitLabels[Rank] = nil
                            end
                            local kitName = plr:GetAttribute("PlayingAsKits")
                            if not kitName then
                                kitName = "none"
                            end
                            
                            local render = bedwars.BedwarsKitMeta[kitName] or bedwars.BedwarsKitMeta.none
                            
                            if kitLabels[Rank] then
                                kitLabels[Rank].Image = render.renderImage
                            else
                                createKitLabel(Rank, render.renderImage)
                            end
						end

                        task.spawn(function()
							while KitRender.Enabled do
								RefreshKitCheck()
								task.wait(UpdateRate)
							end
						end)
                        
                        local connection = plr:GetAttributeChangedSignal("PlayingAsKits"):Connect(function()
                            local currentTick = tick()
                            
                            if not updateDebounce[loopKey] or (currentTick - updateDebounce[loopKey]) >= 0.1 then
                                updateDebounce[loopKey] = currentTick
                                updateKit()
                            end
                        end)
                        
                        activeConnections[loopKey] = connection
                        KitRender:Clean(connection)
                    end
                end
                
                local function setupSquadsRender()
                    local teams = lplr.PlayerGui:FindFirstChild("MatchDraftApp")
                    if not teams then
                        return false
                    end
                    
                    task.wait(0.05)
                    
                    for _, obj in teams:GetDescendants() do
                        if KitRender.Enabled then
                            task.spawn(function()
                                setupKitRender(obj)
                            end)
                        end
                    end
                    
                    KitRender:Clean(teams.DescendantAdded:Connect(function(obj)
                        if KitRender.Enabled then
                            task.wait(0.01)
                            setupKitRender(obj)
                        end
                    end))
                    
                    return true
                end
                
                playerMonitorThread = task.spawn(function()
                    while KitRender.Enabled do
                        task.wait(0.5)
                        
                        local teams = lplr.PlayerGui:FindFirstChild("MatchDraftApp")
                        if teams then
                            for _, obj in teams:GetDescendants() do
                                if obj.Name == "PlayerRender" and KitRender.Enabled then
                                    local userId = string.match(obj.Image, "id=(%d+)")
                                    if userId then
                                        local id = tonumber(userId)
                                        if id and not processedPlayers[id] then
                                            task.spawn(function()
                                                setupKitRender(obj)
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                
                task.spawn(function()
                    local success = setupSquadsRender()
                    
                    if not success then
                        retryThread = task.spawn(function()
                            while KitRender.Enabled do
                                task.wait(0.5)
                                if setupSquadsRender() then
                                    break
                                end
                            end
                        end)
                    end
                end)
            else
                if retryThread then
                    task.cancel(retryThread)
                    retryThread = nil
                end
                
                if playerMonitorThread then
                    task.cancel(playerMonitorThread)
                    playerMonitorThread = nil
                end
                
                for key, connection in pairs(activeConnections) do
                    if connection then
                        connection:Disconnect()
                    end
                    activeConnections[key] = nil
                end
                
                for parent, label in pairs(kitLabels) do
                    if label then
                        label:Destroy()
                    end
                    kitLabels[parent] = nil
                end
                
                table.clear(updateDebounce)
                table.clear(processedPlayers)
            end
        end,
        Tooltip = "Shows everyone's kit next to their rank during kit phase (squads ranked!)"
    })
end)


run(function()
    local EAW
	local Methods 
	local hiding = true
	local gui
	local beds,currentbedpos,Dashes = {}, nil, {Value  =1}
	local function create(Name,values)
		local obj = Instance.new(Name)
		for i, v in values do
			obj[i] = v
		end
		return obj
	end
	local function Reset()
		EAW:Clean(TeleportService:Teleport(game.PlaceId, lplr, TeleportService:GetLocalPlayerTeleportData()))
	end
	local function AllbedPOS()
		if workspace:FindFirstChild("MapCFrames") then
			for _, obj in ipairs(workspace:FindFirstChild("MapCFrames"):GetChildren()) do
				if string.match(obj.Name, "_bed$") then
					table.insert(beds, obj.Value.Position)
				end
			end
		end
	end
	local function UpdateCurrentBedPOS()
		if workspace:FindFirstChild("MapCFrames") then
			local currentTeam =  lplr.Character:GetAttribute("Team")
			if workspace:FindFirstChild("MapCFrames") then
				local CFRameName = tostring(currentTeam).."_bed"
				currentbedpos = workspace:FindFirstChild("MapCFrames"):FindFirstChild(CFRameName).Value.Position
			end
		end
	end
	local function closestBed(origin)
		local closest, dist
		for _, pos in ipairs(beds) do
			if pos ~= currentbedpos then
				local d = (pos - origin).Magnitude
				if not dist or d < dist then
					dist, closest = d, pos
				end
			end
		end
		return closest
	end
	local function tweenToBED3(pos,msg,oppositeTeam,Percent)
		if entitylib.isAlive then
			local oldpos = pos
			pos = pos + Vector3.new(0, 5, 0)
			local currentPosition = entitylib.character.RootPart.Position
			if (pos - currentPosition).Magnitude > 0.5 then
				if lplr.Character then
					lplr:SetAttribute('LastTeleported', 0)
				end
				local info = TweenInfo.new(0,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
				local tween = tweenService:Create(entitylib.character.RootPart,info,{CFrame = CFrame.new(pos)})
				local tween2 = tweenService:Create(entitylib.character.RootPart,info,{CFrame = CFrame.new(pos)})
				task.spawn(function() tween:Play() end)
				task.spawn(function()
					if Dashes.Value == 1 then
						Percent:SetAttribute("Percent",62)
						msg.Text = "Dashing to bypass Anti-Cheat.. (1)"
						task.wait(0.05)
						if bedwars.AbilityController:canUseAbility("ELECTRIC_DASH") then
							bedwars.AbilityController:useAbility('ELECTRIC_DASH')
						end
					elseif Dashes.Value == 2 then
						Percent:SetAttribute("Percent",62)
						msg.Text = "Dashing to bypass Anti-Cheat.. (1)"
						task.wait(0.36)
						if bedwars.AbilityController:canUseAbility("ELECTRIC_DASH") then
							bedwars.AbilityController:useAbility('ELECTRIC_DASH')
						end
						Percent:SetAttribute("Percent",72)
						msg.Text = "Dashing to bypass Anti-Cheat.. (2)"
						task.wait(0.54)
						if bedwars.AbilityController:canUseAbility("ELECTRIC_DASH") then
							bedwars.AbilityController:useAbility('ELECTRIC_DASH')
						end
					else
						Percent:SetAttribute("Percent",72)
						msg.Text = "Dashing to bypass Anti-Cheat.. (1)"
						task.wait(0.54)
						if bedwars.AbilityController:canUseAbility("ELECTRIC_DASH") then
							bedwars.AbilityController:useAbility('ELECTRIC_DASH')
							end				
						end
				end)
				task.spawn(function()
					tween.Completed:Wait()
					lplr:SetAttribute('LastTeleported', os.time())
				end)
				lplr:SetAttribute('LastTeleported', os.time())
				task.wait(0.25)
				if lplr.Character then
					task.wait(0.1235)
					lplr:SetAttribute('LastTeleported', os.time())
				end
				Percent:SetAttribute("Percent",83)
				msg.Text = `Fixing current positon {bedwars.BlockController:getBlockPosition(entitylib.character.RootPart.Position)} to {pos}.`
				task.wait(1.45)
				task.spawn(function() tween2:Play() end)
				task.spawn(function()
					tween.Completed:Wait()
					lplr:SetAttribute('LastTeleported', os.time())
					if bedwars.AbilityController:canUseAbility("ELECTRIC_DASH") then
						bedwars.AbilityController:useAbility('ELECTRIC_DASH')				
					end
				end)
				lplr:SetAttribute('LastTeleported', os.time())
				task.wait(0.25)
				if lplr.Character then
					task.wait(0.1235)
					lplr:SetAttribute('LastTeleported', os.time())
				end
				Percent:SetAttribute("Percent",99)
				msg.Text = `Nuking {oppositeTeam} bed.. `
				task.wait(0.85)
				if not Breaker.Enabled then
					Breaker:Toggle(true)
				end
				EAW:Clean(lplr.PlayerGui.NotificationApp.DescendantAdded:Connect(function(obj)
					obj:Destroy()
				end))
				EAW:Clean(lplr.PlayerGui.ChildAdded:Connect(function(obj)
					
					Percent:SetAttribute("Percent",100)
					msg.Text = 'Match ended. ReTeleporting to another Empty Game...'
					task.wait(0.5)
					if obj.Name == "WinningTeam" then
						lplr:Kick("Don't disconnect, this will auto teleport you!")
						task.wait(1)
						Reset()
					end
				end))
			end
		end
	end
	
	local function MethodThree(TooltipText,Percent)
		Percent:SetAttribute("Percent",5)
		TooltipText.Text = 'Finding all current beds positions near me...'
		task.wait(0.015825)
		AllbedPOS()
		Percent:SetAttribute("Percent",15)
		task.wait(0.1345)
		Percent:SetAttribute("Percent",35)
		TooltipText.Text = 'Founded my team\'s bed position...'
		UpdateCurrentBedPOS()
		if currentbedpos then
			task.wait(0.15)
			Percent:SetAttribute("Percent",48)
			TooltipText.Text = 'Finding other team\'s bed...'
			task.wait(.485)
			bedpos = closestBed(entitylib.character.RootPart.Position)
			if bedpos then
				Percent:SetAttribute("Percent",54)
				local bp = tostring(bedpos)
				if lplr.Team.Name == "Blue" then
						TooltipText.Text = `Founded Orange's bed at {bp}`
						tweenToBED3(bedpos,TooltipText,'Orange',Percent)
					else
						TooltipText.Text = `Founded Blue's bed at {bp}`
						tweenToBED3(bedpos,TooltipText,'Blue',Percent)
					end
				else
				if lplr.Team.Name == "Blue" then
					TooltipText.Text = 'Couldn\'t find my Orange\'s bed position? ReTeleporting...'
					lplr:Kick("Don't disconnect, this will auto teleport you!")
					task.wait(0.5)
					Reset()
				else
					TooltipText.Text = 'Couldn\'t find my Blue\'s bed position? ReTeleporting...'
					lplr:Kick("Don't disconnect, this will auto teleport you!")
					task.wait(0.5)
					Reset()
				end
			end
		else
			TooltipText.Text = 'Couldn\'t find my bed position? ReTeleporting...'
			lplr:Kick("Don't disconnect, this will auto teleport you!")
			task.wait(0.5)
			Reset()
		end
		task.spawn(function()
			EAW:Clean(playersService.PlayerAdded:Connect(function(playerToBlock)
				local NewFoundedPlayersName = playerToBlock.Name
				if playersService:FindFirstChild(NewFoundedPlayersName) then

					local RobloxGui = coreGui:WaitForChild("RobloxGui")
					local CoreGuiModules = RobloxGui:WaitForChild("Modules")
					local PlayerDropDownModule = require(CoreGuiModules:WaitForChild("PlayerDropDown"))
					PlayerDropDownModule:InitBlockListAsync()
					local BlockingUtility = PlayerDropDownModule:CreateBlockingUtility()

					
					if BlockingUtility:IsPlayerBlockedByUserId(playerToBlock.UserId) then
						return
					end
					local successfullyBlocked = BlockingUtility:BlockPlayerAsync(playerToBlock)
					if successfullyBlocked then
						TooltipText.Text = string.format("Successfully blocked %s! lobbying... ",NewFoundedPlayersName)
						task.wait(0.125)
					end
					lobby()
				end
			end))
		end)
	end

    EAW = vape.Categories.Minigames:CreateModule({
		Name = "AutoWin",
		Tooltip = 'must have elektra to use this',
		Function = function(callback) 
			if callback then
					local tips = {
						"you can always be afk while you farm...",
						"this is a tip lol...",
						'you can always sleep while afk farming...',
						'you have 2 other methods for auto farm...',
						'this is the most undetected farming and best method out here...',
						'note to bedwars dev/mods FUCK YOU...',
						'this is the improved autowin method',
						'owner of shade\'s executor is a fucking skid LMFAO',
						'nothing lmfao',
						'note to ghost the ac mod: you have a mental disorder for banning me retard',
						'the devs still havent patched elektra tp so keep abusing it'
					}
					local lastTip
					local prefix = "tip: "
					local typeSpeed = 0.085
					local eraseSpeed = 0.04
					local waitBetween = 2
					local hidden = true
					local function AccAgeHook(txt)
						task.spawn(function()
							local daysTotal = math.max(lplr.AccountAge, 1)

							local YEARS = 365
							local MONTHS = 30
							local HOURS_IN_DAY = 24

							local years = math.floor(daysTotal / YEARS)
							local remainingDays = daysTotal % YEARS

							local months = math.floor(remainingDays / MONTHS)
							local days = remainingDays % MONTHS

							local hours = daysTotal == 1 and 1 or 0
							local minutes = daysTotal == 1 and 0 or 0

							local parts = {}

							if years > 0 then
								table.insert(parts, years .. (years == 1 and " year" or " years"))
							end

							if months > 0 then
								table.insert(parts, months .. (months == 1 and " month" or " months"))
							end

							if days > 0 then
								table.insert(parts, days .. (days == 1 and " day" or " days"))
							end

							if daysTotal <= 1 then
								table.insert(parts, hours .. (hours == 1 and " hour" or " hours"))
								table.insert(parts, minutes .. " minutes")
							end

							local result = table.concat(parts, ", ")
							txt.Text = 'Account age: '..result
						end)
					end

					local function LevelCheckHook(txt)
						task.spawn(function()
							while EAW.Enabled do
								txt.Text = 'level: '..tostring(lplr:GetAttribute("PlayerLevel")) or "0"
								task.wait(0.01)
							end
						end)
					end
					
					local function LogoBGBGTween(image)
						local MAX = 0.92
						local MIN = 0.84

						local tweenInfo = TweenInfo.new(
							0.96,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.InOut
						)


						local growTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MAX
						})

						local shrinkTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MIN
						})

						task.spawn(function()
							while EAW.Enabled do
								growTween:Play()
								growTween.Completed:Wait()

								shrinkTween:Play()
								shrinkTween.Completed:Wait()
							end
						end)
					end

					local function LogoBGTween(image)
						local MAX = 0.95
						local MIN = 0.9

						local tweenInfo = TweenInfo.new(
							0.96,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.InOut
						)


						local growTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MAX
						})

						local shrinkTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MIN
						})

						task.spawn(function()
							while EAW.Enabled do
								growTween:Play()
								growTween.Completed:Wait()

								shrinkTween:Play()
								shrinkTween.Completed:Wait()
							end
						end)
					end

					local function Vig1Tween(image)
						local MAX = 1
						local MIN = 0.85

						local tweenInfo = TweenInfo.new(
							1.5,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.InOut
						)

						local growTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MAX
						})

						local shrinkTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MIN
						})

						task.spawn(function()
							while EAW.Enabled do
								growTween:Play()
								growTween.Completed:Wait()

								shrinkTween:Play()
								shrinkTween.Completed:Wait()
							end
						end)
					end

					local function Vig2Tween(image)
						local MAX = 0.98
						local MIN = 0.48

						local tweenInfo = TweenInfo.new(
							1.2,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.InOut
						)


						local growTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MAX
						})

						local shrinkTween = tweenService:Create(image, tweenInfo, {
							ImageTransparency = MIN
						})

						task.spawn(function()
							while EAW.Enabled do
								growTween:Play()
								growTween.Completed:Wait()

								shrinkTween:Play()
								shrinkTween.Completed:Wait()
							end
						end)
					end

					local function username(txt,btn)
						hidden = not hidden

						if hidden then
							txt.Text = "username: [HIDDEN]"
							btn.BackgroundColor3 = Color3.fromRGB(236, 78, 78)
							btn.Text = 'Reveal user'
						else
							txt.Text = "username: "..lplr.Name
							btn.BackgroundColor3 = Color3.fromRGB(141, 236, 78)
							btn.Text = 'Conceal user'
						end
					end

					local function playTip(txt)
						local index

						if #tips > 1 then
							repeat
								index = math.random(1, #tips)
							until index ~= lastTip
						else
							index = 1
						end

						lastTip = index
						local tipText = tips[index]

						txt.Text = prefix .. tipText
						txt.MaxVisibleGraphemes = #prefix

						for i = #prefix + 1, #prefix + #tipText do
							txt.MaxVisibleGraphemes = i
							task.wait(typeSpeed)
						end

						task.wait(1.5)

						for i = #prefix + #tipText, #prefix, -1 do
							txt.MaxVisibleGraphemes = i
							task.wait(eraseSpeed)
						end

						task.wait(waitBetween)
					end

					local function StartTips(txt)
						task.wait(2)
						task.spawn(function()
							while true do
								playTip(txt)
							end
						end)
					end

					local function PercentUpdate(txt,per,snd)
						per = math.clamp(per, 0, 100)
						txt.Text = tostring(per).."%"
						local MaxPercent = 100
						local NewPercent = (per / MaxPercent)

						local tweenInfo = TweenInfo.new(
							0.3,
							Enum.EasingStyle.Sine,
							Enum.EasingDirection.Out
						)


						local tween = tweenService:Create(snd, tweenInfo, {
							Size = UDim2.fromScale(NewPercent, 1)
						})
						tween:Play()
						tween.Completed:Connect(function()
							task.wait(.1)
							tween:Destroy()
						end)
					end

					local function hookcheck(txt,frame)
						task.spawn(function()
							txt:GetAttributeChangedSignal('Percent'):Connect(function()
								PercentUpdate(txt,txt:GetAttribute("Percent"),frame)
							end)
						end)
					end

					local AutoFarmUI = create("ScreenGui",{Name='AutowinUI',Parent=lplr.PlayerGui,IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=999})
					local MainFrame = create("Frame",{Parent=AutoFarmUI,Name='AutoFarmFrame',BackgroundColor3=Color3.fromRGB(25,25,25),Size=UDim2.fromScale(1,1)})
					local PerFrameMain = create("Frame",{BorderSizePixel=0,Parent=MainFrame,Name='LevelFrame',BackgroundColor3=Color3.fromRGB(40,40,45),Position=UDim2.new(0.5,-150,0.5,80),Size=UDim2.fromOffset(300,3),ZIndex=2})
					local PerFrameSecondary = create("Frame",{BackgroundColor3=Color3.fromRGB(215,215,215),BorderSizePixel=0,Parent=PerFrameMain,Name='Secondary',Size=UDim2.fromScale(0,1),ZIndex=3})
					local PercentText = create("TextLabel",{Name='Percent',Parent=PerFrameMain,BackgroundTransparency=1,Position=UDim2.new(0.5,-50,-26.167,50),TextColor3 = Color3.fromRGB(200, 200, 200),BackgroundColor3=Color3.fromRGB(255,255,255),Size=UDim2.fromOffset(100,20),ZIndex=2,Font=Enum.Font.Code,Text='0%',TextSize=12})
					PercentText:SetAttribute("Percent",0)
					create("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.8,Parent=PerFrameMain})
					local XPFrameTip = create("Frame",{Name='XPFrame',BackgroundTransparency=1,Position=UDim2.fromScale(0.881,0.742),Size=UDim2.fromOffset(184,219),Parent=MainFrame})
					local div = create("Frame",{Parent=XPFrameTip,Name='Divider',BackgroundColor3=Color3.fromRGB(56,56,56),Position=UDim2.fromScale(0.049,0.146),Size=UDim2.fromOffset(168,4)})
					create("UICorner",{Parent = div})
					create("TextLabel",{Name='d1',BackgroundTransparency=1,Position=UDim2.new(0.598,-110,0.288,-30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='(Day 1) > Level 9',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = XPFrameTip})
					create("TextLabel",{Name='d2',BackgroundTransparency=1,Position=UDim2.new(0.598, -110,0.438, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='(Day 2) > Level 13',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = XPFrameTip})
					create("TextLabel",{Name='d3',BackgroundTransparency=1,Position=UDim2.new(0.598, -110,0.589, -30),Size=UDim2.fromOffset(184,44),ZIndex=2,Font=Enum.Font.Code,Text='(Day 3) > Level 16',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = XPFrameTip})
					create("TextLabel",{Name='d4',BackgroundTransparency=1,Position=UDim2.new(0.598, -110,0.79, -30),Size=UDim2.fromOffset(184,43),ZIndex=2,Font=Enum.Font.Code,Text='(Day 4) > Level 19',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = XPFrameTip})
					create("TextLabel",{Name='d5',BackgroundTransparency=1,Position=UDim2.new(0.598, -110,0.986, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='(Day 5) > Level 20(Rank!)',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = XPFrameTip})
					create("TextLabel",{Name='title',BackgroundTransparency=1,Position=UDim2.new(0.598, -110,0.137, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='XP Capped Level\'s',TextColor3=Color3.fromRGB(120,120,120),TextSize=18,TextWrapped=true,Parent = XPFrameTip})
					local LogoBGBG = create("ImageLabel",{Parent=MainFrame,Name='LogoBGBG',BackgroundTransparency=1,Position=UDim2.new(0.5,-120,0.5,-170),Size=UDim2.fromOffset(240,240),Image='rbxassetid://127677235878436',ImageTransparency=0.84})
					local LogoBG = create("ImageLabel",{Parent=LogoBGBG,Name='LogoBG',BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Image='rbxassetid://127677235878436',ImageTransparency=0.95})
					local Logo = create("ImageLabel",{Parent=LogoBG,Name='Logo',BackgroundTransparency=1,Position=UDim2.new(0.5,-100,0.708,-150),Size=UDim2.fromOffset(200,200),ZIndex=2,Image='rbxassetid://127677235878436'})
					local Vig1 = create("ImageLabel",{Parent=MainFrame,Name='Vig1',BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=2,Image='rbxassetid://135131984221448',ImageTransparency=1})
					local Vig2 = create("ImageLabel",{Parent=MainFrame,Name='Vig2',BackgroundTransparency=1,Size=UDim2.fromScale(2,2),Position=UDim2.fromScale(-0.474,-0.02),Rotation=90,ZIndex=2,Image='rbxassetid://135131984221448',ImageTransparency=1})
					local AccAge = create("TextLabel",{Name='AccAge',BackgroundTransparency=1,Position=UDim2.new(0.068, -110,0.873, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='Account age: ',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = MainFrame})
					local Tip = create("TextLabel",{TextXAlignment='Left',Name='Tip',BackgroundTransparency=1,Position=UDim2.new(0.5,-300,1,-40),Size=UDim2.fromOffset(1171,20),ZIndex=2,Font=Enum.Font.Code,Text='tip: ...',TextColor3=Color3.fromRGB(130,130,130),TextSize=10,TextWrapped=true,Parent = MainFrame})
					local Tooltip = create("TextLabel",{Name='Tooltip',BackgroundTransparency=1,Position=UDim2.new(0.5,-200,0.5,100),Size=UDim2.fromOffset(400,30),ZIndex=2,Font=Enum.Font.Code,Text='...',TextColor3=Color3.fromRGB(200,200,200),TextSize=14,TextWrapped=true,Parent = MainFrame})
					local LvL = create("TextLabel",{Name='lvl',BackgroundTransparency=1,Position=UDim2.new(0.068, -110,0.949, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='level: 0',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = MainFrame})
					local Username = create("TextLabel",{Name='user',BackgroundTransparency=1,Position=UDim2.new(0.068, -110,0.911, -30),Size=UDim2.fromOffset(184,33),ZIndex=2,Font=Enum.Font.Code,Text='username: [HIDDEN]',TextColor3=Color3.fromRGB(120,120,120),TextSize=14,TextWrapped=true,Parent = MainFrame})
					local UserButton = create("TextButton",{Name='btn',TextColor3=Color3.fromRGB(255,255,255),BackgroundColor3=Color3.fromRGB(236,78,78),Position=UDim2.new(4.098, 0,0, 0),Size=UDim2.fromOffset(130,26),ZIndex=1,Font=Enum.Font.Code,Text='Reveal user',TextSize=18,Parent = Username})
					create("UICorner",{Parent = UserButton})

					UserButton.Activated:Connect(function()
						username(Username,UserButton)
					end)
					LevelCheckHook(LvL)
					AccAgeHook(AccAge)
					hookcheck(PercentText,PerFrameSecondary)
					LogoBGTween(LogoBG)
					LogoBGBGTween(LogoBGBG)
					Vig1Tween(Vig1)
					Vig2Tween(Vig2)
					StartTips(Tip)
					local num = math.floor((3 / 1.85))
					Tooltip.Text = 'checking if you are in empty game...'
					task.wait((3 / 1.85))
					if #playersService:GetChildren() ~= 1 then
						num = math.floor((6 / 3.335))
						Tooltip.Text = 'player\'s found. Teleporting to a Empty Game..'
						lplr:Kick("Don't disconnect, this will auto teleport you!")
						task.wait((6 / 3.335))
						Reset()
					else
						Tooltip.Text = 'waiting for match to start...'
						repeat task.wait(0.1) until store.equippedKit ~= '' and store.matchState ~= 0 or (not EAW.Enabled)
						MethodThree(Tooltip,PercentText)
					end
			else
				entitylib.character.Humanoid.Health = -9e9
				if lplr.PlayerGui:FindFirstChild('AutowinUI') then
					lplr.PlayerGui:FindFirstChild('AutowinUI'):Destroy()
				end
			end
		end
	})

	gui = EAW:CreateToggle({
		Name = "Gui",
		Default = true,
		Function = function(v)
			if lplr.PlayerGui:FindFirstChild('AutowinUI') then
				lplr.PlayerGui:FindFirstChild('AutowinUI').Enabled = v
			end
		end
	})
end)

run(function()
	local AutoHonor
	local Delay
	local honoredusers = {}
	local maxhonors = 2
	
	local function getTeammates()
		local teammates = {}
		local nonteammates = {}
		local myTeam = lplr.Team
		
		for i, plr in playersService:GetPlayers() do
			if plr ~= lplr then
				if plr.Team == myTeam then
					table.insert(teammates, plr)
				else
					table.insert(nonteammates, plr)
				end
			end
		end
		return teammates, nonteammates
	end
	
	local function honorPlayers()
		if #honoredusers >= maxhonors then return end
		
		local teammates, nonteammates = getTeammates()
		
		if #teammates > 0 and #honoredusers < maxhonors then
			local randomTeammate = teammates[math.random(1, #teammates)]
			if not honoredusers[randomTeammate.UserId] then
				task.wait(Delay.Value)
				bedwars.HonorController:honorPlayer(randomTeammate.UserId)
				honoredusers[randomTeammate.UserId] = true
			end
		end
		
		if #nonteammates > 0 and #honoredusers < maxhonors then
			local randomEnemy = nonteammates[math.random(1, #nonteammates)]
			if not honoredusers[randomEnemy.UserId] then
				task.wait(Delay.Value)
				bedwars.HonorController:honorPlayer(randomEnemy.UserId)
				honoredusers[randomEnemy.UserId] = true
			end
		end
	end
	
	AutoHonor = vape.Categories.Minigames:CreateModule({
		Name = "AutoHonor",
		Function = function(callback)
			if callback then
				AutoHonor:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill and deathTable.entityInstance == lplr.Character and isEveryoneDead() and store.matchState ~= 2 then
						honorPlayers()
					end
				end))
				AutoHonor:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(...)
					honorPlayers()
				end))
			else
				table.clear(honoredusers)
			end
		end
	})
	Delay = AutoHonor:CreateSlider({
		Name = 'Delay',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Default = 0.05
	})
end)

run(function()
	local KitSkins
	local Players = playersService
	local RunService = runService
	local LocalPlayer = Players.LocalPlayer
	local RS = replicatedStorage

	local CURRENT_ITEM_SKIN = "Victorious Lyla"
	local CURRENT_SKIN_TYPE = "Nightmare"

	local ok1, ItemType = pcall(function()
		return require(RS.TS.item["item-type"]).ItemType
	end)
	if not ok1 then ItemType = {} end

	local ok2, ItemSkinType = pcall(function()
		return require(RS.TS.games.bedwars["item-skin"]["item-skin-types"]).ItemSkinType
	end)
	if not ok2 then ItemSkinType = {} end

	local KitSkinCtrl
	pcall(function()
		local KC = require(RS.rbxts_include.node_modules["@easy-games"].knit.src).KnitClient
		KitSkinCtrl = bedwars.KitSkinController
	end)

	local BOW_ROT = CFrame.Angles(0, math.rad(-90), 0)
	local CROSSBOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(-360), 0)
	local LUNAR_CROSSBOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, -190, math.rad(-180))
	local VICTORIOUS_ARCHER_BOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, -52, math.rad(90))
	local VICTORIOUS_ARCHER_CROSSBOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, -190, math.rad(-180))
	local VICTORIOUS_ARCHER_HEADHUNTER_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0)
	local HEADHUNTER_ROT = CFrame.new(0.4, 0, 0) * CFrame.Angles(0, math.rad(360), 0)
	local AXE_ROT = CFrame.new(0, 0, -0.4) * CFrame.Angles(0, math.rad(90), 0)
	local PICKAXE_ROT = CFrame.new(0, 0, -0.1) * CFrame.Angles(0, math.rad(110), 0)
	local LASSO_ROT = CFrame.Angles(0, math.rad(90), 0)
	local STAFF_ROT = CFrame.Angles(0, math.rad(90), 0)
	local SWORD_ROT = CFrame.new(0, -1.7, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local HEARTBEAM_SWORD_ROT = CFrame.new(0, -1.2, 0) * CFrame.Angles(0, math.rad(0), 0)
	local LIFE_BOW_ROT = CFrame.Angles(0, math.rad(-20), 0)
	local DAO_ROT = CFrame.new(0, -1.7, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local VIC_ROT = CFrame.new(0, -1.9, 0) * CFrame.Angles(0, math.rad(360), 0)
	local HEXED_DAO_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, 160, math.rad(-180))
	local SNOW_DAO_ROT = CFrame.new(-0.2, -0.9, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local HARPOON_ROT = CFrame.new(0, -1.4, -0.15) * CFrame.Angles(0, math.rad(180), 0)
	local TRIDENT_ROT = CFrame.new(0, 0.5, 0.05) * CFrame.Angles(0, math.rad(180), 0)
	local LYLA_BOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(30, -30, 183.56)
	local LYLA_CROSSBOW_ROT = CFrame.Angles(math.rad(0), math.rad(180), math.rad(0))
	local LYLA_HEADHUNTER_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(0), 0)

	local CANNON_HAND_SCALE = 0.34
	local CANNON_PLACED_OFFSET = CFrame.new(0, -1.0, 0)
	local CANNON_TOOL_NAME = "cannon"

	local CANNON_SKIN_NAMES = {
		["Victorious Cannon"] = {
			Gold = "cannon_gold_victorious",
			Platinum = "cannon_platinum_victorious",
			Diamond = "cannon_diamond_victorious",
			Emerald = "cannon_emerald_victorious",
			Nightmare = "cannon_nightmare_victorious",
		},
		["Ghost Cannon"] = { Default = "cannon_ghost" },
		["Deep Sea Cannon"] = { Default = "cannon_deepsea" },
	}

	local CANNON_SOUND_NAMES = {
		Gold = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
		Platinum = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
		Diamond = "CANNON_FIRE_VICTORIOUS_DIAMOND",
		Emerald = "CANNON_FIRE_VICTORIOUS_EMERALD",
		Nightmare = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
	}

	local SKIN_OFFSETS = {
		["nightmare_victorious_flower_bow"] = LYLA_BOW_ROT,
		["emerald_victorious_flower_bow"] = LYLA_BOW_ROT,
		["diamond_victorious_flower_bow"] = LYLA_BOW_ROT,
		["platinum_victorious_flower_bow"] = LYLA_BOW_ROT,
		["gold_victorious_flower_bow"] = LYLA_BOW_ROT,
		["nightmare_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["emerald_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["diamond_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["platinum_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["gold_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["nightmare_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["emerald_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["diamond_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["platinum_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["gold_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_nightmare"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_emerald"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_diamond"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_platinum"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_gold"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["flower_bow_frost_queen"] = BOW_ROT,
		["tactical_crossbow_lunar_dragon"] = LUNAR_CROSSBOW_ROT,
		["life_bow_mummy"] = LIFE_BOW_ROT,
		["flower_headhunter_frost_queen"] = HEADHUNTER_ROT,
		["wood_sword_darkvalentine"] = SWORD_ROT,
		["stone_sword_darkvalentine"] = SWORD_ROT,
		["iron_sword_darkvalentine"] = SWORD_ROT,
		["diamond_sword_darkvalentine"] = SWORD_ROT,
		["emerald_sword_darkvalentine"] = SWORD_ROT,
		["wood_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["stone_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["iron_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["diamond_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["emerald_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["wood_bow_victorious_nightmare"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_emerald"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_diamond"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_platinum"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_gold"] = VICTORIOUS_ARCHER_BOW_ROT,
		["tactical_crossbow_victorious_nightmare"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_emerald"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_diamond"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_platinum"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_gold"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["life_crossbow_mummy"] = CROSSBOW_ROT,
		["life_headhunter_mummy"] = HEADHUNTER_ROT,
		["victorious_gold_triton"] = TRIDENT_ROT,
		["victorious_platinum_triton"] = TRIDENT_ROT,
		["victorious_diamond_triton"] = TRIDENT_ROT,
		["victorious_emerald_triton"] = TRIDENT_ROT,
		["victorious_nightmare_triton"] = TRIDENT_ROT,
		["demon_triton"] = HARPOON_ROT,
		["lasso_mummy"] = LASSO_ROT,
		["lasso_wrangler_reindeer_lassy"] = LASSO_ROT,
		["lasso_lifeguard"] = LASSO_ROT,
		["wood_axe_darkvalentine"] = AXE_ROT,
		["stone_axe_darkvalentine"] = AXE_ROT,
		["iron_axe_darkvalentine"] = AXE_ROT,
		["diamond_axe_darkvalentine"] = AXE_ROT,
		["wood_axe_valentine"] = AXE_ROT,
		["stone_axe_valentine"] = AXE_ROT,
		["iron_axe_valentine"] = AXE_ROT,
		["diamond_axe_valentine"] = AXE_ROT,
		["wood_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["stone_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["iron_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["diamond_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["wood_pickaxe_valentine"] = PICKAXE_ROT,
		["stone_pickaxe_valentine"] = PICKAXE_ROT,
		["iron_pickaxe_valentine"] = PICKAXE_ROT,
		["diamond_pickaxe_valentine"] = PICKAXE_ROT,
		["gold_victorious_wizard_staff"] = STAFF_ROT,
		["gold_victorious_wizard_staff_2"] = STAFF_ROT,
		["gold_victorious_wizard_staff_3"] = STAFF_ROT,
		["platinum_victorious_wizard_staff"] = STAFF_ROT,
		["platinum_victorious_wizard_staff_2"] = STAFF_ROT,
		["platinum_victorious_wizard_staff_3"] = STAFF_ROT,
		["diamond_victorious_wizard_staff"] = STAFF_ROT,
		["diamond_victorious_wizard_staff_2"] = STAFF_ROT,
		["diamond_victorious_wizard_staff_3"] = STAFF_ROT,
		["emerald_victorious_wizard_staff"] = STAFF_ROT,
		["emerald_victorious_wizard_staff_2"] = STAFF_ROT,
		["emerald_victorious_wizard_staff_3"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff_2"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff_3"] = STAFF_ROT,
		["wood_dao_victorious"] = VIC_ROT,
		["stone_dao_victorious"] = VIC_ROT,
		["iron_dao_victorious"] = VIC_ROT,
		["diamond_dao_victorious"] = VIC_ROT,
		["emerald_dao_victorious"] = VIC_ROT,
		["wood_dao_cursed"] = HEXED_DAO_ROT,
		["stone_dao_cursed"] = HEXED_DAO_ROT,
		["iron_dao_cursed"] = HEXED_DAO_ROT,
		["diamond_dao_cursed"] = HEXED_DAO_ROT,
		["emerald_dao_cursed"] = HEXED_DAO_ROT,
		["wood_dao_tiger"] = DAO_ROT,
		["stone_dao_tiger"] = DAO_ROT,
		["iron_dao_tiger"] = DAO_ROT,
		["diamond_dao_tiger"] = DAO_ROT,
		["emerald_dao_tiger"] = DAO_ROT,
		["wood_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["stone_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["iron_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["diamond_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["emerald_dao_snow_rabbit"] = SNOW_DAO_ROT,
	}

	local KIT_SKIN_MAP = {
		["Victorious Lyla"] = { Gold = "gold_victorious_lyla", Platinum = "platinum_victorious_lyla", Diamond = "diamond_victorious_lyla", Emerald = "emerald_victorious_lyla", Nightmare = "nightmare_victorious_lyla" },
		["Frost Queen Lyla"] = { Default = "flower_bee_frost_queen" },
		["Victorious Archer"] = { Gold = "archer_victorious_gold", Platinum = "archer_victorious_platinum", Diamond = "archer_victorious_diamond", Emerald = "archer_victorious_emerald", Nightmare = "archer_victorious_nightmare" },
		["Lunar Dragon Archer"] = { Default = "archer_lunar_dragon" },
		["Victorious Yuzi"] = { Default = "yuzi_victorious" },
		["Hexed Yuzi"] = { Default = "dasher_cursed" },
		["Tiger Yuzi"] = { Default = "dasher_tiger" },
		["Snow Rabbit Yuzi"] = { Default = "dasher_snow_rabbit" },
		["Victorious Zeno"] = { Gold = "gold_victorious_wizard", Platinum = "platinum_victorious_wizard", Diamond = "diamond_victorious_wizard", Emerald = "emerald_victorious_wizard", Nightmare = "nightmare_victorious_wizard" },
		["Victorious Triton"] = { Gold = "victorious_gold_triton", Platinum = "victorious_platinum_triton", Diamond = "victorious_diamond_triton", Emerald = "victorious_emerald_triton", Nightmare = "victorious_nightmare_triton" },
		["Demon Triton"] = { Default = "demon_triton" },
		["Mummy Life Bow"] = { Default = "mummy_nazar" },
		["Mummy Lasso"] = { Default = "cowgirl_mummy" },
		["Victorious Cannon"] = { Gold = "gold_victorious_davey", Platinum = "platinum_victorious_davey", Diamond = "diamond_victorious_davey", Emerald = "emerald_victorious_davey", Nightmare = "nightmare_victorious_davey" },
		["Ghost Cannon"] = { Default = "davey_ghost" },
		["Deep Sea Cannon"] = { Default = "davey_deepsea" },
	}

	local STORE_SKIN_MAP = {
		["Balloon Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.BALLOON_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.BALLOON_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.BALLOON_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.BALLOON_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.BALLOON_EMERALD_SWORD } } end,
		["Banana Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.BANANA_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.BANANA_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.BANANA_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.BANANA_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.BANANA_EMERALD_SWORD } } end,
		["Valentine Pack"] = function() return { 
			{ ItemType.WOOD_SWORD, ItemSkinType.VALENTINE_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.VALENTINE_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.VALENTINE_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.VALENTINE_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.VALENTINE_EMERALD_SWORD },
			{ ItemType.WOOD_PICKAXE, ItemSkinType.VALENTINE_WOOD_PICKAXE }, { ItemType.STONE_PICKAXE, ItemSkinType.VALENTINE_STONE_PICKAXE }, { ItemType.IRON_PICKAXE, ItemSkinType.VALENTINE_IRON_PICKAXE }, { ItemType.DIAMOND_PICKAXE, ItemSkinType.VALENTINE_DIAMOND_PICKAXE },
			{ ItemType.WOOD_AXE, ItemSkinType.VALENTINE_WOOD_AXE }, { ItemType.STONE_AXE, ItemSkinType.VALENTINE_STONE_AXE }, { ItemType.IRON_AXE, ItemSkinType.VALENTINE_IRON_AXE }, { ItemType.DIAMOND_AXE, ItemSkinType.VALENTINE_DIAMOND_AXE }
		} end,
		["Darkheart Pack"] = function() return { 
			{ ItemType.WOOD_SWORD, ItemSkinType.DARKVALENTINE_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.DARKVALENTINE_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.DARKVALENTINE_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.DARKVALENTINE_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.DARKVALENTINE_EMERALD_SWORD },
			{ ItemType.WOOD_PICKAXE, ItemSkinType.DARKVALENTINE_WOOD_PICKAXE }, { ItemType.STONE_PICKAXE, ItemSkinType.DARKVALENTINE_STONE_PICKAXE }, { ItemType.IRON_PICKAXE, ItemSkinType.DARKVALENTINE_IRON_PICKAXE }, { ItemType.DIAMOND_PICKAXE, ItemSkinType.DARKVALENTINE_DIAMOND_PICKAXE },
			{ ItemType.WOOD_AXE, ItemSkinType.DARKVALENTINE_WOOD_AXE }, { ItemType.STONE_AXE, ItemSkinType.DARKVALENTINE_STONE_AXE }, { ItemType.IRON_AXE, ItemSkinType.DARKVALENTINE_IRON_AXE }, { ItemType.DIAMOND_AXE, ItemSkinType.DARKVALENTINE_DIAMOND_AXE }
		} end,
		["Heartbeam Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.HEARTBEAM_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.HEARTBEAM_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.HEARTBEAM_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.HEARTBEAM_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.HEARTBEAM_EMERALD_SWORD } } end,
		["Mummy Life Bow"] = function() return { { ItemType.LIFE_BOW, ItemSkinType.LIFE_BOW_MUMMY }, { ItemType.LIFE_CROSSBOW, ItemSkinType.LIFE_CROSSBOW_MUMMY }, { ItemType.LIFE_HEADHUNTER, ItemSkinType.LIFE_HEADHUNTER_MUMMY } } end,
		["Mummy Lasso"] = function() return { { ItemType.LASSO, ItemSkinType.LASSO_MUMMY } } end,
	}

	local function yuziDaoMap(suffix)
		return {
			wood_dao = "wood_dao_" .. suffix,
			stone_dao = "stone_dao_" .. suffix,
			iron_dao = "iron_dao_" .. suffix,
			diamond_dao = "diamond_dao_" .. suffix,
			emerald_dao = "emerald_dao_" .. suffix,
		}
	end

	local SKIN_DATA = {
		["Victorious Lyla"] = function(t)
			local lt = t:lower()
			return {
				flower_bow = lt .. "_victorious_flower_bow",
				flower_crossbow = lt .. "_victorious_flower_crossbow",
				flower_headhunter = lt .. "_victorious_flower_headhunter",
			}
		end,
		["Frost Queen Lyla"] = function()
			return {
				flower_bow = "flower_bow_frost_queen",
				flower_crossbow = "flower_crossbow_frost_queen",
				flower_headhunter = "flower_headhunter_frost_queen",
			}
		end,
		["Victorious Archer"] = function(t)
			local lt = t:lower()
			return {
				wood_bow = "wood_bow_victorious_" .. lt,
				tactical_crossbow = "tactical_crossbow_victorious_" .. lt,
				tactical_headhunter = "tactical_headhunter_victorious_" .. lt,
			}
		end,
		["Lunar Dragon Archer"] = function()
			return {
				wood_bow = "wood_bow_lunar_dragon",
				tactical_crossbow = "tactical_crossbow_lunar_dragon",
				tactical_headhunter = "tactical_headhunter_lunar_dragon",
			}
		end,
		["Victorious Triton"] = function(t)
			return { harpoon = "victorious_" .. t:lower() .. "_triton" }
		end,
		["Demon Triton"] = function() return { harpoon = "demon_triton" } end,
		["Victorious Yuzi"] = function() return yuziDaoMap("victorious") end,
		["Hexed Yuzi"] = function() return yuziDaoMap("cursed") end,
		["Tiger Yuzi"] = function() return yuziDaoMap("tiger") end,
		["Snow Rabbit Yuzi"] = function() return yuziDaoMap("snow_rabbit") end,
		["Victorious Zeno"] = function(t)
			local lt = t:lower()
			return {
				wizard_staff = lt .. "_victorious_wizard_staff",
				wizard_staff_2 = lt .. "_victorious_wizard_staff_2",
				wizard_staff_3 = lt .. "_victorious_wizard_staff_3",
			}
		end,
		["Balloon Swords"] = function() return { wood_sword = "balloon_wood_sword", stone_sword = "balloon_stone_sword", iron_sword = "balloon_iron_sword", diamond_sword = "balloon_diamond_sword", emerald_sword = "balloon_emerald_sword" } end,
		["Banana Swords"] = function() return { wood_sword = "banana_wood_sword", stone_sword = "banana_stone_sword", iron_sword = "banana_iron_sword", diamond_sword = "banana_diamond_sword", emerald_sword = "banana_emerald_sword" } end,
		["Valentine Pack"] = function() return { 
			wood_sword = "wood_sword_valentine", stone_sword = "stone_sword_valentine", iron_sword = "iron_sword_valentine", diamond_sword = "diamond_sword_valentine", emerald_sword = "emerald_sword_valentine",
			wood_pickaxe = "wood_pickaxe_valentine", stone_pickaxe = "stone_pickaxe_valentine", iron_pickaxe = "iron_pickaxe_valentine", diamond_pickaxe = "diamond_pickaxe_valentine",
			wood_axe = "wood_axe_valentine", stone_axe = "stone_axe_valentine", iron_axe = "iron_axe_valentine", diamond_axe = "diamond_axe_valentine"
		} end,
		["Darkheart Pack"] = function() return { 
			wood_sword = "wood_sword_darkvalentine", stone_sword = "stone_sword_darkvalentine", iron_sword = "iron_sword_darkvalentine", diamond_sword = "diamond_sword_darkvalentine", emerald_sword = "emerald_sword_darkvalentine",
			wood_pickaxe = "wood_pickaxe_darkvalentine", stone_pickaxe = "stone_pickaxe_darkvalentine", iron_pickaxe = "iron_pickaxe_darkvalentine", diamond_pickaxe = "diamond_pickaxe_darkvalentine",
			wood_axe = "wood_axe_darkvalentine", stone_axe = "stone_axe_darkvalentine", iron_axe = "iron_axe_darkvalentine", diamond_axe = "diamond_axe_darkvalentine"
		} end,
		["Heartbeam Swords"] = function() return { wood_sword = "wood_sword_heartbeam", stone_sword = "stone_sword_heartbeam", iron_sword = "iron_sword_heartbeam", diamond_sword = "diamond_sword_heartbeam", emerald_sword = "emerald_sword_heartbeam" } end,
		["Mummy Lasso"] = function() return { lasso = "lasso_mummy" } end,
		["Mummy Life Bow"] = function() return { life_bow = "life_bow_mummy", life_crossbow = "life_crossbow_mummy", life_headhunter = "life_headhunter_mummy" } end,
	}

	local TIERED_SKINS = {
		["Victorious Lyla"] = true,
		["Victorious Archer"] = true,
		["Victorious Zeno"] = true,
		["Victorious Triton"] = true,
		["Victorious Cannon"] = true,
	}

	local function normalizeName(s)
		return s:lower():gsub("[_%s%-]", "")
	end

	local function isCannonSkin()
		return CANNON_SKIN_NAMES[CURRENT_ITEM_SKIN] ~= nil
	end

	local function getCurrentCannonSkinName()
		local tbl = CANNON_SKIN_NAMES[CURRENT_ITEM_SKIN]
		if not tbl then return nil end
		return tbl[CURRENT_SKIN_TYPE] or tbl.Default
	end

	local function getCannonSkinSource(skinName)
		local assets = RS:FindFirstChild("Assets")
		if not assets then return nil end
		local blocks = assets:FindFirstChild("Blocks")
		if not blocks then return nil end
		return blocks:FindFirstChild(skinName)
	end

	local function keepOriginalInvisible(tool)
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not tool or not tool.Parent then
				conn:Disconnect()
				return
			end
			for _, d in ipairs(tool:GetDescendants()) do
				if d:IsA("BasePart") and not d:IsDescendantOf(tool:FindFirstChild("LOCAL_ITEM_RESKIN") or game) then
					d.LocalTransparencyModifier = 1
					d.Transparency = 1
				elseif (d:IsA("Decal") or d:IsA("Texture")) and not d:IsDescendantOf(tool:FindFirstChild("LOCAL_ITEM_RESKIN") or game) then
					d.Transparency = 1
				end
			end
		end)
		table.insert(connections, conn)
	end

	local function getCurrentMappings()
		local fn = SKIN_DATA[CURRENT_ITEM_SKIN]
		if not fn then return {} end
		return fn(CURRENT_SKIN_TYPE) or {}
	end

	local function getKitSkinValue()
		local m = KIT_SKIN_MAP[CURRENT_ITEM_SKIN]
		if not m then return nil end
		return m[CURRENT_SKIN_TYPE] or m.Default
	end

	local function getStoreSkins()
		local fn = STORE_SKIN_MAP[CURRENT_ITEM_SKIN]
		if not fn then return {} end
		return fn() or {}
	end

	local tagged = setmetatable({}, { __mode = "k" })
	local connections = {}
	local oldGetKitSkin = nil
	local savedStoreSkins = {}

	local cannonTagged = setmetatable({}, { __mode = "k" })
	local cannonConnections = {}
	local cannonRenderConns = {}
	local oldFireCannon, oldLaunchSelf
	local soundsHooked = false

	local function firstBasePart(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then return d end
		end
	end

	local function makeInvisible(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then
				d.LocalTransparencyModifier = 1
				d.Transparency = 1
			elseif d:IsA("Decal") or d:IsA("Texture") then
				d.Transparency = 1
			end
		end
	end

	local function restoreVisibility(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then
				d.LocalTransparencyModifier = 0
				d.Transparency = 0
			elseif d:IsA("Decal") or d:IsA("Texture") then
				d.Transparency = 0
			end
		end
	end

	local function setNoCollide(model)
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
				d.Massless = true
				d.Anchored = false
			end
		end
	end

	local function weldAllTo(anchor, container)
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("BasePart") and d ~= anchor then
				local wc = Instance.new("WeldConstraint")
				wc.Part0 = anchor
				wc.Part1 = d
				wc.Parent = anchor
			end
		end
	end

	local function attachReskin(tool, skinName)
		if not tool or tagged[tool] then return end
		tagged[tool] = true

		local origHandle = tool:FindFirstChild("Handle")
		if not (origHandle and origHandle:IsA("BasePart")) then
			origHandle = firstBasePart(tool)
		end
		if not origHandle then tagged[tool] = nil; return end

		local itemsFolder = RS:FindFirstChild("Items")
		if not itemsFolder then tagged[tool] = nil; return end
		local source = itemsFolder:FindFirstChild(skinName)
		if not source then tagged[tool] = nil; return end

		makeInvisible(tool)

		local clone = source:Clone()
		clone.Name = "LOCAL_ITEM_RESKIN"
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				pcall(d.Destroy, d)
			end
		end

		setNoCollide(clone)
		clone.Parent = tool

		local cloneAnchor = clone:FindFirstChild("Handle")
		if not (cloneAnchor and cloneAnchor:IsA("BasePart")) then
			if clone:IsA("Model") then
				if not clone.PrimaryPart then
					local p = firstBasePart(clone)
					if p then pcall(function() clone.PrimaryPart = p end) end
				end
				cloneAnchor = clone.PrimaryPart
			end
			cloneAnchor = cloneAnchor or firstBasePart(clone)
		end

		if not cloneAnchor then
			clone:Destroy(); restoreVisibility(tool); tagged[tool] = nil; return
		end

		pcall(function() cloneAnchor.CFrame = origHandle.CFrame end)
		weldAllTo(cloneAnchor, clone)

		local w = Instance.new("Weld")
		w.Part0 = origHandle
		w.Part1 = cloneAnchor
		w.C0 = SKIN_OFFSETS[skinName] or CFrame.identity
		w.C1 = CFrame.identity
		w.Parent = cloneAnchor
	end

	local function weldAllToPrimary(model)
		local primary = model.PrimaryPart
		if not primary then return end
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") and d ~= primary then
				local wc = Instance.new("WeldConstraint")
				wc.Part0 = primary
				wc.Part1 = d
				wc.Parent = primary
			end
		end
	end

	local function attachCannonReskin(targetRoot, posOffset, heldScale)
		if not targetRoot or cannonTagged[targetRoot] then return end
		cannonTagged[targetRoot] = true

		local targetPart = targetRoot:FindFirstChild("Handle")
		if not (targetPart and targetPart:IsA("BasePart")) then
			targetPart = firstBasePart(targetRoot)
		end
		if not targetPart then cannonTagged[targetRoot] = nil; return end

		local skinName = getCurrentCannonSkinName()
		if not skinName then cannonTagged[targetRoot] = nil; return end
		local source = getCannonSkinSource(skinName)
		if not source then cannonTagged[targetRoot] = nil; return end

		makeInvisible(targetRoot)

		local clone = source:Clone()
		clone.Name = "LOCAL_CANNON_RESKIN"
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				pcall(d.Destroy, d)
			end
		end

		if not clone:IsA("Model") then
			setNoCollide(clone)
			clone.Parent = targetRoot
			return
		end

		if not clone.PrimaryPart then
			local p = firstBasePart(clone)
			if p then pcall(function() clone.PrimaryPart = p end) end
		end
		if not clone.PrimaryPart then
			clone:Destroy(); cannonTagged[targetRoot] = nil; return
		end

		if heldScale and heldScale ~= 1 then
			pcall(function() clone:ScaleTo(heldScale) end)
		end

		setNoCollide(clone)
		clone.Parent = targetRoot

		local offset = posOffset or CFrame.identity
		pcall(function() clone:PivotTo(targetPart.CFrame * offset) end)

		weldAllToPrimary(clone)

		local wc = Instance.new("WeldConstraint")
		wc.Part0 = targetPart
		wc.Part1 = clone.PrimaryPart
		wc.Parent = clone.PrimaryPart
	end

	local function hookCannonThirdPerson(character)
		local function onChildAdded(child)
			if not (child:IsA("Tool") and child.Name == CANNON_TOOL_NAME) then return end
			task.wait()

			local handle = child:FindFirstChild("Handle") or firstBasePart(child)
			if not handle then return end

			local existing = child:FindFirstChild("LOCAL_CANNON_RESKIN")
			if existing then existing:Destroy(); cannonTagged[child] = nil end

			attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)

			local start = time()
			local conn
			conn = RunService.RenderStepped:Connect(function()
				if not child.Parent then conn:Disconnect(); return end
				makeInvisible(child)
				if time() - start > 3 then conn:Disconnect() end
			end)
			table.insert(cannonRenderConns, conn)
		end

		for _, c in ipairs(character:GetChildren()) do onChildAdded(c) end
		local conn = character.ChildAdded:Connect(onChildAdded)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonViewmodel()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local function hookVM(vm)
			for _, child in ipairs(vm:GetChildren()) do
				if child.Name == CANNON_TOOL_NAME then
					attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
				end
			end
			local conn = vm.ChildAdded:Connect(function(child)
				if child.Name == CANNON_TOOL_NAME then
					task.wait()
					attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
				end
			end)
			table.insert(cannonConnections, conn)
		end
		local vm = cam:FindFirstChild("Viewmodel")
		if vm then hookVM(vm) end
		local conn = cam.ChildAdded:Connect(function(child)
			if child.Name == "Viewmodel" then task.wait(); hookVM(child) end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonContainer(container)
		if not container then return end
		for _, child in ipairs(container:GetChildren()) do
			if child.Name == CANNON_TOOL_NAME then
				attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
			end
		end
		local conn = container.ChildAdded:Connect(function(child)
			if child.Name == CANNON_TOOL_NAME then
				task.wait()
				attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
			end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonBlocksFolder(blocksFolder)
		for _, child in ipairs(blocksFolder:GetChildren()) do
			if child.Name == CANNON_TOOL_NAME then
				attachCannonReskin(child, CANNON_PLACED_OFFSET, 1)
			end
		end
		local conn = blocksFolder.ChildAdded:Connect(function(child)
			if child.Name == CANNON_TOOL_NAME then
				task.wait()
				attachCannonReskin(child, CANNON_PLACED_OFFSET, 1)
			end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookAllWorldCannons()
		local map = workspace:FindFirstChild("Map")
		if not map then return end
		local worlds = map:FindFirstChild("Worlds")
		if not worlds then return end
		for _, world in ipairs(worlds:GetChildren()) do
			local blocks = world:FindFirstChild("Blocks")
			if blocks then hookCannonBlocksFolder(blocks) end
		end
		local conn = worlds.ChildAdded:Connect(function(world)
			task.wait()
			local blocks = world:FindFirstChild("Blocks")
			if blocks then hookCannonBlocksFolder(blocks) end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonSounds()
		if soundsHooked then return end
		if not (bedwars and bedwars.CannonHandController) then return end
		soundsHooked = true
		oldFireCannon = bedwars.CannonHandController.fireCannon
		oldLaunchSelf = bedwars.CannonHandController.launchSelf

		local function replaceSound()
			for _, v in ipairs(workspace.SoundPool:GetChildren()) do
				if v:IsA("Sound") and v.SoundId == "rbxassetid://7121064180" then v:Destroy() end
			end
			local key = CANNON_SOUND_NAMES[CURRENT_SKIN_TYPE] or CANNON_SOUND_NAMES.Nightmare
			if bedwars.SoundManager and bedwars.SoundList and bedwars.SoundList[key] then
				bedwars.SoundManager:playSound(bedwars.SoundList[key])
			end
		end

		bedwars.CannonHandController.fireCannon = function(...) replaceSound(); return oldFireCannon(...) end
		bedwars.CannonHandController.launchSelf = function(...) replaceSound(); return oldLaunchSelf(...) end
	end

	local function unhookCannonSounds()
		if soundsHooked and bedwars and bedwars.CannonHandController then
			if oldFireCannon then bedwars.CannonHandController.fireCannon = oldFireCannon end
			if oldLaunchSelf then bedwars.CannonHandController.launchSelf = oldLaunchSelf end
		end
		oldFireCannon = nil; oldLaunchSelf = nil; soundsHooked = false
	end

	local function cleanupCannons()
		for _, c in pairs(cannonConnections) do pcall(function() c:Disconnect() end) end
		for _, c in pairs(cannonRenderConns) do pcall(function() c:Disconnect() end) end
		table.clear(cannonConnections)
		table.clear(cannonRenderConns)

		for root in pairs(cannonTagged) do
			if root and root.Parent then
				local r = root:FindFirstChild("LOCAL_CANNON_RESKIN")
				if r then r:Destroy() end
				restoreVisibility(root)
			end
		end
		table.clear(cannonTagged)

		local map = workspace:FindFirstChild("Map")
		if map then
			local worlds = map:FindFirstChild("Worlds")
			if worlds then
				for _, world in ipairs(worlds:GetChildren()) do
					local blocks = world:FindFirstChild("Blocks")
					if blocks then
						for _, child in ipairs(blocks:GetChildren()) do
							if child.Name == CANNON_TOOL_NAME then
								local r = child:FindFirstChild("LOCAL_CANNON_RESKIN")
								if r then r:Destroy() end
								restoreVisibility(child)
							end
						end
					end
				end
			end
		end

		unhookCannonSounds()
	end

	local function applyKitSkinHook()
		if not KitSkinCtrl then return end
		local val = getKitSkinValue()
		if not val then return end
		if not oldGetKitSkin then oldGetKitSkin = KitSkinCtrl.getKitSkin end
		KitSkinCtrl.getKitSkin = function(self, char)
			if char == LocalPlayer.Character then return val end
			return oldGetKitSkin(self, char)
		end
	end

	local function removeKitSkinHook()
		if KitSkinCtrl and oldGetKitSkin then
			KitSkinCtrl.getKitSkin = oldGetKitSkin
			oldGetKitSkin = nil
		end
	end

	local function applyStoreSkins()
		if not (bedwars and bedwars.Store) then return end
		local skins = getStoreSkins()
		savedStoreSkins = {}
		local state = bedwars.Store:getState()
		for _, pair in ipairs(skins) do
			if pair[1] and pair[2] then
				local prev = state.Locker and state.Locker.selectedItemSkins and state.Locker.selectedItemSkins[pair[1]]
				table.insert(savedStoreSkins, { pair[1], prev })
				pcall(function() bedwars.Store:dispatch({ type = "LockerSetItemSkin", itemType = pair[1], itemSkin = pair[2] }) end)
			end
		end
	end

	local function clearStoreSkins()
		if not (bedwars and bedwars.Store) then return end
		for _, saved in ipairs(savedStoreSkins) do
			pcall(function() bedwars.Store:dispatch({ type = "LockerSetItemSkin", itemType = saved[1], itemSkin = saved[2] }) end)
		end
		savedStoreSkins = {}
	end

	local function tryApply(child)
		if isCannonSkin() then return end
		local mappings = getCurrentMappings()

		local skinName = mappings[child.Name:lower()]

		if not skinName then
			local childNorm = normalizeName(child.Name)
			for k, v in pairs(mappings) do
				if normalizeName(k) == childNorm then skinName = v; break end
			end
		end

		if not skinName then return end
		task.wait()
		if child.Parent then attachReskin(child, skinName) end
	end

	local function hookViewmodel()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local function hookVM(vm)
			for _, child in ipairs(vm:GetChildren()) do tryApply(child) end
			table.insert(connections, vm.ChildAdded:Connect(tryApply))
		end
		local vm = cam:FindFirstChild("Viewmodel")
		if vm then hookVM(vm) end
		table.insert(connections, cam.ChildAdded:Connect(function(child)
			if child.Name == "Viewmodel" then task.wait(); hookVM(child) end
		end))
	end

	local function hookContainer(container)
		if not container then return end
		for _, child in ipairs(container:GetChildren()) do tryApply(child) end
		table.insert(connections, container.ChildAdded:Connect(tryApply))
	end

	local function onCharacterAdded(character)
		task.wait(0.2)
		applyKitSkinHook()
		if isCannonSkin() then
			hookCannonContainer(LocalPlayer.Backpack)
			hookCannonContainer(character)
			hookCannonThirdPerson(character)
		else
			hookContainer(LocalPlayer.Backpack)
			hookContainer(character)
		end
	end

	local function cleanup()
		for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
		table.clear(connections)
		for root in pairs(tagged) do
			if root and root.Parent then
				local r = root:FindFirstChild("LOCAL_ITEM_RESKIN")
				if r then r:Destroy() end
				restoreVisibility(root)
			end
		end
		table.clear(tagged)
		removeKitSkinHook()
		clearStoreSkins()
		cleanupCannons()
	end

	local skinNames = {}
	for name in pairs(SKIN_DATA) do table.insert(skinNames, name) end
	for name in pairs(CANNON_SKIN_NAMES) do table.insert(skinNames, name) end
	table.sort(skinNames)

	local SkinTypeDropdown

	KitSkins = vape.Categories.Render:CreateModule({
		Name = "KitSkins",
		Function = function(enabled)
			if enabled then
				if isCannonSkin() then
					hookCannonViewmodel()
					hookAllWorldCannons()
					hookCannonSounds()
					applyKitSkinHook()
					if LocalPlayer.Character then
						hookCannonContainer(LocalPlayer.Backpack)
						hookCannonContainer(LocalPlayer.Character)
						hookCannonThirdPerson(LocalPlayer.Character)
					end
				else
					hookViewmodel()
					applyKitSkinHook()
					applyStoreSkins()
					if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
				end
				table.insert(connections, LocalPlayer.CharacterAdded:Connect(onCharacterAdded))
			else
				cleanup()
			end
		end,
		Tooltip = "Client-sided item skin changer",
	})

	KitSkins:CreateDropdown({
		Name = "Item Skin",
		List = skinNames,
		Default = CURRENT_ITEM_SKIN,
		Function = function(val)
			CURRENT_ITEM_SKIN = val
			if SkinTypeDropdown and SkinTypeDropdown.Object then
				SkinTypeDropdown.Object.Visible = TIERED_SKINS[val] == true
			end
			if KitSkins.Enabled then KitSkins:Toggle(); KitSkins:Toggle() end
		end,
	})

	SkinTypeDropdown = KitSkins:CreateDropdown({
		Name = "Skin Type",
		List = { "Gold", "Platinum", "Diamond", "Emerald", "Nightmare", "Default" },
		Default = CURRENT_SKIN_TYPE,
		Function = function(val)
			CURRENT_SKIN_TYPE = val
			if KitSkins.Enabled then KitSkins:Toggle(); KitSkins:Toggle() end
		end,
	})

	task.defer(function()
		if SkinTypeDropdown and SkinTypeDropdown.Object then
			SkinTypeDropdown.Object.Visible = TIERED_SKINS[CURRENT_ITEM_SKIN] == true
		end
		if SkinTypeDropdown and SkinTypeDropdown.Set then
			SkinTypeDropdown:Set(CURRENT_SKIN_TYPE)
		end
	end)
end)

run(function()
	local PotatoMode
	local originalProperties = {}
	local blockMonitorConnections = {}
	local processedBlocks = {}
	
	local blockColors = {
		["clay_white"] = Color3.fromRGB(255, 255, 255),
		["wool_white"] = Color3.fromRGB(255, 255, 255),
		["wool_red"] = Color3.fromRGB(255, 50, 50),
		["wool_green"] = Color3.fromRGB(50, 255, 50),
		["grass"] = Color3.fromRGB(50, 255, 50),
		["moss_block"] = Color3.fromRGB(50, 255, 50),
		["wool_blue"] = Color3.fromRGB(50, 100, 255),
		["wool_yellow"] = Color3.fromRGB(255, 255, 50),
		["wool_orange"] = Color3.fromRGB(255, 150, 50),
		["clay_orange"] = Color3.fromRGB(255, 150, 50),
		["wool_purple"] = Color3.fromRGB(180, 50, 255),
		["clay_light_brown"] = Color3.fromRGB(200, 170, 120),
		["wool_pink"] = Color3.fromRGB(255, 100, 200),
		["wool_black"] = Color3.fromRGB(50, 50, 50),
		["wool_cyan"] = Color3.fromRGB(50, 255, 255),
		["wool_magenta"] = Color3.fromRGB(255, 50, 150),
		["wool_lime"] = Color3.fromRGB(150, 255, 50),
		["wool_brown"] = Color3.fromRGB(150, 75, 0),
		["wood_plank_spruce"] = Color3.fromRGB(222, 184, 135),
		["wool_light_blue"] = Color3.fromRGB(100, 200, 255),
		["wool_gray"] = Color3.fromRGB(150, 150, 150),
		["clay"] = Color3.fromRGB(220, 180, 140),
		["wood"] = Color3.fromRGB(180, 140, 100),
		["stone"] = Color3.fromRGB(150, 150, 150),
		["andesite"] = Color3.fromRGB(150, 150, 150),
		["cobblestone"] = Color3.fromRGB(150, 150, 150),
		["obsidian"] = Color3.fromRGB(50, 30, 80),
		["bedrock"] = Color3.fromRGB(80, 80, 80),
		["tnt"] = Color3.fromRGB(255, 50, 50),
		["sandstone"] = Color3.fromRGB(220, 200, 150),
		["sand"] = Color3.fromRGB(220, 200, 150),
		["wool"] = Color3.fromRGB(200, 200, 200),
		["bed"] = Color3.fromRGB(200, 50, 50),
		["concrete"] = Color3.fromRGB(180, 180, 180),
	}
	
	local cachedColors = {}
	
	local function getBlockColor(blockName)
		if cachedColors[blockName] then
			return cachedColors[blockName]
		end
		
		if blockColors[blockName] then
			cachedColors[blockName] = blockColors[blockName]
			return blockColors[blockName]
		end
		
		local lowerName = blockName:lower()
		
		if blockColors[lowerName] then
			cachedColors[blockName] = blockColors[lowerName]
			return blockColors[lowerName]
		end
		
		if lowerName:find("wool", 1, true) then 
			for key, color in pairs(blockColors) do
				if key:find("wool", 1, true) and lowerName:find(key, 1, true) then
					cachedColors[blockName] = color
					return color
				end
			end
			cachedColors[blockName] = blockColors["wool"]
			return blockColors["wool"]
		end
		
		for name, color in pairs(blockColors) do
			if lowerName:find(name, 1, true) then
				cachedColors[blockName] = color
				return color
			end
		end
		
		local defaultColor = Color3.fromRGB(150, 150, 150)
		cachedColors[blockName] = defaultColor
		return defaultColor
	end
	
	local function cleanupDeadReferences()
		for block, _ in pairs(originalProperties) do
			if not block or not block.Parent then
				originalProperties[block] = nil
				processedBlocks[block] = nil
			end
		end
	end
	
	local function simplifyBlock(block)
		if not block or not block.Parent or processedBlocks[block] then return end
		
		if not originalProperties[block] then
			originalProperties[block] = {
				Material = block.Material,
				Color = block.Color,
				TextureID = block:IsA("MeshPart") and block.TextureID or nil,
				Textures = {}
			}
			
			for _, child in block:GetChildren() do
				if child:IsA("Texture") or child:IsA("Decal") then
					table.insert(originalProperties[block].Textures, {
						Class = child.ClassName,
						Texture = child.Texture,
						StudsPerTileU = child.StudsPerTileU,
						StudsPerTileV = child.StudsPerTileV,
						Face = child.Face,
						Transparency = child.Transparency,
						Color3 = child:IsA("Decal") and child.Color3 or nil
					})
				end
			end
		end
		
		block.Material = Enum.Material.SmoothPlastic
		block.Color = getBlockColor(block.Name)
		
		for _, child in block:GetChildren() do
			if child:IsA("Texture") or child:IsA("Decal") then
				child:Destroy()
			end
		end
		
		if block:IsA("MeshPart") and block.TextureID ~= "" then
			block.TextureID = ""
		end
		
		processedBlocks[block] = true
	end
	
	local function restoreBlock(block)
		if not block or not block.Parent then 
			originalProperties[block] = nil
			processedBlocks[block] = nil
			return 
		end
		
		local props = originalProperties[block]
		if not props then return end
		
		block.Material = props.Material or Enum.Material.Plastic
		block.Color = props.Color or Color3.fromRGB(255, 255, 255)
		
		if props.TextureID and block:IsA("MeshPart") then
			block.TextureID = props.TextureID
		end
		
		for _, textureProps in props.Textures do
			local newTexture
			if textureProps.Class == "Texture" then
				newTexture = Instance.new("Texture")
				newTexture.StudsPerTileU = textureProps.StudsPerTileU or 1
				newTexture.StudsPerTileV = textureProps.StudsPerTileV or 1
			else
				newTexture = Instance.new("Decal")
				newTexture.Color3 = textureProps.Color3 or Color3.fromRGB(255, 255, 255)
			end
			
			newTexture.Texture = textureProps.Texture or ""
			newTexture.Face = textureProps.Face or Enum.NormalId.Front
			newTexture.Transparency = textureProps.Transparency or 0
			newTexture.Parent = block
		end
		
		originalProperties[block] = nil
		processedBlocks[block] = nil
	end
	
	local function isTargetBlock(obj)
		if not obj:IsA("BasePart") then return false end
		
		local name = obj.Name
		
		if blockColors[name] then return true end
		
		local lowerName = name:lower()
		return lowerName:find("wool", 1, true) or 
		       lowerName:find("clay", 1, true) or
		       lowerName:find("wood", 1, true) or 
		       lowerName:find("stone", 1, true) or 
		       lowerName:find("glass", 1, true) or
		       lowerName:find("plank", 1, true) or 
		       lowerName:find("bed", 1, true) or 
		       lowerName:find("obsidian", 1, true) or
		       lowerName:find("sand", 1, true) or 
		       lowerName:find("end", 1, true) or 
		       lowerName:find("tnt", 1, true) or
		       lowerName:find("barrier", 1, true) or 
		       lowerName:find("magic", 1, true) or 
		       lowerName:find("concrete", 1, true) or
		       lowerName:find("_block", 1, true) or 
		       obj:IsA("Seat")
	end
	
	local function processExistingBlocks(simplify)
		local descendants = workspace:GetDescendants()
		
		task.spawn(function()
			for i, obj in descendants do
				if isTargetBlock(obj) then
					if simplify then
						simplifyBlock(obj)
					else
						restoreBlock(obj)
					end
				end
			end
			
			if not simplify then
				cleanupDeadReferences()
			end
		end)
	end
	
	local function setupBlockMonitor(simplify)
		for _, conn in blockMonitorConnections do
			conn:Disconnect()
		end
		table.clear(blockMonitorConnections)
		
		if not simplify then return end
		
		local mainConn = workspace.DescendantAdded:Connect(function(descendant)
			if isTargetBlock(descendant) then
				task.defer(function()
					if descendant and descendant.Parent then
						simplifyBlock(descendant)
					end
				end)
			end
		end)
		
		table.insert(blockMonitorConnections, mainConn)
		
		local lastCleanup = 0
		local cleanupConn = runService.Heartbeat:Connect(function()
			local now = tick()
			if now - lastCleanup >= 5 then
				lastCleanup = now
				cleanupDeadReferences()
			end
		end)
		
		table.insert(blockMonitorConnections, cleanupConn)
	end
	
	PotatoMode = vape.Categories.Render:CreateModule({
		Name = 'PotatoMode',
		Function = function(callback)
			if callback then
				processExistingBlocks(true)
				setupBlockMonitor(true)
			else
				processExistingBlocks(false)
				for _, conn in blockMonitorConnections do
					conn:Disconnect()
				end
				table.clear(blockMonitorConnections)
				table.clear(cachedColors)
				cleanupDeadReferences()
			end
		end,
		Tooltip = 'Removes block textures but keeps colors'
	})
end)

run(function()
    local KitDisplay

    local function getKitMeta(player)
        local kit = player:GetAttribute('PlayingAsKits') or player:GetAttribute('PlayingAsKit') or 'none'
        return bedwars.BedwarsKitMeta[kit] or bedwars.BedwarsKitMeta.none
    end

    local function getPlayerFromDraft(render, name)
        local id = render and render:match('id=(%d+)')
        if id then
            local player = playersService:GetPlayerByUserId(tonumber(id))
            if player then
                return player
            end
        end

        for _, v in playersService:GetPlayers() do
            if render and render:find('id='..v.UserId, 1, true) then
                return v
            end

            if name and (v.Name == name or v.DisplayName == name or v:GetAttribute('DisguiseDisplayName') == name) then
                return v
            end

            local displayName
            pcall(function()
                displayName = bedwars.StreamerModeController:getDisplayName(v)
            end)
            if name and displayName == name then
                return v
            end
        end
		return nil
    end

    local waitForChild = function(start, ...)
        local parent = start
        for _, v in ({...}) do
            parent = parent and parent:WaitForChild(v, 5)
            if not parent then
                break
            end
        end
        return parent
    end

    local function getPlayerName(card)
        local textbar = card and card:FindFirstChild('TextBackgroundBar')
        local label = textbar and textbar:FindFirstChild('PlayerName') or card and card:FindFirstChild('PlayerName', true)
        return label and label.Text or ''
    end

    local function getDraftCard(container)
        if not container then return end
        return container.Name == 'MatchDraftPlayerCard' and container or container:FindFirstChild('MatchDraftPlayerCard', true)
    end

    local function callback5v5(v, plr)
        if not v then return end
        local render = v:FindFirstChild('PlayerRender', true)
        local player = plr or getPlayerFromDraft(render and render.Image or '', getPlayerName(v))

        if player then
            local kitImage = getKitMeta(player)
            local roact = v:FindFirstChild('KitImage')

            if not roact then
                roact = Instance.new('ImageLabel', v)
                roact.BackgroundTransparency = 1
                roact.AnchorPoint = Vector2.new(1, 0.5)
                roact.Position = UDim2.fromScale(1.05, 0.5)
                roact.Name = 'KitImage'
                roact.Size = UDim2.fromScale(1.5, 1.5)
                roact.ZIndex = 1
                roact.ImageTransparency = 0.4
                roact.SliceCenter = Rect.new(0, 0, 0, 0)
                roact.SliceScale = 1
                roact.ScaleType = Enum.ScaleType.Crop

                KitDisplay:Clean(roact)

                local ratio = Instance.new('UIAspectRatioConstraint', roact)
                ratio.Name = '1'
                ratio.AspectRatio = 1
                ratio.AspectType = Enum.AspectType.FitWithinMaxSize
                ratio.DominantAxis = Enum.DominantAxis.Width
            end

            roact.Image = kitImage.renderImage
            roact.Position = UDim2.fromScale(1.05, 0)
            tweenService:Create(roact, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Position = UDim2.fromScale(1.05, 0.4)
            }):Play()

            local function update()
                kitImage = getKitMeta(player)
                roact.Image = kitImage.renderImage
            end

            KitDisplay:Clean(player:GetAttributeChangedSignal('PlayingAsKits'):Connect(update))
            KitDisplay:Clean(player:GetAttributeChangedSignal('PlayingAsKit'):Connect(update))
        end
    end

    local function callbacksquad(v)
        if not v then return end
        local render = v:FindFirstChild('PlayerRender', true)
        local player = render and getPlayerFromDraft(render.Image, '') or nil

        if player then 
            local kitImage = getKitMeta(player)
            local Roact = v:FindFirstChild('Kitcvrender')

            if not Roact then
                local base = v:FindFirstChild('3') or v:WaitForChild('3', 5)
                if not base then return end
                Roact = base:Clone()
                Roact.Parent = v
                Roact.Name = 'Kitcvrender'
                KitDisplay:Clean(Roact)
            end

            Roact.Image = kitImage.renderImage

            KitDisplay:Clean(render:GetPropertyChangedSignal('Image'):Connect(function()
                local newplayer = getPlayerFromDraft(render.Image, '')
                if newplayer then
                    player = newplayer
                    kitImage = getKitMeta(player)
                    Roact.Image = kitImage.renderImage
                end
            end))

            local function update()
                kitImage = getKitMeta(player)
                Roact.Image = kitImage.renderImage
            end

            KitDisplay:Clean(player:GetAttributeChangedSignal('PlayingAsKits'):Connect(update))
            KitDisplay:Clean(player:GetAttributeChangedSignal('PlayingAsKit'):Connect(update))
        end
    end

    local function setup5v5(DraftApp)
        local Background = DraftApp:FindFirstChild('DraftAppBackground')
        local BodyContainer = Background and Background:FindFirstChild('1') and Background['1']:FindFirstChild('BodyContainer')
        local hooked = false

        for i = 1, 2 do
            local dtc = BodyContainer and BodyContainer:FindFirstChild('Team'..i..'Column')
            if dtc then
                hooked = true
                KitDisplay:Clean(dtc.ChildAdded:Connect(function(child)
                    task.delay(0.2, function()
                        if KitDisplay.Enabled then
                            callback5v5(getDraftCard(child))
                        end
                    end)
                end))

                for _, v: Instance in dtc:GetChildren() do
                    if v:IsA('Frame') then
                        callback5v5(getDraftCard(v))
                    end
                end
            end
        end

        if not hooked then
            for _, label in DraftApp:GetDescendants() do
                if label:IsA('TextLabel') and label.Name == 'PlayerName' then
                    local container = label.Parent
                    for _ = 1, 3 do
                        container = container and container.Parent
                    end
                    if container then
                        callback5v5(getDraftCard(container))
                    end
                end
            end

            KitDisplay:Clean(DraftApp.DescendantAdded:Connect(function(child)
                if child:IsA('TextLabel') and child.Name == 'PlayerName' then
                    task.delay(0.2, function()
                        local container = child.Parent
                        for _ = 1, 3 do
                            container = container and container.Parent
                        end
                        if KitDisplay.Enabled and container then
                            callback5v5(getDraftCard(container))
                        end
                    end)
                end
            end))
        end

        return hooked
    end

    local function setupSquad(DraftApp)
        local Background = DraftApp:FindFirstChild('DraftAppBackground')
        local BodyContainer = Background and Background:FindFirstChild('1') and Background['1']:FindFirstChild('BodyContainer')
        local TeamsColumn = BodyContainer and BodyContainer:FindFirstChild('TeamsColumn')
        if not TeamsColumn then return end

        for _, v: Instance in TeamsColumn:GetChildren() do
            if v:IsA('Frame') then
                local plrframe = waitForChild(v, '1', '2', '4')
                if plrframe then
                    for _, plr in plrframe:GetChildren() do
                        callbacksquad(plr)
                    end

                    KitDisplay:Clean(plrframe.ChildAdded:Connect(function(plr)
                        task.delay(1, callbacksquad, plr)
                    end))
                end
            end
        end
    end

    KitDisplay = vape.Categories.Render:CreateModule({
        Name = 'Kit Display',
		Tags = {'new'},
        Tooltip = 'Allows you to see the other opponent team\'s kits',
        Function = function(call)
            if call then
                local DraftApp = lplr.PlayerGui:WaitForChild('MatchDraftApp', 9e9)
                setup5v5(DraftApp)
                setupSquad(DraftApp)
            end
        end
    })
end)

run(function()
	local VelocityPlus
	local Mode
	local Chance
	local TargetCheck
	local rand = Random.new()
	local old = nil

	local function rotateY(v, deg)
		local r = math.rad(deg)
		return Vector3.new(
			v.X * math.cos(r) - v.Z * math.sin(r),
			0,
			v.X * math.sin(r) + v.Z * math.cos(r)
		)
	end

	VelocityPlus = vape.Categories.Combat:CreateModule({
		Name = 'VelocityPlus',
		Tooltip = 'Redirects knockback you receive in a chosen direction.',
		Function = function(callback)
			if callback then
				old = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
					if rand:NextNumber(0, 100) > Chance.Value then
						return old(root, mass, dir, knockback, ...)
					end
					if TargetCheck.Enabled and not entitylib.EntityPosition({
						Range = 50, Part = 'RootPart', Players = true
					}) then
						return old(root, mass, dir, knockback, ...)
					end
					local victimPos = root.Position
					local victimFlat = Vector3.new(victimPos.X, 0, victimPos.Z)
					local awayVec = victimFlat - Vector3.new(dir.X, 0, dir.Z)
					if awayVec.Magnitude < 0.001 then
						return old(root, mass, dir, knockback, ...)
					end
					awayVec = awayVec.Unit
					local chosen = Mode.Value
					if chosen == 'Random' then
						chosen = ({'Left', 'Right', 'Pull'})[rand:NextInteger(1, 3)]
					end
					local desiredAway
					if chosen == 'Left' then
						desiredAway = rotateY(awayVec, 90)
					elseif chosen == 'Right' then
						desiredAway = rotateY(awayVec, -90)
					elseif chosen == 'Pull' then
						desiredAway = -awayVec
					else
						desiredAway = awayVec
					end
					local fakeAttacker = Vector3.new(
						victimPos.X - desiredAway.X * 100,
						dir.Y,
						victimPos.Z - desiredAway.Z * 100
					)
					return old(root, mass, fakeAttacker, knockback, ...)
				end
			else
				if old then
					bedwars.KnockbackUtil.applyKnockback = old
					old = nil
				end
			end
		end
	})

	Mode = VelocityPlus:CreateDropdown({
		Name = 'Direction',
		List = {'Left', 'Right', 'Pull', 'Random'},
		Default = 'Random',
		Tooltip = 'Left/Right: deflect sideways 90Â°\nPull: go past the attacker\nRandom: pick one each hit'
	})
	Chance = VelocityPlus:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%',
		Tooltip = 'Probability the redirect applies per knockback event'
	})
	TargetCheck = VelocityPlus:CreateToggle({
		Name = 'Only when targeting',
		Tooltip = 'Only redirects knockback when an enemy is within 50 studs'
	})
end)

run(function()
	local Breaker
	local Mode
	local Range
	local BreakSpeed
	local Angle
	local UpdateRate
	local Custom
	local Bed
	local Hive
	local Tesla
	local LuckyBlock
	local IronOre
	local Effect
	local Closest
	local CustomHealth
	local Animation
	local SelfBreak
	local InstantBreak
	local LimitItem
	local AutoTool = {Enabled = false}
	local customlist, parts = {}, {}
	
	local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		xpcall(function()
			--if block:GetAttribute('NoHealthbar') then return end
			if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
				self.healthbarMaid:DoCleaning()
				self.healthbarBlockRef = blockRef
				local create = bedwars.Roact.createElement
				local percent = math.clamp(health / maxHealth, 0, 1)
				local cleanCheck = true
				local part = Instance.new('Part')
				part.Size = Vector3.one
				part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
				part.Transparency = 1
				part.Anchored = true
				part.CanCollide = false
				part.Parent = workspace
				self.healthbarPart = part
				bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)
		
				local mounted = bedwars.Roact.mount(create('BillboardGui', {
					Size = UDim2.fromOffset(249, 102),
					StudsOffset = Vector3.new(0, 2.5, 0),
					Adornee = part,
					MaxDistance = 40,
					AlwaysOnTop = true
				}, {
					create('Frame', {
						Size = UDim2.fromOffset(160, 50),
						Position = UDim2.fromOffset(44, 32),
						BackgroundColor3 = Color3.new(),
						BackgroundTransparency = 0.5
					}, {
						create('UICorner', {CornerRadius = UDim.new(0, 5)}),
						create('ImageLabel', {
							Size = UDim2.new(1, 89, 1, 52),
							Position = UDim2.fromOffset(-48, -31),
							BackgroundTransparency = 1,
							Image = getcustomasset('catv6/assets/new/blur.png'),
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(52, 31, 261, 502)
						}),
						create('TextLabel', {
							Size = UDim2.fromOffset(145, 14),
							Position = UDim2.fromOffset(13, 12),
							BackgroundTransparency = 1,
							Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							TextColor3 = Color3.new(),
							TextScaled = true,
							Font = Enum.Font.Arial
						}),
						create('TextLabel', {
							Size = UDim2.fromOffset(145, 14),
							Position = UDim2.fromOffset(12, 11),
							BackgroundTransparency = 1,
							Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							TextColor3 = color.Dark(uipallet.Text, 0.16),
							TextScaled = true,
							Font = Enum.Font.Arial
						}),
						create('Frame', {
							Size = UDim2.fromOffset(138, 4),
							Position = UDim2.fromOffset(12, 32),
							BackgroundColor3 = uipallet.Main
						}, {
							create('UICorner', {CornerRadius = UDim.new(1, 0)}),
							create('Frame', {
								[bedwars.Roact.Ref] = self.healthbarProgressRef,
								Size = UDim2.fromScale(percent, 1),
								BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
							}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
						})
					})
				}), part)
		
				self.healthbarMaid:GiveTask(function()
					cleanCheck = false
					self.healthbarBlockRef = nil
					bedwars.Roact.unmount(mounted)
					if self.healthbarPart then
						self.healthbarPart:Destroy()
					end
					self.healthbarPart = nil
				end)
		
				bedwars.RuntimeLib.Promise.delay(5):andThen(function()
					if cleanCheck then
						self.healthbarMaid:DoCleaning()
					end
				end)
			end
		
			local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
			tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
				Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
			}):Play()
		end, warn)
	end
	
	local hit = 0
	
	local function attemptBreak(tab, localPosition)
		if not tab then return end
		if #tab > 1 then
			pcall(function()
				table.sort(tab, function(a, b)
					return (localPosition - a.Position).Magnitude <= (localPosition - b.Position).Magnitude
				end)
			end)
		end
		for _, v in tab do
			if (v.Position - localPosition).Magnitude < Range.Value and bedwars.BlockController:isBlockBreakable({blockPosition = v.Position / 3}, lplr) then
				if not SelfBreak.Enabled and v:GetAttribute('PlacedByUserId') == lplr.UserId then continue end
				if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then continue end
				if LimitItem.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then continue end
	
				hit += 1
				local target, path, endpos = bedwars.breakBlock(v, Effect.Enabled, Animation.Enabled, CustomHealth.Enabled and customHealthbar or nil, InstantBreak.Enabled, AutoTool.Enabled, Mode.Value, Angle.Value, Closest.Enabled)
				if path then
					local currentnode = target
					for _, part in parts do
						part.Position = currentnode or Vector3.zero
						if currentnode then
							part.BoxHandleAdornment.Color3 = currentnode == endpos and Color3.new(1, 0.2, 0.2) or currentnode == target and Color3.new(0.2, 0.2, 1) or Color3.new(0.2, 1, 0.2)
						end
						currentnode = path[currentnode]
					end
				end
	
				task.wait(InstantBreak.Enabled and (store.damageBlockFail > tick() and 4.5 or 0) or BreakSpeed.Value)
	
				return true
			end
		end
	
		return false
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Alias = {'nuker', 'bedbreaker', 'bednuker'},
		Tags = {'updated'},
		Function = function(callback)
			if callback then
				for _ = 1, 30 do
					local part = Instance.new('Part')
					part.Anchored = true
					part.CanQuery = false
					part.CanCollide = false
					part.Transparency = 1
					part.Parent = gameCamera
					local highlight = Instance.new('BoxHandleAdornment')
					highlight.Size = Vector3.one
					highlight.AlwaysOnTop = true
					highlight.ZIndex = 1
					highlight.Transparency = 0.5
					highlight.Adornee = part
					highlight.Parent = part
					table.insert(parts, part)
				end
	
				local beds = collection('bed', Breaker)
				local teslas = collection('tesla-trap', Breaker, function(tab, obj)
					task.delay(0.1, function()
						local player = playersService:GetPlayerByUserId(obj:GetAttribute('PlacedByUserId'))
						if player and player:GetAttribute('Team') ~= lplr:GetAttribute('Team') then
							table.insert(tab, obj)
						end
					end)
				end)
				local hives = collection('beehive', Breaker, function(tab, obj)
					task.delay(0.1, function()
						local player = playersService:GetPlayerByUserId(obj:GetAttribute('PlacedByUserId'))
						if player and player:GetAttribute('Team') ~= lplr:GetAttribute('Team') then
							table.insert(tab, obj)
						end
					end)
				end)
				local luckyblock = collection('LuckyBlock', Breaker)
				local ironores = collection('iron_ore_mesh_block', Breaker)
				customlist = collection('block', Breaker, function(tab, obj)
					if table.find(Custom.ListEnabled, obj.Name) then
						table.insert(tab, obj)
					end
				end)
	
				repeat
					task.wait(1 / UpdateRate.Value)
					if not Breaker.Enabled then break end
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
	
						if attemptBreak(Tesla.Enabled and teslas, localPosition) then continue end
						if attemptBreak(Bed.Enabled and beds, localPosition) then continue end
						if attemptBreak(Hive.Enabled and hives, localPosition) then continue end
						if attemptBreak(customlist, localPosition) then continue end
						if attemptBreak(LuckyBlock.Enabled and luckyblock, localPosition) then continue end
						if attemptBreak(IronOre.Enabled and ironores, localPosition) then continue end
	
						for _, v in parts do
							v.Position = Vector3.zero
						end
					end
				until not Breaker.Enabled
			else
				for _, v in parts do
					v:ClearAllChildren()
					v:Destroy()
				end
				table.clear(parts)
			end
		end,
		Tooltip = 'Break blocks around you automatically'
	})
	Mode = Breaker:CreateDropdown({
		Name = 'Break Sorting',
		List = {'Distance', 'Health'},
		Tooltip = 'Distance - Targets nearest blocks\nHealth = Targets the best block',
		Default = 'Health'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	BreakSpeed = Breaker:CreateSlider({
		Name = 'Break speed',
		Min = 0,
		Max = 0.3,
		Default = 0.25,
		Decimal = 100,
		Suffix = 'seconds'
	})
	Angle = Breaker:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 360,	
	})
	UpdateRate = Breaker:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	Custom = Breaker:CreateTextList({
		Name = 'Custom',
		Function = function()
			if not customlist then return end
			table.clear(customlist)
			for _, obj in store.blocks do
				if table.find(Custom.ListEnabled, obj.Name) then
					table.insert(customlist, obj)
				end
			end
		end
	})
	AutoTool = Breaker:CreateToggle({Name = 'Auto Tool'})
	Bed = Breaker:CreateToggle({
		Name = 'Break Bed',
		Default = true
	})
	Tesla = Breaker:CreateToggle({
		Name = 'Break Tesla',
		Default = true
	})
	Hive = Breaker:CreateToggle({
		Name = 'Break Hive',
		Default = true
	})
	LuckyBlock = Breaker:CreateToggle({
		Name = 'Break Lucky Block',
		Default = true
	})
	IronOre = Breaker:CreateToggle({
		Name = 'Break Iron Ore',
		Default = true
	})
	Effect = Breaker:CreateToggle({
		Name = 'Show Healthbar & Effects',
		Function = function(callback)
			if CustomHealth and CustomHealth.Object then
				CustomHealth.Object.Visible = callback
			end
		end,
		Default = true
	})
	CustomHealth = Breaker:CreateToggle({
		Name = 'Custom Healthbar',
		Default = true,
		Darker = true
	})
	Animation = Breaker:CreateToggle({Name = 'Animation'})
	SelfBreak = Breaker:CreateToggle({Name = 'Self Break'})
	InstantBreak = Breaker:CreateToggle({Name = 'Instant Break'})
	Closest = Breaker:CreateToggle({
		Name = 'Closest Break',
		Tooltip = 'Breaks the nearest cover block to your mouse before the target block, falling back to your position'
	})
	LimitItem = Breaker:CreateToggle({
		Name = 'Limit to items',
		Tooltip = 'Only breaks when tools are held'
	})
end)


run(function()
	local ItemESP
	local Distance
	local Transparency
	local Scale 
	local WhitelistOnly
	local Whitelist = {ListEnabled = {}, Object = nil}

	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local Reference, Strings, Sizes = {}, {}, {}

	local function Added(ent)
		local Name = bedwars.ItemMeta[ent.Name] and bedwars.ItemMeta[ent.Name].displayName or ent.Name
		if WhitelistOnly.Enabled and not table.find(Whitelist.ListEnabled, Name:lower()) then
			return
		end

		Strings[ent] = (Name).. '%s'
		if Distance.Enabled then
			Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
		end

		local nametag = Instance.new('TextLabel')
		nametag.TextSize = 14 * Scale.Value
		nametag.Font = Enum.Font.Arial
		local size = getfontsize(removeTags(ent.Name), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
		nametag.Name = ent.Name
		nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
		nametag.AnchorPoint = Vector2.new(0.5, 1)
		nametag.BackgroundColor3 = Color3.new()
		nametag.BackgroundTransparency = 0.5
		nametag.BorderSizePixel = 0
		nametag.Visible = false
		nametag.Text = string.format(Strings[ent], 'nan', ent:GetAttribute('Amount') >= 2 and ' x'..tostring(ent:GetAttribute('Amount')) or '')
		nametag.TextColor3 = Color3.new(1, 1, 1)
		nametag.RichText = true
		nametag.Parent = Folder
		Reference[ent] = nametag	
	end
	local function Updated(ent)
		if Reference[ent] then
			Reference[ent].TextSize = 14 * Scale.Value
			Reference[ent].BackgroundTransparency = Transparency.Value
		end
	end
	local function Removing(ent)
		if Reference[ent] then
			Reference[ent]:Destroy()
			Reference[ent] = nil
		end
	end
	
	ItemESP = vape.Categories.Render:CreateModule({
		Name = 'Item ESP',
		Tooltip = 'Renders tags dropped items',
		Function = function(call)
			if call then
				ItemESP:Clean(collectionService:GetInstanceAddedSignal('ItemDrop'):Connect(Added))
				ItemESP:Clean(collectionService:GetInstanceRemovedSignal('ItemDrop'):Connect(Removing))
				ItemESP:Clean(runService.RenderStepped:Connect(function()
					for ent, nametag in Reference do
						local headPos, headVis = gameCamera:WorldToViewportPoint(ent.Position + Vector3.new(0, 1, 0))
						nametag.Visible = headVis
						if not headVis then
							continue
						end
			
						if Distance.Enabled then
							local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.Position).Magnitude) or 0
							if Sizes[ent] ~= mag then
								nametag.Text = string.format(Strings[ent], mag, ent:GetAttribute('Amount') >= 2 and ' x'..tostring(ent:GetAttribute('Amount')) or '')
								local size = getfontsize(removeTags(nametag.Text), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
								nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
								Sizes[ent] = mag
							end
						end
						nametag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
					end
				end))

				for _, v in collectionService:GetTagged('ItemDrop') do
					Added(v)
				end
			else
				for i in Reference do
					Removing(i)
				end
			end
		end
	})
	Distance = ItemESP:CreateToggle({
		Name = 'Distance',
		Tooltip = 'Shows the distance of the item'
	})
	ItemESP:CreateToggle({
		Name = 'Group items',
		Tooltip = 'Group items into easier to read tags'
	})
	Transparency = ItemESP:CreateSlider({
		Name = 'Transparency',
		Function = function()
			if ItemESP.Enabled then
				for ent in Reference do
					Updated(ent)
				end
			end
		end,
		Default = 0.5,
		Min = 0,
		Max = 1,
		Decimal = 100
	})
	Scale = ItemESP:CreateSlider({
		Name = 'Scale',
		Default = 1,
		Min = 0.1,
		Max = 1.5,
		Decimal = 10,
		Function = function()
			if ItemESP.Enabled then
				for ent in Reference do
					Updated(ent)
				end
			end
		end
	})
	WhitelistOnly = ItemESP:CreateToggle({
		Name = 'Whitelist Only',
		Tooltip = 'Only renders whitelisted items',
		Function = function(call)
			if Whitelist.Object then
				Whitelist.Object.Visible = call
				
				if ItemESP.Enabled then
					ItemESP:Toggle()
					ItemESP:Toggle()
				end
			end
		end
	})
	Whitelist = ItemESP:CreateTextList({
		Name = 'Allowed items',
		Visible = false,
		Darker = true,
		Function = function()
			if ItemESP.Enabled then
				ItemESP:Toggle()
				ItemESP:Toggle()
			end
		end
	})
end)

run(function()
    local BedAlarm
    local Range
    local Volume
    local Highlight

    local function getBed()
        if entitylib.isAlive then
            local id = lplr.Character:GetAttribute('Team')
            for i,v in collectionService:GetTagged('bed') do
                if tonumber(id) == tonumber(v:GetAttribute('TeamId')) then
                    return v
                end
            end
        end

        return
    end

    BedAlarm = vape.Legit:CreateModule({
        Name = 'Bed Alarm',
        Function = function(callback)
            if callback then
                local Notifytick = os.clock()
                local highlight = {}

                repeat
                    local bed, localpos = getBed(), nil
                    if bed then
                        localpos = bed:GetPivot().Position
                    end

                    if localpos then
                        local ent = localpos and entitylib.AllPosition({
                            Origin = localpos,
                            Range = Range.Value,
                            Part = 'RootPart',
                            Players = true
                        })

                        if ent and #ent > 0 and os.clock() > Notifytick then
                            Notifytick = os.clock() + 3.05
                            if Highlight.Enabled then
                                for _, v in ent do
                                    if not highlight[v.Character] then
                                        highlight[v.Character] = true
                                        bedwars.BedAlarmController:addIntruderPlayerHighlight(v.Player) 
                                    end
                                end
                            end
                            bedwars.NotificationController:sendInfoNotification({
                                message = '[Bed Alarm]: An intruder is near your bed!',
                            })
                            bedwars.SoundManager:playSound(bedwars.SoundList.BED_ALARM, {
                                volumeMultiplier = Volume.Value
                            })
                        end
                    end
                    task.wait(0.1)
                until not BedAlarm.Enabled
            end
        end,
        Tooltip = 'Notifies when theres an enemy near bed'
    })

    Highlight = BedAlarm:CreateToggle({
        Name = 'Highlight intruders',
        Tooltip = 'Shows where the intruders are\n(just like bedwar\'s bed alarm)',
        Default = true
    })
    Range = BedAlarm:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 100,
        Default = 70,
        Suffix = function(val)
            return val <= 1 and 'stud' or 'studs'
        end
    })
    Volume = BedAlarm:CreateSlider({
        Name = 'Volume multiplier',
        Min = 0.1,
        Max = 2,
        Default = 1.4,
        Decimal = 100
    })
end)

run(function()
	local KnockbackDelay
	local Chance
	local AirDelay
	local GroundDelay
	local TargetCheck

	local old, rand
	local function apply(type, env, ...)
		local root, mass, dir, knockback = ...
		knockback = knockback and table.clone(knockback) or {}
		knockback[type] = env[type] and knockback[type] or 0
		return old(root, mass, dir, knockback, select(5, ...))
	end
		
	KnockbackDelay = vape.Categories.Utility:CreateModule({
		Name = 'Knockback Delay',
		Tooltip = 'Delays incoming knockback packets',
		Function = function(callback) 
			if callback then
				old, rand = bedwars.KnockbackUtil.applyKnockback, Random.new()
				bedwars.KnockbackUtil.applyKnockback = function(...)
					if rand:NextNumber(0, 100) > Chance.Value then
						return old(...)
					end

					local root, mass, dir, knockback = ...
					if (not TargetCheck.Enabled) or entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true
					}) then 
						local env = {}
						task.delay(AirDelay:GetRandomValue() / 1000, apply, 'horizontal', env, root, mass, dir, knockback, select(5, ...))
						task.delay(GroundDelay:GetRandomValue() / 1000, apply, 'vertical', env, root, mass, dir, knockback, select(5, ...))
						return
					end
					return old(...)
				end
			else
				bedwars.KnockbackUtil.applyKnockback = old or bedwars.KnockbackUtil.applyKnockback
			end
		end,
		Tags = {'new'},
	})

	Chance = KnockbackDelay:CreateSlider({
		Name = 'Chance',
		Min = 1,
		Max = 100,
		Default = 40,
		Suffix = '%'
	})
	AirDelay = KnockbackDelay:CreateTwoSlider({
		Name = 'Air delay',
		Min = 0,
		Max = 500,
		DefaultMin = 50,
		DefaultMax = 200
	})
	GroundDelay = KnockbackDelay:CreateTwoSlider({
		Name = 'Ground delay',
		Min = 0,
		Max = 500,
		DefaultMin = 50,
		DefaultMax = 200
	})
	TargetCheck = KnockbackDelay:CreateToggle({Name = 'Target check'})
end)

run(function()
    local GeneratorESP
    DiamondToggle = nil
    EmeraldToggle = nil
    TeamGenToggle = nil
    ShowOwnTeamGen = nil
    ShowEnemyTeamGen = nil
    local UIStyle
    local CompactDiamondToggle
    local CompactEmeraldToggle
    local CollectionService = collectionService
    local RunService = runService
    local Reference = {}
    local Folder = Instance.new('Folder')
    Folder.Parent = vape.gui
    local CompactFolder = Instance.new('Folder')
    CompactFolder.Parent = vape.gui
    local teamColors = {
        [1] = {name = "Blue",   color = Color3.fromRGB(85, 150, 255)},
        [2] = {name = "Orange", color = Color3.fromRGB(255, 150, 50)},
        [3] = {name = "Pink",   color = Color3.fromRGB(255, 100, 200)},
        [4] = {name = "Yellow", color = Color3.fromRGB(255, 255, 50)}
    }

    local generatorTypes = {
        diamond = {
            keywords = {'diamond'},
            color = Color3.fromRGB(85, 200, 255),
            icon = 'diamond',
            displayName = 'Diamond',
            isTeamGen = false
        },
        emerald = {
            keywords = {'emerald'},
            color = Color3.fromRGB(0, 255, 100),
            icon = 'emerald',
            displayName = 'Emerald',
            isTeamGen = false
        }
    }

    local compactUI = Instance.new('ScreenGui')
    compactUI.Name = 'GeneratorCompactUI'
    compactUI.Parent = vape.gui
    compactUI.Enabled = false
    compactUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    compactUI.DisplayOrder = 10
    compactUI.ResetOnSpawn = false

    local mainFrame = Instance.new('Frame')
    mainFrame.Name = 'MainFrame'
    mainFrame.Parent = compactUI
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(1, -8, 1, -8)
    mainFrame.Size = UDim2.new(0, 120, 0, 100)
    mainFrame.AnchorPoint = Vector2.new(1, 1)

    local uicorner = Instance.new('UICorner')
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = mainFrame

    local title = Instance.new('TextLabel')
    title.Name = 'Title'
    title.Parent = mainFrame
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "GEN ESP"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.5
    title.TextStrokeColor3 = Color3.new(0, 0, 0)

    local diamondFrame = Instance.new('Frame')
    diamondFrame.Name = 'DiamondFrame'
    diamondFrame.Parent = mainFrame
    diamondFrame.BackgroundTransparency = 1
    diamondFrame.Size = UDim2.new(1, -20, 0, 25)
    diamondFrame.Position = UDim2.new(0, 10, 0, 35)

    local diamondIcon = Instance.new('ImageLabel')
    diamondIcon.Name = 'DiamondIcon'
    diamondIcon.Parent = diamondFrame
    diamondIcon.BackgroundTransparency = 1
    diamondIcon.Size = UDim2.new(0, 18, 0, 18)
    diamondIcon.Position = UDim2.new(0, 0, 0.5, -9)
    diamondIcon.Image = bedwars.getIcon({itemType = 'diamond'}, true)

    local diamondTimer = Instance.new('TextLabel')
    diamondTimer.Name = 'DiamondTimer'
    diamondTimer.Parent = diamondFrame
    diamondTimer.BackgroundTransparency = 1
    diamondTimer.Size = UDim2.new(1, -25, 1, 0)
    diamondTimer.Position = UDim2.new(0, 25, 0, 0)
    diamondTimer.Text = "00"
    diamondTimer.TextColor3 = Color3.fromRGB(85, 200, 255)
    diamondTimer.TextSize = 18
    diamondTimer.Font = Enum.Font.GothamBold
    diamondTimer.TextXAlignment = Enum.TextXAlignment.Left

    local emeraldFrame = Instance.new('Frame')
    emeraldFrame.Name = 'EmeraldFrame'
    emeraldFrame.Parent = mainFrame
    emeraldFrame.BackgroundTransparency = 1
    emeraldFrame.Size = UDim2.new(1, -20, 0, 25)
    emeraldFrame.Position = UDim2.new(0, 10, 0, 65)

    local emeraldIcon = Instance.new('ImageLabel')
    emeraldIcon.Name = 'EmeraldIcon'
    emeraldIcon.Parent = emeraldFrame
    emeraldIcon.BackgroundTransparency = 1
    emeraldIcon.Size = UDim2.new(0, 18, 0, 18)
    emeraldIcon.Position = UDim2.new(0, 0, 0.5, -9)
    emeraldIcon.Image = bedwars.getIcon({itemType = 'emerald'}, true)

    local emeraldTimer = Instance.new('TextLabel')
    emeraldTimer.Name = 'EmeraldTimer'
    emeraldTimer.Parent = emeraldFrame
    emeraldTimer.BackgroundTransparency = 1
    emeraldTimer.Size = UDim2.new(1, -25, 1, 0)
    emeraldTimer.Position = UDim2.new(0, 25, 0, 0)
    emeraldTimer.Text = "00"
    emeraldTimer.TextColor3 = Color3.fromRGB(0, 255, 100)
    emeraldTimer.TextSize = 18
    emeraldTimer.Font = Enum.Font.GothamBold
    emeraldTimer.TextXAlignment = Enum.TextXAlignment.Left

    local diamondTimes = {}
    local emeraldTimes = {}

    local function getMyTeamId()
        local myTeam = lplr:GetAttribute('Team')
        if myTeam == nil then return nil end
        return tonumber(myTeam)
    end

    local function getGeneratorTeamId(generatorId)
        local teamNum = string.match(generatorId, "^(%d+)_generator")
        if teamNum then
            return tonumber(teamNum)
        end
        return nil
    end

    local function isTeamGenerator(generatorId)
        return string.match(generatorId, "^%d+_generator") ~= nil
    end

    local function getGeneratorType(generatorId)
        local idLower = string.lower(generatorId)

        if isTeamGenerator(generatorId) then
            return 'teamgen', {
                color = Color3.fromRGB(200, 200, 200),
                icon = 'iron',
                displayName = 'Team Gen',
                isTeamGen = true
            }
        end

        for genType, config in pairs(generatorTypes) do
            for _, keyword in ipairs(config.keywords) do
                if idLower:find(keyword) then
                    return genType, config
                end
            end
        end
        return nil, nil
    end

    local function isGeneratorEnabled(genType, teamId)
        if genType == 'diamond' then
            return DiamondToggle.Enabled
        elseif genType == 'emerald' then
            return EmeraldToggle.Enabled
        elseif genType == 'teamgen' then
            if not TeamGenToggle.Enabled then return false end
            local myTeamId = getMyTeamId()
            if not myTeamId or not teamId then return TeamGenToggle.Enabled end
            if teamId == myTeamId then
                return ShowOwnTeamGen.Enabled
            else
                return ShowEnemyTeamGen.Enabled
            end
        end
        return false
    end

    local function getProperIcon(iconType)
        local icon = bedwars.getIcon({itemType = iconType}, true)
        if not icon or icon == "" then return nil end
        return icon
    end

    local function getTierText(generatorAdornee)
        if not generatorAdornee then return nil end
        if generatorAdornee.Name ~= 'GeneratorAdornee' then return nil end
        local reactTree = generatorAdornee:FindFirstChild('RoactTree')
        if not reactTree then return nil end
        local teamApp = reactTree:FindFirstChild('TeamOreGeneratorApp')
        if not teamApp then return nil end
        local globalGen = teamApp:FindFirstChild('GlobalOreGenerator')
        if globalGen then
            for _, child in pairs(globalGen:GetDescendants()) do
                if child:IsA('TextLabel') then
                    local text = child.Text
                    if text:find("Tier") or text:match("^[IVX]+$") or text == "0" then
                        return child
                    end
                end
            end
        end
        local teamGenMain = teamApp:FindFirstChild('TeamGenMain')
        if teamGenMain then
            for _, child in pairs(teamGenMain:GetDescendants()) do
                if child:IsA('TextLabel') then
                    local text = child.Text
                    if text:find("Tier") or text:match("^[IVX]+$") or text == "0" then
                        return child
                    end
                end
            end
        end
        return nil
    end

    local function extractTierLevel(tierText)
        if not tierText or tierText == "" then return "0" end
        if tierText == "0" then return "0" end
        local tierMatch = tierText:match("Tier%s+([IVX]+)")
        if tierMatch then return tierMatch end
        if tierText:match("^[IVX]+$") then return tierText end
        local numTier = tierText:match("Tier%s+(%d+)")
        if numTier then
            local num = tonumber(numTier)
            if num == 0 then return "0"
            elseif num == 1 then return "I"
            elseif num == 2 then return "II"
            elseif num == 3 then return "III"
            end
        end
        return "0"
    end

    local function getCountdownText(generatorAdornee)
        if not generatorAdornee then return nil end
        if generatorAdornee.Name ~= 'GeneratorAdornee' then return nil end
        local reactTree = generatorAdornee:FindFirstChild('RoactTree')
        if not reactTree then return nil end
        local teamApp = reactTree:FindFirstChild('TeamOreGeneratorApp')
        if not teamApp then return nil end
        local globalGen = teamApp:FindFirstChild('GlobalOreGenerator')
        if not globalGen then return nil end
        local countdown = globalGen:FindFirstChild('Countdown')
        if not countdown then return nil end
        local textLabel = countdown:FindFirstChild('Text')
        if not textLabel then
            if countdown:IsA('TextLabel') then return countdown end
            return nil
        end
        return textLabel
    end

    local function extractSecondsFromText(text)
        if not text or text == "" then return 0 end
        local seconds = text:match("%[(%d+)%]")
        if seconds then return tonumber(seconds) or 0 end
        local justNumber = text:match("(%d+)")
        if justNumber then return tonumber(justNumber) or 0 end
        return 0
    end

    local function getResourceCount(position, resourceType)
        local count = 0
        for _, drop in pairs(CollectionService:GetTagged('ItemDrop')) do
            if drop:FindFirstChild('Handle') then
                local dropName = drop.Name:lower()
                if dropName:find(resourceType) then
                    local dist = (drop.Handle.Position - position).Magnitude
                    if dist <= 10 then
                        local amount = drop:GetAttribute('Amount') or 1
                        count = count + amount
                    end
                end
            end
        end
        return count
    end

    local CompactGenerators = {}

    local function rebuildCompactGenerators()
        table.clear(CompactGenerators)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == 'GeneratorAdornee' then
                local ok, generatorId = pcall(function() return obj:GetAttribute('Id') end)
                if ok and generatorId and type(generatorId) == 'string' and generatorId ~= '' then
                    local genType = getGeneratorType(generatorId)
                    if genType == 'diamond' or genType == 'emerald' then
                        table.insert(CompactGenerators, {obj = obj, genType = genType})
                    end
                end
            end
        end
    end

    local function updateCompactUI()
        if not GeneratorESP.Enabled or UIStyle.Value ~= 'Compact' then
            compactUI.Enabled = false
            return
        end
        compactUI.Enabled = true
        local bestDiamondTime = math.huge
        local bestEmeraldTime = math.huge
        for i = #CompactGenerators, 1, -1 do
            local entry = CompactGenerators[i]
            if not entry.obj or not entry.obj.Parent then
                table.remove(CompactGenerators, i)
                continue
            end
            local countdownText = getCountdownText(entry.obj)
            if countdownText and countdownText.Text then
                local timeLeft = extractSecondsFromText(countdownText.Text)
                if entry.genType == 'diamond' and timeLeft > 0 and timeLeft < bestDiamondTime then
                    bestDiamondTime = timeLeft
                elseif entry.genType == 'emerald' and timeLeft > 0 and timeLeft < bestEmeraldTime then
                    bestEmeraldTime = timeLeft
                end
            end
        end
        local showDiamond = CompactDiamondToggle and CompactDiamondToggle.Enabled
        local showEmerald = CompactEmeraldToggle and CompactEmeraldToggle.Enabled

        if not showDiamond and not showEmerald then
            compactUI.Enabled = false
            return
        end

        diamondFrame.Visible = showDiamond
        emeraldFrame.Visible = showEmerald

        if showDiamond then
            diamondFrame.Position = UDim2.new(0, 10, 0, 35)
        end
        if showEmerald then
            emeraldFrame.Position = UDim2.new(0, 10, 0, showDiamond and 65 or 35)
        end

        diamondTimes[1] = bestDiamondTime ~= math.huge and bestDiamondTime or 0
        emeraldTimes[1] = bestEmeraldTime ~= math.huge and bestEmeraldTime or 0
        if bestDiamondTime == math.huge then
            diamondTimer.Text = "00"
        else
            diamondTimer.Text = string.format("%02d", bestDiamondTime)
            if bestDiamondTime <= 5 then
                diamondTimer.TextColor3 = Color3.fromRGB(255, 50, 50)
            elseif bestDiamondTime <= 10 then
                diamondTimer.TextColor3 = Color3.fromRGB(255, 165, 0)
            else
                diamondTimer.TextColor3 = Color3.fromRGB(85, 200, 255)
            end
        end
        if bestEmeraldTime == math.huge then
            emeraldTimer.Text = "00"
        else
            emeraldTimer.Text = string.format("%02d", bestEmeraldTime)
            if bestEmeraldTime <= 5 then
                emeraldTimer.TextColor3 = Color3.fromRGB(255, 50, 50)
            elseif bestEmeraldTime <= 10 then
                emeraldTimer.TextColor3 = Color3.fromRGB(255, 165, 0)
            else
                emeraldTimer.TextColor3 = Color3.fromRGB(0, 255, 100)
            end
        end
    end

    local function clearAllESP()
        Folder:ClearAllChildren()
        table.clear(Reference)
        compactUI.Enabled = false
    end

    local function createESP(generatorAdornee, genType, config, position, teamId)
        if not isGeneratorEnabled(genType, teamId) then return end
        if Reference[generatorAdornee] then return end

        if UIStyle.Value == 'Compact' then
            Reference[generatorAdornee] = {
                genType = genType,
                position = position,
                teamId = teamId,
                isTeamGen = config.isTeamGen
            }
            return
        end

        local displayColor = config.color
        local teamName = nil
        if config.isTeamGen and teamId and teamColors[teamId] then
            displayColor = teamColors[teamId].color
            teamName = teamColors[teamId].name
        end

        local billboard = Instance.new('BillboardGui')
        billboard.Parent = Folder
        billboard.Name = 'generator-esp-' .. genType
        billboard.AlwaysOnTop = true
        billboard.ClipsDescendants = false
        billboard.Adornee = generatorAdornee

        if config.isTeamGen then
            billboard.Size = UDim2.fromOffset(180, 55)
            billboard.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
        else
            billboard.Size = UDim2.fromOffset(80, 30)
            billboard.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
        end

        local blur = addBlur(billboard)
        blur.Visible = true

        if config.isTeamGen and teamName then
            local dot = Instance.new('Frame')
            dot.Name = 'TeamDot'
            dot.Parent = billboard
            dot.Size = UDim2.fromOffset(8, 8)
            dot.Position = UDim2.new(0, 10, 0, 5)
            dot.BackgroundColor3 = displayColor
            dot.BorderSizePixel = 0
            local dotCorner = Instance.new('UICorner')
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local teamLabel = Instance.new('TextLabel')
            teamLabel.Name = 'TeamLabel'
            teamLabel.Parent = billboard
            teamLabel.BackgroundTransparency = 1
            teamLabel.Size = UDim2.new(1, 0, 0, 18)
            teamLabel.Position = UDim2.new(0, 0, 0, 0)
            teamLabel.Text = teamName
            teamLabel.TextColor3 = displayColor
            teamLabel.TextSize = 13
            teamLabel.Font = Enum.Font.GothamBold
            teamLabel.TextStrokeTransparency = 0.4
            teamLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            teamLabel.TextXAlignment = Enum.TextXAlignment.Center
        end

        local frame = Instance.new('Frame')
        frame.Size = config.isTeamGen and UDim2.new(1, 0, 0, 35) or UDim2.fromScale(1, 1)
        frame.Position = config.isTeamGen and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = billboard

        if config.isTeamGen and teamId and teamColors[teamId] then
            local stripe = Instance.new('Frame')
            stripe.Name = 'TeamStripe'
            stripe.Parent = frame
            stripe.Size = UDim2.new(0, 3, 1, 0)
            stripe.Position = UDim2.new(0, 0, 0, 0)
            stripe.BackgroundColor3 = displayColor
            stripe.BorderSizePixel = 0
            local stripeCorner = Instance.new('UICorner')
            stripeCorner.CornerRadius = UDim.new(0, 3)
            stripeCorner.Parent = stripe
        end

        local uicorner2 = Instance.new('UICorner')
        uicorner2.CornerRadius = UDim.new(0, 6)
        uicorner2.Parent = frame

        if config.isTeamGen then
            local tierLabel = Instance.new('TextLabel')
            tierLabel.Name = 'Tier'
            tierLabel.Size = UDim2.new(0, 25, 1, 0)
            tierLabel.Position = UDim2.new(0, 8, 0, 0)
            tierLabel.BackgroundTransparency = 1
            tierLabel.Text = "0"
            tierLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
            tierLabel.TextSize = 16
            tierLabel.Font = Enum.Font.GothamBold
            tierLabel.TextStrokeTransparency = 0.5
            tierLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            tierLabel.Parent = frame

            local resources = {
                {name = 'iron',    color = Color3.fromRGB(200, 200, 200), icon = 'iron',    xOffset = 35},
                {name = 'diamond', color = Color3.fromRGB(85, 200, 255),  icon = 'diamond', xOffset = 85},
                {name = 'emerald', color = Color3.fromRGB(0, 255, 100),   icon = 'emerald', xOffset = 135}
            }

            local resourceLabels = {}
            for _, resource in ipairs(resources) do
                local iconImage = getProperIcon(resource.icon)
                if iconImage then
                    local image = Instance.new('ImageLabel')
                    image.Size = UDim2.fromOffset(18, 18)
                    image.Position = UDim2.new(0, resource.xOffset, 0.5, 0)
                    image.AnchorPoint = Vector2.new(0, 0.5)
                    image.BackgroundTransparency = 1
                    image.Image = iconImage
                    image.Parent = frame
                end
                local countLabel = Instance.new('TextLabel')
                countLabel.Name = resource.name .. '_count'
                countLabel.Size = UDim2.new(0, 25, 1, 0)
                countLabel.Position = UDim2.new(0, resource.xOffset + 20, 0, 0)
                countLabel.BackgroundTransparency = 1
                countLabel.Text = "0"
                countLabel.TextColor3 = resource.color
                countLabel.TextSize = 16
                countLabel.Font = Enum.Font.GothamBold
                countLabel.TextStrokeTransparency = 0.5
                countLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                countLabel.TextXAlignment = Enum.TextXAlignment.Left
                countLabel.Parent = frame
                resourceLabels[resource.name] = countLabel
            end

            Reference[generatorAdornee] = {
                billboard = billboard,
                tierLabel = tierLabel,
                ironLabel = resourceLabels.iron,
                diamondLabel = resourceLabels.diamond,
                emeraldLabel = resourceLabels.emerald,
                genType = genType,
                position = position,
                teamId = teamId,
                isTeamGen = true
            }
        else
            local iconImage = getProperIcon(config.icon)
            if iconImage then
                local image = Instance.new('ImageLabel')
                image.Size = UDim2.fromOffset(20, 20)
                image.Position = UDim2.new(0, 5, 0.5, 0)
                image.AnchorPoint = Vector2.new(0, 0.5)
                image.BackgroundTransparency = 1
                image.Image = iconImage
                image.Parent = frame
            end
            local timerLabel = Instance.new('TextLabel')
            timerLabel.Name = 'Timer'
            timerLabel.Size = UDim2.new(0, 30, 1, 0)
            timerLabel.Position = UDim2.new(0.5, 0, 0, 0)
            timerLabel.AnchorPoint = Vector2.new(0.5, 0)
            timerLabel.BackgroundTransparency = 1
            timerLabel.Text = "00"
            timerLabel.TextColor3 = displayColor
            timerLabel.TextSize = 18
            timerLabel.Font = Enum.Font.GothamBold
            timerLabel.TextStrokeTransparency = 0.5
            timerLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            timerLabel.Parent = frame
            local amountLabel = Instance.new('TextLabel')
            amountLabel.Name = 'Amount'
            amountLabel.Size = UDim2.new(0, 20, 1, 0)
            amountLabel.Position = UDim2.new(1, -20, 0, 0)
            amountLabel.BackgroundTransparency = 1
            amountLabel.Text = "0"
            amountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            amountLabel.TextSize = 16
            amountLabel.Font = Enum.Font.GothamBold
            amountLabel.TextStrokeTransparency = 0.5
            amountLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            amountLabel.Parent = frame
            Reference[generatorAdornee] = {
                billboard = billboard,
                timerLabel = timerLabel,
                amountLabel = amountLabel,
                genType = genType,
                position = position,
                teamId = teamId,
                isTeamGen = false
            }
        end
    end

    local function updateESP(generatorAdornee)
        local ref = Reference[generatorAdornee]
        if not ref then return end
        if UIStyle.Value == 'Compact' then return end

        if ref.isTeamGen then
            if ref.tierLabel then
                local tierTextLabel = getTierText(generatorAdornee)
                if tierTextLabel and tierTextLabel.Text then
                    ref.tierLabel.Text = extractTierLevel(tierTextLabel.Text)
                else
                    ref.tierLabel.Text = "0"
                end
            end
            if ref.ironLabel then
                ref.ironLabel.Text = tostring(getResourceCount(ref.position, 'iron'))
            end
            if ref.diamondLabel then
                ref.diamondLabel.Text = tostring(getResourceCount(ref.position, 'diamond'))
            end
            if ref.emeraldLabel then
                ref.emeraldLabel.Text = tostring(getResourceCount(ref.position, 'emerald'))
            end
        else
            local countdownText = getCountdownText(generatorAdornee)
            if countdownText and countdownText.Text then
                local timeLeft = extractSecondsFromText(countdownText.Text)
                if ref.timerLabel then
                    ref.timerLabel.Text = string.format("%02d", timeLeft)
                    if timeLeft <= 5 then
                        ref.timerLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                    elseif timeLeft <= 10 then
                        ref.timerLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                    else
                        ref.timerLabel.TextColor3 = generatorTypes[ref.genType].color
                    end
                end
            else
                if ref.timerLabel then
                    ref.timerLabel.Text = "00"
                    ref.timerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            if ref.amountLabel then
                ref.amountLabel.Text = tostring(getResourceCount(ref.position, ref.genType))
            end
        end
    end

    local function processGeneratorAdornee(obj)
        if obj.Name ~= 'GeneratorAdornee' then return end
        local ok, generatorId = pcall(function() return obj:GetAttribute('Id') end)
        if not ok then return end
        if generatorId == nil then return end
        if type(generatorId) ~= 'string' then return end
        if generatorId == '' then return end

        local position = obj:GetPivot().Position
        local genType, config = getGeneratorType(generatorId)
        if not genType or not config then return end

        local teamId = getGeneratorTeamId(generatorId)
        if isGeneratorEnabled(genType, teamId) then
            createESP(obj, genType, config, position, teamId)
        end
    end

    local function findAllGenerators()
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(processGeneratorAdornee, obj)
        end
    end

    local function refreshESP()
        clearAllESP()
        if GeneratorESP.Enabled then
            findAllGenerators()
        end
    end

    local updateTimer = 0

    GeneratorESP = vape.Categories.Render:CreateModule({
        Name = 'GeneratorESP',
        Function = function(callback)
            if callback then
                findAllGenerators()
                rebuildCompactGenerators()

                GeneratorESP:Clean(workspace.DescendantAdded:Connect(function(obj)
                    if not GeneratorESP.Enabled then return end
                    task.wait(0.2)
                    pcall(processGeneratorAdornee, obj)
                    if obj.Name == 'GeneratorAdornee' then
                        rebuildCompactGenerators()
                    end
                end))

                GeneratorESP:Clean(runService.Heartbeat:Connect(function(dt)
                    if not GeneratorESP.Enabled then return end
                    updateTimer = updateTimer + dt
                    if updateTimer < 0.2 then return end
                    updateTimer = 0
                    for generatorAdornee, ref in pairs(Reference) do
                        if generatorAdornee and generatorAdornee.Parent then
                            updateESP(generatorAdornee)
                        else
                            if ref.billboard then ref.billboard:Destroy() end
                            Reference[generatorAdornee] = nil
                        end
                    end
                    updateCompactUI()
                end))

                GeneratorESP:Clean(workspace.DescendantRemoving:Connect(function(obj)
                    if not GeneratorESP.Enabled then return end
                    if Reference[obj] then
                        if Reference[obj].billboard then Reference[obj].billboard:Destroy() end
                        Reference[obj] = nil
                    end
                end))
            else
                clearAllESP()
            end
        end,
        Tooltip = 'ESP for generators showing timer and item counts'
    })

    UIStyle = GeneratorESP:CreateDropdown({
        Name = 'UI Style',
        List = {'Original', 'Compact'},
        Default = 'Original',
        Function = function(val)
            local isOriginal = val == 'Original'
            if DiamondToggle then DiamondToggle.Object.Visible = isOriginal end
            if EmeraldToggle then EmeraldToggle.Object.Visible = isOriginal end
            if TeamGenToggle then TeamGenToggle.Object.Visible = isOriginal end
            if ShowOwnTeamGen then ShowOwnTeamGen.Object.Visible = isOriginal and TeamGenToggle.Enabled end
            if ShowEnemyTeamGen then ShowEnemyTeamGen.Object.Visible = isOriginal and TeamGenToggle.Enabled end
            if CompactDiamondToggle then CompactDiamondToggle.Object.Visible = not isOriginal end
            if CompactEmeraldToggle then CompactEmeraldToggle.Object.Visible = not isOriginal end
            refreshESP()
        end,
        Tooltip = 'Choose between original billboard ESP or compact side UI'
    })

    DiamondToggle = GeneratorESP:CreateToggle({
        Name = 'Diamond',
        Function = function() refreshESP() end,
        Default = false,
        Visible = true
    })

    EmeraldToggle = GeneratorESP:CreateToggle({
        Name = 'Emerald',
        Function = function() refreshESP() end,
        Default = false,
        Visible = true
    })

    CompactDiamondToggle = GeneratorESP:CreateToggle({
        Name = 'Compact Diamond',
        Default = false,
        Visible = false,
        Function = function()
            refreshESP()
        end
    })

    CompactEmeraldToggle = GeneratorESP:CreateToggle({
        Name = 'Compact Emerald',
        Default = false,
        Visible = false,
        Function = function()
            refreshESP()
        end
    })

    TeamGenToggle = GeneratorESP:CreateToggle({
        Name = 'Team Generators',
        Function = function(callback)
            if ShowOwnTeamGen then ShowOwnTeamGen.Object.Visible = callback end
            if ShowEnemyTeamGen then ShowEnemyTeamGen.Object.Visible = callback end
            refreshESP()
        end,
        Default = true
    })

    ShowOwnTeamGen = GeneratorESP:CreateToggle({
        Name = 'Show Own Team',
        Function = function() refreshESP() end,
        Default = false,
        Visible = true
    })

    ShowEnemyTeamGen = GeneratorESP:CreateToggle({
        Name = 'Show Enemy Teams',
        Function = function() refreshESP() end,
        Default = true,
        Visible = true
    })
end)

run(function()
    local AutoBD
    local Range
    local MaxBlocks
    local BlockType
    local CheckInterval
    local CustomPattern
    local Pattern = {Value = 'Pyramid'}
    
    local patternFunctions = {
        Pyramid = function(bedPos)
            local positions = {}
            for y = 0, 2 do
                for x = -y, y do
                    for z = -y, y do
                        if math.abs(x) == y or math.abs(z) == y then
                            table.insert(positions, bedPos + Vector3.new(x * 3, y * 3, z * 3))
                        end
                    end
                end
            end
            return positions
        end,
        
        Wall = function(bedPos)
            local positions = {}
            for x = -1, 1 do
                for z = -1, 1 do
                    if x == -1 or x == 1 or z == -1 or z == 1 then
                        for y = 0, 2 do
                            table.insert(positions, bedPos + Vector3.new(x * 3, y * 3, z * 3))
                        end
                    end
                end
            end
            return positions
        end,
        
        Box = function(bedPos)
            local positions = {}
            for x = -1, 1 do
                for y = 0, 1 do
                    for z = -1, 1 do
                        if not (x == 0 and z == 0) then
                            table.insert(positions, bedPos + Vector3.new(x * 3, y * 3, z * 3))
                        end
                    end
                end
            end
            return positions
        end
    }
    
    local function getBed()
        if entitylib.isAlive then
            local teamId = lplr:GetAttribute('Team')
            for _, bed in collectionService:GetTagged('bed') do
                if tonumber(teamId) == tonumber(bed:GetAttribute('TeamId')) then
                    return bed
                end
            end
        end
        return nil
    end
    
    local function getDefenseBlock()
        local blockItem = getWool()
        if blockItem then
            return blockItem
        end
        
        for _, item in store.inventory.inventory.items do
            local meta = bedwars.ItemMeta[item.itemType]
            if meta and meta.block and not meta.block.seeThrough then
                return item.itemType, item.amount
            end
        end
        
        return nil, 0
    end
    
    AutoBD = vape.Categories.World:CreateModule({
        Name = 'AutoBD',
        Function = function(callback)
            if callback then
                local placedCount = 0
                
                repeat
                    if entitylib.isAlive then
                        local bed = getBed()
                        
                        if bed then
                            local bedPos = bed.Position
                            local blockType, blockAmount = getDefenseBlock()
                            
                            if not blockType then
                                task.wait(1)
                                continue
                            end
                            
                            local positions = patternFunctions[Pattern.Value](bedPos)
                            placedCount = 0
                            
                            for _, pos in positions do
                                if placedCount >= MaxBlocks.Value then
                                    break
                                end
                                
                                if not getPlacedBlock(pos) then
                                    local nearEnemy = entitylib.AllPosition({
                                        Origin = bedPos,
                                        Range = Range.Value,
                                        Part = 'RootPart',
                                        Players = true
                                    })
                                    
                                    if #nearEnemy > 0 then
                                        task.spawn(bedwars.placeBlock, pos, blockType)
                                        placedCount = placedCount + 1
                                        task.wait(0.05)
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(CheckInterval.Value)
                until not AutoBD.Enabled
            end
        end,
        Tooltip = ''
    })
    
    Pattern = AutoBD:CreateDropdown({
        Name = 'Pattern',
        List = {'Pyramid', 'Wall', 'Box'},
        Default = 'Pyramid'
    })
    
    Range = AutoBD:CreateSlider({
        Name = 'Detection Range',
        Min = 10,
        Max = 50,
        Default = 25,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end,
        Tooltip = ''
    })
    
    MaxBlocks = AutoBD:CreateSlider({
        Name = 'Max Blocks',
        Min = 1,
        Max = 20,
        Default = 10,
        Tooltip = ''
    })
    
    CheckInterval = AutoBD:CreateSlider({
        Name = 'Check Interval',
        Min = 0.5,
        Max = 5,
        Default = 1,
        Decimal = 10,
        Suffix = 's',
        Tooltip = ''
    })
end)

run(function()
    local AutoCycle
    local Range
    local Emerald
    local Diamond
    local Delay
    local GUI
    local pickupQueue = {}
    
    local function canPickup(item)
        if not item then return false end
        if tick() - (item:GetAttribute('ClientDropTime') or 0) < 2 then return false end
        
        local itemType = item.Name
        if Emerald.Enabled and itemType == 'emerald' then return true end
        if Diamond.Enabled and itemType == 'diamond' then return true end
        
        return false
    end
    
    AutoCycle = vape.Categories.Utility:CreateModule({
        Name = 'AutoCycle',
        Function = function(callback)
            if callback then
                local items = collection('ItemDrop', AutoCycle)
                
                repeat
                    if entitylib.isAlive then
                        if GUI.Enabled and bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
                            task.wait(0.1)
                            continue
                        end
                        
                        local localPosition = entitylib.character.RootPart.Position
                        table.clear(pickupQueue)
                        
                        for _, v in items do
                            if canPickup(v) and (localPosition - v.Position).Magnitude <= Range.Value then
                                table.insert(pickupQueue, v)
                            end
                        end
                        
                        if #pickupQueue > 0 then
                            table.sort(pickupQueue, function(a, b)
                                return (localPosition - a.Position).Magnitude < (localPosition - b.Position).Magnitude
                            end)
                            
                            for _, item in pickupQueue do
                                if item and item.Parent then
                                    task.spawn(function()
                                        bedwars.Client:Get(remotes.PickupItem):CallServerAsync({
                                            itemDrop = item
                                        }):andThen(function(suc)
                                            if suc and bedwars.SoundList then
                                                bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
                                            end
                                        end)
                                    end)
                                    task.wait(Delay.Value)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                until not AutoCycle.Enabled
            end
        end,
        Tooltip = ''
    })
    
    Range = AutoCycle:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 20,
        Default = 10,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })
    
    Delay = AutoCycle:CreateSlider({
        Name = 'Pickup Delay',
        Min = 0,
        Max = 0.5,
        Default = 0.05,
        Decimal = 100,
        Suffix = 's'
    })
    
    Emerald = AutoCycle:CreateToggle({
        Name = 'Emerald',
        Default = true
    })
    
    Diamond = AutoCycle:CreateToggle({
        Name = 'Diamond',
        Default = true
    })
    
    GUI = AutoCycle:CreateToggle({
        Name = 'GUI Check',
        Tooltip = ''
    })
end)

run(function()
	local ShadowRemover
	local connections = {}
	local originalShadows = {}
	local processedShadows = {}
	
	local function removeShadow(obj)
		if obj:IsA("BasePart") and not processedShadows[obj] then
			if not originalShadows[obj] then
				originalShadows[obj] = obj.CastShadow
			end
			obj.CastShadow = false
			processedShadows[obj] = true
		end
	end
	
	ShadowRemover = vape.Categories.Render:CreateModule({
		Name = 'ShadowRemover',
		Function = function(callback)
			if callback then
				local descendants = workspace:GetDescendants()
				
				task.spawn(function()
					for i, obj in descendants do
						removeShadow(obj)
						if i % 100 == 0 then
							task.wait()
						end
					end
				end)
				
				local conn = workspace.DescendantAdded:Connect(function(obj)
					if ShadowRemover.Enabled then
						removeShadow(obj)
					end
				end)
				table.insert(connections, conn)
			else
				for obj, shadow in pairs(originalShadows) do
					if obj and obj.Parent then
						pcall(function()
							obj.CastShadow = shadow
						end)
					end
				end
				
				for _, conn in connections do
					conn:Disconnect()
				end
				table.clear(connections)
				table.clear(originalShadows)
				table.clear(processedShadows)
			end
		end,
		Tooltip = 'Removes shadows from all parts for FPS boost'
	})
end)

run(function()
	local FrameBuffer
	local Latency
	local Rate
	
	local defaultFFlags = {
		DFIntDebugDefaultTargetWorldStepsPerFrame = nil,
		DFIntMaxMissedWorldStepsRemembered = nil,
		DFIntWorldStepsOffsetAdjustRate = nil,
		DFIntDebugSendDistInSteps = nil,
		DFIntWorldStepMax = nil,
		DFIntWarpFactor = nil
	}
	
	local function captureDefaults()
		for name, _ in pairs(defaultFFlags) do
			local suc, val = pcall(function()
				return getfflag(name)
			end)
			if suc then
				defaultFFlags[name] = val
			end
		end
	end
	captureDefaults()
	
	local function restoreFFlags()
		for name, val in pairs(defaultFFlags) do
			if val then
				pcall(function()
					setfflag(name, val)
				end)
			end
		end
	end
	
	local function applyFFlags(latencyMs, rate)
		rate = math.max(rate, 1)
		local latency = latencyMs
		if latency <= 1 then
			latency = 1.5
		end
		
		local OG = -2147483648
		local NEW = OG * (latency / 1000)
		local NEW2 = NEW * -1
		local str = tostring(NEW)
		local str2 = tostring(NEW2)
		
		pcall(function() setfflag('DFIntDebugDefaultTargetWorldStepsPerFrame', str) end)
		pcall(function() setfflag('DFIntMaxMissedWorldStepsRemembered', str) end)
		pcall(function() setfflag('DFIntWorldStepsOffsetAdjustRate', str2) end)
		pcall(function() setfflag('DFIntDebugSendDistInSteps', str) end)
		pcall(function() setfflag('DFIntWorldStepMax', str) end)
		pcall(function() setfflag('DFIntWarpFactor', str2) end)
	end
	
	FrameBuffer = vape.Categories.Blatant:CreateModule({
		Name = 'FrameBuffer',
		Function = function(callback)
			if callback then
				repeat
					applyFFlags(Latency.Value, Rate.Value)
					task.wait(1 / math.max(Rate.Value, 1))
				until not FrameBuffer.Enabled
				
				restoreFFlags()
			end
		end,
	})
	
	Latency = FrameBuffer:CreateSlider({
		Name = "Latency",
		Min = 0,
		Max = 1000,
		Default = 250,
		Suffix = 'ms'
	})
	
	Rate = FrameBuffer:CreateSlider({
		Name = "Rate",
		Min = 1,
		Max = 360,
		Default = 60,
		Suffix = 'hz'
	})
end)

run(function()
	local SkinChanger
	local Players = playersService
	local RunService = runService
	local LocalPlayer = Players.LocalPlayer
	local RS = game.ReplicatedStorage

	local CURRENT_ITEM_SKIN = "Victorious Lyla"
	local CURRENT_SKIN_TYPE = "Nightmare"

	local ok1, ItemType = pcall(function()
		return require(RS.TS.item["item-type"]).ItemType
	end)
	if not ok1 then ItemType = {} end

	local ok2, ItemSkinType = pcall(function()
		return require(RS.TS.games.bedwars["item-skin"]["item-skin-types"]).ItemSkinType
	end)
	if not ok2 then ItemSkinType = {} end

	local KitSkinCtrl
	pcall(function()
		local KC = require(RS.rbxts_include.node_modules["@easy-games"].knit.src).KnitClient
		KitSkinCtrl = KC.Controllers.KitSkinController
	end)

	local BOW_ROT = CFrame.Angles(0, math.rad(-90), 0)
	local CROSSBOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(-360), 0)
	local LUNAR_CROSSBOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, -190, math.rad(-180))
	local VICTORIOUS_ARCHER_BOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, -52, math.rad(90))
	local VICTORIOUS_ARCHER_CROSSBOW_ROT = CFrame.new(0.00, 0.00, 0.00) * CFrame.Angles(math.rad(0), math.rad(80), math.rad(0.00))
	local VICTORIOUS_ARCHER_HEADHUNTER_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0)
	local HEADHUNTER_ROT = CFrame.new(0.4, 0, 0) * CFrame.Angles(0, math.rad(360), 0)
	local AXE_ROT = CFrame.new(0, 0, -0.4) * CFrame.Angles(0, math.rad(90), 0)
	local PICKAXE_ROT = CFrame.new(0, 0, -0.1) * CFrame.Angles(0, math.rad(110), 0)
	local LASSO_ROT = CFrame.Angles(0, math.rad(90), 0)
	local STAFF_ROT = CFrame.Angles(0, math.rad(90), 0)
	local PIXEL_SWORD_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local SWORD_ROT = CFrame.new(0, -1.7, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local HEARTBEAM_SWORD_ROT = CFrame.new(0, -1.2, 0) * CFrame.Angles(0, math.rad(0), 0)
	local LIFE_BOW_ROT = CFrame.Angles(0, math.rad(-20), 0)
	local DAO_ROT = CFrame.new(0, -1.7, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local VIC_ROT = CFrame.new(0, -1.9, 0) * CFrame.Angles(0, math.rad(360), 0)
	local HEXED_DAO_ROT = CFrame.new(0.00, 0.00, 0.00) * CFrame.Angles(math.rad(180.00), math.rad(-4.00), math.rad(0.00))
	local SNOW_DAO_ROT = CFrame.new(-0.2, -0.9, 0) * CFrame.Angles(0, math.rad(-180), 0)
	local HARPOON_ROT = CFrame.new(0, -1.4, -0.15) * CFrame.Angles(0, math.rad(180), 0)
	local TRIDENT_ROT = CFrame.new(0, 0.5, 0.05) * CFrame.Angles(0, math.rad(180), 0)
	local LYLA_BOW_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(30, -30, 183.56)
	local LYLA_CROSSBOW_ROT = CFrame.Angles(math.rad(0), math.rad(180), math.rad(0))
	local LYLA_HEADHUNTER_ROT = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(0), 0)
	local LYLA_FROST_CROSSBOW_ROT = CFrame.new(0.00, 0.00, 0.00) * CFrame.Angles(math.rad(180.00), math.rad(178.00), math.rad(0.00))

	local CANNON_HAND_SCALE = 0.34
	local CANNON_PLACED_OFFSET = CFrame.new(0, -1.0, 0)
	local CANNON_TOOL_NAME = "cannon"

	local CANNON_SKIN_NAMES = {
		["Victorious Cannon"] = {
			Gold = "cannon_gold_victorious",
			Platinum = "cannon_platinum_victorious",
			Diamond = "cannon_diamond_victorious",
			Emerald = "cannon_emerald_victorious",
			Nightmare = "cannon_nightmare_victorious",
		},
		["Ghost Cannon"] = { Default = "cannon_ghost" },
		["Deep Sea Cannon"] = { Default = "cannon_deepsea" },
	}

	local CANNON_SOUND_NAMES = {
		Gold = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
		Platinum = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
		Diamond = "CANNON_FIRE_VICTORIOUS_DIAMOND",
		Emerald = "CANNON_FIRE_VICTORIOUS_EMERALD",
		Nightmare = "CANNON_FIRE_VICTORIOUS_NIGHTMARE",
	}

	local SKIN_OFFSETS = {
		["nightmare_victorious_flower_bow"] = LYLA_BOW_ROT,
		["emerald_victorious_flower_bow"] = LYLA_BOW_ROT,
		["diamond_victorious_flower_bow"] = LYLA_BOW_ROT,
		["platinum_victorious_flower_bow"] = LYLA_BOW_ROT,
		["gold_victorious_flower_bow"] = LYLA_BOW_ROT,
		["nightmare_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["emerald_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["diamond_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["platinum_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["gold_victorious_flower_crossbow"] = LYLA_CROSSBOW_ROT,
		["nightmare_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["emerald_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["diamond_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["platinum_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["gold_victorious_flower_headhunter"] = LYLA_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_nightmare"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_emerald"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_diamond"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_platinum"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["tactical_headhunter_victorious_gold"] = VICTORIOUS_ARCHER_HEADHUNTER_ROT,
		["flower_bow_frost_queen"] = BOW_ROT,
		["tactical_crossbow_lunar_dragon"] = LUNAR_CROSSBOW_ROT,
		["life_bow_mummy"] = LIFE_BOW_ROT,
		["flower_headhunter_frost_queen"] = HEADHUNTER_ROT,
		["flower_crossbow_frost_queen"] = LYLA_FROST_CROSSBOW_ROT,
		["wood_sword_darkvalentine"] = SWORD_ROT,
		["stone_sword_darkvalentine"] = SWORD_ROT,
		["iron_sword_darkvalentine"] = SWORD_ROT,
		["diamond_sword_darkvalentine"] = SWORD_ROT,
		["emerald_sword_darkvalentine"] = SWORD_ROT,
		["wood_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["stone_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["iron_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["diamond_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["emerald_sword_heartbeam"] = HEARTBEAM_SWORD_ROT,
		["wood_bow_victorious_nightmare"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_emerald"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_diamond"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_platinum"] = VICTORIOUS_ARCHER_BOW_ROT,
		["wood_bow_victorious_gold"] = VICTORIOUS_ARCHER_BOW_ROT,
		["tactical_crossbow_victorious_nightmare"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_emerald"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_diamond"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_platinum"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["tactical_crossbow_victorious_gold"] = VICTORIOUS_ARCHER_CROSSBOW_ROT,
		["life_crossbow_mummy"] = CROSSBOW_ROT,
		["life_headhunter_mummy"] = HEADHUNTER_ROT,
		["victorious_gold_triton"] = TRIDENT_ROT,
		["victorious_platinum_triton"] = TRIDENT_ROT,
		["victorious_diamond_triton"] = TRIDENT_ROT,
		["victorious_emerald_triton"] = TRIDENT_ROT,
		["victorious_nightmare_triton"] = TRIDENT_ROT,
		["demon_triton"] = HARPOON_ROT,
		["lasso_mummy"] = LASSO_ROT,
		["lasso_wrangler_reindeer_lassy"] = LASSO_ROT,
		["lasso_lifeguard"] = LASSO_ROT,
		["wood_axe_darkvalentine"] = AXE_ROT,
		["stone_axe_darkvalentine"] = AXE_ROT,
		["iron_axe_darkvalentine"] = AXE_ROT,
		["diamond_axe_darkvalentine"] = AXE_ROT,
		["wood_axe_valentine"] = AXE_ROT,
		["stone_axe_valentine"] = AXE_ROT,
		["iron_axe_valentine"] = AXE_ROT,
		["diamond_axe_valentine"] = AXE_ROT,
		["wood_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["stone_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["iron_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["diamond_pickaxe_darkvalentine"] = PICKAXE_ROT,
		["wood_pickaxe_valentine"] = PICKAXE_ROT,
		["stone_pickaxe_valentine"] = PICKAXE_ROT,
		["iron_pickaxe_valentine"] = PICKAXE_ROT,
		["diamond_pickaxe_valentine"] = PICKAXE_ROT,
		["gold_victorious_wizard_staff"] = STAFF_ROT,
		["gold_victorious_wizard_staff_2"] = STAFF_ROT,
		["gold_victorious_wizard_staff_3"] = STAFF_ROT,
		["platinum_victorious_wizard_staff"] = STAFF_ROT,
		["platinum_victorious_wizard_staff_2"] = STAFF_ROT,
		["platinum_victorious_wizard_staff_3"] = STAFF_ROT,
		["diamond_victorious_wizard_staff"] = STAFF_ROT,
		["diamond_victorious_wizard_staff_2"] = STAFF_ROT,
		["diamond_victorious_wizard_staff_3"] = STAFF_ROT,
		["emerald_victorious_wizard_staff"] = STAFF_ROT,
		["emerald_victorious_wizard_staff_2"] = STAFF_ROT,
		["emerald_victorious_wizard_staff_3"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff_2"] = STAFF_ROT,
		["nightmare_victorious_wizard_staff_3"] = STAFF_ROT,
		["wood_dao_victorious"] = VIC_ROT,
		["stone_dao_victorious"] = VIC_ROT,
		["iron_dao_victorious"] = VIC_ROT,
		["diamond_dao_victorious"] = VIC_ROT,
		["emerald_dao_victorious"] = VIC_ROT,
		["wood_dao_cursed"] = HEXED_DAO_ROT,
		["stone_dao_cursed"] = HEXED_DAO_ROT,
		["iron_dao_cursed"] = HEXED_DAO_ROT,
		["diamond_dao_cursed"] = HEXED_DAO_ROT,
		["emerald_dao_cursed"] = HEXED_DAO_ROT,
		["wood_dao_tiger"] = DAO_ROT,
		["stone_dao_tiger"] = DAO_ROT,
		["iron_dao_tiger"] = DAO_ROT,
		["diamond_dao_tiger"] = DAO_ROT,
		["emerald_dao_tiger"] = DAO_ROT,
		["wood_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["stone_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["iron_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["diamond_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["emerald_dao_snow_rabbit"] = SNOW_DAO_ROT,
		["wood_sword_pixel"] = PIXEL_SWORD_ROT,
		["stone_sword_pixel"] = PIXEL_SWORD_ROT,
		["iron_sword_pixel"] = PIXEL_SWORD_ROT,
		["diamond_sword_pixel"] = PIXEL_SWORD_ROT,
		["emerald_sword_pixel"] = PIXEL_SWORD_ROT,
		["wood_sword_short_pixel"] = PIXEL_SWORD_ROT,
		["stone_sword_short_pixel"] = PIXEL_SWORD_ROT,
		["iron_sword_short_pixel"] = PIXEL_SWORD_ROT,
		["diamond_sword_short_pixel"] = PIXEL_SWORD_ROT,
		["emerald_sword_short_pixel"] = PIXEL_SWORD_ROT,
	}

	local KIT_SKIN_MAP = {
		["Victorious Lyla"] = { Gold = "gold_victorious_lyla", Platinum = "platinum_victorious_lyla", Diamond = "diamond_victorious_lyla", Emerald = "emerald_victorious_lyla", Nightmare = "nightmare_victorious_lyla" },
		["Frost Queen Lyla"] = { Default = "flower_bee_frost_queen" },
		["Victorious Archer"] = { Gold = "archer_victorious_gold", Platinum = "archer_victorious_platinum", Diamond = "archer_victorious_diamond", Emerald = "archer_victorious_emerald", Nightmare = "archer_victorious_nightmare" },
		["Lunar Dragon Archer"] = { Default = "archer_lunar_dragon" },
		["Victorious Yuzi"] = { Default = "yuzi_victorious" },
		["Hexed Yuzi"] = { Default = "dasher_cursed" },
		["Tiger Yuzi"] = { Default = "dasher_tiger" },
		["Snow Rabbit Yuzi"] = { Default = "dasher_snow_rabbit" },
		["Victorious Zeno"] = { Gold = "gold_victorious_wizard", Platinum = "platinum_victorious_wizard", Diamond = "diamond_victorious_wizard", Emerald = "emerald_victorious_wizard", Nightmare = "nightmare_victorious_wizard" },
		["Victorious Triton"] = { Gold = "victorious_gold_triton", Platinum = "victorious_platinum_triton", Diamond = "victorious_diamond_triton", Emerald = "victorious_emerald_triton", Nightmare = "victorious_nightmare_triton" },
		["Demon Triton"] = { Default = "demon_triton" },
		["Mummy Life Bow"] = { Default = "mummy_nazar" },
		["Mummy Lasso"] = { Default = "cowgirl_mummy" },
		["Victorious Cannon"] = { Gold = "gold_victorious_davey", Platinum = "platinum_victorious_davey", Diamond = "diamond_victorious_davey", Emerald = "emerald_victorious_davey", Nightmare = "nightmare_victorious_davey" },
		["Ghost Cannon"] = { Default = "davey_ghost" },
		["Deep Sea Cannon"] = { Default = "davey_deepsea" },
	}

	local STORE_SKIN_MAP = {
		["Balloon Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.BALLOON_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.BALLOON_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.BALLOON_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.BALLOON_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.BALLOON_EMERALD_SWORD } } end,
		["Banana Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.BANANA_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.BANANA_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.BANANA_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.BANANA_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.BANANA_EMERALD_SWORD } } end,
		["Valentine Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.VALENTINE_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.VALENTINE_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.VALENTINE_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.VALENTINE_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.VALENTINE_EMERALD_SWORD } } end,
		["Darkheart Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.DARKVALENTINE_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.DARKVALENTINE_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.DARKVALENTINE_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.DARKVALENTINE_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.DARKVALENTINE_EMERALD_SWORD } } end,
		["Heartbeam Swords"] = function() return { { ItemType.WOOD_SWORD, ItemSkinType.HEARTBEAM_WOOD_SWORD }, { ItemType.STONE_SWORD, ItemSkinType.HEARTBEAM_STONE_SWORD }, { ItemType.IRON_SWORD, ItemSkinType.HEARTBEAM_IRON_SWORD }, { ItemType.DIAMOND_SWORD, ItemSkinType.HEARTBEAM_DIAMOND_SWORD }, { ItemType.EMERALD_SWORD, ItemSkinType.HEARTBEAM_EMERALD_SWORD } } end,
		["Valentine Pickaxes"] = function() return { { ItemType.WOOD_PICKAXE, ItemSkinType.VALENTINE_WOOD_PICKAXE }, { ItemType.STONE_PICKAXE, ItemSkinType.VALENTINE_STONE_PICKAXE }, { ItemType.IRON_PICKAXE, ItemSkinType.VALENTINE_IRON_PICKAXE }, { ItemType.DIAMOND_PICKAXE, ItemSkinType.VALENTINE_DIAMOND_PICKAXE } } end,
		["Darkheart Pickaxes"] = function() return { { ItemType.WOOD_PICKAXE, ItemSkinType.DARKVALENTINE_WOOD_PICKAXE }, { ItemType.STONE_PICKAXE, ItemSkinType.DARKVALENTINE_STONE_PICKAXE }, { ItemType.IRON_PICKAXE, ItemSkinType.DARKVALENTINE_IRON_PICKAXE }, { ItemType.DIAMOND_PICKAXE, ItemSkinType.DARKVALENTINE_DIAMOND_PICKAXE } } end,
		["Valentine Axes"] = function() return { { ItemType.WOOD_AXE, ItemSkinType.VALENTINE_WOOD_AXE }, { ItemType.STONE_AXE, ItemSkinType.VALENTINE_STONE_AXE }, { ItemType.IRON_AXE, ItemSkinType.VALENTINE_IRON_AXE }, { ItemType.DIAMOND_AXE, ItemSkinType.VALENTINE_DIAMOND_AXE } } end,
		["Darkheart Axes"] = function() return { { ItemType.WOOD_AXE, ItemSkinType.DARKVALENTINE_WOOD_AXE }, { ItemType.STONE_AXE, ItemSkinType.DARKVALENTINE_STONE_AXE }, { ItemType.IRON_AXE, ItemSkinType.DARKVALENTINE_IRON_AXE }, { ItemType.DIAMOND_AXE, ItemSkinType.DARKVALENTINE_DIAMOND_AXE } } end,
		["Mummy Life Bow"] = function() return { { ItemType.LIFE_BOW, ItemSkinType.LIFE_BOW_MUMMY }, { ItemType.LIFE_CROSSBOW, ItemSkinType.LIFE_CROSSBOW_MUMMY }, { ItemType.LIFE_HEADHUNTER, ItemSkinType.LIFE_HEADHUNTER_MUMMY } } end,
		["Mummy Lasso"] = function() return { { ItemType.LASSO, ItemSkinType.LASSO_MUMMY } } end,
	}

	local function yuziDaoMap(suffix)
		return {
			wood_dao = "wood_dao_" .. suffix,
			stone_dao = "stone_dao_" .. suffix,
			iron_dao = "iron_dao_" .. suffix,
			diamond_dao = "diamond_dao_" .. suffix,
			emerald_dao = "emerald_dao_" .. suffix,
		}
	end

	local SKIN_DATA = {
		["Victorious Lyla"] = function(t)
			local lt = t:lower()
			return {
				flower_bow = lt .. "_victorious_flower_bow",
				flower_crossbow = lt .. "_victorious_flower_crossbow",
				flower_headhunter = lt .. "_victorious_flower_headhunter",
			}
		end,
		["Frost Queen Lyla"] = function()
			return {
				flower_bow = "flower_bow_frost_queen",
				flower_crossbow = "flower_crossbow_frost_queen",
				flower_headhunter = "flower_headhunter_frost_queen",
			}
		end,
		["Victorious Archer"] = function(t)
			local lt = t:lower()
			return {
				wood_bow = "wood_bow_victorious_" .. lt,
				tactical_crossbow = "tactical_crossbow_victorious_" .. lt,
				tactical_headhunter = "tactical_headhunter_victorious_" .. lt,
			}
		end,
		["Lunar Dragon Archer"] = function()
			return {
				wood_bow = "wood_bow_lunar_dragon",
				tactical_crossbow = "tactical_crossbow_lunar_dragon",
				tactical_headhunter = "tactical_headhunter_lunar_dragon",
			}
		end,
		["Victorious Triton"] = function(t)
			return { harpoon = "victorious_" .. t:lower() .. "_triton" }
		end,
		["Demon Triton"] = function() return { harpoon = "demon_triton" } end,
		["Victorious Yuzi"] = function() return yuziDaoMap("victorious") end,
		["Hexed Yuzi"] = function() return yuziDaoMap("cursed") end,
		["Tiger Yuzi"] = function() return yuziDaoMap("tiger") end,
		["Snow Rabbit Yuzi"] = function() return yuziDaoMap("snow_rabbit") end,
		["Victorious Zeno"] = function(t)
			local lt = t:lower()
			return {
				wizard_staff = lt .. "_victorious_wizard_staff",
				wizard_staff_2 = lt .. "_victorious_wizard_staff_2",
				wizard_staff_3 = lt .. "_victorious_wizard_staff_3",
			}
		end,
		["Balloon Swords"] = function() return { wood_sword = "balloon_wood_sword", stone_sword = "balloon_stone_sword", iron_sword = "balloon_iron_sword", diamond_sword = "balloon_diamond_sword", emerald_sword = "balloon_emerald_sword" } end,
		["Banana Swords"] = function() return { wood_sword = "banana_wood_sword", stone_sword = "banana_stone_sword", iron_sword = "banana_iron_sword", diamond_sword = "banana_diamond_sword", emerald_sword = "banana_emerald_sword" } end,
		["Valentine Swords"] = function() return { wood_sword = "wood_sword_valentine", stone_sword = "stone_sword_valentine", iron_sword = "iron_sword_valentine", diamond_sword = "diamond_sword_valentine", emerald_sword = "emerald_sword_valentine" } end,
		["Darkheart Swords"] = function() return { wood_sword = "wood_sword_darkvalentine", stone_sword = "stone_sword_darkvalentine", iron_sword = "iron_sword_darkvalentine", diamond_sword = "diamond_sword_darkvalentine", emerald_sword = "emerald_sword_darkvalentine" } end,
		["Heartbeam Swords"] = function() return { wood_sword = "wood_sword_heartbeam", stone_sword = "stone_sword_heartbeam", iron_sword = "iron_sword_heartbeam", diamond_sword = "diamond_sword_heartbeam", emerald_sword = "emerald_sword_heartbeam" } end,
		["Valentine Pickaxes"] = function() return { wood_pickaxe = "wood_pickaxe_valentine", stone_pickaxe = "stone_pickaxe_valentine", iron_pickaxe = "iron_pickaxe_valentine", diamond_pickaxe = "diamond_pickaxe_valentine" } end,
		["Darkheart Pickaxes"] = function() return { wood_pickaxe = "wood_pickaxe_darkvalentine", stone_pickaxe = "stone_pickaxe_darkvalentine", iron_pickaxe = "iron_pickaxe_darkvalentine", diamond_pickaxe = "diamond_pickaxe_darkvalentine" } end,
		["Valentine Axes"] = function() return { wood_axe = "wood_axe_valentine", stone_axe = "stone_axe_valentine", iron_axe = "iron_axe_valentine", diamond_axe = "diamond_axe_valentine" } end,
		["Darkheart Axes"] = function() return { wood_axe = "wood_axe_darkvalentine", stone_axe = "stone_axe_darkvalentine", iron_axe = "iron_axe_darkvalentine", diamond_axe = "diamond_axe_darkvalentine" } end,
		["Mummy Lasso"] = function() return { lasso = "lasso_mummy" } end,
		["Mummy Life Bow"] = function() return { life_bow = "life_bow_mummy", life_crossbow = "life_crossbow_mummy", life_headhunter = "life_headhunter_mummy" } end,
		["Pixel Swords"] = function() return { wood_sword = "wood_sword_pixel", stone_sword = "stone_sword_pixel", iron_sword = "iron_sword_pixel", diamond_sword = "diamond_sword_pixel", emerald_sword = "emerald_sword_pixel" } end,
		["Pixel Swords Short"] = function() return { wood_sword = "wood_sword_short_pixel", stone_sword = "stone_sword_short_pixel", iron_sword = "iron_sword_short_pixel", diamond_sword = "diamond_sword_short_pixel", emerald_sword = "emerald_sword_short_pixel" } end,
	}

	local TIERED_SKINS = {
		["Victorious Lyla"] = true,
		["Victorious Archer"] = true,
		["Victorious Zeno"] = true,
		["Victorious Triton"] = true,
		["Victorious Cannon"] = true,
	}

	local function normalizeName(s)
		return s:lower():gsub("[_%s%-]", "")
	end

	local function isCannonSkin()
		return CANNON_SKIN_NAMES[CURRENT_ITEM_SKIN] ~= nil
	end

	local function getCurrentCannonSkinName()
		local tbl = CANNON_SKIN_NAMES[CURRENT_ITEM_SKIN]
		if not tbl then return nil end
		return tbl[CURRENT_SKIN_TYPE] or tbl.Default
	end

	local function getCannonSkinSource(skinName)
		local assets = RS:FindFirstChild("Assets")
		if not assets then return nil end
		local blocks = assets:FindFirstChild("Blocks")
		if not blocks then return nil end
		return blocks:FindFirstChild(skinName)
	end

	local function getCurrentMappings()
		local fn = SKIN_DATA[CURRENT_ITEM_SKIN]
		if not fn then return {} end
		return fn(CURRENT_SKIN_TYPE) or {}
	end

	local function getKitSkinValue()
		local m = KIT_SKIN_MAP[CURRENT_ITEM_SKIN]
		if not m then return nil end
		return m[CURRENT_SKIN_TYPE] or m.Default
	end

	local function getStoreSkins()
		local fn = STORE_SKIN_MAP[CURRENT_ITEM_SKIN]
		if not fn then return {} end
		return fn() or {}
	end

	local tagged = setmetatable({}, { __mode = "k" })
	local connections = {}
	local invisConns = setmetatable({}, { __mode = "k" })
	local oldGetKitSkin = nil
	local savedStoreSkins = {}

	local cannonTagged = setmetatable({}, { __mode = "k" })
	local cannonConnections = {}
	local cannonRenderConns = {}
	local oldFireCannon, oldLaunchSelf
	local soundsHooked = false

	local function firstBasePart(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then return d end
		end
	end

	local function makeInvisible(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then
				d.LocalTransparencyModifier = 1
				d.Transparency = 1
			elseif d:IsA("Decal") or d:IsA("Texture") then
				d.Transparency = 1
			end
		end
	end

	local function restoreVisibility(root)
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") then
				d.LocalTransparencyModifier = 0
				d.Transparency = 0
			elseif d:IsA("Decal") or d:IsA("Texture") then
				d.Transparency = 0
			end
		end
	end

	local function setNoCollide(model)
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
				d.Massless = true
				d.Anchored = false
			end
		end
	end

	local function weldAllTo(anchor, container)
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("BasePart") and d ~= anchor then
				local wc = Instance.new("WeldConstraint")
				wc.Part0 = anchor
				wc.Part1 = d
				wc.Parent = anchor
			end
		end
	end

	local function startInvisibilityEnforcer(tool)
		if invisConns[tool] then
			pcall(function() invisConns[tool]:Disconnect() end)
			invisConns[tool] = nil
		end
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not tool or not tool.Parent then
				conn:Disconnect()
				invisConns[tool] = nil
				return
			end
			local reskin = tool:FindFirstChild("LOCAL_ITEM_RESKIN")
			for _, d in ipairs(tool:GetDescendants()) do
				if reskin and d:IsDescendantOf(reskin) then continue end
				if d:IsA("BasePart") then
					d.LocalTransparencyModifier = 1
					d.Transparency = 1
				elseif d:IsA("Decal") or d:IsA("Texture") then
					d.Transparency = 1
				end
			end
		end)
		invisConns[tool] = conn
		table.insert(connections, conn)
	end

	local function attachReskin(tool, skinName)
		if not tool or tagged[tool] then return end
		tagged[tool] = true

		local origHandle = tool:FindFirstChild("Handle")
		if not (origHandle and origHandle:IsA("BasePart")) then
			origHandle = firstBasePart(tool)
		end
		if not origHandle then tagged[tool] = nil; return end

		local itemsFolder = RS:FindFirstChild("Items")
		if not itemsFolder then tagged[tool] = nil; return end
		local source = itemsFolder:FindFirstChild(skinName)
		if not source then tagged[tool] = nil; return end
		makeInvisible(tool)

		local clone = source:Clone()
		clone.Name = "LOCAL_ITEM_RESKIN"
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				pcall(d.Destroy, d)
			end
		end

		setNoCollide(clone)
		clone.Parent = tool

		local cloneAnchor = clone:FindFirstChild("Handle")
		if not (cloneAnchor and cloneAnchor:IsA("BasePart")) then
			if clone:IsA("Model") then
				if not clone.PrimaryPart then
					local p = firstBasePart(clone)
					if p then pcall(function() clone.PrimaryPart = p end) end
				end
				cloneAnchor = clone.PrimaryPart
			end
			cloneAnchor = cloneAnchor or firstBasePart(clone)
		end

		if not cloneAnchor then
			clone:Destroy(); restoreVisibility(tool); tagged[tool] = nil; return
		end

		pcall(function() cloneAnchor.CFrame = origHandle.CFrame end)
		weldAllTo(cloneAnchor, clone)

		local w = Instance.new("Weld")
		w.Part0 = origHandle
		w.Part1 = cloneAnchor
		w.C0 = SKIN_OFFSETS[skinName] or CFrame.identity
		w.C1 = CFrame.identity
		w.Parent = cloneAnchor
		startInvisibilityEnforcer(tool)
	end

	local function weldAllToPrimary(model)
		local primary = model.PrimaryPart
		if not primary then return end
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") and d ~= primary then
				local wc = Instance.new("WeldConstraint")
				wc.Part0 = primary
				wc.Part1 = d
				wc.Parent = primary
			end
		end
	end

	local function attachCannonReskin(targetRoot, posOffset, heldScale)
		if not targetRoot or cannonTagged[targetRoot] then return end
		cannonTagged[targetRoot] = true

		local targetPart = targetRoot:FindFirstChild("Handle")
		if not (targetPart and targetPart:IsA("BasePart")) then
			targetPart = firstBasePart(targetRoot)
		end
		if not targetPart then cannonTagged[targetRoot] = nil; return end

		local skinName = getCurrentCannonSkinName()
		if not skinName then cannonTagged[targetRoot] = nil; return end
		local source = getCannonSkinSource(skinName)
		if not source then cannonTagged[targetRoot] = nil; return end

		makeInvisible(targetRoot)

		local clone = source:Clone()
		clone.Name = "LOCAL_CANNON_RESKIN"
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				pcall(d.Destroy, d)
			end
		end

		if not clone:IsA("Model") then
			setNoCollide(clone)
			clone.Parent = targetRoot
			return
		end

		if not clone.PrimaryPart then
			local p = firstBasePart(clone)
			if p then pcall(function() clone.PrimaryPart = p end) end
		end
		if not clone.PrimaryPart then
			clone:Destroy(); cannonTagged[targetRoot] = nil; return
		end

		if heldScale and heldScale ~= 1 then
			pcall(function() clone:ScaleTo(heldScale) end)
		end

		setNoCollide(clone)
		clone.Parent = targetRoot

		local offset = posOffset or CFrame.identity
		pcall(function() clone:PivotTo(targetPart.CFrame * offset) end)

		weldAllToPrimary(clone)

		local wc = Instance.new("WeldConstraint")
		wc.Part0 = targetPart
		wc.Part1 = clone.PrimaryPart
		wc.Parent = clone.PrimaryPart
	end

	local function hookCannonThirdPerson(character)
		local function onChildAdded(child)
			if not (child:IsA("Tool") and child.Name == CANNON_TOOL_NAME) then return end
			task.wait()

			local handle = child:FindFirstChild("Handle") or firstBasePart(child)
			if not handle then return end

			local existing = child:FindFirstChild("LOCAL_CANNON_RESKIN")
			if existing then existing:Destroy(); cannonTagged[child] = nil end

			attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)

			local start = time()
			local conn
			conn = RunService.RenderStepped:Connect(function()
				if not child.Parent then conn:Disconnect(); return end
				makeInvisible(child)
				if time() - start > 3 then conn:Disconnect() end
			end)
			table.insert(cannonRenderConns, conn)
		end

		for _, c in ipairs(character:GetChildren()) do onChildAdded(c) end
		local conn = character.ChildAdded:Connect(onChildAdded)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonViewmodel()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local function hookVM(vm)
			for _, child in ipairs(vm:GetChildren()) do
				if child.Name == CANNON_TOOL_NAME then
					attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
				end
			end
			local conn = vm.ChildAdded:Connect(function(child)
				if child.Name == CANNON_TOOL_NAME then
					task.wait()
					attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
				end
			end)
			table.insert(cannonConnections, conn)
		end
		local vm = cam:FindFirstChild("Viewmodel")
		if vm then hookVM(vm) end
		local conn = cam.ChildAdded:Connect(function(child)
			if child.Name == "Viewmodel" then task.wait(); hookVM(child) end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonContainer(container)
		if not container then return end
		for _, child in ipairs(container:GetChildren()) do
			if child.Name == CANNON_TOOL_NAME then
				attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
			end
		end
		local conn = container.ChildAdded:Connect(function(child)
			if child.Name == CANNON_TOOL_NAME then
				task.wait()
				attachCannonReskin(child, CFrame.identity, CANNON_HAND_SCALE)
			end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonBlocksFolder(blocksFolder)
		for _, child in ipairs(blocksFolder:GetChildren()) do
			if child.Name == CANNON_TOOL_NAME then
				attachCannonReskin(child, CANNON_PLACED_OFFSET, 1)
			end
		end
		local conn = blocksFolder.ChildAdded:Connect(function(child)
			if child.Name == CANNON_TOOL_NAME then
				task.wait()
				attachCannonReskin(child, CANNON_PLACED_OFFSET, 1)
			end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookAllWorldCannons()
		local map = workspace:FindFirstChild("Map")
		if not map then return end
		local worlds = map:FindFirstChild("Worlds")
		if not worlds then return end
		for _, world in ipairs(worlds:GetChildren()) do
			local blocks = world:FindFirstChild("Blocks")
			if blocks then hookCannonBlocksFolder(blocks) end
		end
		local conn = worlds.ChildAdded:Connect(function(world)
			task.wait()
			local blocks = world:FindFirstChild("Blocks")
			if blocks then hookCannonBlocksFolder(blocks) end
		end)
		table.insert(cannonConnections, conn)
	end

	local function hookCannonSounds()
		if soundsHooked then return end
		if not (bedwars and bedwars.CannonHandController) then return end
		soundsHooked = true
		oldFireCannon = bedwars.CannonHandController.fireCannon
		oldLaunchSelf = bedwars.CannonHandController.launchSelf

		local function replaceSound()
			for _, v in ipairs(workspace.SoundPool:GetChildren()) do
				if v:IsA("Sound") and v.SoundId == "rbxassetid://7121064180" then v:Destroy() end
			end
			local key = CANNON_SOUND_NAMES[CURRENT_SKIN_TYPE] or CANNON_SOUND_NAMES.Nightmare
			if bedwars.SoundManager and bedwars.SoundList and bedwars.SoundList[key] then
				bedwars.SoundManager:playSound(bedwars.SoundList[key])
			end
		end

		bedwars.CannonHandController.fireCannon = function(...) replaceSound(); return oldFireCannon(...) end
		bedwars.CannonHandController.launchSelf = function(...) replaceSound(); return oldLaunchSelf(...) end
	end

	local function unhookCannonSounds()
		if soundsHooked and bedwars and bedwars.CannonHandController then
			if oldFireCannon then bedwars.CannonHandController.fireCannon = oldFireCannon end
			if oldLaunchSelf then bedwars.CannonHandController.launchSelf = oldLaunchSelf end
		end
		oldFireCannon = nil; oldLaunchSelf = nil; soundsHooked = false
	end

	local function cleanupCannons()
		for _, c in pairs(cannonConnections) do pcall(function() c:Disconnect() end) end
		for _, c in pairs(cannonRenderConns) do pcall(function() c:Disconnect() end) end
		table.clear(cannonConnections)
		table.clear(cannonRenderConns)

		for root in pairs(cannonTagged) do
			if root and root.Parent then
				local r = root:FindFirstChild("LOCAL_CANNON_RESKIN")
				if r then r:Destroy() end
				restoreVisibility(root)
			end
		end
		table.clear(cannonTagged)

		local map = workspace:FindFirstChild("Map")
		if map then
			local worlds = map:FindFirstChild("Worlds")
			if worlds then
				for _, world in ipairs(worlds:GetChildren()) do
					local blocks = world:FindFirstChild("Blocks")
					if blocks then
						for _, child in ipairs(blocks:GetChildren()) do
							if child.Name == CANNON_TOOL_NAME then
								local r = child:FindFirstChild("LOCAL_CANNON_RESKIN")
								if r then r:Destroy() end
								restoreVisibility(child)
							end
						end
					end
				end
			end
		end

		unhookCannonSounds()
	end

	local function applyKitSkinHook()
		if not KitSkinCtrl then return end
		local val = getKitSkinValue()
		if not val then return end
		if not oldGetKitSkin then oldGetKitSkin = KitSkinCtrl.getKitSkin end
		KitSkinCtrl.getKitSkin = function(self, char)
			if char == LocalPlayer.Character then return val end
			return oldGetKitSkin(self, char)
		end
	end

	local function removeKitSkinHook()
		if KitSkinCtrl and oldGetKitSkin then
			KitSkinCtrl.getKitSkin = oldGetKitSkin
			oldGetKitSkin = nil
		end
	end

	local function applyStoreSkins()
		if not (bedwars and bedwars.Store) then return end
		local skins = getStoreSkins()
		savedStoreSkins = {}
		local state = bedwars.Store:getState()
		for _, pair in ipairs(skins) do
			if pair[1] and pair[2] then
				local prev = state.Locker and state.Locker.selectedItemSkins and state.Locker.selectedItemSkins[pair[1]]
				table.insert(savedStoreSkins, { pair[1], prev })
				pcall(function() bedwars.Store:dispatch({ type = "LockerSetItemSkin", itemType = pair[1], itemSkin = pair[2] }) end)
			end
		end
	end

	local function clearStoreSkins()
		if not (bedwars and bedwars.Store) then return end
		for _, saved in ipairs(savedStoreSkins) do
			pcall(function() bedwars.Store:dispatch({ type = "LockerSetItemSkin", itemType = saved[1], itemSkin = saved[2] }) end)
		end
		savedStoreSkins = {}
	end

	local function tryApply(child)
		if isCannonSkin() then return end
		local mappings = getCurrentMappings()

		local skinName = mappings[child.Name:lower()]

		if not skinName then
			local childNorm = normalizeName(child.Name)
			for k, v in pairs(mappings) do
				if normalizeName(k) == childNorm then skinName = v; break end
			end
		end

		if not skinName then return end
		task.wait()
		if child.Parent then attachReskin(child, skinName) end
	end

	local function hookViewmodel()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local function hookVM(vm)
			for _, child in ipairs(vm:GetChildren()) do tryApply(child) end
			table.insert(connections, vm.ChildAdded:Connect(tryApply))
		end
		local vm = cam:FindFirstChild("Viewmodel")
		if vm then hookVM(vm) end
		table.insert(connections, cam.ChildAdded:Connect(function(child)
			if child.Name == "Viewmodel" then task.wait(); hookVM(child) end
		end))
	end

	local function hookContainer(container)
		if not container then return end
		for _, child in ipairs(container:GetChildren()) do tryApply(child) end
		table.insert(connections, container.ChildAdded:Connect(tryApply))
	end

	local function cleanupDeadTagged()
		for root in pairs(tagged) do
			if not root or not root.Parent then
				tagged[root] = nil
			end
		end
		for tool in pairs(invisConns) do
			if not tool or not tool.Parent then
				pcall(function() invisConns[tool]:Disconnect() end)
				invisConns[tool] = nil
			end
		end
	end

	local function onCharacterAdded(character)
		task.wait(0.2)
		cleanupDeadTagged()
		applyKitSkinHook()
		if isCannonSkin() then
			hookCannonContainer(LocalPlayer.Backpack)
			hookCannonContainer(character)
			hookCannonThirdPerson(character)
		else
			hookContainer(LocalPlayer.Backpack)
			hookContainer(character)
		end
	end

	local function cleanup()
		for tool, conn in pairs(invisConns) do
			pcall(function() conn:Disconnect() end)
		end
		table.clear(invisConns)

		for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
		table.clear(connections)
		for root in pairs(tagged) do
			if root and root.Parent then
				local r = root:FindFirstChild("LOCAL_ITEM_RESKIN")
				if r then r:Destroy() end
				restoreVisibility(root)
			end
		end
		table.clear(tagged)
		removeKitSkinHook()
		clearStoreSkins()
		cleanupCannons()
	end

	local skinNames = {}
	for name in pairs(SKIN_DATA) do table.insert(skinNames, name) end
	for name in pairs(CANNON_SKIN_NAMES) do table.insert(skinNames, name) end
	table.sort(skinNames)

	local SkinTypeDropdown

	SkinChanger = vape.Categories.Render:CreateModule({
		Name = "SkinChanger",
		Function = function(enabled)
			if enabled then
				if isCannonSkin() then
					hookCannonViewmodel()
					hookAllWorldCannons()
					hookCannonSounds()
					applyKitSkinHook()
					if LocalPlayer.Character then
						hookCannonContainer(LocalPlayer.Backpack)
						hookCannonContainer(LocalPlayer.Character)
						hookCannonThirdPerson(LocalPlayer.Character)
					end
				else
					hookViewmodel()
					applyKitSkinHook()
					applyStoreSkins()
					if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
				end
				table.insert(connections, LocalPlayer.CharacterAdded:Connect(onCharacterAdded))
			else
				cleanup()
			end
		end,
		Tooltip = "Client-sided item skin changer",
	})

	SkinChanger:CreateDropdown({
		Name = "Item Skin",
		List = skinNames,
		Default = CURRENT_ITEM_SKIN,
		Function = function(val)
			CURRENT_ITEM_SKIN = val
			if SkinTypeDropdown and SkinTypeDropdown.Object then
				SkinTypeDropdown.Object.Visible = TIERED_SKINS[val] == true
			end
			if SkinChanger.Enabled then SkinChanger:Toggle(); SkinChanger:Toggle() end
		end,
	})

	SkinTypeDropdown = SkinChanger:CreateDropdown({
		Name = "Skin Type",
		List = { "Gold", "Platinum", "Diamond", "Emerald", "Nightmare", "Default" },
		Default = CURRENT_SKIN_TYPE,
		Function = function(val)
			CURRENT_SKIN_TYPE = val
			if SkinChanger.Enabled then SkinChanger:Toggle(); SkinChanger:Toggle() end
		end,
	})

	task.defer(function()
		if SkinTypeDropdown and SkinTypeDropdown.Object then
			SkinTypeDropdown.Object.Visible = TIERED_SKINS[CURRENT_ITEM_SKIN] == true
		end
		if SkinTypeDropdown and SkinTypeDropdown.Set then
			SkinTypeDropdown:Set(CURRENT_SKIN_TYPE)
		end
	end)
end)

run(function()
	local CheckMatchStateButton

	CheckMatchStateButton = vape.Categories.Render:CreateModule({
		Name = "print bedwars match stats",
		Function = function(callback)
			if callback then
				local state = bedwars.Store:getState()
				print(state.Game.matchState)
			end	
		end	
	})
end)

run(function()
    local AutoFarm
	local runcheck = false

	local function getSword()
    local state = bedwars.Store:getState()

	local queupath = game:GetService("ReplicatedStorage"):WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events"):WaitForChild("joinQueue")
	local args = {
    [1] = {
        ["queueType"] = "bedwars_to1"
       }
    }

    local inventory = state
        and state.Inventory
        and state.Inventory.observedInventory
        and state.Inventory.observedInventory.inventory
        and state.Inventory.observedInventory.inventory.items

    if not inventory then
        return nil
    end

    for _, item in pairs(inventory) do
        if item.itemType and string.find(item.itemType, "sword") then
            return item.itemType
        end
    end

    return nil
    end

    local function antiafk()
      for _, v in getconnections(lplr.Idled) do
          v:Disable()
      end
    end

    AutoFarm = vape.Categories.Blatant:CreateModule({
        Name = "Legit AutoFarm",
        Function = function(callback)
            if callback then
				runcheck = callback

				task.spawn(function()
					while runcheck do

						antiafk()

						local matchstats = bedwars.Store:getState().Game.matchState

						if matchstats == 1 then
							sword = getSword()

							if sword then

							switchItem(sword, 0.1)
							bedwars.SwordController:swingSwordAtMouse()

							end	
						end
						
						if matchstats == 2 then
							queupath:FireServer(unpack(args))
						end	

						task.wait(1)
					end
				end)
            else
				runcheck = callback
            end    
        end,
        
        ToolTip = "You can afk and farming level"
    })
end)

run(function()
	local ScriptRunner
	local ScriptCode

	ScriptRunner = vape.Categories.Blatant:CreateModule({
		Name = "ScriptRunner",
		Function = function(callback)
			if callback then
				pcall(function()
					loadstring(ScriptCode.Value)()
				end)
			else

			end	
		end,
		ToolTip = "You can run lua script"	
	})

	ScriptCode = ScriptRunner:CreateTextBox({
		Name = "Script"
	})
end)

run(function()
	local SilentAura
	local Targets
	local Speed
	local Range
	local Angle
	local Mode
	local Area
	local LegitAura
	local Mouse
	local NoSwing
	local Limit
	local SilentAim
	local SwingTime
	local Perfect
	local Show
	local Targetcolor
	local Attackcolor
	-- 追加: KillauraTargetを優先するかどうかのトグル
	local UseKillauraTarget 
	-- 追加: NoHit オプション
	local NoHit

	local function getAttackData()
		if not entitylib.isAlive then
			return false
		end
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) and (tick() - bedwars.SwordController.lastSwing) > 0.3 then
				return false
			end
		end
		if LegitAura.Enabled and (tick() - bedwars.SwordController.lastSwing) > 0.3 then
			return false
		end
		if (lplr.Character:GetAttribute('StunnedUntilTime') or 0) - workspace:GetServerTimeNow() > 0 then
			return false
		end
		if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
			return false
		end
		local sword = Limit.Enabled and store.hand or store.tools.sword
		if not sword or not sword.tool then
			return false
		end
		local meta = bedwars.ItemMeta[sword.tool.Name]
		if Limit.Enabled then
			if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then
				return false
			end
		end

		-- 変更点: UseKillauraTargetが有効で、Killauraのターゲットが存在すればそれを優先して返す
		if UseKillauraTarget and UseKillauraTarget.Enabled and store.KillauraTarget then
			local kTarget = store.KillauraTarget
			-- ターゲットが有効か確認
			if kTarget and kTarget.RootPart and kTarget.Humanoid and kTarget.Humanoid.Health > 0 then
				return sword, meta, kTarget
			end
		end

		return sword, meta
	end

	local cache = {}
	local function getAim(ent)
		if Area.Value == 'Closest' then
			if not cache[ent.Character] then
				cache[ent.Character] = ent.Character:GetChildren()
			end
			local localPosition, magnitude, part = inputService.GetMouseLocation(inputService), 9e9, nil
			for _, v in cache[ent.Character] do
				if v and v.Parent and v:IsA('BasePart') then
					local position, vis = gameCamera.WorldToViewportPoint(gameCamera, v.Position)
					if vis then
						local mag = (localPosition - Vector2.new(position.x, position.y)).Magnitude
						if mag < magnitude then
							magnitude = mag
							part = v
						end
					end
				end
			end
			if part then
				return part.Position
			end
		end
		return ent.RootPart.Position
	end

	local function ease(t)
		return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
	end

	local function findAim(localcframe, ent, fps, started)
		local prog, rng = ease(math.min((tick() - started) / (1 / (Speed.Value * 0.5)), 1)), Random.new()
		local speed = Speed.Value * prog
		return localcframe:Lerp(CFrame.lookAt(localcframe.p, getAim(ent) + Vector3.new((rng:NextNumber() - 0.5) * 15 * fps, (rng:NextNumber() - 0.5) * 15 * fps, (rng:NextNumber() - 0.5) * 15 * fps)), speed * fps), speed
	end

	local box = Instance.new('BoxHandleAdornment')
	box.Adornee = nil
	box.AlwaysOnTop = true
	box.Size = Vector3.new(3, 5, 3)
	box.CFrame = CFrame.new(0, -0.5, 0)
	box.ZIndex = 0
	box.Parent = vape.gui

	SilentAura = vape.Categories.Combat:CreateModule({
		Name = 'Silent Aura',
		Function = function(callback)
			if callback then
				local lastent, lastfound = nil, 0
				local foundat = tick()
				local lastattacked = tick()
				
				SilentAura:Clean(runService.PostSimulation:Connect(function(dt)
					if entitylib.isAlive and tick() - lastfound < 0.5 then
						targetinfo.Targets[lastent] = tick() + 0.5
						entitylib.character.Humanoid.AutoRotate = not SilentAim.Enabled
						local cframe, speed = findAim(gameCamera.CFrame, lastent, dt, foundat)
						if SilentAim.Enabled then
							entitylib.character.RootPart.CFrame = entitylib.character.RootPart.CFrame:Lerp(CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(lastent.RootPart.Position.X, entitylib.character.RootPart.Position.Y, lastent.RootPart.Position.Z)), (speed + 2) * dt)
						else
							gameCamera.CFrame = cframe
						end
					elseif entitylib.isAlive then
						entitylib.character.Humanoid.AutoRotate = true
					end
				end))

				local frames = 9e9
				repeat
					task.wait()
					-- getAttackDataは now returns sword, meta, optional_priority_target
					local sword, meta, priorityTarget = getAttackData()
					
					if sword then
						local localPosition = entitylib.character.RootPart.Position
						
						-- 優先ターゲットがある場合はそれを使用、なければ通常通り索敵
						local ent = priorityTarget or entitylib.EntityPosition({
							Origin = localPosition,
							Range = bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE + Range.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = 1,
							Sort = sortmethods[Mode.Value or 'Distance'],
						})

						local Slider = tick() - lastattacked < 0.1 and Attackcolor or Targetcolor
						box.Adornee = Show.Enabled and ent and ent.RootPart or nil
						box.Transparency = 1 - Slider.Opacity
						box.Color3 = Color3.fromHSV(Slider.Hue, Slider.Sat, Slider.Value)

						if ent then
							if not store.hand or store.hand.tool ~= sword.tool then
								local hotbar = getHotbar(sword.tool)
								if hotbar then
									hotbarSwitch(hotbar)
								else
									continue
								end
							end
							if frames > 50 then
								frames = 0
							end
							frames += 1
							local localfacing = (inputService.KeyboardEnabled and gameCamera or entitylib.character.RootPart).CFrame.LookVector * Vector3.new(1, 0, 1)
							local delta, flat = (ent.RootPart.Position - localPosition), ((ent.RootPart.Position - localPosition) * Vector3.new(1, 0, 1))
							local facingdot = flat.Magnitude > 0 and localfacing.Magnitude > 0 and (localfacing / localfacing.Magnitude):Dot(flat / flat.Magnitude) or 0
							if facingdot < math.cos(math.rad(Angle.Value) / 2) then
								continue
							end
							if not LegitAura.Enabled and (tick() - bedwars.SwordController.lastSwing) >= (Perfect.Enabled and (meta.sword.attackSpeed or 0.11) or math.max(SwingTime.Value, 0.11)) then
								bedwars.SwordController:playSwordEffect(meta, false)
								bedwars.SwordController.lastSwing = tick()
							end
							if lastent ~= ent or facingdot < -0.5 then
								foundat = tick()
							end
							lastent, lastfound = ent, tick()
							if delta.Magnitude > bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE then
								continue
							end
							
							-- NoHit が有効でない場合のみ攻撃パケットを送信
							if not NoHit.Enabled then
								lastattacked = tick()
								local dir = CFrame.lookAt(localPosition, ent.RootPart.Position).LookVector
								local pos = localPosition + dir * math.max(delta.Magnitude - 14.4, 0)
								bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
								bedwars.Client:Get(remotes.AttackEntity):SendToServer({
									weapon = sword.tool,
									chargedAttack = {chargeRatio = 0},
									entityInstance = ent.Character,
									validate = {
										raycast = {
											cameraPosition = {value = pos},
											cursorDirection = {value = dir},
										},
										targetPosition = {
											value = ent.RootPart.Position,
										},
										selfPosition = {value = pos},
									},
								})
							end
						else
							lastfound = 0
							frames = 0
						end
					else
						box.Adornee = nil
						lastfound = 0
						frames = 0
					end
				until not SilentAura.Enabled
			else
				if entitylib.isAlive then
					entitylib.character.Humanoid.AutoRotate = true
				end
				box.Adornee = nil
			end
		end,
		Tooltip = 'Automatically aims and attacks nearby target',
	})

	Targets = SilentAura:CreateTargets({
		Players = true,
		NPCs = true,
	})
	Speed = SilentAura:CreateSlider({
		Name = 'Aim speed',
		Min = 1,
		Max = 10,
		Default = 6,
		Decimal = 5,
		Tooltip = 'How fast the Aura is going to aim',
	})
	SwingTime = SilentAura:CreateSlider({
		Name = 'Swing time',
		Darker = true,
		Visible = false,
		Min = 0,
		Max = 0.5,
		Default = 0.42,
		Decimal = 100,
	})
	Range = SilentAura:CreateSlider({
		Name = 'Extra swing distance',
		Tooltip = 'Where you will start swinging, not attacking',
		Min = 0,
		Max = 6,
		Suffix = function(val)
			return val <= 1 and 'stud' or 'studs'
		end,
		Decimal = 5,
		Default = 3,
	})
	Angle = SilentAura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 180,
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	Mode = SilentAura:CreateDropdown({
		Name = 'Target mode',
		List = methods,
		Tooltip = 'How Aura should prioritize targets',
		Default = 'Health',
	})
	Area = SilentAura:CreateDropdown({
		Name = 'Target area',
		Tooltip = 'Where the Aura will aim towards',
		List = {'Center', 'Closest'},
		Default = 'Center',
		Visible = false,
	})
	Perfect = SilentAura:CreateToggle({
		Name = 'Perfect Swing',
		Tooltip = 'Follows tool\'s swing time',
		Function = function(callback)
			SwingTime.Object.Visible = not callback
		end,
		Default = true,
	})
	Mouse = SilentAura:CreateToggle({Name = 'Require mouse down'})
	LegitAura = SilentAura:CreateToggle({Name = 'Swing only'})
	SilentAim = SilentAura:CreateToggle({
		Name = 'Silent Aim',
		Tooltip = 'Uses catvape\'s aiming technology to silently aim while looking legit',
		Default = true,
		Function = function(callback)
			Area.Object.Visible = not callback
		end,
	})
	Show = SilentAura:CreateToggle({
		Name = 'Show target',
		Default = true,
		Function = function(callback)
			pcall(function()
				Targetcolor.Object.Visible = callback
				Attackcolor.Object.Visible = callback
			end)
		end,
	})
	Targetcolor = SilentAura:CreateColorSlider({
		Name = 'Target color',
		Darker = true,
		DefaultOpacity = 0.5,
		DefaultHue = 1,
	})
	Attackcolor = SilentAura:CreateColorSlider({
		Name = 'Attack color',
		Darker = true,
		DefaultOpacity = 0.5,
	})
	Limit = SilentAura:CreateToggle({Name = 'Limit to items'})
	
	-- 追加: Killauraのターゲットを優先するトグル
	UseKillauraTarget = SilentAura:CreateToggle({
		Name = 'Use Killaura Target',
		Tooltip = 'Prioritizes the target currently selected by Killaura module',
		Default = false
	})
	
	-- 追加: NoHit トグル
	NoHit = SilentAura:CreateToggle({
		Name = 'No Hit',
		Tooltip = 'Disables sending attack packets to server (aim only)',
		Default = false
	})
end)

run(function()
	local Attack
	local Mine
	local Place
	local oldAttackReach, oldMineReach, oldPlaceReach
	local SwordReach, MineReach

	Reach = vape.Categories.Combat:CreateModule({
		Name = 'AeroReach',
		Function = function(callback)
			if callback then
				if SwordReach and SwordReach.Enabled then
					oldAttackReach = bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE
					bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = Attack.Value + 2
				end
				
				task.spawn(function()
					repeat task.wait(0.1) until bedwars.BlockBreakController or not Reach.Enabled
					if not Reach.Enabled or not MineReach or not MineReach.Enabled then return end
					
					pcall(function()
						local blockBreaker = bedwars.BlockBreakController:getBlockBreaker()
						if blockBreaker then
							oldMineReach = oldMineReach or blockBreaker:getRange()
							blockBreaker:setRange(Mine.Value)
						end
					end)
				end)
				
				task.spawn(function()
					while Reach.Enabled do
						task.wait(5)
						if not Reach.Enabled then break end
						if SwordReach.Enabled and bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE ~= Attack.Value + 2 then
							bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = Attack.Value + 2
						end
						if MineReach.Enabled then
							pcall(function()
								local blockBreaker = bedwars.BlockBreakController:getBlockBreaker()
								if blockBreaker and blockBreaker:getRange() ~= Mine.Value then
									blockBreaker:setRange(Mine.Value)
								end
							end)
						end
					end
				end)
			else
				if oldAttackReach then
					bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = oldAttackReach
				end
				
				if oldMineReach then
					pcall(function()
						local blockBreaker = bedwars.BlockBreakController:getBlockBreaker()
						if blockBreaker then
							blockBreaker:setRange(oldMineReach)
						end
					end)
				end

				oldAttackReach, oldMineReach = nil, nil
			end
		end,
		Tooltip = 'Extends reach for attacking, mining, and placing blocks'
	})
	
	SwordReach = Reach:CreateToggle({
		Name = 'Sword Reach',
		Default = true,
		Function = function(v)
			if Attack then Attack.Object.Visible = v end
			if Reach.Enabled then
				if v then
					bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = Attack.Value + 2
				else
					bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = oldAttackReach or 14.4
				end
			end
		end
	})

	Attack = Reach:CreateSlider({
		Name = 'Attack Range',
		Darker = true,
		Visible = true,
		Min = 0,
		Max = 20,
		Default = 18,
		Function = function(val)
			if Reach.Enabled then
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val + 2
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	
	MineReach = Reach:CreateToggle({
		Name = 'Mine Reach',
		Default = false,
		Function = function(v)
			if Mine then Mine.Object.Visible = v end
		end
	})

	Mine = Reach:CreateSlider({
		Name = 'Mine Range',
		Darker = true,
		Visible = false,
		Min = 0,
		Max = 30,
		Default = 18,
		Function = function(val)
			if Reach.Enabled then
				pcall(function()
					local blockBreaker = bedwars.BlockBreakController:getBlockBreaker()
					if blockBreaker then
						blockBreaker:setRange(val)
					end
				end)
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)

run(function()
	local Lighting = game:GetService("Lighting")
	local Fullbright

	local function enableFullBright()
	Lighting.Ambient = Color3.new(1, 1, 1)
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.GlobalShadows = false
	
	Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
	Lighting.ColorShift_Top = Color3.new(1, 1, 1)
	Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
	end

	local function DisabledFullBright()
	Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
	Lighting.Brightness = 1
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.GlobalShadows = true
	
	Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
	Lighting.ColorShift_Top = Color3.new(0, 0, 0)
	Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
	end
	
	Fullbright = vape.Categories.Render:CreateModule({
		Name = "FullBright",
		Function = function(callback)
			if callback then
				enableFullBright()
			else
				DisabledFullBright()
			end	
		end	
	})
end)

run(function()
	local PlaceReach
	local PlaceRange
	local Mode
	
	local oldGetMouseInfo = nil
	
	PlaceReach = vape.Categories.Combat:CreateModule({
		Name = "Place Reach",
		Function = function(callback)
			if callback then
				if not oldGetMouseInfo then
					oldGetMouseInfo = bedwars.BlockSelector.getMouseInfo
				end
				
				bedwars.BlockSelector.getMouseInfo = function(...)
					local self, selectType, args = ...
					if not args then args = {} end
					
					-- Select == 0 が Placement（置く時）
					if selectType == 0 and PlaceReach.Enabled then
						args.range = PlaceRange.Value
					end
					
					return oldGetMouseInfo(self, selectType, args)
				end
				
			else
				if oldGetMouseInfo then
					bedwars.BlockSelector.getMouseInfo = oldGetMouseInfo
					oldGetMouseInfo = nil
				end
			end
		end,
		Tooltip = "Extends block placement reach using BlockSelector hook (same as old BlockReach)"
	})
	
	PlaceRange = PlaceReach:CreateSlider({
		Name = "Place Range",
		Min = 10,
		Max = 60,
		Default = 35,
		Suffix = function(val)
			return val == 1 and "stud" or "studs"
		end
	})
	
	PlaceReach:CreateButton({
		Name = "Reset to Default",
		Function = function()
			PlaceRange:SetValue(24)
		end
	})
end)

run(function()
    local InfinityJump
    local Height

    InfinityJump = vape.Categories.Blatant:CreateModule({
        Name = 'Infinity Jump',
        Tooltip = '',
        Function = function(callback)
            if callback then
                InfinityJump:Clean(runService.RenderStepped:Connect(function()
                    if not entitylib.isAlive then return end
                    
                    local root = entitylib.character.RootPart
                    
                    if inputService:IsKeyDown(Enum.KeyCode.Space) then
                        root.Velocity = Vector3.new(root.Velocity.X, Height.Value, root.Velocity.Z)
                    end
                end))
            end
        end,
    })

    Height = InfinityJump:CreateSlider({
        Name = 'Jump Height',
        Min = 30,
        Max = 150,
        Default = 70,
        Suffix = ' studs',
    })
end)

run(function()
    local AutoDodge
    local Targets
    local Melee
    local Range
    
    local oldroot, clone, hip = nil, nil, 2.5
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Include
    rayParams.RespectCanCollide = true
    
    local function doClone()
        if store.rootpart then return end
        if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 then
            if oldroot and oldroot.Parent then
                return true
            end
    
            hip = entitylib.character.Humanoid.HipHeight
            oldroot = entitylib.character.HumanoidRootPart
            if not lplr.Character.Parent then return false end
            lplr.Character.Parent = replicatedStorage
            clone = oldroot:Clone()
            clone.Parent = lplr.Character
            oldroot.Transparency = 1
            oldroot.Parent = workspace
            store.rootpart = oldroot
            lplr.Character.PrimaryPart = clone
            lplr.Character.Parent = workspace
            bedwars.QueryUtil:setQueryIgnored(clone, true)
            bedwars.QueryUtil:setQueryIgnored(oldroot, true)
            return true
        end
        return false
    end
    
    local function revertClone()
        if oldroot and oldroot.Parent and entitylib.isAlive then 
            lplr.Character.Parent = replicatedStorage
            oldroot.Parent = lplr.Character
            if clone then
                oldroot.CFrame = clone.CFrame
                oldroot.Velocity = clone.Velocity
                clone:Destroy()
                clone = nil
            end
            lplr.Character.PrimaryPart = oldroot
            lplr.Character.Parent = workspace
            oldroot.CanCollide = true
            entitylib.character.Humanoid.HipHeight = hip or 2.6
            oldroot.Transparency = 1
            oldroot = nil
            store.rootpart = nil
            return true
        end
        return false
    end
    
    AutoDodge = vape.Categories.Blatant:CreateModule({
    	Name = 'Auto Dodge',
    	Tooltip = 'Dodges melee and projectiles "blatantly"',
    	Function = function(call)
    		if call then
    			repeat
    				task.wait()
    			until store.matchState ~= 0 and store.map or not AutoDodge.Enabled
    			if not AutoDodge.Enabled then
    				return
    			end
    
    			rayParams.FilterDescendantsInstances = {store.map}
    			local lowestpoint = 9e9
    			local Dodge = 0
    			for _, v in store.blocks do
    				local point = (v.Position.Y - (v.Size.Y / 2)) - 50
    				if point < lowestpoint then
    					lowestpoint = point
    				end
    			end
    
                AutoDodge:Clean(runService.PostSimulation:Connect(function()
                    if oldroot and oldroot.Parent then
                        local newpoint, pos = lowestpoint, CFrame.new(clone.CFrame.X, lowestpoint - 6, clone.CFrame.Z)
                        if Dodge then
                            newpoint = workspace:Raycast(pos.Position, Vector3.new(0, 1000, 0), rayParams)
                            if newpoint then
                                newpoint = CFrame.new(clone.CFrame.X, newpoint.Position.Y - 6, clone.CFrame.Z) * CFrame.Angles(math.rad(90), 0, 0)
                            end
                        end
                        oldroot.Velocity = Vector3.zero
                        oldroot.CFrame = Dodge and (newpoint or pos) or (clone.CFrame + Vector3.new(0, 1, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                    end
                end))
    
                local last = true
                repeat
                    if entitylib.isAlive then
                        if oldroot then
                            local ownership = isnetworkowner(oldroot)
                            if not ownership and ownership ~= last then
                                notif('AutoDodge', 'Network ownership disowned', 7, 'alert')
                            end
                            last = ownership
                            if not ownership then
                                Dodge = false
                                revertClone()
                                task.wait()
                                continue
                            end
                        end
    
                        if Melee.Enabled and entitylib.EntityPosition({
                            Range = Range.Value,
                            Players = Targets.Players.Enabled,
                            NPCs = Targets.NPCs.Enabled,
                            Wallcheck = Targets.Walls.Enabled or nil,
                            Sort = sortmethods.Distance,
                            Part = 'RootPart',
                        }) and doClone() then
                            Dodge = false
                            task.wait(0.2)
                            Dodge = true
                            task.wait(0.4)
                        else
                            Dodge = false
                            revertClone()
                        end
                    end
                    task.wait()
                until not AutoDodge.Enabled
    		else
    			revertClone()
    		end
    	end,
    })
    
    Targets = AutoDodge:CreateTargets({
    	Players = true,
    	NPCs = false,
    })
    Melee = AutoDodge:CreateToggle({
    	Name = 'Melee',
    	Tooltip = 'Dodges melee attacks',
    	Default = true,
    	Function = function(call)
    		pcall(function()
    			Range.Object.Visible = call
    		end)
    	end,
    })
    Range = AutoDodge:CreateSlider({
    	Name = 'Melee Range',
    	Min = 1,
    	Max = 30,
    	Default = 30,
    	Decimal = 5,
    	Darker = true,
    })
    AutoDodge:CreateToggle({
    	Name = 'Projectiles',
    	Tooltip = 'Dodges projectiles',
    	Default = true,
    })
end)

local function rakNetCheck(module)
	if not (raknet and raknet.add_send_hook and pcall(raknet.add_send_hook, function() end)) then
		notif(module, 'This feature requires raknet! (risky feature, please do not use on mains.)', 10, 'warning')
		return false
	end

	return true
end

run(function()
    
    local Desync
    
    local hook
    local function Buffer(mode)
        if mode == 'max_u32' then
            local Floor = math.floor((2 ^ 16) * (2 ^ 16))
            local Abs = math.abs(math.cos(math.pi))
            return Floor - Abs
        elseif mode == 'packet_id' then
            local Offset = math.floor(math.sqrt(9))
            return (math.sqrt(9)) * (2 ^ 3) + Offset
        end
        return 0
    end
    local function Resync()
        if entitylib.isAlive then
            entitylib.character.RootPart.CFrame += Vector3.new(math.nan, math.nan, math.nan)
            notif('Desync', 'Resynced', 2, 'info')
        end
    end
    
    Desync = vape.Categories.Blatant:CreateModule({
        Name = 'Catvape Desync',
        Function = function(callback)
            if callback then
                if not rakNetCheck('Desync') then
                    Desync:Toggle()
                    return
                end
    
                hook = function(packet)
                    if not packet.AsArray or packet.AsArray[1] ~= Buffer('packet_id') then
                        return
                    end
    
                    local data = packet.AsBuffer
                    if data then
                        buffer.writeu32(data, 1, Buffer('max_u32'))
                        buffer.writeu8(data, 25, 7)
    
                        packet:SetData(data)
                    end
                end
                raknet.add_send_hook(hook)
                if entitylib.isAlive and store.matchState ~= 0 then
                    entitylib.character.Humanoid.Health = 0
                    notif('Desync', 'Resyncing, If you flag you have to reset!', 8, 'info')
                end
            elseif hook then
                raknet.remove_send_hook(hook)
            end
        end,
        Tooltip = 'Prevent the server from replicating your current position to other players.'
    })
    
    Desync:CreateButton({Name = 'Resync', Function = Resync})
end)

run(function()
    local DeviceSpoofer
    local Device
    
    DeviceSpoofer = vape.Legit:CreateModule({
        Name = 'Device Spoofer',
        Function = function(callback)
            if callback then
                DeviceSpoofer:Clean(lplr:GetAttributeChangedSignal('UserInputType'):Connect(function()
                    if lplr:GetAttribute('UserInputType') ~= Device.Value then
                        lplr:SetAttribute('UserInputType', Device.Value)
                    end
                end))
            end
        end
    })
    
    Device = DeviceSpoofer:CreateDropdown({
        Name = 'Device',
        List = {'Mobile', 'PC', 'Gamepad'},
        Function = function(val)
            if DeviceSpoofer.Enabled then
                lplr:SetAttribute('UserInputType', val)
            end
        end
    })
end)

run(function()
    local old

    vape.Categories.Blatant:CreateModule({
    	Name = 'Infinite Krystal',
    	Tooltip = 'Gives you max momentum forever',
    	Function = function(call)
    		if call then
    			old = bedwars.GlacialSkaterController.updateMomentum
    			bedwars.GlacialSkaterController.updateMomentum = function(self, ...)
    				self.momentum = 9e9
    				self.lastMomentumReport = 9e9
    				return old(self, ...)
    			end
    		else
    			bedwars.GlacialSkaterController.updateMomentum = old
    		end
    	end
    })
end)

local InfiniteFly
run(function()
    local HiddenPart = Instance.new('Part')
    HiddenPart.Parent = workspace
    HiddenPart.Transparency = 1
    HiddenPart.CanQuery = false
    HiddenPart.CanTouch = false
    HiddenPart.CanCollide = false
    HiddenPart.Anchored = true

    local oldTransparency = {}
    local function doCharacterThing()
        if entitylib.isAlive then
            for index, value in entitylib.character.Character:GetDescendants() do
                if value:IsA('Part') or value:IsA('BasePart') then
                    oldTransparency[value] = value.Transparency

                    value.Transparency = 1
                end
            end
        end
    end

    local function revertCharacter()
        if entitylib.isAlive then
            for index, value in entitylib.character.Character:GetDescendants() do
                if value:IsA('Part') or value:IsA('BasePart') then
                    value.Transparency = oldTransparency[value]
                end
            end
        end
    end

    InfiniteFly = vape.Categories.Blatant:CreateModule({
        Name = 'InfiniteFly',
        Function = function(callback)
            gameCamera.CameraSubject = callback and HiddenPart or entitylib.character.Character

            if callback then
                doCharacterThing()
                HiddenPart.CFrame = entitylib.character.Character.Head.CFrame

                entitylib.character.RootPart.CFrame = CFrame.new(Vector3.new(entitylib.character.RootPart.CFrame.X, 210, entitylib.character.RootPart.CFrame.Z))

                InfiniteFly:Clean(runService.RenderStepped:Connect(function(dt: number)
                    if not entitylib.isAlive then
                        return
                    end

                    HiddenPart.CFrame = CFrame.new(Vector3.new(entitylib.character.RootPart.Position.X, HiddenPart.CFrame.Y, entitylib.character.RootPart.Position.Z))

                    if entitylib.character.RootPart.CFrame.Y < -75 then
                        entitylib.character.RootPart.CFrame = CFrame.new(Vector3.new(entitylib.character.RootPart.CFrame.X, 210, entitylib.character.RootPart.CFrame.Z))
                    end
                end))
            else
                revertCharacter()
            end
        end,
        ExtraText = function()
            return 'Heatseeker'
        end
    })
end)

run(function()
    local TweenService = game:GetService("TweenService")
    
    local GodKill
    local Range
    local Height
    local Interval
    local GroundStayTime
    local AllowTween
    local TweenSpeed -- 追加：速度調整用
    
    local isOnGround = false
    local groundTimer = 0
    local lastDropTime = 0
    local currentTween = nil

    GodKill = vape.Categories.Blatant:CreateModule({
        Name = 'GodKill',
        Function = function(callback)
            if callback then
                lastDropTime = tick()
                isOnGround = false
                groundTimer = 0
                
                GodKill:Clean(runService.Heartbeat:Connect(function()
                    if not entitylib.isAlive then return end
                    
                    local target = entitylib.EntityPosition({
                        Range = Range.Value,
                        Part = 'RootPart',
                        Players = true,
                        Sort = sortmethods.Distance
                    })

                    if target and target.Humanoid and target.Humanoid.Health > 0 then
                        local root = entitylib.character.RootPart
                        local targetPos = target.RootPart.Position
                        
                        if not isOnGround then
                            -- 【修正】上空のブロック判定と絶対埋まらない安全な高さの計算
                            local desiredHeight = Height.Value
                            local safeY = targetPos.Y + desiredHeight
                            
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {lplr.Character, target.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            
                            -- 自分の現在の足元から、ターゲット上空の目標地点へ向けてレイを飛ばす
                            -- これにより、移動経路にある天井や障害物をすべて検知する
                            local rayOrigin = root.Position
                            local rayDirection = Vector3.new(targetPos.X - rayOrigin.X, safeY - rayOrigin.Y, targetPos.Z - rayOrigin.Z)
                            local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
                            
                            if rayResult then
                                -- 天井に当たった場合、ヒットしたY座標から「頭が埋まらない安全マージン」を引く
                                -- キャラクターのHipHeight(約2) + 胴体と頭の分の余裕(約3.5)を考慮
                                local humanoid = entitylib.character.Humanoid
                                local characterHeightOffset = (humanoid.HipHeight or 2) + 3.5
                                
                                -- 当たった位置のすぐ下を限界値にする（絶対にめり込ませない）
                                safeY = rayResult.Position.Y - characterHeightOffset
                                
                                -- 万が一、ターゲットの足元より低くなってしまう場合はターゲットの少し上に固定
                                if safeY < targetPos.Y + 3 then
                                    safeY = targetPos.Y + 3
                                end
                            end

                            local targetCFrame = CFrame.new(targetPos.X, safeY, targetPos.Z)
                            
                            -- AllowTweenがオンの場合
                            if AllowTween.Value then
                                if currentTween then 
                                    currentTween:Cancel() 
                                end
                                
                                -- スライダーの値を秒数に変換 (0 = 0.01秒の超高速 / 10 = 1.0秒の低速)
                                -- 0のときに止まるのを防ぐため、0.01をベースにしています
                                local duration = math.max(0.01, TweenSpeed.Value * 0.1)
                                
                                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                                currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
                                currentTween:Play()
                            else
                                -- オフの場合は瞬時にテレポート
                                root.CFrame = targetCFrame
                            end
                            
                            -- 地面に落とすタイミングかチェック
                            if tick() - lastDropTime >= Interval.Value then
                                lastDropTime = tick()
                                
                                -- Raycastで地面の高さを検出
                                local groundRayParams = RaycastParams.new()
                                groundRayParams.FilterDescendantsInstances = {lplr.Character}
                                groundRayParams.CollisionGroup = root.CollisionGroup
                                
                                local rayOriginDrop = targetPos + Vector3.new(0, 2, 0)
                                local rayDirectionDrop = Vector3.new(0, -30, 0)
                                local rayResultDrop = workspace:Raycast(rayOriginDrop, rayDirectionDrop, groundRayParams)
                                
                                local groundY = targetPos.Y + 1
                                if rayResultDrop then
                                    local hipHeight = entitylib.character.Humanoid.HipHeight or 2
                                    groundY = rayResultDrop.Position.Y + hipHeight
                                end
                                
                                -- 下降はラグをなくすため常に瞬時
                                root.CFrame = CFrame.new(targetPos.X, groundY, targetPos.Z)
                                
                                isOnGround = true
                                groundTimer = tick()
                            end
                        else
                            -- 地面滞在時間が経過したら空中に戻る状態へ
                            if tick() - groundTimer >= GroundStayTime.Value then
                                isOnGround = false
                            end
                        end
                    else
                        -- ターゲットがいない、または死亡した場合はリセット
                        isOnGround = false
                        if currentTween then 
                            currentTween:Cancel() 
                        end
                    end
                end))
            else
                -- モジュールがオフになったときにリセット
                isOnGround = false
                if currentTween then 
                    currentTween:Cancel() 
                end
            end
        end,
        Tooltip = 'Elevates you above the target and periodically drops you to the ground.'
    })

    Range = GodKill:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 30,
        Default = 14.4,
        Suffix = function(val) return val == 1 and 'stud' or 'studs' end
    })
    
    Height = GodKill:CreateSlider({
        Name = 'Height',
        Min = 5,
        Max = 50,
        Default = 18,
        Suffix = function(val) return val == 1 and 'stud' or 'studs' end
    })
    
    Interval = GodKill:CreateSlider({
        Name = 'Drop Interval',
        Min = 0.5,
        Max = 5,
        Default = 2,
        Decimal = 10,
        Suffix = 's'
    })

    GroundStayTime = GodKill:CreateSlider({
        Name = 'Ground Stay Time',
        Min = 0.05,
        Max = 1.0,
        Default = 0.1,
        Decimal = 100,
        Suffix = 's',
        Tooltip = 'How long you stay on the ground before returning to the sky.'
    })

    AllowTween = GodKill:CreateToggle({
        Name = 'Allow Tween',
        Default = false,
        Tooltip = 'If enabled, uses a tween to go up. If disabled, teleports instantly.'
    })

    -- 追加：Tweenの速さを調整するスライダー (0 = 最速, 10 = 遅い)
    TweenSpeed = GodKill:CreateSlider({
        Name = 'Tween Speed',
        Min = 0,
        Max = 10,
        Default = 0,
        Decimal = 10,
        Suffix = function(val) return val == 0 and '' or '' end,
        Tooltip = '0 is nearly instant, 10 is slow.'
    })
end)

run(function()
	local KillThunder
	local ThunderSoundId = "rbxassetid://83327278598628"

	KillThunder = vape.Categories.Render:CreateModule({
		Name = 'KillThunder',
		Function = function(callback)
			if callback then
				KillThunder:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					local char = deathTable.entityInstance
					if not char or not char.Parent then return end

					local pos = char:GetPivot().Position

					local function createRod(offset, thickness, transparency)
						local bolt = Instance.new("Part")
						bolt.Size = Vector3.new(thickness, 80, thickness)
						bolt.CFrame = CFrame.new(
							pos.X + offset.X,
							pos.Y + 40,
							pos.Z + offset.Z
						)
						bolt.Material = Enum.Material.Neon
						bolt.Color = Color3.fromRGB(180, 180, 255)
						bolt.Transparency = transparency
						bolt.Anchored = true
						bolt.CanCollide = false
						bolt.Parent = workspace

						game:GetService("Debris"):AddItem(bolt, 0.3)
					end

					-- メイン太棒
					createRod(Vector3.new(0,0,0), 2, 0)

					-- 周りの棒たち
					for i = 1, 6 do
						createRod(
							Vector3.new(
								math.random(-3,3),
								0,
								math.random(-3,3)
							),
							math.random(0.3, 1),
							0.3
						)
					end

					-- ちょい遅れてもう一発（重ね感）
					task.delay(0.05, function()
						for i = 1, 4 do
							createRod(
								Vector3.new(
									math.random(-2,2),
									0,
									math.random(-2,2)
								),
								math.random(0.2, 0.8),
								0.5
							)
						end
					end)

					-- 音
					local sound = Instance.new("Sound")
					sound.SoundId = ThunderSoundId
					sound.Volume = 3
					sound.Parent = workspace
					sound:Play()
					game:GetService("Debris"):AddItem(sound, 3)

				end))
			end
		end,
		Tooltip = 'Stacked rod lightning effect'
	})
end)

run(function()
    local DamageBoost
    local BoostSpeed
    local Duration
    
    -- 状態管理用変数
    local isBoosting = false
    local boostEndTime = 0

    DamageBoost = vape.Categories.Blatant:CreateModule({
        Name = 'DamageBoost',
        Function = function(callback)
            if callback then
                -- ダメージイベントの監視開始
                DamageBoost:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
                    -- 自分自身がダメージを受けた場合のみ処理
                    if damageTable.entityInstance == lplr.Character then
                        -- 現在の時間を記録し、ブースト終了時間を設定
                        boostEndTime = tick() + Duration.Value
                        isBoosting = true
                        
                        -- 物理演算の更新ループで速度を上書きするためのフラグを立てる
                        frictionTable.DamageBoost = true
                        updateVelocity()
                    end
                end))
                
                -- PreSimulationループで速度を強制適用
                DamageBoost:Clean(runService.PreSimulation:Connect(function(dt)
                    if isBoosting and entitylib.isAlive and isnetworkowner(entitylib.character.RootPart) then
                        local currentTime = tick()
                        
                        -- 設定された時間が経過したらブースト解除
                        if currentTime >= boostEndTime then
                            isBoosting = false
                            frictionTable.DamageBoost = nil
                            updateVelocity()
                            return
                        end
                        
                        -- ブースト中の速度適用ロジック (Speedモジュールを参考)
                        local root = entitylib.character.RootPart
                        local moveDirection = entitylib.character.Humanoid.MoveDirection
                        
                        -- 移動方向がない場合は何もしない（空中での制御防止など）
                        if moveDirection.Magnitude > 0 then
                            -- 目標速度(BoostSpeed)と現在速度の差を埋めるようにCFrameを操作
                            -- Speedモジュールと同様、直接AssemblyLinearVelocityを書き換えるのではなく
                            -- CFrameの移動量として加算することで、ゲームの物理挙動と馴染みやすくする
                            
                            local currentSpeed = getSpeed() -- 現在の基本速度を取得
                            local targetSpeed = BoostSpeed.Value
                            
                            -- 加速が必要な場合のみ適用
                            if targetSpeed > currentSpeed then
                                local destination = (moveDirection * (targetSpeed - currentSpeed) * dt)
                                root.CFrame += destination
                                
                                -- 速度ベクトルも強制的に上書きして即座に反映させる
                                root.AssemblyLinearVelocity = (moveDirection * targetSpeed) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                            end
                        end
                    end
                end))
            else
                -- モジュールOFF時のクリーンアップ
                isBoosting = false
                frictionTable.DamageBoost = nil
                updateVelocity()
            end
        end,
        Tooltip = 'Applies a burst of speed when taking damage.'
    })

    BoostSpeed = DamageBoost:CreateSlider({
        Name = 'Boost Speed',
        Min = 1,
        Max = 50, -- RealTimeSpeedやSpeedの最大値より少し高めに設定可能に
        Default = 30,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })

    Duration = DamageBoost:CreateSlider({
        Name = 'Duration',
        Min = 0.1,
        Max = 2.0,
        Default = 0.5,
        Decimal = 10,
        Suffix = 'seconds'
    })
end)

run(function()
    local Lighting = game:GetService("Lighting")
    local NightMode
    local Brightness
    local originalSettings = {}

    -- 現在の照明設定を保存する関数
    local function saveOriginalSettings()
        originalSettings.ClockTime = Lighting.ClockTime
        originalSettings.Ambient = Lighting.Ambient
        originalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
        originalSettings.Brightness = Lighting.Brightness
        originalSettings.GlobalShadows = Lighting.GlobalShadows
    end

    -- 夜の照明設定を適用する関数
    local function applyNightMode()
        local brightLevel = Brightness.Value / 100 -- 0.0 ~ 1.0
        
        Lighting.ClockTime = 0 -- 真夜中に固定
        
        -- 環境光を補間 (真っ暗な青黒色 ～ 明るい月夜)
        local baseDarkColor = Color3.fromRGB(10, 10, 20)
        local baseLightColor = Color3.fromRGB(130, 130, 150) -- 上限を明るく調整
        local targetColor = baseDarkColor:Lerp(baseLightColor, brightLevel)
        
        Lighting.Ambient = targetColor
        Lighting.OutdoorAmbient = targetColor
        
        -- 全体の明るさ(Brightness)も連動して調整 (最小0.3 ～ 最大1.5)
        Lighting.Brightness = 0.3 + (1.2 * brightLevel)
        Lighting.GlobalShadows = true
    end

    -- 元の照明設定に戻す関数
    local function restoreSettings()
        Lighting.ClockTime = originalSettings.ClockTime
        Lighting.Ambient = originalSettings.Ambient
        Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        Lighting.Brightness = originalSettings.Brightness
        Lighting.GlobalShadows = originalSettings.GlobalShadows
    end

    NightMode = vape.Categories.Render:CreateModule({
        Name = "NightMode",
        Function = function(callback)
            if callback then
                saveOriginalSettings()
                applyNightMode()
            else
                restoreSettings()
            end
        end,
        Tooltip = "Changes the world lighting to a night theme. Adjust brightness to your liking."
    })

    Brightness = NightMode:CreateSlider({
        Name = "Night Brightness",
        Min = 0,
        Max = 100,
        Default = 60, -- デフォルトを少し明るめ(60%)に設定
        Suffix = "%",
        Function = function()
            -- スライダーを動かした際、モジュールが有効なら即座に設定を更新
            if NightMode.Enabled then
                applyNightMode()
            end
        end,
        Tooltip = "Adjusts how bright the night environment is. Higher = brighter."
    })
end)

run(function()
    local BedwarsAnimationPlayer
    local AnimationId
    local Loop
    local Speed
    local currentTrack = nil
    local animationInstance = nil

    -- アニメーションを再生する関数
    local function playCustomAnimation(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
        
        -- 既存のアニメーショントラックをすべて停止して競合を防ぐ
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end

        -- アニメーションIDの整形 (数字のみの入力にも対応)
        local rawId = AnimationId.Value:gsub("%s+", "")
        local animId = rawId
        if rawId:match("^%d+$") then
            animId = "rbxassetid://" .. rawId
        elseif not rawId:match("^rbxassetid://") and not rawId:match("^rbxasset://") then
            animId = "rbxassetid://" .. rawId
        end

        -- アニメーションインスタンスの作成と読み込み
        animationInstance = Instance.new("Animation")
        animationInstance.AnimationId = animId
        
        local success, loadedTrack = pcall(function()
            return animator:LoadAnimation(animationInstance)
        end)

        if success and loadedTrack then
            currentTrack = loadedTrack
            -- Action4 は Roblox 内で最も高いアニメーション優先度（既存のアニメーションを上書きする）
            currentTrack.Priority = Enum.AnimationPriority.Action4
            currentTrack.Looped = Loop.Enabled
            currentTrack:Play(0.1, 1, Speed.Value)
        else
            vape:CreateNotification("BedwarsAnimationPlayer", "Invalid Animation ID", 3, "alert")
        end
    end

    -- アニメーションを停止する関数
    local function stopCustomAnimation()
        if currentTrack then
            currentTrack:Stop(0.2)
            currentTrack = nil
        end
        if animationInstance then
            animationInstance:Destroy()
            animationInstance = nil
        end
    end

    BedwarsAnimationPlayer = vape.Categories.Blatant:CreateModule({
        Name = 'BedwarsAnimationPlayer',
        Function = function(callback)
            if callback then
                -- 現在生きていれば即座に適用
                if entitylib.isAlive then
                    playCustomAnimation(entitylib.character.Character)
                end
                
                -- リスポーン時にも自動的に適用
                BedwarsAnimationPlayer:Clean(entitylib.Events.LocalAdded:Connect(function(ent)
                    if ent == entitylib.character then
                        playCustomAnimation(ent.Character)
                    end
                end))
            else
                stopCustomAnimation()
            end
        end,
        Tooltip = 'Forces a custom animation to play with highest priority, overriding default animations like walking or attacking.'
    })

    AnimationId = BedwarsAnimationPlayer:CreateTextBox({
        Name = 'Animation ID',
        Default = '560832030', -- 例: 何か適当なアニメーションID (数字のみでも可)
        Placeholder = 'rbxassetid://...'
    })

    Loop = BedwarsAnimationPlayer:CreateToggle({
        Name = 'Loop Animation',
        Default = true
    })

    Speed = BedwarsAnimationPlayer:CreateSlider({
        Name = 'Playback Speed',
        Min = 0.1,
        Max = 3.0,
        Default = 1.0,
        Decimal = 10,
        Function = function(val)
            if currentTrack and BedwarsAnimationPlayer.Enabled then
                currentTrack:AdjustSpeed(val)
            end
        end
    })
end)

run(function()
    local BowAssist
    local Targets
    local Sort
    local Shake
    local Speed
    local Angle
    local FOV
    local Blacklist
    local Mouse
    local ThirdPerson
    local Projectiles
    
    local function ease(t)
    	return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
    end
    
    local function findAim(localcframe, predicted, fps, started, offset)
    	local prog, rng = ease(math.min((tick() - started) / (1 / (Speed.Value * 0.5)), 1)), Random.new()
    	local speed = Speed.Value * prog
    
    	return localcframe:Lerp(CFrame.lookAt(localcframe.p, predicted + Vector3.new((rng:NextNumber() - 0.5) * Shake.Value * fps, offset + ((rng:NextNumber() - 0.5) * Shake.Value * fps), (rng:NextNumber() - 0.5) * Shake.Value * fps)), speed * fps), speed
    end
    
    local launchHook
    local lasttarget, started = nil, 0
    local function getAttackData()
    	if not entitylib.isAlive then
    		return false
    	end
    	if Mouse.Enabled and not inputService:IsMouseButtonPressed(0) then
    		return false
    	end
    	if not store.hand.tool or not bedwars.ItemMeta[store.hand.tool.Name].projectileSource and store.hand.toolType ~= 'bow' then
    		return false
    	end
    	if Blacklist.Enabled and table.find(Projectiles.ListEnabled, store.hand.tool.Name == 'glue_trap' and 'gloop' or store.hand.tool.Name) then
    		return false
    	end
    
    	if (tick() - started) > 1 or not lasttarget or not lasttarget.Parent or not lasttarget.Humanoid or lasttarget.Humanoid.Health <= 0 then
    		local ent = entitylib.EntityMouse({
    			Origin = entitylib.character.RootPart.Position,
    			Range = FOV.Value,
    			Part = 'RootPart',
    			Wallcheck = Targets.Walls.Enabled,
    			Players = Targets.Players.Enabled,
    			NPCs = Targets.NPCs.Enabled,
    			Sort = sortmethods[Sort.Value],
    		})
    		if ent then
    			started = tick()
    		end
    		lasttarget = ent
    	end
    	return lasttarget
    end
    
    local rayCheck = RaycastParams.new()
    
    BowAssist = vape.Categories.Combat:CreateModule({
    	Name = 'Bow Assist',
    	Function = function(callback)
    		if callback then
    			local multi, predicted = 0, nil
    			local lastpredicted = 0
    			local lastent, found, update = nil, 0, 0
    
    			launchHook = bedwars.ProjectileLaunchHook:Add('BowAssist', 10, function(nextLaunch, ...)
    				local res = nextLaunch(...)
    				local projmeta = select(2, ...)
    				multi = projmeta and (projmeta.velocityMultiplier + 2) or 0
    				if projmeta and tick() - update < 0.1 and lastent and lastent.RootPart then
    					local meta = projmeta:getProjectileMeta()
    					local gravity = (meta.gravitationalAcceleration or 196.2) * projmeta.gravityMultiplier
    					local calc = prediction.SolveTrajectory(entitylib.character.RootPart.Position, (meta.launchVelocity or 100) * (1 - lplr:GetNetworkPing()), gravity, lastent.RootPart.Position, lastent.RootPart.Velocity, workspace.Gravity, entitylib.character.HipHeight, nil, rayCheck)
    					predicted = calc
    					lastpredicted = tick()
    				else
    					predicted = nil
    				end
    				return res
    			end)
    
    			BowAssist:Clean(runService.PostSimulation:Connect(function(dt)
    				local ent = getAttackData()
    				if ent then
    					local delta = (ent.RootPart.Position - entitylib.character.RootPart.Position)
    					local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    					local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
    					if angle >= (math.rad(Angle.Value) / 2) then
    						return
    					end
    					if ent ~= lastent then
    						found = tick()
    					end
    					lastent = ent
    					update = tick()
    					if tick() - lastpredicted < 0.1 then
    						targetinfo.Targets[ent] = tick() + 1
    						local cframe, speed = findAim(gameCamera.CFrame, predicted or ent.RootPart.Position, dt, found, multi + ((entitylib.character.RootPart.Position.Y - ent.RootPart.Position.Y) / 7))
    						if inputService.MouseEnabled and entitylib.character.Head.LocalTransparencyModifier == 1 then
    							gameCamera.CFrame = cframe
    						elseif ThirdPerson.Enabled and inputService.MouseEnabled then
    							local viewport = gameCamera:WorldToViewportPoint(predicted)
    							local pos = (Vector2.new(viewport.X, viewport.Y) - inputService:GetMouseLocation()) * (speed / 15)
    							mousemoverel(pos.X, pos.Y)
    						end
    					end
    				end
    			end))
    		else
    			if launchHook then
    				launchHook()
    				launchHook = nil
    			end
    		end
    	end,
        Tooltip = 'Smoothly aims your projectile trajectory to the target'
    })
    
    Targets = BowAssist:CreateTargets({
    	Players = true,
    	Walls = true,
    })
    local methods = {'Damage', 'Distance'}
    for i in sortmethods do
    	if not table.find(methods, i) then
    		table.insert(methods, i)
    	end
    end
    Sort = BowAssist:CreateDropdown({
    	Name = 'Target mode',
    	List = methods,
    	Default = 'Angle',
    })
    Speed = BowAssist:CreateSlider({
    	Name = 'Aim speed',
    	Min = 1,
    	Max = 20,
    	Default = 7,
    	Suffix = 'sp/s',
    	Tooltip = 'How fast you will aim per second',
    })
    Angle = BowAssist:CreateSlider({
    	Name = 'Max angle',
    	Min = 1,
    	Max = 360,
    	Default = 120,
    })
    Shake = BowAssist:CreateSlider({
    	Name = 'Shake',
    	Min = 1,
    	Max = 100,
    	Default = 5,
    	Tooltip = 'Jitters your screen, Simulating human aim',
    })
    FOV = BowAssist:CreateSlider({
    	Name = 'FOV',
    	Min = 1,
    	Max = 1000,
    	Default = 200,
    })
    Mouse = BowAssist:CreateToggle({
    	Name = 'Require mouse down',
    	Default = inputService.KeyboardEnabled,
    })
    ThirdPerson = BowAssist:CreateToggle({
    	Name = 'Use mouse aim',
    	Tooltip = 'Aims using the mouse if ur on third person',
    	Default = true,
    })
    Blacklist = BowAssist:CreateToggle({
    	Name = 'Use blacklist',
    	Default = true,
    	Function = function(callback)
    		if Projectiles then
    			Projectiles.Object.Visible = callback
    		end
    	end,
    	Tooltip = 'Doesn\'t bow-assist if your holding one of the blacklisted projectiles',
    })
    Projectiles = BowAssist:CreateTextList({
    	Name = 'Blacklisted',
    	Default = { 'fireball', 'telepearl', 'gloop' },
    	Darker = true,
    })
end)

run(function()
    local AutoLegitFarm
    local RandomQueue
    local AutoMovement
    
    -- Anti-AFK
    local function disableAfk()
        pcall(function()
            for _, v in getconnections(lplr.Idled) do
                v:Disconnect()
            end
        end)
    end

    -- キュー参加機能
    local function joinQueue()
        local state = bedwars.Store:getState()
        if state.Party.leader.userId == lplr.UserId and state.Party.queueState == 0 then
            if RandomQueue.Enabled then
                local listofmodes = {}
                for i, v in bedwars.QueueMeta do
                    if not v.disabled and not v.voiceChatOnly and not v.rankCategory then
                        table.insert(listofmodes, i)
                    end
                end
                if #listofmodes > 0 then
                    bedwars.QueueController:joinQueue(listofmodes[math.random(1, #listofmodes)])
                else
                    bedwars.QueueController:joinQueue(store.queueType)
                end
            else
                bedwars.QueueController:joinQueue(store.queueType)
            end
        end
    end

    -- 剣を取得 (ベースコードのgetSwordとは別に簡易版を用意)
    local function getMySword()
        local inv = store.inventory and store.inventory.inventory and store.inventory.inventory.items
        if not inv then return nil end
        for _, item in pairs(inv) do
            if item.itemType and string.find(item.itemType:lower(), "sword") then
                return item.itemType
            end
        end
        return nil
    end

    AutoLegitFarm = vape.Categories.Utility:CreateModule({
        Name = "AutoLegitFarm",
        Function = function(callback)
            if callback then
                disableAfk()
                
                -- メインループ
                task.spawn(function()
                    local moveTimer = 0
                    local camTimer = 0
                    
                    while AutoLegitFarm.Enabled do
                        task.wait(0.1)
                        disableAfk()
                        
                        local state = bedwars.Store:getState()
                        local matchState = state.Game.matchState
                        
                        -- 試合中のレジット行動 (剣振り)
                        if matchState == 1 then
                            local sword = getMySword()
                            if sword then
                                pcall(function()
                                    switchItem(sword, 0.1)
                                    bedwars.SwordController:swingSwordAtMouse()
                                end)
                            end
                        end
                        
                        -- AutoMovement ロジック (Humanoid:MoveTo使用)
                        if AutoMovement.Enabled and entitylib.isAlive then
                            local hum = entitylib.character.Humanoid
                            local root = entitylib.character.RootPart
                            
                            -- MoveTo の更新 (0.5〜1.5秒ごとにランダムな地点へ)
                            moveTimer = moveTimer - 0.1
                            if moveTimer <= 0 then
                                moveTimer = math.random(5, 15) / 10
                                
                                -- 現在位置からランダムなオフセットを計算
                                local offsetX = math.random(-15, 15)
                                local offsetZ = math.random(-15, 15)
                                local targetPos = root.Position + Vector3.new(offsetX, 0, offsetZ)
                                
                                -- Humanoid:MoveTo で移動指示
                                pcall(function()
                                    hum:Move(targetPos)
                                end)
                            end
                            
                            -- カメラの自然な揺れ
                            camTimer = camTimer - 0.1
                            if camTimer <= 0 then
                                camTimer = math.random(10, 30) / 10
                                local rx = math.random(-3, 3) / 100
                                local ry = math.random(-3, 3) / 100
                                pcall(function()
                                    gameCamera.CFrame = gameCamera.CFrame * CFrame.Angles(rx, ry, 0)
                                end)
                            end
                        end
                    end
                end)

                -- 試合終了時の再キュー
                AutoLegitFarm:Clean(vapeEvents.MatchEndEvent.Event:Connect(function()
                    task.wait(2)
                    joinQueue()
                end))

                -- 死亡 + 試合終了時の再キュー
                AutoLegitFarm:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
                    if deathTable.entityInstance == lplr.Character then
                        local state = bedwars.Store:getState()
                        if state.Game.matchState == 2 then
                            task.wait(2)
                            joinQueue()
                        end
                    end
                end))

                -- ベッド破壊時の再キュー
                AutoLegitFarm:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
                    local myTeam = tonumber(lplr:GetAttribute('Team'))
                    local brokenTeam = tonumber(bedTable.brokenBedTeam.id)
                    if myTeam and brokenTeam and myTeam == brokenTeam then
                        task.wait(1.5)
                        joinQueue()
                    end
                end))
            end
        end,
        Tooltip = "Anti-AFK, legit farm, auto queue & Humanoid:MoveTo movement."
    })

    RandomQueue = AutoLegitFarm:CreateToggle({
        Name = "Random Queue",
        Default = true,
        Tooltip = "Queues a random available mode instead of current mode."
    })

    AutoMovement = AutoLegitFarm:CreateToggle({
        Name = "Auto Movement",
        Default = false,
        Tooltip = "Uses Humanoid:MoveTo to simulate natural wandering."
    })
end)

run(function()
local NoFall
local AlwaysNofall

NoFall = vape.Categories.Blatant:CreateModule({
	Name = 'Render NoFall',
	Function = function(callback)
		if callback then
			NoFall:Clean(runService.Heartbeat:Connect(function(dt)
				if entitylib.isAlive and bedwars.Knit.Controllers.MatchController:getMatchState() == 1 then
					local root = entitylib.character.RootPart
					local v = root.Velocity

					-- AlwaysNofall: 常にLanded状態にする
					if AlwaysNofall.Enabled then
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
					end

					if root.Velocity.Y < -35 and not vape.Modules.Fly.Enabled then
						root.Velocity = Vector3.new(0, 2.5, 0)
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
						runService.PreRender:Wait()
						root.Velocity = v
					end
				end
			end))

			NoFall:Clean(entitylib.Events.LocalAdded:Connect(function(char)
				local animator = char.Humanoid:WaitForChild('Animator', 1)
				if animator and NoFall.Enabled and not vape.Modules.Fly.Enabled then
					task.wait(.5)
					NoFall:Toggle()
					NoFall:Toggle()
				end
			end))
		end
	end,
	Tooltip = 'Take no fall damage.'
})

-- 追加: AlwaysNofall オプション
AlwaysNofall = NoFall:CreateToggle({
	Name = 'Always NoFall',
	Default = false,
	Tooltip = 'Constantly sets Humanoid state to Landed every frame.'
})
end)

run(function()
    local BackTrack
    local Mode
    local Latency
    local Tick
    
    BackTrack = vape.Categories.Utility:CreateModule({
        Name = 'Back Track',
        Function = function(callback)
            if callback then
                repeat
                    local ent = entitylib.EntityPosition({
                        Part = 'RootPart',
                        Range = 22,
                        Players = true,
                        Wallcheck = true,
                    })
    
                    if ent then
                        if Mode.Value == 'Manual' then
                            setfflag('TargetTimeDelayFacctorTenths', '50000')
                            task.wait(0.05 * Tick.Value)
                            setfflag('TargetTimeDelayFacctorTenths', '20')
                            task.wait(0.05 * Tick.Value)
                        else
                            setfflag('TargetTimeDelayFacctorTenths', tostring(math.floor(20 + (Latency:GetRandomValue() / 20))))
                            task.wait(1)
                        end
                    else
                        setfflag('TargetTimeDelayFacctorTenths', '20')
                    end
                    task.wait()
                until not BackTrack.Enabled
            end
        end,
        Tooltip = 'Lags targets at certain times to increase attack distance'
    })
    getgenv().Backtrack = BackTrack
    Latency = BackTrack:CreateTwoSlider({
        Name = 'Latency',
        Min = 1,
        Max = 500,
        DefaultMin = 50,
        DefaultMax = 120,
        Darker = true,
    })
    Tick = BackTrack:CreateSlider({
        Name = 'Ticks',
        Min = 1,
        Max = 20,
        Default = 5,
        Darker = true,
        Visible = false,
    })
    Mode = BackTrack:CreateDropdown({
        Name = 'Mode',
        List = { 'Manual', 'Lag Based' },
        Default = 'Manual',
        Function = function(val)
            if Latency and Tick then
                Latency.Object.Visible = val == 'Manual'
                Tick.Object.Visible = val == 'Lag Based'
            end
        end,
    })
end)

run(function()
    local ShowThemResource
    local Reference = {} -- { [TeamId] = { Iron = 0, Diamond = 0, Emerald = 0, UI = Frame } }
    local Folder = Instance.new("Folder")
    Folder.Parent = vape.gui
    
    -- チームカラー定義
    local teamColors = {
        [1] = Color3.fromRGB(85, 150, 255),   -- Blue
        [2] = Color3.fromRGB(255, 150, 50),   -- Orange
        [3] = Color3.fromRGB(255, 100, 200),  -- Pink
        [4] = Color3.fromRGB(255, 255, 50),   -- Yellow
        [5] = Color3.fromRGB(75, 255, 75),    -- Lime/Other
        [6] = Color3.fromRGB(150, 150, 150),  -- Gray
    }

    -- リソース名の判定用テーブル
    local resourceTypes = {
        ["iron"] = "Iron",
        ["gold"] = "Gold",
        ["diamond"] = "Diamond",
        ["emerald"] = "Emerald"
    }

    -- 指定されたフォルダからリソースを集計する関数
    local function countResourcesInFolder(folder, counts)
        if not folder or not folder:IsA("Instance") then return end
        
        for _, item in pairs(folder:GetChildren()) do
            local name = item.Name:lower()
            local amount = 1
            
            -- Amount属性があればそれを使う
            if item:GetAttribute("Amount") then
                amount = item:GetAttribute("Amount")
            end
            
            -- リソース名と一致するか確認
            for key, resName in pairs(resourceTypes) do
                if name == key or name:find(key) then
                    counts[resName] = (counts[resName] or 0) + amount
                    break
                end
            end
        end
    end

    local function updateUI()
        if not ShowThemResource.Enabled then return end
        
        local counts = {} -- [TeamId] = { Iron = n, Diamond = n, Emerald = n }
        
        -- 1. プレイヤーのインベントリから集計
        local inventoriesFolder = replicatedStorage:FindFirstChild("Inventories")
        if inventoriesFolder then
            for _, playerFolder in pairs(inventoriesFolder:GetChildren()) do
                if playerFolder:IsA("Folder") and playerFolder.Name ~= "CachedInvItems" then
                    local plr = playersService:FindFirstChild(playerFolder.Name)
                    if plr and plr:GetAttribute("Team") then
                        local teamId = tonumber(plr:GetAttribute("Team"))
                        if not counts[teamId] then
                            counts[teamId] = { Iron = 0, Diamond = 0, Emerald = 0 }
                        end
                        countResourcesInFolder(playerFolder, counts[teamId])
                    end
                end
            end
        end
        
        -- 2. チェストの中身から集計 (StorageESPと同じ仕組み)
        for _, chestObj in pairs(collectionService:GetTagged('chest')) do
            local chestFolder = chestObj:FindFirstChild("ChestFolderValue")
            if chestFolder and chestFolder.Value and chestFolder.Value:IsA("Folder") then
                -- チェストの所有者（置いた人）のチームを取得
                local ownerId = chestObj:GetAttribute("PlacedByUserId")
                if ownerId then
                    local ownerPlr = playersService:GetPlayerByUserId(ownerId)
                    if ownerPlr and ownerPlr:GetAttribute("Team") then
                        local teamId = tonumber(ownerPlr:GetAttribute("Team"))
                        if not counts[teamId] then
                            counts[teamId] = { Iron = 0, Diamond = 0, Emerald = 0 }
                        end
                        countResourcesInFolder(chestFolder.Value, counts[teamId])
                    end
                end
            end
        end

        -- UI更新処理
        for teamId, data in pairs(counts) do
            if not Reference[teamId] then
                -- 新しいチームのUI作成
                local frame = Instance.new("Frame")
                frame.Name = "TeamRes_" .. teamId
                frame.Size = UDim2.fromOffset(140, 60)
                frame.BackgroundColor3 = teamColors[teamId] or Color3.new(1,1,1)
                frame.BackgroundTransparency = 0.2
                frame.BorderSizePixel = 0
                frame.Position = UDim2.new(0, 10, 1, -10 - (#Reference * 70))
                frame.AnchorPoint = Vector2.new(0, 1)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 4)
                corner.Parent = frame
                
                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(1, 0, 0, 20)
                title.BackgroundTransparency = 1
                title.Text = "Team " .. teamId
                title.TextColor3 = Color3.new(1,1,1)
                title.TextStrokeTransparency = 0.5
                title.Font = Enum.Font.GothamBold
                title.TextSize = 14
                title.Parent = frame
                
                local content = Instance.new("TextLabel")
                content.Name = "Content"
                content.Size = UDim2.new(1, -10, 1, -20)
                content.Position = UDim2.new(0, 5, 0, 20)
                content.BackgroundTransparency = 1
                content.TextXAlignment = Enum.TextXAlignment.Left
                content.TextYAlignment = Enum.TextYAlignment.Top
                content.TextColor3 = Color3.new(1,1,1)
                content.TextStrokeTransparency = 0.5
                content.Font = Enum.Font.Gotham
                content.TextSize = 12
                content.Parent = frame
                
                frame.Parent = Folder
                Reference[teamId] = { UI = frame, Content = content }
            end
            
            local uiData = Reference[teamId]
            if uiData then
                uiData.Content.Text = 
                    "🔩 Iron: " .. data.Iron .. "\n" ..
                    "💎 Dia: " .. data.Diamond .. "\n" ..
                    "❇ Em: " .. data.Emerald
            end
        end
        
        -- 存在しないチームのUIを削除
        for teamId, data in pairs(Reference) do
            if not counts[teamId] then
                data.UI:Destroy()
                Reference[teamId] = nil
            end
        end
        
        -- 位置調整（左下から上に積み上げる）
        local index = 0
        for teamId, data in pairs(Reference) do
            data.UI.Position = UDim2.new(0, 10, 1, -10 - (index * 70))
            index += 1
        end
    end

    ShowThemResource = vape.Categories.Render:CreateModule({
        Name = 'ShowThemResource',
        Function = function(callback)
            if callback then
                -- ReplicatedStorage.Inventories の変更を監視
                local invFolder = replicatedStorage:FindFirstChild("Inventories")
                if invFolder then
                    ShowThemResource:Clean(invFolder.ChildAdded:Connect(updateUI))
                    ShowThemResource:Clean(invFolder.ChildRemoved:Connect(updateUI))
                end
                
                -- チェストの増減を監視
                ShowThemResource:Clean(collectionService:GetInstanceAddedSignal('chest'):Connect(updateUI))
                ShowThemResource:Clean(collectionService:GetInstanceRemovedSignal('chest'):Connect(updateUI))
                
                -- プレイヤーのチーム変更を監視
                ShowThemResource:Clean(playersService.PlayerAdded:Connect(function(plr)
                    ShowThemResource:Clean(plr:GetAttributeChangedSignal('Team'):Connect(updateUI))
                end))
                
                -- 初期実行と定期更新
                updateUI()
                ShowThemResource:Clean(runService.Heartbeat:Connect(updateUI))
            else
                Folder:ClearAllChildren()
                table.clear(Reference)
            end
        end,
        Tooltip = 'Shows total resources held by each team (Inventory + Chests).'
    })

    -- オプション: UIの大きさ調整
    local UIScale = ShowThemResource:CreateSlider({
        Name = 'UI Scale',
        Min = 0.5,
        Max = 2.0,
        Default = 1.0,
        Decimal = 10,
        Function = function(val)
            for _, data in pairs(Reference) do
                if data.UI then
                    data.UI.Size = UDim2.fromOffset(140 * val, 60 * val)
                    data.UI:FindFirstChild('Title').TextSize = 14 * val
                    data.UI:FindFirstChild('Content').TextSize = 12 * val
                end
            end
        end
    })
end)

run(function()
    local FastCameraChange

    -- Exploitのマウスホイールスクロール関数を安全に呼び出すラッパー
    local function simulateScroll(dir)
        pcall(function()
            if typeof(mousescroll) == "function" then
                mousescroll(dir)
            elseif typeof(mousewheel) == "function" then
                mousewheel(dir)
            elseif typeof(mouse1scroll) == "function" then
                mouse1scroll(dir)
            end
        end)
    end

    FastCameraChange = vape.Categories.Utility:CreateModule({
        Name = 'FastCameraChange',
        Function = function(callback)
            -- task.spawnを使って、スクロール処理が他の処理をブロックしないようにする
            task.spawn(function()
                if callback then
                    -- callbackがtrue（モジュールON）のとき -> 1人称にするためにホイールを上にスクロール
                    for i = 1, 40 do
                        simulateScroll(999999) -- 1: ホイール上（ズームイン）
                        task.wait()
                    end
                else
                    -- callbackがfalse（モジュールOFF）のとき -> 3人称にするためにホイールを下にスクロール
                    for i = 1, 40 do
                        simulateScroll(-9999999) -- -1: ホイール下（ズームアウト）
                        task.wait()
                    end
                end
            end)
        end,
        Tooltip = 'Simulates mouse wheel to toggle between 1st and 3rd person'
    })
end)

run(function()
	local Breaker
	local Range
	local BreakSpeed
	local UpdateRate
	local Bed
	local LuckyBlock
	local IronOre
	local Tesla
	local Hive
	local Pinata
	local Crops
	local Effect
	local CustomHealth = {}
	local Animation
	local SelfBreak
	local InstantBreak
	local LimitItem
	local AutoTool
	local MouseDown
	local Snow
	local YetiBreaker
	local RagnarBreaker
	local ShowPath
	local BreakClosest
	local BlockHighlight
	local BreakerHighlightColor
	local BreakerAngle
	local blockHighlightInstance
	local frozenBlockPositions = {}
	local parts = {}
	local lastTier4Break = 0
	local tierTeamIds = { tier99 = {}, tier4 = {} }
	local lastTierCacheUpdate = 0
	local hit = 0
	local cachedTeammates = {}
	local cachedTeammatesTime = 0
	local breakabilityCache = {}
	local BREAK_CACHE_TTL = 0.5

	local function cachedIsBreakable(v)
		local now = tick()
		local cached = breakabilityCache[v]
		if cached and (now - cached.t) < BREAK_CACHE_TTL then
			return cached.v
		end
		local blockPos = bedwars.BlockController:getBlockPosition(v.Position)
		local ok, result = pcall(bedwars.BlockController.isBlockBreakable, bedwars.BlockController, {blockPosition = blockPos}, lplr)
		local val = ok and result
		breakabilityCache[v] = {v = val, t = now}
		return val
	end

	local function updateTierTeamCache()
		local now = tick()
		if now - lastTierCacheUpdate < 3 then return end 
		lastTierCacheUpdate = now
		
		table.clear(tierTeamIds.tier99)
		table.clear(tierTeamIds.tier4)

		for _, player in playersService:GetPlayers() do
			local tier = getAccountTier(player)
			if tier >= 99 then
				local teamId = player.Character and (player.Character:GetAttribute('Team') or player.Character:GetAttribute('TeamId'))
				if teamId then
					tierTeamIds.tier99[tonumber(teamId)] = true
				end
			elseif tier == 4 then
				local teamId = player.Character and (player.Character:GetAttribute('Team') or player.Character:GetAttribute('TeamId'))
				if teamId then
					tierTeamIds.tier4[tonumber(teamId)] = true
				end
			end
		end
	end

	local function getPlacerTier(block)
		if not block then return 0 end
		
		updateTierTeamCache()
		
		local blockTeamId = block:GetAttribute('Team') or block:GetAttribute('TeamId')
		if blockTeamId then
			blockTeamId = tonumber(blockTeamId)
			if blockTeamId then
				if tierTeamIds.tier99[blockTeamId] then
					return 99
				elseif tierTeamIds.tier4[blockTeamId] then
					return 4
				end
			end
		end

		local userId = block:GetAttribute('PlacedByUserId')
		if userId then
			local success, player = pcall(playersService.GetPlayerByUserId, playersService, userId)
			if success and player then
				return getAccountTier(player)
			end
		end
		
		return 0
	end

	local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		if block:GetAttribute('NoHealthbar') then return end
		if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
			self.healthbarMaid:DoCleaning()
			self.healthbarBlockRef = blockRef
			local create = bedwars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			self.healthbarPart = part
			bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)

			local mounted = bedwars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('newvape/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[bedwars.Roact.Ref] = self.healthbarProgressRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)

			self.healthbarMaid:GiveTask(function()
				cleanCheck = false
				self.healthbarBlockRef = nil
				bedwars.Roact.unmount(mounted)
				if self.healthbarPart then
					self.healthbarPart:Destroy()
				end
				self.healthbarPart = nil
			end)

			bedwars.RuntimeLib.Promise.delay(5):andThen(function()
				if cleanCheck then
					self.healthbarMaid:DoCleaning()
				end
			end)
		end

		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
			Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
		}):Play()
	end

	local function rebuildTeammateCache()
		local now = tick()
		if now - cachedTeammatesTime < 2 then return end
		cachedTeammatesTime = now
		table.clear(cachedTeammates)
		local localTeam = lplr.Team
		if not localTeam then return end
		for _, player in playersService:GetPlayers() do
			if player.Team == localTeam then
				cachedTeammates[player.UserId] = true
			end
		end
	end

	local function isSameTeam(userId)
		if not userId then return false end
		rebuildTeammateCache()
		return cachedTeammates[userId] == true
	end

	local function passesChecks(v)
		local placerTier = getPlacerTier(v)
		local myTier = getAccountTier(lplr)

		if placerTier >= 99 and myTier <= 4 then
			return false  
		end

		if placerTier == 4 and myTier == 0 then
			if tick() - lastTier4Break < (1.65 + math.random() * 0.7) then
				return false 
			end
			lastTier4Break = tick() 
		end

		if not SelfBreak.Enabled then
			if v.Name == 'bed' then
				local myTeam = lplr.Character and (lplr.Character:GetAttribute('Team') or lplr.Character:GetAttribute('TeamId'))
				local bedTeam = v:GetAttribute('Team') or v:GetAttribute('TeamId')
				if not myTeam or not bedTeam or tonumber(bedTeam) == tonumber(myTeam) then 
					return false 
				end
			end

			local blockTeam = v:GetAttribute('Team') or v:GetAttribute('TeamId')
			local myTeam = lplr.Character and (lplr.Character:GetAttribute('Team') or lplr.Character:GetAttribute('TeamId'))
			
			if blockTeam and myTeam and tonumber(blockTeam) == tonumber(myTeam) then
				return false
			end

			if v:GetAttribute('PlacedByUserId') == lplr.UserId then 
				return false 
			end
			
			if isSameTeam(v:GetAttribute('PlacedByUserId')) then 
				return false 
			end
		end

		if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then 
			return false 
		end
		
		if LimitItem.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then 
			return false 
		end
		
		return true
	end

	local function wrappedHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		if BlockHighlight and BlockHighlight.Enabled and blockHighlightInstance then
			blockHighlightInstance.Size = block.Size + Vector3.new(0.01, 0.01, 0.01)
			blockHighlightInstance.Adornee = block
		end
		if CustomHealth.Enabled then
			customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		end
	end

	local function doBreak(v, isPathBlock)
		hit += 1
		if RagnarBreaker and RagnarBreaker.Enabled then
			if store.equippedKit == 'berserker' and bedwars.AbilityController and bedwars.AbilityController:canUseAbility("berserker_rage") then
				replicatedStorage:WaitForChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"):WaitForChild("useAbility"):FireServer("berserker_rage")
			end
		end
		if BreakClosest and BreakClosest.Enabled then bedwars.breakClosestMode = true end
		local target, path, endpos = bedwars.breakBlock(v, Effect.Enabled, Animation.Enabled, wrappedHealthbar, (InstantBreak.Enabled or AutoTool.Enabled) and LimitItem.Enabled)
		bedwars.breakClosestMode = false
		if path and ShowPath and ShowPath.Enabled then
			local placerTier = getPlacerTier(v)
			if placerTier == 4 and placerTier < 99 and getAccountTier(lplr) == 0 then
				task.wait(0.65 + math.random() * 0.4)  
			end
			local currentnode = target
			for _, part in parts do
				part.Position = currentnode or Vector3.zero
				if currentnode then
					part.BoxHandleAdornment.Color3 = currentnode == endpos and Color3.new(1, 0.2, 0.2) or currentnode == target and Color3.new(0.2, 0.2, 1) or Color3.new(0.2, 1, 0.2)
				end
				currentnode = path[currentnode]
			end
		end
		task.wait(isPathBlock and 0 or (InstantBreak.Enabled and (store.damageBlockFail > tick() and 4.5 or 0) or BreakSpeed.Value))
		return true
	end

	local function doBreakDirect(block)
		if not block or not block.Parent then return end
		local blockPos = bedwars.BlockController:getBlockPosition(block.Position)
		pcall(function()
			bedwars.ClientDamageBlock:Get('DamageBlock'):CallServerAsync({
				blockRef = {blockPosition = blockPos},
				hitPosition = block.Position,
				hitNormal = Vector3.FromNormalId(Enum.NormalId.Top)
			})
		end)
		task.wait(BreakSpeed.Value)
	end

	local function findPathBlock(targetPos, playerPos)
		local dir = (targetPos - playerPos)
		local distance = dir.Magnitude
		if distance < 3 then return nil end
		dir = dir.Unit
		local checked = {}
		local step = 3
		for i = step, distance - step, step do
			local checkPos = roundPos(playerPos + dir * i)
			local key = checkPos.X .. ',' .. checkPos.Y .. ',' .. checkPos.Z
			if checked[key] then continue end
			checked[key] = true
			if (checkPos - targetPos).Magnitude < 2.5 then continue end
			if (checkPos - playerPos).Magnitude < 3 then continue end
			local block = getPlacedBlock(checkPos)
			if block then
				local ok, canBreak = pcall(bedwars.BlockController.isBlockBreakable, bedwars.BlockController, {blockPosition = checkPos / 3}, lplr)
				if ok and canBreak and passesChecks(block) then
					return block
				end
			end
		end
		return nil
	end

	local function isYetiBlock(block)
		if not block then return false end
		local pos = block.Position / 3
		local key = math.round(pos.X) .. ',' .. math.round(pos.Y) .. ',' .. math.round(pos.Z)
		return frozenBlockPositions[key] == true
	end

	local function hookFreezeController()
		local FreezeCtrl = (bedwars.KnitClient and bedwars.KnitClient.Controllers and bedwars.KnitClient.Controllers.FreezeBlocksController)
			or (bedwars.Knit and bedwars.Knit.Controllers and bedwars.Knit.Controllers.FreezeBlocksController)
		if not FreezeCtrl or not FreezeCtrl.freezeBlocks then return end
		local oldFreeze = FreezeCtrl.freezeBlocks
		FreezeCtrl.freezeBlocks = function(self, position, frozenBlocks, ...)
			table.clear(frozenBlockPositions)
			if type(frozenBlocks) == 'table' then
				for _, v in frozenBlocks do
					local pos
					if typeof(v) == 'Vector3' then
						pos = v
					elseif type(v) == 'table' then
						pos = v.position or v.blockPosition or v.pos
					elseif typeof(v) == 'Instance' and v:IsA('BasePart') then
						pos = v.Position / 3
					end
					if pos then
						local key = math.round(pos.X) .. ',' .. math.round(pos.Y) .. ',' .. math.round(pos.Z)
						frozenBlockPositions[key] = true
					end
				end
			end
			task.delay(8, function() table.clear(frozenBlockPositions) end)
			return oldFreeze(self, position, frozenBlocks, ...)
		end
		Breaker:Clean(function()
			pcall(function() FreezeCtrl.freezeBlocks = oldFreeze end)
		end)
	end

	local function findYetiPathBlock(bedPos, playerPos)
		local dir = (bedPos - playerPos)
		local distance = dir.Magnitude
		if distance < 3 then return nil end
		dir = dir.Unit
		local step = 3
		local bestYeti, bestDist = nil, math.huge
		for i = step, distance - step, step do
			local checkPos = roundPos(playerPos + dir * i)
			if (checkPos - bedPos).Magnitude < 4 then continue end
			local block = getPlacedBlock(checkPos)
			if block and isYetiBlock(block) then
				local nextStepPos = roundPos(checkPos + dir * step)
				local nextBlock = getPlacedBlock(nextStepPos)
				if not nextBlock then continue end
				local dist = (checkPos - bedPos).Magnitude
				if dist < bestDist and bedwars.BlockController:isBlockBreakable({blockPosition = checkPos / 3}, lplr) and passesChecks(block) then
					bestYeti = block
					bestDist = dist
				end
			end
		end
		return bestYeti
	end

	local function attemptBreak(tab, localPosition, skipBreakCheck)
		if not tab then return false end
		if MouseDown and MouseDown.Enabled and not inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return false end
		local best, bestDist = nil, math.huge
		for _, v in tab do
			local dist = (v.Position - localPosition).Magnitude
			if dist >= Range.Value or dist >= bestDist then continue end
			if not skipBreakCheck and v.Name ~= 'bed' then
				if not cachedIsBreakable(v) then continue end
			end
			if not passesChecks(v) then continue end
			best = v
			bestDist = dist
		end
		if not best then return false end
		return doBreak(best)
	end

	local function attemptBreakNamed(names, localPosition)
		if names == nil then
			names = {}
		end
		if MouseDown and MouseDown.Enabled and not inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return false end
		local best, bestDist = nil, math.huge
		for _, v in store.blocks do
			if v and v:IsA('BasePart') and table.find(names, v.Name) then
				local dist = (v.Position - localPosition).Magnitude
				if dist < Range.Value and dist < bestDist then
					if cachedIsBreakable(v) and passesChecks(v) then
						if true then
							best = v
							bestDist = dist
						end
					end
				end
			end
		end
		if best then return doBreak(best) end
		return false
	end

	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'AeroBreaker',
		Function = function(callback)
			if callback then
				if ShowPath and ShowPath.Enabled then
					for _ = 1, 8 do
						local part = Instance.new('Part')
						part.Anchored = true
						part.CanQuery = false
						part.CanCollide = false
						part.Transparency = 1
						part.Parent = gameCamera
						local highlight = Instance.new('BoxHandleAdornment')
						highlight.Size = Vector3.one
						highlight.AlwaysOnTop = true
						highlight.ZIndex = 1
						highlight.Transparency = 0.5
						highlight.Adornee = part
						highlight.Parent = part
						table.insert(parts, part)
					end
				end

				if BlockHighlight and BlockHighlight.Enabled then
					blockHighlightInstance = Instance.new('BoxHandleAdornment')
					blockHighlightInstance.AlwaysOnTop = true
					blockHighlightInstance.ZIndex = 10
					blockHighlightInstance.Transparency = 0.3
					blockHighlightInstance.Color3 = BreakerHighlightColor and Color3.fromHSV(BreakerHighlightColor.Hue, BreakerHighlightColor.Sat, BreakerHighlightColor.Value) or Color3.fromRGB(255, 255, 0)
					blockHighlightInstance.Parent = gameCamera
				end
				
				task.spawn(hookFreezeController)
				local beds = collection('bed', Breaker)
				local luckyblock = collection('LuckyBlock', Breaker)
				local ironores = collection('iron_ore_mesh_block', Breaker)

				local trackedSpecial = {tesla_trap={}, beehive={}, pinata={}, carrot={}, melon={}, pumpkin={}, snow_pile={}} 
				local _trackedNames = {tesla_trap = true, beehive = true, pinata = true, carrot = true, melon = true, pumpkin = true, snow_pile = true}

			local function trackAdd(obj)
				if not _trackedNames[obj.Name] then return end
				local t = trackedSpecial[obj.Name]
				if not t then return end
				if obj:IsA('BasePart') then
					table.insert(t, obj)
				elseif obj:IsA('Model') then
					local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA('BasePart')
					if part then table.insert(t, part) end
				end
			end

			local function trackRemove(obj)
				if not _trackedNames[obj.Name] then return end
				local t = trackedSpecial[obj.Name]
				if t then
					if obj:IsA('BasePart') then
						local i = table.find(t, obj)
						if i then table.remove(t, i) end
					elseif obj:IsA('Model') then
						local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA('BasePart')
						if part then
							local i = table.find(t, part)
							if i then table.remove(t, i) end
						end
					end
				end
				breakabilityCache[obj] = nil
			end

			for _, obj in workspace:GetDescendants() do trackAdd(obj) end
			Breaker:Clean(workspace.DescendantAdded:Connect(trackAdd))
			Breaker:Clean(workspace.DescendantRemoving:Connect(trackRemove))

				local lockedPathBlock = nil
				repeat
					task.wait(1 / UpdateRate.Value)
					if not Breaker.Enabled then break end
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position

						if Bed.Enabled and YetiBreaker and YetiBreaker.Enabled then
							local foundYeti = false
							for _, bed in beds do
								if foundYeti then break end
								if (bed.Position - localPosition).Magnitude < Range.Value then
									local yetiBlock = findYetiPathBlock(bed.Position, localPosition)
									if yetiBlock then
										doBreak(yetiBlock)
										foundYeti = true
									end
								end
							end
							if foundYeti then continue end
						end

						local best, bestDist = nil, math.huge
						local _blockPosArg = {}
						local function eval(tab, skip)
							if not tab then return end
							for _, v in tab do
								if not v or not v.Parent then continue end
								local dist = (v.Position - localPosition).Magnitude
								if dist >= Range.Value or dist >= bestDist then continue end
								if not skip and v.Name ~= 'bed' then
									if not cachedIsBreakable(v) then continue end
								end
								if not passesChecks(v) then continue end
								if BreakerAngle and BreakerAngle.Value < 360 then
									local hrp = entitylib.character and entitylib.character.RootPart
									if hrp then
										local toBlock = (v.Position - hrp.Position).Unit
										local dot = hrp.CFrame.LookVector:Dot(toBlock)
										local angleToBlock = math.deg(math.acos(math.clamp(dot, -1, 1)))
										if angleToBlock > BreakerAngle.Value / 2 then continue end
									end
								end
								best = v
								bestDist = dist
							end
						end
						eval(Bed.Enabled and beds, true)
						if not best then
							eval(LuckyBlock.Enabled and luckyblock, true)
							eval(IronOre.Enabled and ironores, true)
							eval(Tesla and Tesla.Enabled and trackedSpecial.tesla_trap, true)
							eval(Snow and Snow.Enabled and trackedSpecial.snow_pile, true)
							eval(Hive and Hive.Enabled and trackedSpecial.beehive)
							eval(Pinata and Pinata.Enabled and trackedSpecial.pinata, true)
							if Crops and Crops.Enabled then
								eval(trackedSpecial.carrot, true)
								eval(trackedSpecial.melon, true)
								eval(trackedSpecial.pumpkin, true)
							end
						end
					
						if best then
							if not MouseDown or not MouseDown.Enabled or inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								if BreakClosest and BreakClosest.Enabled then
									local underBlock = getPlacedBlock(roundPos(localPosition - Vector3.new(0, 3, 0)))
									if underBlock and underBlock ~= best and passesChecks(underBlock) then
										local bpos = bedwars.BlockController:getBlockPosition(underBlock.Position)
										local ok, canBreak = pcall(bedwars.BlockController.isBlockBreakable, bedwars.BlockController, {blockPosition = bpos}, lplr)
										if ok and canBreak then
											doBreak(underBlock, true)
											continue
										end
									end
									local pathBlock = findPathBlock(best.Position, localPosition)
									if pathBlock then
										doBreak(pathBlock, true)
									else
										doBreak(best, false)
									end
								else
									doBreak(best, false)
								end
								continue
							end
						end

						if BlockHighlight and BlockHighlight.Enabled and blockHighlightInstance then
							blockHighlightInstance.Adornee = nil
						end
						for _, v in parts do
							v.Position = Vector3.zero
						end
					end
				until not Breaker.Enabled
			else
				table.clear(breakabilityCache)
				if blockHighlightInstance then
					blockHighlightInstance:Destroy()
					blockHighlightInstance = nil
				end
				for _, v in parts do
					v:ClearAllChildren()
					v:Destroy()
				end
				table.clear(parts)
			end
		end,
		Tooltip = 'Break blocks around you automatically'
	})

	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	BreakSpeed = Breaker:CreateSlider({
		Name = 'Break speed',
		Min = 0,
		Max = 0.3,
		Default = 0.25,
		Decimal = 100,
		Suffix = 'seconds'
	})
	UpdateRate = Breaker:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	Bed = Breaker:CreateToggle({
		Name = 'Break Bed',
		Default = true
	})
	LuckyBlock = Breaker:CreateToggle({
		Name = 'Break Lucky Block',
		Default = true
	})
	IronOre = Breaker:CreateToggle({
		Name = 'Break Iron Ore',
		Default = true
	})
	Snow = Breaker:CreateToggle({
		Name = 'Break Snow',
		Default = false
	})
	Tesla = Breaker:CreateToggle({
		Name = 'Break Tesla',
		Default = true
	})
	Hive = Breaker:CreateToggle({
		Name = 'Break Hive',
		Default = true
	})
	Pinata = Breaker:CreateToggle({
		Name = 'Break Pinata',
		Default = false
	})
	Crops = Breaker:CreateToggle({
		Name = 'Break Crops',
		Default = false,
		Tooltip = 'Breaks pumpkin, carrot and watermelon crops '
	})
	Effect = Breaker:CreateToggle({
		Name = 'Show Healthbar & Effects',
		Function = function(callback)
			if CustomHealth.Object then
				CustomHealth.Object.Visible = callback
			end
		end,
		Default = true
	})
	CustomHealth = Breaker:CreateToggle({
		Name = 'Custom Healthbar',
		Default = true,
		Darker = true
	})
	Animation = Breaker:CreateToggle({Name = 'Animation'})
	SelfBreak = Breaker:CreateToggle({Name = 'Self Break'})
	InstantBreak = Breaker:CreateToggle({Name = 'Instant Break'})
	AutoTool = Breaker:CreateToggle({
		Name = 'Auto Tool',
		Tooltip = 'Automatically switches to the best tool for breaking blocks'
	})
	LimitItem = Breaker:CreateToggle({
		Name = 'Limit to items',
		Tooltip = 'Only breaks when tools are held'
	})
	MouseDown = Breaker:CreateToggle({
		Name = 'Require Mouse Down',
		Tooltip = 'Only breaks blocks when holding left click'
	})
	YetiBreaker = Breaker:CreateToggle({
		Name = 'Yeti Breaker',
		Tooltip = 'Focuses on frozen blocks'
	})
	RagnarBreaker = Breaker:CreateToggle({
		Name = 'Ragnar',
		Tooltip = 'pops the ragnar ability whenever nuking'
	})
	BreakClosest = Breaker:CreateToggle({
		Name = 'Break Closest',
		Default = false,
		Tooltip = 'Prioritizes breaking blocks closest to your character instead of the optimal path'
	})
	ShowPath = Breaker:CreateToggle({
		Name = 'Show Path',
		Default = true,
		Tooltip = 'Show the path boxes when breaking blocks'
	})
	BlockHighlight = Breaker:CreateToggle({
		Name = 'Block Highlight',
		Default = false,
		Tooltip = 'Highlights the block currently being broken',
		Function = function(callback)
			if BreakerHighlightColor and BreakerHighlightColor.Object then
				BreakerHighlightColor.Object.Visible = callback
			end
			if callback then
				if Breaker.Enabled then
					blockHighlightInstance = Instance.new('BoxHandleAdornment')
					blockHighlightInstance.AlwaysOnTop = true
					blockHighlightInstance.ZIndex = 10
					blockHighlightInstance.Transparency = 0.3
					blockHighlightInstance.Color3 = BreakerHighlightColor and Color3.fromHSV(BreakerHighlightColor.Hue, BreakerHighlightColor.Sat, BreakerHighlightColor.Value) 
					blockHighlightInstance.Parent = gameCamera
				end
			else
				table.clear(breakabilityCache)
				if blockHighlightInstance then
					blockHighlightInstance:Destroy()
					blockHighlightInstance = nil
				end
			end
		end
	})
	BreakerHighlightColor = Breaker:CreateColorSlider({
		Name = 'Highlight Color',
		Darker = true,
		DefaultHue = 0.167,
		DefaultOpacity = 0.2,
		Visible = false,
		Tooltip = 'Color of the block highlight',
		Function = function(hue, sat, val)
			if blockHighlightInstance then
				blockHighlightInstance.Color3 = Color3.fromHSV(hue, sat, val)
			end
		end
	})

	BreakerAngle = Breaker:CreateSlider({
		Name = 'Break Angle',
		Min = 0,
		Max = 360,
		Default = 360,
		Tooltip = 'only break blocks within this angle of your look direction 360 = all directions'
	})

	task.defer(function()
		if CustomHealth and CustomHealth.Object then
			CustomHealth.Object.Visible = Effect.Enabled
		end
	end)
end)

run(function()
    local ShopQuickBuy -- coded by seven
    local HoldDelay
    local CPS
    
    local holding = false
    local clickThread
    
    local function getShopId()
        if not entitylib.isAlive then return nil end
        local localPosition = entitylib.character.RootPart.Position
        local id
        for _, v in store.shop do
            if v.Shop and (v.RootPart.Position - localPosition).Magnitude <= 20 then
                id = v.Id
            end
        end
        return id
    end
    
    local function getHoveredItem()
        local mousepos = (inputService:GetMouseLocation() - guiService:GetGuiInset())
        for _, v in lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
            local obj = v
            while obj and obj ~= lplr.PlayerGui do
                local itemType = obj.Name:match('^(.+)_ShopItemCard$')
                if itemType then
                    return itemType
                end
                obj = obj.Parent
            end
        end
    end
    
    local function canBuy(item)
        if item.ignoredByKit and table.find(item.ignoredByKit, store.equippedKit or '') then return false end
        if item.lockedByForge or item.disabled then return false end
        if item.require and item.require.teamUpgrade then
            if (bedwars.Store:getState().Bedwars.teamUpgrades[item.require.teamUpgrade.upgradeId] or -1) < item.require.teamUpgrade.lowestTierIndex then
                return false
            end
        end
        local currency = getItem(item.currency)
        return (currency and currency.amount or 0) >= item.price
    end
    
    local function purchase(itemType, shopId)
        if bedwars.BedwarsShopController.alreadyPurchasedMap[itemType] ~= nil then return end
    
        local item = bedwars.Shop.getShopItem(itemType, lplr, {shopId = shopId})
        if not item or not canBuy(item) then return end
    
        bedwars.Client:Get('BedwarsPurchaseItem'):CallServerAsync({
            shopItem = item,
            shopId = shopId
        }):andThen(function(suc)
            if not suc then return end
            bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
            bedwars.Store:dispatch({
                type = 'BedwarsAddItemPurchased',
                itemType = itemType
            })
            if item.tiered then
                bedwars.BedwarsShopController.alreadyPurchasedMap[itemType] = true
            end
        end)
    end
    
    local function startClicking(itemType)
        if clickThread then
            task.cancel(clickThread)
        end
        clickThread = task.spawn(function()
            repeat
                local shopId = bedwars.AppController:isAppOpen('BedwarsItemShopApp') and store.shopLoaded and getShopId()
                if shopId then
                    purchase(itemType, shopId)
                end
                task.wait(1 / CPS.Value)
            until not holding
            clickThread = nil
        end)
    end
    
    ShopQuickBuy = vape.Categories.Combat:CreateModule({
        Name = 'Shop Clicker',
        Function = function(callback)
            if callback then
                ShopQuickBuy:Clean(inputService.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                    if not bedwars.AppController:isAppOpen('BedwarsItemShopApp') then return end
    
                    local itemType = getHoveredItem()
                    if not itemType then return end
    
                    holding = true
                    task.delay(HoldDelay.Value, function()
                        if holding and getHoveredItem() == itemType then
                            startClicking(itemType)
                        end
                    end)
                end))
    
                ShopQuickBuy:Clean(inputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding = false
                    end
                end))
            else
                holding = false
                if clickThread then
                    task.cancel(clickThread)
                    clickThread = nil
                end
            end
        end,
        Tooltip = 'Hold on a shop item to rapidly buy it.'
    })
    HoldDelay = ShopQuickBuy:CreateSlider({
        Name = 'Hold Delay',
        Min = 0,
        Max = 1,
        Default = 0.15,
        Decimal = 20,
        Suffix = 'seconds'
    })
    CPS = ShopQuickBuy:CreateSlider({
        Name = 'CPS',
        Min = 1,
        Max = 20,
        Default = 20,
        Darker = true
    })
end)

run(function()
	local DisableMatchDraft
	DisableMatchDraft = vape.Categories.Render:CreateModule({
		Name = 'Disable Match Draft',
		Function = function(callback)
			-- pcallを使用して、PlayerGuiやMatchDraftAppが見つからない場合のエラーを防ぐ
			pcall(function()
				local playerGui = lplr:FindFirstChild('PlayerGui')
				if playerGui then
					local draftApp = playerGui:FindFirstChild('MatchDraftApp')
					if draftApp then
						-- callbackがtrueなら非表示(false)、falseなら表示(true)に設定
						draftApp.Enabled = not callback
					end
				end
			end)
		end,
		Tooltip = 'Hides the Match Draft UI (Kit selection screen)'
	})
end)

run(function()
    local AntiHit
    local Height
    local AirTime
    local GroundTime
    local OnlyTargeting
    local TargetRange

    -- 地面検出用Raycast設定
    local groundRay = RaycastParams.new()
    groundRay.RespectCanCollide = true

    -- カメラ補正が有効か（実際にテレポート中のみtrue）
    local antiHitActive = false
    -- BindToRenderStep用ユニーク名
    local camBindName = 'AntiHitCamFix'

    -------------------------------------------------------
    -- 近くに敵がいるかチェック
    -------------------------------------------------------
    local function isEnemyNearby()
        if not OnlyTargeting.Enabled then
            return true
        end
        local ent = entitylib.EntityPosition({
            Range = TargetRange.Value,
            Part = 'RootPart',
            Players = true,
            NPCs = false,
            Wallcheck = true,
        })
        return ent ~= nil
    end

    -------------------------------------------------------
    -- 頭上にブロックがないか（窒息 = SUFFOCATE 防止）
    -------------------------------------------------------
    local function isHeadClear(pos, root)
        local hip = entitylib.character.HipHeight or 2
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {lplr.Character, gameCamera}
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.RespectCanCollide = true
        params.CollisionGroup = root.CollisionGroup
        local origin = pos + Vector3.new(0, root.Size.Y / 2, 0)
        local hit = workspace:Raycast(origin, Vector3.new(0, hip * 2 + 1, 0), params)
        return hit == nil
    end

    -------------------------------------------------------
    -- 全身がブロックにめり込んでいないか（上空テレポート用）
    -------------------------------------------------------
    local function isBodyClear(pos, root)
        local hip = entitylib.character.HipHeight or 2
        local size = root.Size + Vector3.new(0.5, hip * 2, 0.5)
        local overlap = OverlapParams.new()
        overlap.FilterDescendantsInstances = {lplr.Character, gameCamera}
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        overlap.RespectCanCollide = true
        return #workspace:GetPartBoundsInBox(CFrame.new(pos), size, overlap) == 0
    end

    -------------------------------------------------------
    -- カメラ補正（向きはそのまま / 位置Yだけ地面に固定）
    -- CameraSubjectは変えないのでマウス視点は壊れない
    -------------------------------------------------------
    local function bindCameraFix()
        runService:BindToRenderStep(
            camBindName,
            Enum.RenderPriority.Camera.Value + 5, -- カメラ更新の“直後”に実行
            function()
                -- 実際にテレポート中以外は補正しない（＝通常カメラのまま）
                if not antiHitActive or not entitylib.isAlive then
                    return
                end

                local root = entitylib.character.RootPart

                -- 地面のYを取得
                groundRay.FilterDescendantsInstances = {lplr.Character, gameCamera}
                groundRay.CollisionGroup = root.CollisionGroup
                local ray = workspace:Raycast(
                    root.Position + Vector3.new(0, 2, 0),
                    Vector3.new(0, -500, 0),
                    groundRay
                )
                if not ray then
                    return -- 奈落（地面なし）なら補正しない
                end

                local groundY = ray.Position.Y + (entitylib.character.HipHeight or 2)
                -- 注視点を“地面レベルの頭の高さ”に固定
                local focus = Vector3.new(root.Position.X, groundY + 1, root.Position.Z)

                -- 現在のカメラの“向き”をそのまま保持
                local cf = gameCamera.CFrame
                local look = cf.LookVector

                -- 現在のズーム距離（1人称時は小さくなるのでガード）
                local dist = (gameCamera.Focus.Position - cf.Position).Magnitude
                if not (dist == dist) or dist < 0.1 then
                    dist = 0.5
                end

                -- 向きは変えず、位置だけ「地面注視点 - 向き*距離」に移動
                local newPos = focus - look * dist
                gameCamera.CFrame = CFrame.fromMatrix(newPos, cf.RightVector, cf.UpVector)
            end
        )
    end

    -------------------------------------------------------
    -- モジュール本体
    -------------------------------------------------------
    AntiHit = vape.Categories.Blatant:CreateModule({
        Name = 'AntiHit',
        Function = function(callback)
            if callback then
                antiHitActive = false

                -- カメラ補正を登録（CameraSubjectは一切触らない）
                bindCameraFix()
                AntiHit:Clean(function()
                    pcall(function()
                        runService:UnbindFromRenderStep(camBindName)
                    end)
                    antiHitActive = false
                end)

                -- メインループ
                task.spawn(function()
                    while AntiHit.Enabled do
                        local root = entitylib.character and entitylib.character.RootPart
                        local alive = entitylib.isAlive
                        local owner = root and isnetworkowner(root)

                        -- 生存 / 所有チェック
                        if not alive or not owner then
                            antiHitActive = false
                            task.wait(0.1)
                            continue
                        end

                        -- OnlyTargeting: 敵が近くにいないならスキップ（カメラも通常）
                        if not isEnemyNearby() then
                            antiHitActive = false
                            task.wait(0.1)
                            continue
                        end

                        -- ここからテレポート開始 → カメラ補正ON
                        antiHitActive = true

                        local hip = entitylib.character.HipHeight or 2

                        -- ① 高く飛ぶ（天井＆めり込みチェック付き）
                        local skyY = Height.Value
                        local upParams = RaycastParams.new()
                        upParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
                        upParams.FilterType = Enum.RaycastFilterType.Exclude
                        upParams.RespectCanCollide = true
                        upParams.CollisionGroup = root.CollisionGroup
                        local upRay = workspace:Raycast(
                            root.Position + Vector3.new(0, 2, 0),
                            Vector3.new(0, math.max(skyY - root.Position.Y, 1), 0),
                            upParams
                        )
                        if upRay then
                            skyY = upRay.Position.Y - (hip + 2)
                            if skyY < root.Position.Y + 3 then
                                skyY = root.Position.Y + 3
                            end
                        end
                        local skyPos = Vector3.new(root.Position.X, skyY, root.Position.Z)
                        if isBodyClear(skyPos, root) then
                            root.CFrame = CFrame.new(skyPos)
                            root.AssemblyLinearVelocity = Vector3.new(
                                root.AssemblyLinearVelocity.X, 0,
                                root.AssemblyLinearVelocity.Z
                            )
                        end

                        -- ② 上空で待機
                        task.wait(AirTime.Value)

                        -- ③ 地面に戻る（奈落＆窒息チェック付き）
                        if entitylib.isAlive and AntiHit.Enabled then
                            local ray2 = workspace:Raycast(
                                root.Position + Vector3.new(0, 2, 0),
                                Vector3.new(0, -500, 0),
                                groundRay
                            )
                            if ray2 then
                                local returnY = ray2.Position.Y + hip
                                local returnPos = Vector3.new(
                                    root.Position.X, returnY, root.Position.Z
                                )
                                if isHeadClear(returnPos, root) then
                                    root.CFrame = CFrame.new(returnPos)
                                    root.AssemblyLinearVelocity = Vector3.new(
                                        root.AssemblyLinearVelocity.X, 0,
                                        root.AssemblyLinearVelocity.Z
                                    )
                                end
                            end
                            -- 頭上にブロック/奈落なら戻らず上空に留まる
                        end

                        -- ④ 地面で少し待機 → ①に戻る
                        task.wait(GroundTime.Value)
                    end

                    antiHitActive = false
                end)
            else
                -- 無効化時
                pcall(function()
                    runService:UnbindFromRenderStep(camBindName)
                end)
                antiHitActive = false
            end
        end,
        Tooltip = 'Dodges attacks by bouncing sky/ground. Camera stays normal (mouse aim intact); no suffocation/void.'
    })

    -------------------------------------------------------
    -- オプション
    -------------------------------------------------------
    Height = AntiHit:CreateSlider({
        Name = 'Height',
        Min = 50,
        Max = 500,
        Default = 80,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })

    AirTime = AntiHit:CreateSlider({
        Name = 'Air Time',
        Min = 0.1,
        Max = 3,
        Default = 0.7,
        Decimal = 10,
        Suffix = 'seconds'
    })

    GroundTime = AntiHit:CreateSlider({
        Name = 'Ground Time',
        Min = 0,
        Max = 1,
        Default = 0.1,
        Decimal = 100,
        Suffix = 'seconds'
    })

    OnlyTargeting = AntiHit:CreateToggle({
        Name = 'Only Targeting',
        Default = false,
        Tooltip = 'Only activates when an enemy is nearby',
        Function = function(callback)
            if TargetRange and TargetRange.Object then
                TargetRange.Object.Visible = callback
            end
        end
    })

    TargetRange = AntiHit:CreateSlider({
        Name = 'Target Range',
        Min = 5,
        Max = 50,
        Default = 30,
        Darker = true,
        Visible = false,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })
end)

run(function()
    local AutoKaida
    local Targets
    local SwingRange
    local AttackRange
    local Sort
    local Limit
    local Swing
    local Mouse
    local GUI
    local Perfect
    local Distance
    
    local function getAttackData()
        local claw = (Limit.Enabled and store.hand.tool and store.hand) or not Limit.Enabled and getItem('summoner_claw', nil, true)
        if claw and claw.tool.Name:find('summoner_claw') then
            if Mouse.Enabled and not inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                return false
            end
            if GUI.Enabled and bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
                return false
            end
            return claw
        end
        return false
    end
    
    AutoKaida = vape.Categories.Blatant:CreateModule({
        Name = 'Auto Kaida',
        Function = function(callback)
            if callback then
                repeat
                    if entitylib.isAlive and (workspace:GetServerTimeNow() - bedwars.SummonerClawHandController.lastAttackTime) > bedwars.SummonerKitBalance.CLAW_COOLDOWN then
                        local claw = getAttackData()
                        if claw then
                            local ent = entitylib.EntityPosition({
                                Range = SwingRange.Value,
                                Wallcheck = Targets.Walls.Enabled or nil,
                                Part = 'RootPart',
                                Players = Targets.Players.Enabled,
                                NPCs = Targets.NPCs.Enabled,
                                Sort = sortmethods[Sort.Value]
                            })
                            if ent then
                                local selfpos = entitylib.character.RootPart.Position
                                local dir = CFrame.lookAt(selfpos, ent.RootPart.Position).LookVector
                                local delta = (ent.RootPart.Position - selfpos)
    
                                if Perfect.Enabled and (selfpos - ent.RootPart.Position).Magnitude <= Distance.Value then
                                    if bedwars.AbilityController:canUseAbility('summoner_start_charging') and bedwars.AbilityController:canUseAbility('summoner_finish_charging') then
                                        bedwars.AbilityController:useAbility('summoner_start_charging')
                                        task.wait(0.5)
                                        bedwars.AbilityController:useAbility('summoner_finish_charging')
                                        if not Swing.Enabled then
                                            continue
                                        end
                                    end
                                end
    
                                if not Swing.Enabled then
                                    local active = false
                                    for _, v in workspace:QueryDescendants('#Summoner_SummonCircle') do
                                        local pivot = v:FindFirstChild('Pivot')
                                        if pivot and math.floor(pivot.Position.X) == math.floor(entitylib.character.RootPart.Position.X) and math.floor(pivot.Position.Z) == math.floor(entitylib.character.RootPart.Position.Z) then
                                            active = true
                                            break
                                        end
                                    end
                                    if active then
                                        task.wait()
                                        continue
                                    end
                                end
    
                                if (selfpos - ent.RootPart.Position).Magnitude <= AttackRange.Value then
                                    bedwars.Client:Get('SummonerClawAttackRequest'):SendToServer({
                                        position = selfpos + dir * math.max(delta.Magnitude - 16.399, 0),
                                        direction = dir,
                                        clientTime = workspace:GetServerTimeNow()
                                    })
                                end
                                bedwars.SummonerClawHandController.lastAttackTime = workspace:GetServerTimeNow()
                                bedwars.SummonerClawController:clawAttack(lplr, selfpos, dir, claw.tool.Name)
                            end
                        end
                    end
                    task.wait(0.1)
                until not AutoKaida.Enabled
            end
        end
    })
    
    Targets = AutoKaida:CreateTargets({Players = true})
    SwingRange = AutoKaida:CreateSlider({
        Name = 'Swing Range',
        Min = 1,
        Max = 32,
        Default = 32,
        Suffix = function(val)
            return val <= 1 and 'stud' or 'studs'
        end
    })
    AttackRange = AutoKaida:CreateSlider({
        Name = 'Attack Range',
        Min = 1,
        Max = 32,
        Default = 32,
        Suffix = function(val)
            return val <= 1 and 'stud' or 'studs'
        end
    })
    local methods = {'Damage', 'Distance'}
    for i in sortmethods do
        if not table.find(methods, i) then
            table.insert(methods, i)
        end
    end
    Sort = AutoKaida:CreateDropdown({
        Name = 'Target mode',
        List = methods,
        Default = methods[2]
    })
    Mouse = AutoKaida:CreateToggle({Name = 'Require mouse down'})
    GUI = AutoKaida:CreateToggle({Name = 'GUI check'})
    Swing = AutoKaida:CreateToggle({
        Name = 'Swing during ability',
        Default = true,
        Tooltip = 'Continue claw attacks while charging ability'
    })
    Limit = AutoKaida:CreateToggle({Name = 'Limit to items'})
    Perfect = AutoKaida:CreateToggle({
        Name = 'Perfect ability',
        Function = function(callback)
            pcall(function()
                Distance.Object.Visible = callback
            end)
        end
    })
    Distance = AutoKaida:CreateSlider({
        Name = 'Distance',
    	Min = 3,
    	Max = 15,
    	Default = 6,
    	Visible = false,
    	Suffix = function(val)
    		return val <= 1 and 'stud' or 'studs'
    	end,
        Darker = true
    })
end)

run(function()
    local LagBackCT
    local SizeOpt
    local HeightOpt
    local ShowGauge

    local MAX_AIR_TIME = 2.5 -- 空中2.5秒でラグバック
    local DANGER_TIME  = 0.5 -- この秒数を切ったら危険表示(パルス)

    -- 残り秒数 → 色 (緑:安全 … 赤:危険)
    local function timerColor(remaining)
        local ratio = math.clamp(remaining / MAX_AIR_TIME, 0, 1)
        return Color3.fromHSV(ratio * 0.33, 0.85, 1)
    end

    LagBackCT = vape.Categories.Render:CreateModule({
        Name = 'LagBackCT',
        Function = function(callback)
            if not callback then return end

            -- ========== UI 生成 ==========
            local label = Instance.new('TextLabel')
            label.Name = 'LagBackCTLabel'
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.BackgroundTransparency = 1
            label.Text = ''
            label.Font = Enum.Font.ArialBold
            label.Parent = vape.gui
            LagBackCT:Clean(label)

            local gauge = Instance.new('Frame')
            gauge.Name = 'LagBackCTGauge'
            gauge.AnchorPoint = Vector2.new(0.5, 0) -- 中心基準
            gauge.BackgroundColor3 = Color3.new()
            gauge.BackgroundTransparency = 0.5
            gauge.BorderSizePixel = 0
            gauge.Parent = vape.gui
            LagBackCT:Clean(gauge)

            local gaugeCorner = Instance.new('UICorner')
            gaugeCorner.CornerRadius = UDim.new(0, 0)
            gaugeCorner.Parent = gauge

            local fill = Instance.new('Frame')
            fill.Name = 'Fill'
            fill.Size = UDim2.fromScale(0, 1)
            fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            fill.BorderSizePixel = 0
            fill.Parent = gauge

            local fillCorner = gaugeCorner:Clone()
            fillCorner.Parent = fill

            -- ========== 状態 ==========
            local airStart = nil -- 空中に入った瞬間のtick (地面にいる間はnil)

            -- ========== 毎フレーム更新 ==========
            LagBackCT:Clean(runService.RenderStepped:Connect(function()
                local size    = SizeOpt.Value
                local yOffset = HeightOpt.Value -- 負 = 上 / 正 = 下

                -- レイアウト (label も gauge も X は 0.5 + offset 0 → 中央揃え)
                label.Position = UDim2.new(0.5, 0, 0.5, yOffset)

                local gaugeWidth = size * 4
                gauge.Size = UDim2.fromOffset(gaugeWidth, math.max(3, size / 8))
                gauge.Position = UDim2.new(0.5, 0, 0.5, yOffset + size * 0.75)
                gauge.Visible = ShowGauge.Enabled

                -- 死亡中 / 地面にいる間はリセットして非表示
                if not entitylib.isAlive or entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                    airStart = nil
                    label.Text = ''
                    fill.Size = UDim2.fromScale(0, 1)
                    return
                end

                -- 空中ならタイマー開始
                airStart = airStart or tick()
                local remaining = math.max(MAX_AIR_TIME - (tick() - airStart), 0)
                local col = timerColor(remaining)

                -- 危険域で小さくパルス
                local pulse = 1
                if remaining <= DANGER_TIME then
                    pulse = 1 + math.sin(tick() * 14) * 0.05
                end

                label.Text = string.format('%.1f', remaining)
                label.TextSize = size * pulse
                label.TextColor3 = col

                fill.Size = UDim2.fromScale(remaining / MAX_AIR_TIME, 1)
                fill.BackgroundColor3 = col
            end))
        end,
        Tooltip = 'Displays a lagback countdown timer while airborne.'
    })

    -- ========== オプション ==========
    SizeOpt = LagBackCT:CreateSlider({
        Name = 'Size',
        Min = 12,
        Max = 75,
        Default = 48,
        Tooltip = 'Text size of the countdown'
    })

    HeightOpt = LagBackCT:CreateSlider({
        Name = 'Height',
        Min = -300,
        Max = 300,
        Default = -175,
        Suffix = 'px',
        Tooltip = 'Vertical offset from screen center (negative = up, positive = down)'
    })

    ShowGauge = LagBackCT:CreateToggle({
        Name = 'Show Gauge',
        Default = true,
        Tooltip = 'Shows the depletion bar under the timer'
    })
end)

run(function()
    local DisableKrystalGui
    local TARGETS = {'ActionBarScreenGui', 'StatusEffectHudScreen'}
    local watchConnection

    -- 安全に Enabled を書き換える (未取得 / 型違い / 破棄済みでもエラーを出さない)
    local function setEnabled(gui, state)
        if not gui or not gui:IsA('ScreenGui') then return end
        pcall(function()
            gui.Enabled = state
        end)
    end

    -- PlayerGui 配下の対象をまとめて state にする
    local function applyAll(state)
        local playerGui = lplr:FindFirstChild('PlayerGui')
        if not playerGui then return end
        for _, name in TARGETS do
            setEnabled(playerGui:FindFirstChild(name), state)
        end
    end

    -- 後から (再) 生成された GUI も確実に消す
    local function handleChild(child)
        if not table.find(TARGETS, child.Name) then return end
        setEnabled(child, false)
        -- ゲーム側が遅延で Enabled を true に戻すケースへの保険
        task.delay(0.15, function()
            if DisableKrystalGui.Enabled then
                setEnabled(child, false)
            end
        end)
    end

    DisableKrystalGui = vape.Categories.Render:CreateModule({
        Name = 'DisableKrystalGui',
        Function = function(callback)
            if callback then
                applyAll(false)
                local playerGui = lplr:FindFirstChild('PlayerGui')
                if playerGui then
                    watchConnection = playerGui.ChildAdded:Connect(handleChild)
                    DisableKrystalGui:Clean(watchConnection)
                end
            else
                if watchConnection then
                    pcall(function() watchConnection:Disconnect() end)
                    watchConnection = nil
                end
                applyAll(true)
            end
        end,
        Tooltip = 'Hides the ActionBar and StatusEffect HUD (Krystal UI).'
    })
end)