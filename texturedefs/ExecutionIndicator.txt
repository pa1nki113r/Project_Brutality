// Red Frame from Target Spy
Texture "ts_framr_top_right", 64, 64
{
  Patch  ts_framr, 0, 0
  {
    FlipX
  }
  Offset 64, 0
}

Texture "ts_framr_bottom_left", 64, 64
{
  Patch  ts_framr, 0, 0
  {
    FlipY
  }
  Offset 0, 64
}

Texture "ts_framr_bottom_right", 64, 64
{
  Patch  ts_framr, 0, 0
  {
    FlipX
    FlipY
  }
  Offset 64, 64
}