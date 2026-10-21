foreach (cue in ["overdrive","blade_arc","blade_pierce","distortion","delay","harmonics","howling","sonic_rotation"])
 ::$bvvar{namespace}.ValkyrieVisualThemes["kanade_"+cue] <- {
  Effect="effect_bv_kanade_tachibana_"+cue,Color="#ffffff",Scale=0.8,EndScale=1.1,ScaleStep=0.0,EndScaleStep=0.0,
  Duration=400,Layers=1,DelayStep=0,Offsets=[{X=0,Y=["overdrive","harmonics","sonic_rotation"].find(cue)!=null?-30:25}]
 };
