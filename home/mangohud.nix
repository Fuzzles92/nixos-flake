#==========================================#
#        Mango Hub
#==========================================#

{ config, pkgs, ... }:

{
  xdg.configFile."MangoHud/MangoHud.conf" = {
    force = true;
    text = ''
      ########################################
      # Managed declaratively by Home Manager
      ########################################

      ### Layout ###
      legacy_layout=false
      position=top-left
      background_alpha=0.5
      background_color=000000
      text_color=ffffff
      text_outline
      hud_no_margin

      ### GPU Stats ###
      gpu_stats
      gpu_load_change
      gpu_temp
      gpu_mem_temp
      vram

      ### CPU & Memory ###
      cpu_stats
      cpu_load_change
      cpu_temp
      ram
      procmem
      procmem_shared

      ### FPS / Frame Timing ###
      fps
      fps_metrics=avg,0.01
      frametime_color=00ff00

      # FPS limiter (can be toggled)
      fps_limit_method=late
      toggle_fps_limit=Shift_L+F1

      ### Input Toggles ###
      toggle_logging=Shift_L+F2
      toggle_hud_position=Shift_R+F11
      toggle_hud=Shift_R+F12

      ### Thresholds & Colors ###
      fps_value=30,60
      fps_color=cc0000,ffaa7f,92e79a

      gpu_load_value=60,90
      gpu_load_color=92e79a,ffaa7f,cc0000

      cpu_load_value=60,90
      cpu_load_color=92e79a,ffaa7f,cc0000

      ### Component Colors ###
      gpu_color=2e9762
      cpu_color=2e97cb
      vram_color=ad64c1
      ram_color=c26693
      wine_color=eb5b5b
      engine_color=eb5b5b
      media_player_color=ffffff
      network_color=e07b85
      battery_color=92e79a

      ### Media Player ###
      media_player_format={title};{artist};{album}
    '';
  };
}
