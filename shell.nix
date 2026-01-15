{
  pkgs ? import <nixpkgs> {},
}:

let
  luaEnv = pkgs.lua.withPackages (ps: [
    ps.lualogging
  ]);
in
pkgs.mkShell {
  packages = [
    pkgs.love
    luaEnv
  ];

  shellHook = ''
    # Make Lua packages visible to LÖVE's embedded LuaJIT
    export LUA_PATH="${luaEnv}/share/lua/5.2/?.lua;${luaEnv}/share/lua/5.2/?/init.lua;;"
    export LUA_CPATH="${luaEnv}/lib/lua/5.2/?.so;;"

    echo "LUA_PATH=$LUA_PATH"
    echo "LUA_CPATH=$LUA_CPATH"
  '';
}
