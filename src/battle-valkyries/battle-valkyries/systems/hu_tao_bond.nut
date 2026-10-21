::$bvvar{namespace}.HuTaoBondTraitID <- "$bvvar{modId}.trait.hu_tao_bond";
::$bvvar{namespace}.HuTaoBond <- {
 ShopRequested=false,
	function ensureTrait(actor)
	{
		if (actor == null || ::$bvvar{namespace}.getActorValkyrieID(actor) != "hu_tao") return null;
		local skills = actor.getSkills(), trait = skills.getSkillByID(::$bvvar{namespace}.HuTaoBondTraitID);
		if (trait == null)
		{
			trait = ::new("scripts/skills/traits/battle_valkyries/hu_tao_bond_trait"); skills.add(trait);
		}
		return trait;
	},
	function findTrait()
	{
		if (!("World" in getroottable()) || ::World == null || !("getPlayerRoster" in ::World) || ::World.getPlayerRoster() == null) return null;
		foreach (actor in ::World.getPlayerRoster().getAll())
			if (::$bvvar{namespace}.getActorValkyrieID(actor) == "hu_tao" && !::$bvvar{namespace}.isActorDeadOrDying(actor)) return this.ensureTrait(actor);
		return null;
	},
	function stage(value)
	{
		foreach (entry in ::$bvvar{namespace}.HuTaoBondStages) if (entry.Value == value) return entry;
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
		flags.set("BVHuTaoBondCombatID", this.combatID() + 1);
		flags.set("BVHuTaoBondInCombat", true);
        ::$bvvar{namespace}.HuTaoEquipment.start(actor);

	},
	function wasVictorious(actor)
	{
		return actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getFlags().get("BVHuTaoBondCombatID") == this.combatID()
			&& actor.getFlags().get("BVHuTaoBondInCombat") == true
			&& ::World.Statistics.getFlags().get("LastCombatResult") == 1;
	},
	function finishCombat()
	{
		local trait = this.findTrait();
		if (trait != null)
		{
			local actor = trait.getContainer().getActor();
			this.awardCombatBond(this.combatID());
			actor.getFlags().set("BVHuTaoBondInCombat", false);
			this.deliverRewards(trait);
		}
	},
	function awardCombatBond(combatID)
	{
		local trait = this.findTrait();
		if (trait == null) return;
		local flags = trait.getContainer().getActor().getFlags();
		if (flags.get("BVHuTaoBondInCombat") != true || flags.get("BVHuTaoBondCombatID") != combatID
			|| flags.get("BVHuTaoBondLastAwardedCombatID") == combatID
			|| ::World.Statistics.getFlags().get("LastCombatResult") != 1) return;
		trait.addBond(4);
        ::$bvvar{namespace}.HuTaoEquipment.victory(trait.getContainer().getActor(),combatID);
		flags.set("BVHuTaoBondLastAwardedCombatID", combatID);
	},
 function skinUnlocked(actor=null)
 {
  local trait=actor==null?this.findTrait():this.ensureTrait(actor);
  return trait!=null&&trait.hasTriggeredStage(100);
 },
 function deliverRewards(trait)
 {
  if(trait==null)return;local actor=trait.getContainer().getActor(),equipment=::$bvvar{namespace}.HuTaoEquipment,ready=true;
  foreach(key,d in equipment.Items)if(!equipment.grant(actor,key))ready=false;
  equipment.sync(actor);
  local result=::$bvvar{namespace}.syncActorSkills(actor,"hu-tao-bond-reward");if(!result.Success||!ready)return;
  foreach(value in trait.m.TriggeredStages)
  {
   local changed=trait.addStage(trait.m.ClaimedStages,value);
   if(changed)trait.addStage(trait.m.NoticeStages,value);
  }
 },
 function rewardNotice(trait,value){return trait.hasClaimedStage(value)?"$bv{hu_tao.bond.claimed}":"$bv{hu_tao.bond.pending}";},
 function campStage(location)
 {
  if(location==null||!location.isLocation()||!location.getFlags().has("BVHuTaoBondStage"))return null;
  local value=location.getFlags().get("BVHuTaoBondStage");
  return typeof value=="integer"&&location.getTypeID()=="$bvvar{modId}.location.hu_tao_bond_"+value?this.stage(value):null;
 },
	function locations(value)
	{
		local result = [];
		local trait=this.findTrait();if(trait==null)return result;
		local owner=::$bvvar{namespace}.HuTaoEquipment.ownerKey(trait.getContainer().getActor());
		foreach (location in ::World.EntityManager.getLocations())
			if (location != null && location.isAlive() && location.getTypeID() == "$bvvar{modId}.location.hu_tao_bond_" + value && location.getFlags().get("BVHuTaoOwner")==owner) result.push(location);
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
		local location = ::World.spawnLocation("scripts/entity/world/locations/battle_valkyries/hu_tao_bond_camp_location", tile.Coords);
		if (location == null) return false;
		try { location.configure(value); location.getFlags().set("BVHuTaoOwner",::$bvvar{namespace}.HuTaoEquipment.ownerKey(trait.getContainer().getActor())); location.onSpawned(); }
		catch (e) { location.die(); ::logWarning("[Battle Valkyries] Hu Tao bond camp creation failed: " + e); return false; }
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
            || location.getFlags().get("BVHuTaoOwner")!=::$bvvar{namespace}.HuTaoEquipment.ownerKey(trait.getContainer().getActor())
            || location.getFlags().get("BVHuTaoBondCombatID") != this.combatID()) return false;
		if(!::$bvvar{namespace}.HuTaoChallenge.objectivesMet(value))return false;
		return trait.completeChallengeStage(value);
	},
	function checkEvent()
	{
		local trait = this.maintain();
		if (trait == null) return false;
        this.ShopRequested=!trait.hasPendingStage()&&trait.getNoticeStage()==0&&::$bvvar{namespace}.HuTaoEquipment.missingKeys(trait.getContainer().getActor()).len()>0;
        if(!trait.hasPendingStage()&&trait.getNoticeStage()==0&&!this.ShopRequested&&trait.getContainer().getActor().getFlags().get("BVHuTaoPrologue")==true)return false;
		return ::World.Events.updateSpecialEvents();
	}
};
