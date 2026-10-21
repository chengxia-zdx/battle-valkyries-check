this.kanade_tachibana_echo <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
 m={KanadeTerminal=false},
 function create(){this.bandit_raider.create();this.m.Name="$bv{kanade.echo.name}";},
 function onInit(){this.bandit_raider.onInit();this.configure(this.getFaction());},
 function configure(faction,overload=false,terminal=false)
 {
  this.setFaction(faction);this.m.KanadeTerminal=terminal;local b=this.m.BaseProperties;
  b.Hitpoints=terminal?450:(overload?300:80);b.MeleeSkill=terminal?90:(overload?80:65);b.MeleeDefense=terminal?20:10;b.RangedDefense=10;
  b.ActionPoints=9;this.m.Hitpoints=b.Hitpoints;this.m.CurrentProperties=clone b;
  this.m.Name=terminal?"$bv{kanade.terminal.name}":(overload?"$bv{kanade.overload.name}":"$bv{kanade.echo.name}");
  this.getSkills().update();this.setDirty(true);
 },
 function onDamageReceived(attacker,skill,hit)
 {
  if(!this.m.KanadeTerminal)return this.bandit_raider.onDamageReceived(attacker,skill,hit);
  local reduced=clone hit,mult=1.0-0.25*::Math.min(3,::$bvvar{namespace}.KanadeMissions.units("anchor").len());
  reduced.DamageRegular*=mult;reduced.DamageArmor*=mult;return this.bandit_raider.onDamageReceived(attacker,skill,reduced);
 }
});
