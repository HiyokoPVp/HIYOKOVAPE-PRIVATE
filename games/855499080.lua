--[[
    SkywarsProjAim (Fixed & Optimized + Mouse FOV + WallCheck + Target Part)
    SilentAura (BoxHandleAdornment Visualization + Fixed MaxAngle)
]]
local run = function(func)
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
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction

local function notif(...)
	return vape:CreateNotification(...)
end

for _, v in {'AntiRagdoll', 'TriggerBot', 'SilentAim', 'AutoRejoin', 'Rejoin', 'Disabler', 'Timer', 'ServerHop', 'MouseTP', 'MurderMystery'} do
	vape:Remove(v)
end

local function getRaycastFilterType()
	local ok, value = pcall(function()
		return Enum.RaycastFilterType.Exclude
	end)

	if ok then
		return value
	end

	ok, value = pcall(function()
		return Enum.RaycastFilterType.Blacklist
	end)

	if ok then
		return value
	end

	return nil
end

local function buildWallCheckParams()
	local params = RaycastParams.new()

	local filterType = getRaycastFilterType()
	if filterType then
		params.FilterType = filterType
	end

	-- プレイヤーキャラは全部除外して、壁だけ判定しやすくする
	local filter = {}
	for _, player in ipairs(playersService:GetPlayers()) do
		if player.Character then
			table.insert(filter, player.Character)
		end
	end

	params.FilterDescendantsInstances = filter
	params.IgnoreWater = true

	pcall(function()
		params.RespectCanCollide = false
	end)

	return params
end

local function isPositionVisible(originPosition, targetPosition, params)
	local direction = targetPosition - originPosition
	local distance = direction.Magnitude

	if distance < 0.001 then
		return true
	end

	local ok, result = pcall(function()
		return workspace:Raycast(originPosition, direction, params)
	end)

	if not ok then
		return true
	end

	-- 何も当たらなければ見える扱い
	if not result then
		return true
	end

	-- 目標より手前に何かが当たっているなら壁越し扱い
	return result.Distance >= distance - 0.5
end

