::$bvvar{namespace}.KanadeBondTraitID <- "$bvvar{modId}.trait.kanade_tachibana_bond";
::$bvvar{namespace}.KanadeBond <- {
 ShopRequested=false,
	function ensureTrait(actor)
	{
		if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "kanade_tachibana") return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.KanadeBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/kanade_tachibana_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (!("World" in getroottable()) || ::World == null || !("getPlayerRoster" in ::World) || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (::$bvvar{namespace}.getActorValkyrieID(actor) == "kanade_tachibana" && !::$bvvar{namespace}.isActorDeadOrDying(actor)) return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.KanadeBondStages) if (entry.Value == value) return entry;
		return null;
	},
	function campStage(location)
	{
		if (location == null || !location.isLocation()) return null;
		local flags = location.getFlags();
		// Native tag_collection.get returns false for absent keys, not null.
		if (!flags.has("BVKanadeBondStage")) return null;
		local value = flags.get("BVKanadeBondStage");
		if (typeof value != "integer" || location.getTypeID() != "$bvvar{modId}.location.kanade_tachibana_bond_" + value) return null;
		return this.stage(value);
	},
	function combatID()
	{
		local id = ::World.Statistics.getFlags().get("LastCombatID");
		return typeof id == "integer" ? id : 0;
	},
	function startCombat(actor)
	{
		if (this.ensureTrait(actor) == null) return;
		local flags = actor.getFlags();
		flags.set("BVKanadeBondCombatID", this.combatID() + 1);
		flags.set("BVKanadeBondInCombat", true);
		
	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVKanadeBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVKanadeBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVKanadeBondInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVKanadeBondInCombat") != true || flags.get("BVKanadeBondCombatID") != combatID
			|| flags.get("BVKanadeBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
		flags.set("BVKanadeBondLastAwardedCombatID", combatID);
	},
 function followStageSkin(actor,entry)
 {
  local bv=::$bvvar{namespace},flags=actor.getFlags();
  local current=bv.getActorFlagString(actor,bv.ValkyrieSkinIDFlag);
  local last=bv.getActorFlagString(actor,"BVKanadeAutoSkin");
  if(last==null)last="kanade_tachibana_skin";
  // Native missing flags are false; use the shared string reader before comparing IDs.
  if(flags.get("BVKanadeManualSkin")==true||(current!=null&&current!=last))return true;
  local previous=bv.Kanade.AutoChangingSkin,granted=false;
  bv.Kanade.AutoChangingSkin=true;
  try{granted=bv.grantActorValkyrieSkinTrait(actor,"kanade_tachibana",null,entry.Skin);}
  catch(e){bv.Kanade.AutoChangingSkin=previous;throw e;}
  bv.Kanade.AutoChangingSkin=previous;
  if(granted)flags.set("BVKanadeAutoSkin",entry.Skin);
  return granted;
 },
 function deliverRewards(trait)
 {
  if(trait==null)return;
  local a=trait.getContainer().getActor(),k=::$bvvar{namespace}.Kanade;
  k.migrateEquipment(a,trait);
  k.upgradeEquipment(a);
  k.grantStageEquipment(a,0);
  local rotationReady=true;
  if(trait.hasTriggeredStage(100))rotationReady=::$bvvar{namespace}.attachTransientSkill(a,"kanade_sonic_rotation","kanade.bond.100").Success;
  // Older saves claimed rewards while the first automatic outfit was skipped.
  // Repair only that missing skin ledger, without reopening rewards or notices.
  if(::$bvvar{namespace}.getActorFlagString(a,"BVKanadeAutoSkin")==null)
  {
   local latest=null;
   foreach(entry in ::$bvvar{namespace}.KanadeBondStages)
    if(trait.hasTriggeredStage(entry.Value)&&trait.hasClaimedStage(entry.Value)
     &&(latest==null||entry.Value>latest.Value))latest=entry;
   if(latest!=null&&!this.followStageSkin(a,latest))return;
  }
  foreach(value in trait.m.TriggeredStages)
  {
   if(!k.grantStageEquipment(a,value))continue;
   if(trait.hasClaimedStage(value))continue;
   if(value==100&&!rotationReady)continue;
   local entry=this.stage(value);
   if(entry==null)continue;
   if(!this.followStageSkin(a,entry))continue;
   trait.addStage(trait.m.ClaimedStages,value);trait.addStage(trait.m.NoticeStages,value);
  }
 },
 function rewardNotice(trait,value)
 {
  if(!trait.hasClaimedStage(value))return "$bv{kanade.bond.reward_pending}";
  return "$bv{kanade.bond.reward_notice}";
 },
	function locations(value)
	{
		local result = [];
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.kanade_tachibana_bond_" + value) result.push(location);
		return result;
	},
	function reveal(location)
	{
		location.setVisibleInFogOfWar(true); location.setDiscovered(true);
		if (location.hasSprite("selection")) location.getSprite("selection").Visible = true;
		::World.uncoverFogOfWar(location.getTile().Pos, 500.0);
	},
	function spawn(value)
	{
		local trait = this.findTrait();
		if (trait == null || this.stage(value) == null || trait.hasTriggeredStage(value)) return false;
		local recovery = trait.hasChallengeSpawnedStage(value);
		if (!recovery && trait.getNextPendingStage() != value) return false;
		local existing = this.locations(value);
		if (existing.len() > 0)
		{
			if (!recovery && !trait.startChallengeStage(value)) return false;
			this.reveal(existing[0]);
			for (local i = 1; i < existing.len(); ++i) existing[i].die();
			return true;
		}
		// Reuse the established nearby land search and faction adapters.
		local tile = ::$bvvar{namespace}.getHimekoBondChallengeSpawnTile();
		if (tile == null) return false;
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/kanade_tachibana_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Kanade bond camp creation failed: " + e); return false; }
		if (!recovery && !trait.startChallengeStage(value)) { location.die(); return false; }
		return true;
	},
	function maintain()
	{
		local trait = this.findTrait();
		if (trait == null) return null;
		this.deliverRewards(trait);
		foreach (value in trait.m.ChallengeSpawnedStages) if (this.locations(value).len() == 0) this.spawn(value);
		return trait;
	},
	function completeCamp(location)
	{
		local trait = this.findTrait(), value = location.getBondStage();
		if (trait == null || !this.wasVictorious(trait.getContainer().getActor())
			|| location.getFlags().get("BVKanadeBondCombatID") != this.combatID()) return false;
		// Stage 80 only requires the verified native victory above, even if combat
		// ended before the tactical objective service could publish its result.
		if(value != 80 && location.getFlags().get("BVKanadeObjectiveWon") != true)return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null) return false;
		this.ShopRequested=!trait.hasPendingStage()&&trait.getNoticeStage()==0&&::$bvvar{namespace}.Kanade.missingEquipment(trait.getContainer().getActor()).len()>0;
		if (!trait.hasPendingStage() && trait.getNoticeStage()==0 && !this.ShopRequested) return false;
		return ::World.Events.updateSpecialEvents();
	}
};

::$bvvar{namespace}.hasKanadeBondUpgrade <- function(actor, stage)
{
 if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "kanade_tachibana") return false;
 local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.KanadeBondTraitID);
 return trait != null && trait.hasTriggeredStage(stage);
};
::$bvvar{namespace}.KanadeBond.skinUnlocked <- function(actor,stage)
{
 if(stage==0)return true;
 if(actor==null){local t=this.findTrait();actor=t==null?null:t.getContainer().getActor();}
 return ::$bvvar{namespace}.hasKanadeBondUpgrade(actor,stage);
};
