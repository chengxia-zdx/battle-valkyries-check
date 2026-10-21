this.kanade_tachibana_rescue_skill <- this.inherit("scripts/skills/skill", {
 function create(){this.m.ID="$bvvar{modId}.active.kanade_rescue";this.m.Name="$bv{kanade.rescue.name}";this.m.Description="$bv{kanade.rescue.description}";this.m.Icon="skills/active_66.png";this.m.IconDisabled="skills/active_66_sw.png";this.m.Type=this.Const.SkillType.Active;this.m.Order=this.Const.SkillOrder.UtilityTargeted;this.m.IsActive=true;this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsAttack=false;this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;this.m.ActionPointCost=4;this.m.FatigueCost=5;this.m.MinRange=1;this.m.MaxRange=1;},
 function onVerifyTarget(origin,tile){return tile!=null&&tile.IsOccupiedByActor&&origin.getDistanceTo(tile)==1&&"KanadeMissionUnit" in tile.getEntity().m&&tile.getEntity().m.KanadeKind=="wounded"&&tile.getEntity().getHitpoints()<tile.getEntity().getHitpointsMax();},
 function onUse(a,tile){if(!this.onVerifyTarget(a.getTile(),tile))return false;local b=tile.getEntity();b.setHitpoints(::Math.min(b.getHitpointsMax(),b.getHitpoints()+40));b.setDirty(true);return true;},
 function onCombatFinished(){this.removeSelf();},
 // Private runtime skill: never resolve a public save path during SBS cleanup.
 function removeSelf(){this.m.IsGarbage=true;},
 function onOtherActorTooltip(tooltip,actor){}
});