local function getTargetPartFromCharacter(character, partName)
	if not character then
		return nil
	end

	if partName == 'HumanoidRootPart' then
		return character:FindFirstChild('HumanoidRootPart') or character:FindFirstChild('Head')
	elseif partName == 'Torso' then
		return character:FindFirstChild('UpperTorso')
			or character:FindFirstChild('Torso')
			or character:FindFirstChild('LowerTorso')
			or character:FindFirstChild('HumanoidRootPart')
			or character:FindFirstChild('Head')
	elseif partName == 'Random' then
		local parts = {}

		local head = character:FindFirstChild('Head')
		local hrp = character:FindFirstChild('HumanoidRootPart')
		local torso = character:FindFirstChild('UpperTorso')
			or character:FindFirstChild('Torso')
			or character:FindFirstChild('LowerTorso')

		if head then
			table.insert(parts, head)
		end
		if hrp then
			table.insert(parts, hrp)
		end
		if torso then
			table.insert(parts, torso)
		end

		if #parts > 0 then
			return parts[math.random(1, #parts)]
		end

		return character:FindFirstChild('Head')
	else
		-- Default: Head
		return character:FindFirstChild('Head') or character:FindFirstChild('HumanoidRootPart')
	end
end

-- 最適なターゲット部位を取得
-- Mouseモード: 画面カーソル基準でFOV内から選ぶ
-- Positionモード: 3D距離で選ぶ
local function getBestTargetPart(options)
	options = options or {}

	if not lplr then
		return nil
	end

	local character = lplr.Character
	if not character then
		return nil
	end

	local myRoot = character:FindFirstChild("HumanoidRootPart")
	if not myRoot then
		return nil
	end

	local camera = workspace.CurrentCamera
	local mouseLocation = inputService:GetMouseLocation()

	local wallParams = nil
	local originPosition = nil

	if options.WallCheck then
		if options.WallCheckOrigin == 'Camera' and camera then
			originPosition = camera.CFrame.Position
		else
			local originPart = character:FindFirstChild("Head") or myRoot
			originPosition = originPart.Position
		end

		wallParams = buildWallCheckParams()
	end

	local bestPart = nil
	local bestScore = math.huge

	for _, player in ipairs(playersService:GetPlayers()) do
		if player ~= lplr and player.Character then
			local enemyChar = player.Character
			local enemyHumanoid = enemyChar:FindFirstChildOfClass("Humanoid")

			if enemyHumanoid and enemyHumanoid.Health > 0 then
				local targetPart = getTargetPartFromCharacter(enemyChar, options.TargetPart or 'Head')

				if targetPart then
					local position = targetPart.Position
					local distance = (myRoot.Position - position).Magnitude

					-- Range制限
					if not options.Range or options.Range <= 0 or distance <= options.Range then
						if options.Mode == 'Mouse' then
							if camera then
								local screenPos = camera:WorldToViewportPoint(position)

								if screenPos and screenPos.Z > 0 then
									local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
									local fov = options.FOV or math.huge

									-- まずFOV内かで絞って、その後WallCheckする
									if screenDistance <= fov and screenDistance < bestScore then
										local passesWallCheck = true

										if options.WallCheck and wallParams and originPosition then
											passesWallCheck = isPositionVisible(originPosition, position, wallParams)
										end

										if passesWallCheck then
											bestScore = screenDistance
											bestPart = targetPart
										end
									end
								end
							end
						else
							-- Positionモードは近い順
							if distance < bestScore then
								local passesWallCheck = true

								if options.WallCheck and wallParams and originPosition then
									passesWallCheck = isPositionVisible(originPosition, position, wallParams)
								end

								if passesWallCheck then
									bestScore = distance
									bestPart = targetPart
								end
							end
						end
					end
				end
			end
		end
	end

	return bestPart
end

run(function()
	local SkywarsProjAim
	local Targets
	local Mode
	local Range
	local FOV
	local TargetPart
	local WallCheck
	local WallCheckOrigin
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local ShowTarget
	local DebugMode
	local debugMode = false

	local function dbg(msg)
		if debugMode then
			print('[SkywarsProjAim] ' .. tostring(msg))
		end
	end

	local function updateCircleForMode()
		if not SkywarsProjAim or not Mode then
			return
		end

		if CircleObject then
			pcall(function()
				CircleObject.Visible = SkywarsProjAim.Enabled and Mode.Value == 'Mouse'

				if Mode.Value == 'Mouse' and FOV then
					CircleObject.Radius = FOV.Value
				end
			end)
		end
	end

	SkywarsProjAim = vape.Categories.Combat:CreateModule({
		Name = 'SkywarsProjectileAimbot',
		Function = function(callback)
			updateCircleForMode()

			if callback then
				debugMode = DebugMode and DebugMode.Enabled or false
				dbg('Module ENABLED')

				-- フックおよび動作スレッド
				SkywarsProjAim:Clean(task.spawn(function()
					local lastTool = nil
					local hookedFunction = nil

					while SkywarsProjAim.Enabled do
						local character = lplr.Character
						if character then
							local tool = character:FindFirstChild("Bow") or character:FindFirstChildOfClass("Tool")
							
							-- ツールが変わった場合、または新しいツールが見つかった場合にフック処理を行う
							if tool and tool ~= lastTool then
								lastTool = tool
								local clientControl = tool:FindFirstChild("ClientControl")
								
								if clientControl and clientControl:IsA("RemoteFunction") then
									-- 既存のフック関数を定義
									hookedFunction = function(...)
										if not SkywarsProjAim.Enabled then
											return Vector3.new(0, 0, 0)
										end

										dbg('OnClientInvoke triggered!')

										local targetPart = getBestTargetPart({
											Mode = Mode and Mode.Value or 'Mouse',
											Range = Range and Range.Value or 0,
											FOV = FOV and FOV.Value or math.huge,
											TargetPart = TargetPart and TargetPart.Value or 'Head',
											WallCheck = WallCheck and WallCheck.Enabled or false,
											WallCheckOrigin = WallCheckOrigin and WallCheckOrigin.Value or 'Character',
										})

										if targetPart then
											dbg(
												'Target locked: '
												.. tostring(targetPart.Parent and targetPart.Parent.Name)
												.. ' / Part: '
												.. tostring(targetPart.Name)
												.. ' at '
												.. tostring(targetPart.Position)
											)
											return targetPart.Position
										end

										return Vector3.new(0, 0, 0)
									end

									-- OnClientInvokeを直接上書き
									clientControl.OnClientInvoke = hookedFunction
									dbg('ClientControl successfully hooked for tool: ' .. tool.Name)

									if debugMode then
										notif('SkywarsProjAim', 'Hooked Bow: ' .. tool.Name, 3)
									end
								end
							end

							-- 既にフック済みのツールの場合、他スクリプトによる上書きを検知して復元
							if lastTool and hookedFunction then
								local clientControl = lastTool:FindFirstChild("ClientControl")
								if clientControl then
									pcall(function()
										if clientControl.OnClientInvoke ~= hookedFunction then
											clientControl.OnClientInvoke = hookedFunction
										end
									end)
								end
							end
						else
							-- キャラクターがない場合はリセット
							lastTool = nil
							hookedFunction = nil
						end
						
						task.wait(0.1) -- チェック頻度を上げて反応速度を向上
					end
					
					-- ループ終了時（モジュールオフ時）にフックを解除
					if lastTool then
						local clientControl = lastTool:FindFirstChild("ClientControl")
						if clientControl then
							pcall(function()
								-- 元の関数に戻すことは難しいため、nilまたは空の関数にすることで無効化
								-- ただし、Robloxの仕様上、OnClientInvokeをnilにするとエラーになる場合があるため
								-- モジュールがオフであることを示すダミー関数を残すか、そのままにする
								-- ここでは安全のため、オフ時は0ベクトルを返す関数にしておく
								clientControl.OnClientInvoke = function() return Vector3.new(0,0,0) end
							end)
						end
					end
				end))

				-- FOV Circle更新ループ
				SkywarsProjAim:Clean(runService.RenderStepped:Connect(function()
					if CircleObject then
						pcall(function()
							CircleObject.Position = inputService:GetMouseLocation()
						end)
					end
				end))
			else
				dbg('Module DISABLED')
				debugMode = false
			end
		end,
		ExtraText = function()
			local modeText = Mode and Mode.Value or ''
			local partText = TargetPart and TargetPart.Value or ''

			local text = modeText
			if partText ~= '' then
				text = text .. ' / ' .. partText
			end

			if WallCheck and WallCheck.Enabled then
				text = text .. ' / Wall'
			end

			return text
		end,
		Tooltip = 'Automatically aims projectiles by hooking ClientControl.OnClientInvoke directly. Mouse mode uses FOV, optional WallCheck and target part.'
	})

	Mode = SkywarsProjAim:CreateDropdown({
		Name = 'Mode',
		List = {'Mouse', 'Position'},
		Function = function(val)
			local isMouse = val == 'Mouse'

			if FOV and FOV.Object then
				pcall(function()
					FOV.Object.Visible = isMouse
				end)
			end

			updateCircleForMode()
		end
	})

	Range = SkywarsProjAim:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 500,
		Default = 150,
		Function = function(val)
			-- Rangeは3D距離制限として使用
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end,
		Tooltip = 'Maximum 3D distance for target selection.'
	})

	FOV = SkywarsProjAim:CreateSlider({
		Name = 'FOV',
		Min = 1,
		Max = 1000,
		Default = 150,
		Function = function(val)
			if CircleObject and Mode and Mode.Value == 'Mouse' then
				pcall(function()
					CircleObject.Radius = val
				end)
			end
		end,
		Suffix = function(val)
			return 'px'
		end,
		Tooltip = 'Mouse mode only: only targets inside this screen FOV circle are selected.',
		Visible = Mode.Value == 'Mouse'
	})

	TargetPart = SkywarsProjAim:CreateDropdown({
		Name = 'Target Part',
		List = {'Head', 'HumanoidRootPart', 'Torso', 'Random'},
		Function = function(val)
			-- 次回のOnClientInvokeから反映される
		end,
		Tooltip = 'Part to aim at. Torso supports UpperTorso / Torso / LowerTorso.'
	})

	WallCheck = SkywarsProjAim:CreateToggle({
		Name = 'Wall Check',
		Function = function(callback)
			if WallCheckOrigin and WallCheckOrigin.Object then
				pcall(function()
					WallCheckOrigin.Object.Visible = callback
				end)
			end
		end,
		Tooltip = 'Only aim at targets visible by raycast.'
	})

	WallCheckOrigin = SkywarsProjAim:CreateDropdown({
		Name = 'Wall Check Origin',
		List = {'Character', 'Camera'},
		Function = function(val)
			-- 次回のOnClientInvokeから反映される
		end,
		Tooltip = 'Raycast origin for wall check. Camera can be less strict, Character is more stable.',
		Visible = false
	})

	ShowTarget = SkywarsProjAim:CreateToggle({
		Name = 'Show target info'
	})

	DebugMode = SkywarsProjAim:CreateToggle({
		Name = 'Debug Mode',
		Function = function(callback)
			debugMode = callback
		end,
		Tooltip = 'Prints debug logs to console'
	})

	-- FOV Circle
	SkywarsProjAim:CreateToggle({
		Name = 'FOV Circle',
		Function = function(callback)
			if callback then
				CircleObject = Drawing.new('Circle')
				CircleObject.Filled = CircleFilled and CircleFilled.Enabled or false
				CircleObject.Color = CircleColor and Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value) or Color3.new(1, 1, 1)
				CircleObject.Position = inputService:GetMouseLocation()
				CircleObject.Radius = FOV and FOV.Value or 150
				CircleObject.NumSides = 100
				CircleObject.Transparency = CircleTransparency and (1 - CircleTransparency.Value) or 0.5
				CircleObject.Visible = SkywarsProjAim.Enabled and Mode.Value == 'Mouse'
			else
				pcall(function()
					CircleObject.Visible = false
					CircleObject:Remove()
				end)
				CircleObject = nil
			end

			if CircleColor and CircleColor.Object then
				pcall(function()
					CircleColor.Object.Visible = callback
				end)
			end
			if CircleTransparency and CircleTransparency.Object then
				pcall(function()
					CircleTransparency.Object.Visible = callback
				end)
			end
			if CircleFilled and CircleFilled.Object then
				pcall(function()
					CircleFilled.Object.Visible = callback
				end)
			end
		end
	})

	CircleColor = SkywarsProjAim:CreateColorSlider({
		Name = 'Circle Color',
		Function = function(hue, sat, val)
			if CircleObject then
				pcall(function()
					CircleObject.Color = Color3.fromHSV(hue, sat, val)
				end)
			end
		end,
		Darker = true,
		Visible = false
	})

	CircleTransparency = SkywarsProjAim:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Decimal = 10,
		Default = 0.5,
		Function = function(val)
			if CircleObject then
				pcall(function()
					CircleObject.Transparency = 1 - val
				end)
			end
		end,
		Darker = true,
		Visible = false
	})

	CircleFilled = SkywarsProjAim:CreateToggle({
		Name = 'Circle Filled',
		Function = function(callback)
			if CircleObject then
				pcall(function()
					CircleObject.Filled = callback
				end)
			end
		end,
		Darker = true,
		Visible = false
	})
