fs = require 'bee.filesystem'

local cjass = {}

cjass.path     = fs.ydwe_path() / "compiler" / "AdicHelper"

-- 使用cJass编译地图
-- map_path - 地图路径，fs.path对象
-- option - 附加编译选项, table，支持选项为：
--	enable_jasshelper_debug - 启用Debug模式，true/false
--	runtime_version - 魔兽版本
-- 返回：true编译成功，false编译失败
function cjass.do_compile(self, map_path, option)
	local parameter = option.runtime_version == 24 and " /v24" or " /v23"
					.. (option.enable_jasshelper_debug and " /dbg" or "")

	local command_line = string.format('"%s"%s /mappars="%s"',
		(self.path / "AdicHelper.exe"):string(),
		parameter,
		map_path:string()
	)

	return sys.spawn(command_line, self.path, true)
end

function cjass.compile(self, map_path, option)	
	log.trace("CJass compilation start.")	
	local result = self:do_compile(map_path, option)
	
	if result then
		log.debug("CJass compilation succeeded.")
	else
		log.error("CJass compilation failed.")
	end

	return result
end

return cjass
