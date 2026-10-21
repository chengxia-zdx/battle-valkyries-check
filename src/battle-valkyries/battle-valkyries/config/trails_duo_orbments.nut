local bv=::$bvvar{namespace};
bv.OrbmentForms.renne_aster <- {Name="$bv{trails.orbment.renne_aster}",Lines=[[0,1,2,3,4,5,6]],ActiveSlots=3,PassiveCapacity=3,Icon="$bvvar{iconPrefix}/renne_aster_orbment.png"};
bv.OrbmentForms.alisa_blazing_wing <- {Name="$bv{trails.orbment.alisa_blazing_wing}",Lines=[[0,1,2,3],[0,4,5,6]],ActiveSlots=2,PassiveCapacity=5,Icon="$bvvar{iconPrefix}/alisa_blazing_wing_orbment.png"};
bv.TrailsStarterConfigs <- {
 renne={Form="renne_aster",Weapon="renne_annihilation_scythe",Slots=["timesand:1","timesand:1","brightsky:1","brightsky:1","phantomeye:1","phantomeye:1","swiftwind:1"],Active=["orbment_temporal_boost","orbment_space_barrier","orbment_phantom_noise"],Passive=["orbment_breathing","orbment_far_guard","orbment_composure"]},
 alisa={Form="alisa_blazing_wing",Weapon="alisa_orbal_bow",Slots=["timesand:1","redblade:1","redblade:1","starcut:1","swiftwind:1","swiftwind:1","brightsky:1"],Active=["orbment_fire_bolt","orbment_temporal_boost"],Passive=["orbment_onslaught","orbment_breathing","orbment_swiftness"]}
};
