
local inrange_ = function(tbl, n, m, soft)
	soft = soft or true
	for _, v in pairs(tbl) do
		if (soft) then
			if not (v >= n and v <= m) then 
				return false 
			end
		else
			if not (v > n and v < m) then 
				return false 
			end
		end
	end
	return true		
end 

local getOsName_ = function()
	--/ hack 
	local sep = package.config:sub(1, 1)
	if sep == '/' then return "Unix"
	elseif sep == '\\' then return "Windows"
	end
end

local isUnix_ = function() return getOsName_() == "Unix" end

local isWindows_ = function() return getOsName_() == "Windows" end

local wait_ = function(sec)
	if type(sec) ~= "number" then sec = 1 end
	local to = tonumber(os.clock() + sec)
	while os.clock() < to do end
end

local cls_ = function() 
	local cmd = isUnix_() and "clear" or "cls"
	os.execute(cmd)
end


return {
	inrange = inrange_,
	getOsName = getOsName_,
	isWindows = isWindows_,
	isUnix = isUnix_,
	wait = wait_,
	cls = cls_
}