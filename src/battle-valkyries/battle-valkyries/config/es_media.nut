foreach(cue in ["crest_burst","blade_arc","breunor_wave","galahad_thrust","mordred_trail","bors_charge","griflet_guard","gawain_impact","percival_aura","artorius_slash"])
 ::$bvvar{namespace}.ValkyrieVisualThemes["es_"+cue] <- {Effect="effect_bv_es_"+cue,Color="#ffffff",Scale=0.8,EndScale=1.05,ScaleStep=0.0,EndScaleStep=0.0,Duration=400,Layers=1,DelayStep=0,Offsets=[{X=0,Y=["mordred_trail","percival_aura"].find(cue)!=null?-30:0}]};

// The impact begins immediately; the azure seal expands behind the blast.
::$bvvar{namespace}.ValkyrieVisualThemes.es_crest_burst = {
 Effects=["effect_bv_es_crest_burst","effect_bv_es_crest_pending"],Color="#ffffff",
 Scale=1.0,EndScale=1.7,ScaleStep=0.0,EndScaleStep=0.0,
 Duration=360,Layers=2,DelayStep=50,Offsets=[{X=0,Y=0}]
};
::$bvvar{namespace}.ValkyrieVisualThemes.es_crest_ultimate <- {
 Effects=["effect_bv_es_crest_burst","effect_bv_es_crest_pending","effect_bv_es_crest_burst"],Color="#ffffff",
 Scale=1.2,EndScale=2.3,ScaleStep=0.15,EndScaleStep=0.35,
 Duration=520,Layers=3,DelayStep=60,Offsets=[{X=0,Y=0}]
};
// Cropped mortar impact: no flight lead-in. Shared gain is 7.5.
::$bvvar{namespace}.SkillAudioCues.es_crest_burst <- {
 Owner="es",Volume=0.12,Files=["sounds/skills/es/crest_impact_01.wav"]
};
::$bvvar{namespace}.SkillAudioCues.es_crest_ultimate <- {
 Owner="es",Volume=0.144,Files=["sounds/skills/es/crest_impact_01.wav"]
};
