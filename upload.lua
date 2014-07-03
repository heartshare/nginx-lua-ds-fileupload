local config_upload_pwd="/tmp/"

local upload = require "resty.upload"
local cjson = require "cjson"

local chunk_size = 4096

local form, err = upload:new(chunk_size)
if not form then
    ngx.log(ngx.ERR, "failed to new upload: ", err)
    ngx.exit(500)
end

form:set_timeout(3000) 

while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.say("failed to read: ", err)
        return
    end

    if typ == "header" then
        local file_name=string.match(res[2],[[filename%=%"(.+)%"]])

        if file_name=="" then file_name=nil end

        if file_name then
            ngx.say(file_name)
            file = io.open(config_upload_pwd..file_name, "w+")
            if not file then
                ngx.say("failed to open file ", file_name)
                return
            end
        end

    elseif typ == "body" then
        if file then
            file:write(res)
        end

    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil
        end

    elseif typ == "eof" then
        break
    else
    end
end
