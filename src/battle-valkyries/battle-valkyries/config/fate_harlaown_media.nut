// White cape trails and gold lightning; caster and target anchors are separate.
local themes={
 cast={Brush="cast_ring",Scale=0.45,End=0.80,Duration=420,Y=-30,Layers=1},
 ready={Brush="transform",Scale=0.25,End=0.55,Duration=650,Y=25,Layers=1},
 afterimage={Brush="afterimage",Scale=0.35,End=0.75,Duration=320,Y=10,Layers=1},
 arrival={Brush="cast_ring",Scale=0.30,End=0.85,Duration=450,Y=-30,Layers=1},
 slash={Brush="slash",Scale=0.45,End=1.00,Duration=360,Y=10,Layers=1},
 twin={Brush="twin",Scale=0.40,End=0.95,Duration=350,Y=15,Layers=1},
 lance={Brush="lance",Scale=0.40,End=0.85,Duration=320,Y=35,Layers=1},
 transform={Brush="transform",Scale=0.35,End=1.05,Duration=800,Y=30,Layers=1},
 zanber={Brush="zanber",Scale=0.40,End=1.10,Duration=650,Y=25,Layers=1},
 impact={Brush="impact",Scale=0.30,End=0.70,Duration=260,Y=10,Layers=1}
};
foreach(key,t in themes)::$bvvar{namespace}.ValkyrieVisualThemes["fate_"+key]<-{
 Effect="effect_bv_fate_"+t.Brush,Color="#ffffff",Scale=t.Scale,EndScale=t.End,ScaleStep=0.0,EndScaleStep=0.0,
 Duration=t.Duration,Layers=t.Layers,DelayStep=100,Offsets=[{X=0,Y=t.Y}]
};