end)


run(function()
	local SilentAura
	local Speed
	local MaxAngle
	local Range
	local LimitedItem
	local WallCheck
	local IgnorePlayer
	local ShowTarget

	local targetBox = nil

	local function contains(text, sub)
		return tostring(text):lower():find(tostring(sub):lower(), 1, true) ~= nil
	end

	local function isAllowedItem(limit)
		if not limit or limit == 'Off' then
			return true
		end

		if not lplr then
			return false
		end

		local character = lplr.Character
		if not character then
			return false
		end

		local tool = character:FindFirstChildOfClass('Tool')
		if not tool then
			return false
		end

		if limit == 'Any Tool' then
			return true
		end

		local name = tool.Name

		if limit == 'Sword' then
			return contains(name, 'sword')
				or contains(name, 'blade')
				or contains(name, 'katana')
				or contains(name, 'dagger')
				or contains(name, 'knife')
		elseif limit == 'Bow' then
			return contains(name, 'bow')
		elseif limit == 'Axe' then
			return contains(name, 'axe')
		elseif limit == 'Pickaxe' then
			return contains(name, 'pick')
		end

		return true
	end

	local function getRaycastFilterType()
		local ok, value = pcall(function()
			return Enum.RaycastFilterType.Exclude
		end)

		if ok then
			return value
		end

		ok, value = pcall(function()
			return Enum.RaycastFilterType.Blacklist
		end)

		if ok then
			return value
		end

		return nil
	end

	local function buildWallCheckParams(ignorePlayers)
		local params = RaycastParams.new()

		local filterType = getRaycastFilterType()
		if filterType then
			params.FilterType = filterType
		end

		local filter = {}

		if ignorePlayers then
			for _, player in ipairs(playersService:GetPlayers()) do
				if player.Character then
					table.insert(filter, player.Character)
				end
			end
		else
			if lplr and lplr.Character then
				table.insert(filter, lplr.Character)
			end
		end

		params.FilterDescendantsInstances = filter
		params.IgnoreWater = true

		pcall(function()
			params.RespectCanCollide = false
		end)

		return params
	end

	local function isPositionVisible(originPosition, targetPosition, params)
		local direction = targetPosition - originPosition
		local distance = direction.Magnitude

		if distance < 0.001 then
			return true
		end

		local ok, result = pcall(function()
			return workspace:Raycast(originPosition, direction, params)
		end)

		if not ok then
			return true
		end

		if not result then
			return true
		end

		return result.Distance >= distance - 0.5
	end

	-- MaxAngleは合計角度
	-- 例: 120 -> 右60° / 左60°
	local function isWithinMaxAngle(root, targetPosition, maxAngle)
		-- 360度の場合は常にtrueを返す（全方向許可）
		if not maxAngle or maxAngle >= 360 then
			return true
		end

		local rootPos = root.Position
		local rootCFrame = root.CFrame

		-- Y軸を無視した水平方向のベクトルを計算
		local lookVector = Vector3.new(rootCFrame.LookVector.X, 0, rootCFrame.LookVector.Z)
		if lookVector.Magnitude < 0.001 then
			return true
		end
		lookVector = lookVector.Unit

		local toTarget = Vector3.new(targetPosition.X - rootPos.X, 0, targetPosition.Z - rootPos.Z)
		if toTarget.Magnitude < 0.001 then
			return true
		end
		toTarget = toTarget.Unit

		-- 内積を使って角度を計算
		local dotProduct = lookVector:Dot(toTarget)
		-- math.acosの結果はラジアンなので、degで度に変換
		local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))

		-- MaxAngleは「左右合計」の角度なので、半分ずつ許容する
		return angle <= (maxAngle / 2)
	end

	local function getSilentAuraTarget(options)
		options = options or {}

		if not lplr then
			return nil
		end

		local character = lplr.Character
		if not character then
			return nil
		end

		local myRoot = character:FindFirstChild('HumanoidRootPart')
		if not myRoot then
			return nil
		end

		local myHumanoid = character:FindFirstChildOfClass('Humanoid')
		if not myHumanoid or myHumanoid.Health <= 0 then
			return nil
		end

		if not isAllowedItem(options.LimitedItem) then
			return nil
		end

		local wallParams = nil
		local originPosition = nil

		if options.WallCheck then
			local originPart = character:FindFirstChild('Head') or myRoot
			originPosition = originPart.Position
			wallParams = buildWallCheckParams(options.IgnorePlayer)
		end

		local bestRoot = nil
		local bestDistance = math.huge

		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= lplr and player.Character then
				local enemyChar = player.Character
				local enemyHumanoid = enemyChar:FindFirstChildOfClass('Humanoid')
				local enemyRoot = enemyChar:FindFirstChild('HumanoidRootPart')

				if enemyHumanoid and enemyHumanoid.Health > 0 and enemyRoot then
					local distance = (myRoot.Position - enemyRoot.Position).Magnitude

					if distance <= options.Range then
						-- MaxAngleチェックを追加
						if isWithinMaxAngle(myRoot, enemyRoot.Position, options.MaxAngle) then
							local passesWallCheck = true

							if options.WallCheck and wallParams and originPosition then
								local checkPart = enemyChar:FindFirstChild('Head') or enemyRoot
								passesWallCheck = isPositionVisible(originPosition, checkPart.Position, wallParams)
							end

							if passesWallCheck and distance < bestDistance then
								bestDistance = distance
								bestRoot = enemyRoot
							end
						end
					end
				end
			end
		end

		return bestRoot
	end

	local function clearTargetBox()
		pcall(function()
			if targetBox then
				targetBox:Destroy()
			end
		end)
		targetBox = nil
	end

	local function updateTargetBox(targetRoot)
		local shouldShow = ShowTarget and ShowTarget.Enabled and targetRoot ~= nil

		if not shouldShow then
			clearTargetBox()
			return
		end

		-- ターゲットが変わった場合、またはボックスが存在しない場合は新規作成
		if not targetBox or targetBox.Adornee ~= targetRoot then
			clearTargetBox()
			
			pcall(function()
				targetBox = Instance.new('BoxHandleAdornment')
				targetBox.Name = 'SilentAuraTargetBox'
				targetBox.Size = Vector3.new(2, 2, 2) -- デフォルトサイズ、後で調整
				targetBox.Color3 = Color3.fromRGB(0, 255, 0)
				targetBox.Transparency = 0.5
				targetBox.AlwaysOnTop = true
				targetBox.Adornee = targetRoot
				targetBox.Parent = targetRoot
			end)
		end

		-- ボックスが存在し、正しいターゲットを指している場合、サイズを更新
		if targetBox then
			pcall(function()
				-- HumanoidRootPartのサイズに合わせてBoxを調整（通常は1x1x1程度だが、視認性のため少し大きくしてもよい）
				-- ここではRootPartそのもののSizeを取得して使用
				targetBox.Size = targetRoot.Size
				targetBox.Adornee = targetRoot
				targetBox.Visible = true
			end)
		end
	end

	SilentAura = vape.Categories.Combat:CreateModule({
		Name = 'SilentAura',
		Function = function(callback)
			if callback then
				SilentAura:Clean(runService.RenderStepped:Connect(function(dt)
					if not SilentAura.Enabled then
						return
					end

					local character = lplr.Character
					if not character then
						updateTargetBox(nil)
						return
					end

					local myRoot = character:FindFirstChild('HumanoidRootPart')
					local myHumanoid = character:FindFirstChildOfClass('Humanoid')

					if not myRoot or not myHumanoid or myHumanoid.Health <= 0 then
						updateTargetBox(nil)
						return
					end

					local targetRoot = getSilentAuraTarget({
						Range = Range and Range.Value or 15,
						MaxAngle = MaxAngle and MaxAngle.Value or 120,
						WallCheck = WallCheck and WallCheck.Enabled or false,
						IgnorePlayer = IgnorePlayer and IgnorePlayer.Enabled or false,
						LimitedItem = LimitedItem and LimitedItem.Value or 'Off',
					})

					updateTargetBox(targetRoot)

					if targetRoot then
						pcall(function()
							myHumanoid.AutoRotate = false
						end)

						local speed = Speed and Speed.Value or 5
						local alpha = (speed + 2) * (dt or 1 / 60)

						-- 念のため1を超えないようにだけクランプ
						if alpha > 1 then
							alpha = 1
						end

						local lookTarget = Vector3.new(
							targetRoot.Position.X,
							myRoot.Position.Y,
							targetRoot.Position.Z
						)

						if (lookTarget - myRoot.Position).Magnitude > 0.001 then
							pcall(function()
								myRoot.CFrame = myRoot.CFrame:Lerp(
									CFrame.lookAt(
										myRoot.Position,
										lookTarget
									),
									alpha
								)
							end)
						end
					else
						pcall(function()
							myHumanoid.AutoRotate = true
						end)
					end
				end))
			else
				clearTargetBox()

				pcall(function()
					local character = lplr.Character
					if character then
						local myHumanoid = character:FindFirstChildOfClass('Humanoid')
						if myHumanoid then
							myHumanoid.AutoRotate = true
						end
					end
				end)
			end
		end,
		ExtraText = function()
			local angleText = MaxAngle and tostring(MaxAngle.Value) or '?'
			local rangeText = Range and tostring(Range.Value) or '?'
			return angleText .. '° / ' .. rangeText
		end,
		Tooltip = 'Silently rotates your body toward valid targets using Lerp. Does not touch the camera.'
	})

	Speed = SilentAura:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 10,
		Default = 5,
		Function = function(val)
			-- 次フレームから反映
		end,
		Tooltip = 'Lerp speed. Higher = faster body rotation.'
	})

	MaxAngle = SilentAura:CreateSlider({
		Name = 'MaxAngle',
		Min = 1,
		Max = 360,
		Default = 120,
		Function = function(val)
			-- 次フレームから反映
		end,
		Suffix = function(val)
			return '°'
		end,
		Tooltip = '360 = all directions. 120 = right 60° and left 60° from your facing direction.'
	})

	Range = SilentAura:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 500,
		Default = 15,
		Function = function(val)
			-- 次フレームから反映
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end,
		Tooltip = 'Maximum distance for target selection.'
	})

	LimitedItem = SilentAura:CreateDropdown({
		Name = 'LimitedItem',
		List = {'Off', 'Any Tool', 'Sword', 'Bow', 'Axe', 'Pickaxe'},
		Function = function(val)
			-- 次フレームから反映
		end,
		Tooltip = 'Only activate when holding a matching tool. Detection is by tool name.'
	})

	WallCheck = SilentAura:CreateToggle({
		Name = 'WallCheck',
		Function = function(callback)
			if IgnorePlayer and IgnorePlayer.Object then
				pcall(function()
					IgnorePlayer.Object.Visible = callback
				end)
			end
		end,
		Tooltip = 'Only rotate toward targets that are visible by raycast.'
	})

	IgnorePlayer = SilentAura:CreateToggle({
		Name = 'IgnorePlayer',
		Default = true,
		Function = function(callback)
			-- 次フレームから反映
		end,
		Tooltip = 'When WallCheck is enabled, raycast ignores player characters. If disabled, players can block.',
		Visible = false
	})

	ShowTarget = SilentAura:CreateToggle({
		Name = 'ShowTarget',
		Function = function(callback)
			if not callback then
				clearTargetBox()
			end
		end,
		Tooltip = 'Shows a green box around the current target RootPart.'
	})
