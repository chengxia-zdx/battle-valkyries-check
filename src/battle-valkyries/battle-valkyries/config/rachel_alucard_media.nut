foreach(cue in ["wind","nago_slash","lobelia_seed","lightning","george_shock","bat_cloud","lily","dahlia","elfried_aura","gerbera_wave","calendula"])
 ::$bvvar{namespace}.ValkyrieVisualThemes["rachel_"+cue] <- {Effect="effect_bv_rachel_alucard_"+cue,Color="#ffffff",Scale=0.8,EndScale=1.05,ScaleStep=0.0,EndScaleStep=0.0,Duration=400,Layers=1,DelayStep=0,Offsets=[{X=0,Y=cue=="wind"?-30:0}]};
