return {
	inrange = function(tbl, n, m, soft)
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
}