end)

run(function()
	local playersService = game:GetService('Players')
	local runService = game:GetService('RunService')
	local inputService = game:GetService('UserInputService')
	local lplr = playersService.LocalPlayer
	local vape = shared.vape

	local SkywarsFly
	local FlySpeed
	local FloatStrength

	local function getMoveInput()
		local moveX = 0
		local moveZ = 0

		if inputService:IsKeyDown(Enum.KeyCode.W) then moveZ = moveZ - 1 end
		if inputService:IsKeyDown(Enum.KeyCode.S) then moveZ = moveZ + 1 end
		if inputService:IsKeyDown(Enum.KeyCode.A) then moveX = moveX - 1 end
		if inputService:IsKeyDown(Enum.KeyCode.D) then moveX = moveX + 1 end

		return moveX, moveZ
	end

	SkywarsFly = vape.Categories.Blatant:CreateModule({
		Name = 'SkywarsFly',
		Function = function(callback)
			if callback then
				SkywarsFly:Clean(runService.RenderStepped:Connect(function(dt)
					if not SkywarsFly.Enabled then
						return
					end

					if dt <= 0 then
						dt = 1 / 60
					elseif dt > 0.1 then
						dt = 0.1
					end

					local character = lplr.Character
					if not character then
						return
					end

					local root = character:FindFirstChild('HumanoidRootPart')
					local humanoid = character:FindFirstChildOfClass('Humanoid')
					local camera = workspace.CurrentCamera

					if not root or not humanoid or humanoid.Health <= 0 or not camera then
						return
					end

					local moveX, moveZ = getMoveInput()
					local moveVector = Vector3.zero

					if moveX ~= 0 or moveZ ~= 0 then
						local camLook = camera.CFrame.LookVector
						camLook = Vector3.new(camLook.X, 0, camLook.Z)

						if camLook.Magnitude > 0.001 then
							camLook = camLook.Unit
						else
							camLook = Vector3.new(0, 0, -1)
						end

						local camRight = camera.CFrame.RightVector
						camRight = Vector3.new(camRight.X, 0, camRight.Z)

						if camRight.Magnitude > 0.001 then
							camRight = camRight.Unit
						else
							camRight = Vector3.new(1, 0, 0)
						end

						moveVector = (camLook * -moveZ) + (camRight * moveX)
					end

					if moveVector.Magnitude > 0.001 then
						moveVector = moveVector.Unit

						pcall(function()
							humanoid.AutoRotate = false
						end)

						local speedVal = FlySpeed and FlySpeed.Value or 50
						local currentPos = root.Position
						local newPos = currentPos + (moveVector * speedVal * dt)
						local lookTarget = currentPos + moveVector

						root.CFrame = CFrame.lookAt(
							Vector3.new(newPos.X, currentPos.Y, newPos.Z),
							Vector3.new(lookTarget.X, currentPos.Y, lookTarget.Z)
						)
					else
						pcall(function()
							humanoid.AutoRotate = true
						end)
					end

					local targetYVelocity = 0

					if inputService:IsKeyDown(Enum.KeyCode.Space) then
						targetYVelocity = FloatStrength and FloatStrength.Value or 50
					elseif inputService:IsKeyDown(Enum.KeyCode.LeftShift) or inputService:IsKeyDown(Enum.KeyCode.RightShift) then
						targetYVelocity = -(FloatStrength and FloatStrength.Value or 50)
					end

					local currentVelY = root.AssemblyLinearVelocity.Y
					local diff = targetYVelocity - currentVelY
					local mass = root.AssemblyMass

					if mass <= 0 then
						mass = 50
					end

					if math.abs(diff) > 0.001 then
						pcall(function()
							root:ApplyImpulse(Vector3.new(0, diff * mass, 0))
						end)
					end
				end))
			else
				local character = lplr.Character
				if character then
					local humanoid = character:FindFirstChildOfClass('Humanoid')
					if humanoid then
						pcall(function()
							humanoid.AutoRotate = true
						end)
					end
				end
			end
		end,
		ExtraText = function()
			return 'HiyokoVapeDevloper'
		end,
		Tooltip = 'Fly using CFrame for horizontal movement and ApplyImpulse for vertical floating. Fixed character orientation.'
	})

	FlySpeed = SkywarsFly:CreateSlider({
		Name = 'Horizontal Speed',
		Min = 1,
		Max = 25,
		Default = 25,
		Function = function(val)
		end,
		Suffix = function(val)
			return ' studs/s'
		end,
		Tooltip = 'Speed of horizontal movement via CFrame.'
	})

	FloatStrength = SkywarsFly:CreateSlider({
		Name = 'Vertical Power',
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function(val)
		end,
		Suffix = function(val)
			return ' power'
		end,
		Tooltip = 'Power of ascent/descent via ApplyImpulse.'
	})
end)

