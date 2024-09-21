local protoc = require "tf_api.protoc"
local debug = require "tf_api.debug"

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

   local data = {
      name = "ilse",
      age  = 18,
      contacts = {
         { name = "alice", phonenumber = 12312341234 },
         { name = "bob",   phonenumber = 45645674567 }
      }
   }

-- encode lua table data into binary format in lua string and return
   local bytes = dart_pb.encode("Person", data)
   print('encode ret:', dart_bytes.hex(bytes))

   local enc = '22 12 0A 05 61 6C 69 63 65 10 80 80 80 80 80 80 FC F6 F7 01 22 10 0A 03 62 6F 62 10 B9 8F B9 FA D5 FE FF FF FF 01 0A 04 69 6C 73 65 10 12'
   local enc_bytes = dart_bytes.fromhex(enc)
   local dec = dart_pb.decode("Person", enc_bytes)
   print('decode ret:', debug.debug_table(dec))
end



return M
