--my_utils.lua

function printHeirarchy ( root, str, prefix )
	if str == nil then str = '' end
	if prefix == nil then prefix = '' end

	str = str .. prefix .. root.description .. '(' .. 'root.gid' .. ')' .. ': [' 
	for i, comp in pairs(root:getComponents()) do
		str = str .. comp.name .. ', '
	end
	str = str .. ']\n'
	if root:hasChildren() then
		local numUntilEllipsis = 4
		for j, child in ipairs(root:getChildren()) do
			if j == numUntilEllipsis then str = str .. prefix .. '  ..[' .. (#root:getChildren() - numUntilEllipsis) .. ' more]..\n'
			elseif j > numUntilEllipsis and j < #root:getChildren() then str = str 
			else str = str .. printHeirarchy(child, '', prefix .. '  ') end
		end
	end
	return str
end
