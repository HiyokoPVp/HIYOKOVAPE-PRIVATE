--[[
	Prediction Library (改善版)
	Original: https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
	
	改善点:
	- 正の根の中から最小値（最短飛行時間）を選択するように修正
	- 重力補正ループを正しく動作するように修正
	- ゼロ除算ガード追加
	- 根の精度フィルタ（eps以下の根を除外）
	- gravity == 0 のフォールバックを SolveTrajectory 全体に適用
]]

local module = {}
local eps = 1e-9

local function isZero(d)
	return (d > -eps and d < eps)
end

local function cuberoot(x)
	return (x > 0) and math.pow(x, (1 / 3)) or -math.pow(math.abs(x), (1 / 3))
end

local function solveQuadric(c0, c1, c2)
	local s0, s1
	local p, q, D

	p = c1 / (2 * c0)
	q = c2 / c0
	D = p * p - q

	if isZero(D) then
		s0 = -p
		return s0
	elseif D < 0 then
		return
	else
		local sqrt_D = math.sqrt(D)
		s0 = sqrt_D - p
		s1 = -sqrt_D - p
		return s0, s1
	end
end

local function solveCubic(c0, c1, c2, c3)
	local s0, s1, s2
	local num
	local A, B, C
	local sq_A, p, q
	local cb_p, D

	A = c1 / c0
	B = c2 / c0
	C = c3 / c0

	sq_A = A * A
	p = (1 / 3) * (-(1 / 3) * sq_A + B)
	q = 0.5 * ((2 / 27) * A * sq_A - (1 / 3) * A * B + C)

	cb_p = p * p * p
	D = q * q + cb_p

	if isZero(D) then
		if isZero(q) then
			s0 = 0
			num = 1
		else
			local u = cuberoot(-q)
			s0 = 2 * u
			s1 = -u
			num = 2
		end
	elseif D < 0 then
		local phi = (1 / 3) * math.acos(math.clamp(-q / math.sqrt(-cb_p), -1, 1)) -- clampで安全に
		local t = 2 * math.sqrt(-p)
		s0 = t * math.cos(phi)
		s1 = -t * math.cos(phi + math.pi / 3)
		s2 = -t * math.cos(phi - math.pi / 3)
		num = 3
	else
		local sqrt_D = math.sqrt(D)
		local u = cuberoot(sqrt_D - q)
		local v = -cuberoot(sqrt_D + q)
		s0 = u + v
		num = 1
	end

	local sub = (1 / 3) * A

	if num > 0 then s0 = s0 - sub end
	if num > 1 then s1 = s1 - sub end
	if num > 2 then s2 = s2 - sub end

	return s0, s1, s2
end

function module.solveQuartic(c0, c1, c2, c3, c4)
	local s0, s1, s2, s3

	local coeffs = {}
	local z, u, v, sub
	local A, B, C, D
	local sq_A, p, q, r
	local num

	A = c1 / c0
	B = c2 / c0
	C = c3 / c0
	D = c4 / c0

	sq_A = A * A
	p = -0.375 * sq_A + B
	q = 0.125 * sq_A * A - 0.5 * A * B + C
	r = -(3 / 256) * sq_A * sq_A + 0.0625 * sq_A * B - 0.25 * A * C + D

	if isZero(r) then
		coeffs[3] = q
		coeffs[2] = p
		coeffs[1] = 0
		coeffs[0] = 1

		local results = {solveCubic(coeffs[0], coeffs[1], coeffs[2], coeffs[3])}
		num = #results
		s0, s1, s2 = results[1], results[2], results[3]
	else
		coeffs[3] = 0.5 * r * p - 0.125 * q * q
		coeffs[2] = -r
		coeffs[1] = -0.5 * p
		coeffs[0] = 1

		s0, s1, s2 = solveCubic(coeffs[0], coeffs[1], coeffs[2], coeffs[3])
		z = s0

		u = z * z - r
		v = 2 * z - p

		if isZero(u) then
			u = 0
		elseif u > 0 then
			u = math.sqrt(u)
		else
			return
		end

		if isZero(v) then
			v = 0
		elseif v > 0 then
			v = math.sqrt(v)
		else
			return
		end

		coeffs[2] = z - u
		coeffs[1] = q < 0 and -v or v
		coeffs[0] = 1

		do
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = #results
			s0, s1 = results[1], results[2]
		end

		coeffs[2] = z + u
		coeffs[1] = q < 0 and v or -v
		coeffs[0] = 1

		if num == 0 then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s0, s1 = results[1], results[2]
		end
		if num == 1 then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s1, s2 = results[1], results[2]
		end
		if num == 2 then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s2, s3 = results[1], results[2]
		end
	end

	sub = 0.25 * A

	if num > 0 then s0 = s0 - sub end
	if num > 1 then s1 = s1 - sub end
	if num > 2 then s2 = s2 - sub end
	if num > 3 then s3 = s3 - sub end

	return {s3, s2, s1, s0}
