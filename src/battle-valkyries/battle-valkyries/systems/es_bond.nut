::$bvvar{namespace}.EsBondTraitID <- "$bvvar{modId}.trait.es_bond";
::$bvvar{namespace}.EsBond <- {
 ShopRequested=false,
	function ensureTrait(actor)
	{
		if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "es") return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.EsBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/es_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (!("World" in getroottable()) || ::World == null || !("getPlayerRoster" in ::World) || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (::$bvvar{namespace}.getActorValkyrieID(actor) == "es" && !::$bvvar{namespace}.isActorDeadOrDying(actor)) return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.EsBondStages) if (entry.Value == value) return entry;
		return null;
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
		flags.set("BVEsBondCombatID", this.combatID() + 1);
		flags.set("BVEsBondInCombat", true);

	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVEsBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVEsBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVEsBondInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVEsBondInCombat") != true || flags.get("BVEsBondCombatID") != combatID
			|| flags.get("BVEsBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
		flags.set("BVEsBondLastAwardedCombatID", combatID);
	},
 function deliverRewards(trait)
 {
  if(trait==null)return;
  local actor=trait.getContainer().getActor();
  ::$bvvar{namespace}.EsEquipment.grant(actor);
  // One sync transaction rebuilds all entitlements, including the paired stage-20 skills.
  local result=::$bvvar{namespace}.syncActorSkills(actor,"es-bond-reward");
  if(!result.Success)return;
  foreach(value in trait.m.TriggeredStages)
  {
   local stage=this.stage(value),flags=actor.getFlags(),changed=false;
   local ready=true;
   foreach(key in stage.Skills)
    if(actor.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID(key))==null)ready=false;
   if(!ready)continue;
   // Separate actor ledgers backfill old completed stages without replaying rewards.
   local perkFlag="BVEsBondPerkGranted"+value;
   if(flags.get(perkFlag)!=true)
   {
    actor.setPerkPoints(actor.getPerkPoints()+stage.PerkPoints);
    flags.set(perkFlag,true);changed=true;
   }
   foreach(key in stage.Equipment)
   {
    local wasGranted=flags.get(::$bvvar{namespace}.EsEquipment.Items[key].Flag)==true;
    if(!::$bvvar{namespace}.EsEquipment.grant(actor,key))ready=false;
    else if(!wasGranted)changed=true;
   }
   if(!ready)
   {
    trait.removeStage(trait.m.ClaimedStages,value);
    trait.addStage(trait.m.NoticeStages,value);
    continue;
   }
   if(trait.hasClaimedStage(value)&&!changed)continue;
   trait.addStage(trait.m.ClaimedStages,value);trait.addStage(trait.m.NoticeStages,value);
  }
 },
 function rewardNotice(trait,value){return trait.hasClaimedStage(value)?"$bv{es.bond.claimed}":"$bv{es.bond.pending}";},
 function campStage(location)
 {
  if(location==null||!location.isLocation()||!location.getFlags().has("BVEsBondStage"))return null;
  local value=location.getFlags().get("BVEsBondStage");
  return typeof value=="integer"&&location.getTypeID()=="$bvvar{modId}.location.es_bond_"+value?this.stage(value):null;
 },
	function locations(value)
	{
		local result = [];
		local trait=this.findTrait();if(trait==null)return result;
		local owner=::$bvvar{namespace}.EsEquipment.ownerKey(trait.getContainer().getActor());
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.es_bond_" + value && location.getFlags().get("BVEsOwner")==owner) result.push(location);
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
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/es_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.getFlags().set("BVEsOwner",::$bvvar{namespace}.EsEquipment.ownerKey(trait.getContainer().getActor())); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Es bond camp creation failed: " + e); return false; }
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
			|| this.campStage(location)==null
            || location.getFlags().get("BVEsOwner")!=::$bvvar{namespace}.EsEquipment.ownerKey(trait.getContainer().getActor())
            || location.getFlags().get("BVEsBondCombatID") != this.combatID()) return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null) return false;
        this.ShopRequested=!trait.hasPendingStage()&&trait.getNoticeStage()==0&&::$bvvar{namespace}.EsEquipment.missingKeys(trait.getContainer().getActor()).len()>0;
        if(!trait.hasPendingStage()&&trait.getNoticeStage()==0&&!this.ShopRequested&&trait.getContainer().getActor().getFlags().get("BVEsPrologue")==true)return false;
		return ::World.Events.updateSpecialEvents();
	}
};
