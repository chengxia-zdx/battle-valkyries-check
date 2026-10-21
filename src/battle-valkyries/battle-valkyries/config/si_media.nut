// Separate caster, ground, target and release layers. Delays are cosmetic only.
local bv=::$bvvar{namespace};
local themes={
 si_cast={Brush="cast_ring",Scale=0.35,End=0.75,Duration=450,Y=-30,Layers=1},
 si_ready={Brush="dragon_coil",Scale=0.30,End=0.50,Duration=650,Y=0,Layers=1},
 si_brush_travel={Brush="brush_slash",Scale=0.50,End=0.90,Duration=350,Y=15,Layers=1},
 si_frost_impact={Brush="frost_impact",Scale=0.40,End=0.85,Duration=450,Y=5,Layers=1},
 si_scroll_cast={Brush="scroll_open",Scale=0.40,End=0.90,Duration=750,Y=15,Layers=1},
 si_mark_apply={Brush="ink_seal",Scale=0.35,End=0.95,Duration=600,Y=-28,Layers=1},
 si_root={Brush="ink_seal",Scale=1.05,End=0.60,Duration=550,Y=-20,Layers=2},
 si_ink_transfer={Brush="ink_thread",Scale=0.40,End=0.70,Duration=250,Y=-5,Layers=1},
 si_soul_impact={Brush="soul_wisp",Scale=0.40,End=0.80,Duration=450,Y=20,Layers=1},
 si_lotus_pool={Brush="lotus_pool",Scale=0.50,End=1.10,Duration=950,Y=-32,Layers=2},
 si_lotus_dome={Brush="lotus_dome",Scale=0.50,End=0.95,Duration=850,Y=15,Layers=1},
 si_ward_break={Brush="shield_break",Scale=0.50,End=1.00,Duration=500,Y=10,Layers=1},
 si_dragon_cast={Brush="dragon_coil",Scale=0.45,End=1.05,Duration=1000,Y=25,Layers=1},
 si_dragon_impact={Brush="dragon_dive",Scale=0.55,End=1.10,Duration=800,Y=30,Layers=1},
 si_scroll_close={Brush="scroll_close",Scale=1.05,End=0.30,Duration=600,Y=10,Layers=1},
 si_afterglow={Brush="afterglow",Scale=0.35,End=0.70,Duration=650,Y=45,Layers=1}
};
foreach(key,t in themes) bv.ValkyrieVisualThemes[key] <- {
 Effect="effect_bv_si_"+t.Brush,Color="#ffffff",Scale=t.Scale,EndScale=t.End,ScaleStep=0.05,EndScaleStep=0.08,
 Duration=t.Duration,Layers=t.Layers,DelayStep=130,Offsets=[{X=0,Y=t.Y}]
};
foreach(cue in ["si_brush_cast","si_brush_impact","si_scroll_open","si_mark","si_soul","si_lotus_open","si_ward_break","si_ready","si_dragon_cast","si_dragon_impact"])
 bv.SkillAudioCues[cue] <- {Owner="si",Volume=cue=="si_dragon_cast"?0.34:(cue=="si_soul"?0.16:0.24),Files=["sounds/skills/si/"+cue+"_01.wav"]};