run(function()
	local playersService = cloneref and cloneref(game:GetService('Players')) or game:GetService('Players')
	local runService = cloneref and cloneref(game:GetService('RunService')) or game:GetService('RunService')
	local inputService = cloneref and cloneref(game:GetService('UserInputService')) or game:GetService('UserInputService')
	local lplr = playersService.LocalPlayer
	local vape = shared.vape or vape

	local SkywarsSpeed
	local SpeedValue
	local TPFrequency
	local AutoJump
	local AlwaysJump
	local AutoJumpRange

	local accumulator = 0

	local function getMoveInput()
		local moveX = 0
		local moveZ = 0

		if inputService:IsKeyDown(Enum.KeyCode.W) then moveZ = moveZ - 1 end
		if inputService:IsKeyDown(Enum.KeyCode.S) then moveZ = moveZ + 1 end
		if inputService:IsKeyDown(Enum.KeyCode.A) then moveX = moveX - 1 end
		if inputService:IsKeyDown(Enum.KeyCode.D) then moveX = moveX + 1 end

		return moveX, moveZ
	end

	local function isEnemyNear(range)
		range = range or 15

		local character = lplr.Character
		if not character then
			return false
		end

		local myRoot = character:FindFirstChild('HumanoidRootPart')
		local myHumanoid = character:FindFirstChildOfClass('Humanoid')

		if not myRoot or not myHumanoid or myHumanoid.Health <= 0 then
			return false
		end

		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= lplr and player.Character then
				if not (lplr.Team and player.Team and lplr.Team == player.Team) then
					local enemyChar = player.Character
					local enemyHumanoid = enemyChar:FindFirstChildOfClass('Humanoid')
					local enemyRoot = enemyChar:FindFirstChild('HumanoidRootPart')

					if enemyHumanoid and enemyHumanoid.Health > 0 and enemyRoot then
						if (enemyRoot.Position - myRoot.Position).Magnitude <= range then
							return true
						end
					end
				end
			end
		end

		return false
	end

	local function tryJump(humanoid)
		if not humanoid or humanoid.Health <= 0 then
			return
		end

		if humanoid.FloorMaterial == Enum.Material.Air then
			return
		end

		local ok, state = pcall(function()
			return humanoid:GetState()
		end)

		if ok and (state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping) then
			return
		end

		pcall(function()
			humanoid.Jump = true
		end)

		pcall(function()
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
	end

	SkywarsSpeed = vape.Categories.Blatant:CreateModule({
		Name = 'SkywarsSpeed',
		Function = function(callback)
			if callback then
				accumulator = 0

				SkywarsSpeed:Clean(runService.RenderStepped:Connect(function(dt)
					if not SkywarsSpeed.Enabled then
						return
					end

					if dt <= 0 then
						dt = 1 / 60
					elseif dt > 0.1 then
						dt = 0.1
					end

					local character = lplr.Character
					if not character then
						accumulator = 0
						return
					end

					local root = character:FindFirstChild('HumanoidRootPart')
					local humanoid = character:FindFirstChildOfClass('Humanoid')
					local camera = workspace.CurrentCamera

					if not root or not humanoid or humanoid.Health <= 0 or not camera then
						accumulator = 0
						return
					end

					local shouldJump = false

					if AlwaysJump and AlwaysJump.Enabled then
						shouldJump = true
					elseif AutoJump and AutoJump.Enabled and isEnemyNear(AutoJumpRange and AutoJumpRange.Value or 15) then
						shouldJump = true
					end

					if shouldJump then
						tryJump(humanoid)
					end

					local moveX, moveZ = getMoveInput()
					local moveVector = Vector3.zero

					if moveX ~= 0 or moveZ ~= 0 then
						local camLook = camera.CFrame.LookVector
						camLook = Vector3.new(camLook.X, 0, camLook.Z)

						if camLook.Magnitude > 0.001 then
							camLook = camLook.Unit
						else
							camLook = Vector3.new(0, 0, -1)
						end

						local camRight = camera.CFrame.RightVector
						camRight = Vector3.new(camRight.X, 0, camRight.Z)

						if camRight.Magnitude > 0.001 then
							camRight = camRight.Unit
						else
							camRight = Vector3.new(1, 0, 0)
						end

						moveVector = (camLook * -moveZ) + (camRight * moveX)
					end

					if moveVector.Magnitude > 0.001 then
						moveVector = moveVector.Unit

						pcall(function()
							humanoid.AutoRotate = false
						end)

						pcall(function()
							root.CFrame = CFrame.lookAt(
								root.Position,
								Vector3.new(
									root.Position.X + moveVector.X,
									root.Position.Y,
									root.Position.Z + moveVector.Z
								)
							)
						end)

						local freq = TPFrequency and TPFrequency.Value or 20
						if freq < 1 then
							freq = 1
						end

						local speed = SpeedValue and SpeedValue.Value or 30
						local interval = 1 / freq
						local stepDistance = speed / freq

						accumulator = accumulator + dt

						local maxSteps = math.clamp(math.ceil(freq * dt) + 2, 1, 10)
						local steps = 0

						while accumulator >= interval and steps < maxSteps do
							accumulator = accumulator - interval
							steps = steps + 1

							local currentPos = root.Position
							local newPos = currentPos + (moveVector * stepDistance)

							pcall(function()
								root.CFrame = CFrame.lookAt(
									newPos,
									Vector3.new(
										newPos.X + moveVector.X,
										newPos.Y,
										newPos.Z + moveVector.Z
									)
								)
							end)
						end

						if accumulator > interval then
							accumulator = interval
						end
					else
						accumulator = 0

						pcall(function()
							humanoid.AutoRotate = true
						end)
					end
				end))
			else
				accumulator = 0

				local character = lplr.Character
				if character then
					local humanoid = character:FindFirstChildOfClass('Humanoid')
					if humanoid then
						pcall(function()
							humanoid.AutoRotate = true
						end)
					end
				end
			end
		end,
		ExtraText = function()
			return 'HiyokoVapeDevloper'
		end,
		Tooltip = 'TP Walk speed. Character orientation is fixed, optional AlwaysJump / AutoJump and TP Frequency.'
	})

	SpeedValue = SkywarsSpeed:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 10,
		Default = 30,
		Function = function(val)
		end,
		Suffix = function(val)
			return ' studs/s'
		end,
		Tooltip = 'Movement speed for TP Walk.'
	})

	TPFrequency = SkywarsSpeed:CreateSlider({
		Name = 'TP Frequency',
		Min = 1,
		Max = 100,
		Default = 100,
		Function = function(val)
		end,
		Suffix = function(val)
			return 'Hz'
		end,
		Tooltip = 'How many teleports per second TP Walk performs. Higher is smoother.'
	})

	AutoJump = SkywarsSpeed:CreateToggle({
		Name = 'AutoJump',
		Function = function(callback)
			if AutoJumpRange and AutoJumpRange.Object then
				pcall(function()
					AutoJumpRange.Object.Visible = callback
				end)
			end
		end,
		Tooltip = 'Jump automatically when an enemy is near.'
	})

	AutoJumpRange = SkywarsSpeed:CreateSlider({
		Name = 'AutoJump Range',
		Min = 1,
		Max = 100,
		Default = 15,
		Function = function(val)
		end,
		Suffix = function(val)
			return val == 1 and ' stud' or ' studs'
		end,
		Tooltip = 'Distance used by AutoJump to detect nearby enemies.',
		Visible = false
	})

	AlwaysJump = SkywarsSpeed:CreateToggle({
		Name = 'AlwaysJump',
		Function = function(callback)
		end,
		Tooltip = 'Always jump while grounded.'
	})
end)