end

function module.SolveTrajectory(origin, projectileSpeed, gravity, targetPos, targetVelocity, playerGravity, playerHeight, playerJump, params)
	local disp = targetPos - origin
	local p, q, r = targetVelocity.X, targetVelocity.Y, targetVelocity.Z
	local h, j, k = disp.X, disp.Y, disp.Z
	local l = -0.5 * gravity

	-- 重力補正: プレイヤーが落下中の場合にターゲット着地点を予測
	if math.abs(q) > 0.01 and playerGravity and playerGravity > 0 then
		local estTime = disp.Magnitude / math.max(projectileSpeed, eps) -- ゼロ除算ガード

		-- 落下中かつ下向き速度がある場合のみ補正
		if q < 0 then
			-- 着地するまでの時間を計算: 0 = q*t - 0.5*playerGravity*t^2 -> t = 2q/playerGravity
			local landTime = (2 * math.abs(q)) / playerGravity
			local predictedDrop = q * landTime - 0.5 * playerGravity * landTime * landTime

			-- 着地予測位置へRaycast
			local rayDir = Vector3.new(
				targetVelocity.X * landTime,
				predictedDrop - playerHeight,
				targetVelocity.Z * landTime
			)

			if rayDir.Magnitude > eps then
				local ray = workspace:Raycast(targetPos, rayDir, params)
				if ray then
					-- 着地点にプレイヤー高さ分オフセット
					targetPos = ray.Position + Vector3.new(0, playerHeight, 0)
					-- 着地後は垂直速度ゼロ
					q = 0
					-- disp, j を再計算
					disp = targetPos - origin
					h, j, k = disp.X, disp.Y, disp.Z
				end
			end
		end
	end

	-- gravity == 0 の場合のフォールバック（直線予測）
	if gravity == 0 or isZero(gravity) then
		local dist = disp.Magnitude
		if dist < eps then
			return targetPos -- すでにそこにいる
		end
		local t = dist / projectileSpeed
		return Vector3.new(
			origin.X + (h + p * t),
			origin.Y + (j + q * t),
			origin.Z + (k + r * t)
		)
	end

	-- 4次方程式を解いて飛行時間を求める
	local solutions = module.solveQuartic(
		l * l,
		-2 * q * l,
		q * q - 2 * j * l - projectileSpeed * projectileSpeed + p * p + r * r,
		2 * j * q + 2 * h * p + 2 * k * r,
		j * j + h * h + k * k
	)

	if solutions then
		-- 有効な正の根だけ集める（eps以下は数値誤差なので除外）
		local posRoots = {}
		for _, v in ipairs(solutions) do
			if v and v > eps then
				table.insert(posRoots, v)
			end
		end

		-- 最小の正の根 = 最短飛行時間 = 最も精確な予測
		table.sort(posRoots)

		if posRoots[1] then
			local t = posRoots[1]

			-- ゼロ除算ガード（tが極端に小さい場合）
			if t < eps then return nil end

			local d = (h + p * t) / t
			local e = (j + q * t - l * t * t) / t
			local f = (k + r * t) / t

			return origin + Vector3.new(d, e, f)
		end
	end

	-- 解なし
	return nil
end

return module
