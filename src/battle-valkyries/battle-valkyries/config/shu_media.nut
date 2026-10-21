::$bvvar{namespace}.ValkyrieVisualThemes.shu_heal <- {
 Effect = "effect_bv_shu_heal", Color = "#ffffff", Scale = 0.65, EndScale = 1.05, Duration = 850, Layers = 1, Offsets = [{ X = 0, Y = -20 }]
};
::$bvvar{namespace}.ValkyrieVisualThemes.shu_guard <- {
 Effect = "effect_bv_shu_guard", Color = "#ffffff", Scale = 0.75, EndScale = 1.10, Duration = 1000, Layers = 1, Offsets = [{ X = 0, Y = 0 }]
};
foreach (cue in ["shu_nurture", "shu_granary", "shu_first_guard"])
 ::$bvvar{namespace}.SkillAudioCues[cue] <- {
  Owner = "shu", Volume = cue == "shu_first_guard" ? 0.32 : 0.5,
  Files = ["sounds/skills/shu/" + cue + "_01.wav"]
 };
