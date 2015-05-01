return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 8,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "testTiles",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../images/testTiles.png",
      imagewidth = 32,
      imageheight = 64,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "collisionLayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 0, 0, 0, 0, 0, 0, 2,
        2, 0, 0, 0, 0, 0, 0, 2,
        2, 0, 0, 0, 0, 0, 0, 2,
        2, 0, 0, 0, 0, 0, 0, 2,
        2, 0, 0, 0, 1, 1, 0, 2,
        2, 0, 0, 0, 1, 1, 0, 2,
        2, 2, 2, 2, 2, 2, 2, 2
      }
    }
  }
}
