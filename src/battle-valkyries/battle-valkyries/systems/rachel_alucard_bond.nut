::$bvvar{namespace}.RachelBondTraitID <- "$bvvar{modId}.trait.rachel_alucard_bond";
::$bvvar{namespace}.RachelBond <- {

	function ensureTrait(actor)
	{
		if (actor == null || !::$bvvar{namespace}.Rachel.owns(actor)) return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.RachelBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/rachel_alucard_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (!("World" in getroottable()) || ::World == null || !("getPlayerRoster" in ::World) || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (::$bvvar{namespace}.Rachel.owns(actor) && !::$bvvar{namespace}.isActorDeadOrDying(actor)) return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.RachelBondStages) if (entry.Value == value) return entry;
		return null;
	},
	function combatID()
	{
		local id = ::World.Statistics.getFlags().get("LastCombatID");
		return typeof id == "integer" ? id : 0;
	},
	function startCombat(actor)
	{
		if (!::$bvvar{namespace}.Rachel.alive(actor) || this.ensureTrait(actor) == null) return;
		local flags = actor.getFlags();
		flags.set("BVRachelBondCombatID", this.combatID() + 1);
		flags.set("BVRachelBondInCombat", true);

	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVRachelBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVRachelBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVRachelBondInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVRachelBondInCombat") != true || flags.get("BVRachelBondCombatID") != combatID
			|| flags.get("BVRachelBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
		flags.set("BVRachelBondLastAwardedCombatID", combatID);
	},
 function ownerKey(actor)
 {
  local key=::$bvvar{namespace}.getActorFlagString(actor,"BVRachelBondOwner");
  if(key==null){key="rachel:"+actor.getID();actor.getFlags().set("BVRachelBondOwner",key);}
  return key;
 },
 function deliverRewards(trait)
 {
  if(trait==null)return false;
  local actor=trait.getContainer().getActor();
  if(!::$bvvar{namespace}.Rachel.owns(actor))return false;
  // Only consecutive victories authorize progression. Bond amount and page state never do.
  local stage=0;
  foreach(value in [20,40,60,80,100])
  {
   if(!trait.hasTriggeredStage(value))break;
   stage++;
  }
  local flags=actor.getFlags(),key="$bvvar{modId}.rachel.bond_stage",old=flags.get(key);
  flags.set(key,stage);
  local result=::$bvvar{namespace}.syncActorSkills(actor,"rachel-bond-reward");
  if(!result.Success){flags.set(key,old);return false;}
  actor.getSkills().update();
  foreach(value in [20,40,60,80,100])
   if(value<=stage*20&&!trait.hasClaimedStage(value))
   {
    trait.addStage(trait.m.ClaimedStages,value);
    trait.addStage(trait.m.NoticeStages,value);
   }
  return true;
 },
 function rewardNotice(trait,value){return trait.hasClaimedStage(value)?"$bv{rachel.bond.claimed}":"$bv{rachel.bond.pending}";},
 function campStage(location)
 {
  if(location==null||!location.isLocation()||!location.getFlags().has("BVRachelBondStage"))return null;
  local value=location.getFlags().get("BVRachelBondStage");
  return typeof value=="integer"&&location.getTypeID()=="$bvvar{modId}.location.rachel_alucard_bond_"+value?this.stage(value):null;
 },
	function locations(value)
	{
		local result = [];
		local trait=this.findTrait();if(trait==null)return result;
		local owner=this.ownerKey(trait.getContainer().getActor());
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.rachel_alucard_bond_" + value && location.getFlags().get("BVRachelOwner")==owner) result.push(location);
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
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/rachel_alucard_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.getFlags().set("BVRachelOwner",this.ownerKey(trait.getContainer().getActor())); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Rachel bond camp creation failed: " + e); return false; }
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
            || location.getFlags().get("BVRachelOwner")!=this.ownerKey(trait.getContainer().getActor())
            || location.getFlags().get("BVRachelBondCombatID") != this.combatID()) return false;
		if(!trait.completeChallengeStage(value))return false;
        // Native location settlement runs before ironman autosave.
        this.deliverRewards(trait);
        return true;
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null) return false;
        if(!trait.hasPendingStage()&&trait.getNoticeStage()==0)return false;
		return ::World.Events.updateSpecialEvents();
	}
};
