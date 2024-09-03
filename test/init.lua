local protoc = require "utils.protoc"

local M = {}

local q = {
   pp = 2,
}

function q:print()
    print(self.pp)
end

function M.test()
    print("test")
      q:print()
    local ret = protoc:load [[
   message Phone {
      optional string name        = 1;
      optional int64  phonenumber = 2;
   }
   message Person {
      optional string name     = 1;
      optional int32  age      = 2;
      optional string address  = 3;
      repeated Phone  contacts = 4;
   } ]]
    print('protoc ret:', ret)
end

return M
