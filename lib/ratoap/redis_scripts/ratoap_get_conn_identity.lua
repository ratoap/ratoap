local part_type = ARGV[1]
local part_name = ARGV[2]
local token = ARGV[3]


math.randomseed(tonumber(string.sub(tostring({}), 8, -1), 16))

if part_type == 'driver' and part_name == 'vagrant_ruby' and token == 'xxx' then
  local str = string.format("%s%s%s%s", part_type, part_name, token, math.random())
  return redis.sha1hex(str)
else
  return 0
end
