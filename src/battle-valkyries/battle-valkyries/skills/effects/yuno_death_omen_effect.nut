this.yuno_death_omen_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		OwnerRef = null,
		OwnerID = null,
		ConsumeToken = null,
		Consumed = false,
		Refunded = false,
		FixedDamage = 20
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.yuno_death_omen";
		this.m.Name = "$bv{effect.yuno_death_omen.name}";
		this.m.Description = "$bv{effect.yuno_death_omen.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yuno_fate_rewrite.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/yuno_fate_rewrite_sw.png";
		this.m.IconMini <- "status_effect_74_mini";
		this.m.Overlay <- "status_effect_74";
		this.m.IsStacking = false;
		this.m.OwnerRef = null;
		this.m.OwnerID = null;
		this.m.ConsumeToken = {};
		this.m.Consumed = false;
		this.m.Refunded = false;
		this.m.FixedDamage = 20;
	}

	function setYunoOwner( _owner )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		return this;
	}

	function getYunoOwner()
	{
		local owner = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
		return owner != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == this.m.OwnerID ? owner : null;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{effect.yuno_death_omen.tooltip.attack}" },
			{ id = 4, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{effect.yuno_death_omen.tooltip.followup}" },
			{ id = 5, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.yuno_death_omen.tooltip.refund}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.yuno_death_omen.tooltip.duration}" }
		];
	}

	function isEligibleAttackSource( _attacker, _usedSkill )
	{
		local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_attacker, _usedSkill);
		if (frame == null || !("Source" in frame) || frame.Source == null) return true;
		local source = frame.Source;
		return source != "dot" && source != "terrain" && source != "reflection"
			&& source != "fixed" && (typeof source != "string" || source.find("fixed") == null);
	}

	function getValkyrieAttackDefensePolicy( _usedSkill )
	{
		if (this.m.Consumed) return null;
		local owner = this.getYunoOwner();
		local attacker = null;
		try { attacker = _usedSkill.getContainer().getActor(); } catch (e) { attacker = null; }
		if (owner == null || attacker == null || !::$bvvar{namespace}.isDirectAttack(_usedSkill)
			|| !this.isEligibleAttackSource(attacker, _usedSkill)
			|| !attacker.isAlliedWith(owner))
		{
			return null;
		}
		return { HitChanceBonus = 35, IgnoreActualShield = true, ConsumeToken = this.m.ConsumeToken };
	}

	function restoreActionPoints( _actor, _amount )
	{
		if (_actor == null || _amount <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(_actor)) return;
		_actor.setActionPoints(this.Math.min(_actor.getActionPointsMax(), _actor.getActionPoints() + _amount));
		_actor.setDirty(true);
	}

	function refundKill( _attacker, _owner )
	{
		if (this.m.Refunded) return;
		this.m.Refunded = true;
		this.restoreActionPoints(_attacker, 4);
		this.restoreActionPoints(_owner, 4);
	}

	function applyHunt( _target, _owner )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return null;
		local existing = _target.getSkills().getSkillByID("$bvvar{modId}.effects.yuno_destined_hunt");
		if (existing != null)
		{
			existing.setYunoOwner(_owner);
			existing.onRefresh();
			return existing;
		}
		local effect = this.new("$bvvar{privateFolder}/skills/effects/yuno_destined_hunt_effect");
		effect.setYunoOwner(_owner);
		_target.getSkills().add(effect);
		return effect;
	}

	function consumeValkyrieAttackDefensePolicy( _token, _context )
	{
		if (this.m.Consumed || _token != this.m.ConsumeToken || _context == null) return;
		local owner = this.getYunoOwner();
		local target = "Target" in _context ? _context.Target : (this.getContainer() == null ? null : this.getContainer().getActor());
		local attacker = "User" in _context ? _context.User : null;
		this.m.Consumed = true;
		this.removeSelf();

		if (target == null) return;
		if (::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			this.refundKill(attacker, owner);
			return;
		}
		local nullified = ("Nullified" in _context && _context.Nullified)
			|| ("Result" in _context && _context.Result != null && typeof _context.Result == "table"
				&& "Nullified" in _context.Result && _context.Result.Nullified);
		if (!("Hit" in _context) || !_context.Hit || nullified)
		{
			this.applyHunt(target, owner);
			return;
		}

		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, target, this.m.FixedDamage, { Source = "yuno_death_omen_fixed" });
		if (::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			this.refundKill(attacker, owner);
			return;
		}

		::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, target, {
			AutoHit = true,
			WeaponDamageMult = 1.0,
			ArmorDamageMult = 1.0,
			IgnoreDistance = true
		});
		if (::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			this.refundKill(attacker, owner);
			return;
		}

		target.setActionPoints(this.Math.max(0, target.getActionPoints() - 4));
		::$bvvar{namespace}.addOrRefreshStatus(owner, target, { Type = "dazed", Turns = 1 });
		this.applyHunt(target, owner);
	}

	function onNewRound()
	{
		this.removeSelf();
	}

	function onDeath( _fatalityType )
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		if (actor == null || !("ValkyrieCombatEvents" in ::$bvvar{namespace})) return;

		local actorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(actor);
		local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(actor);
		if (actorRef == null || actorID == null) return;

		// Death and attack-claim finalization occur in the same resolution chain.
		// Never retain this container-managed effect across the Time boundary:
		// resolve the exact effect again from weak actor identity and its one-use token.
		local tag = {
			ActorRef = actorRef,
			ActorID = actorID,
			EffectID = this.m.ID,
			ConsumeToken = this.m.ConsumeToken,
			Epoch = ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch
		};
		::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _tag )
		{
			try
			{
				if (!("ValkyrieCombatEvents" in ::$bvvar{namespace})
					|| ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch != _tag.Epoch)
				{
					return;
				}

				local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.ActorRef);
				if (actor == null || ::$bvvar{namespace}.getValkyrieCombatObjectID(actor) != _tag.ActorID) return;
				local skills = actor.getSkills();
				if (skills == null) return;
				local effect = skills.getSkillByID(_tag.EffectID);
				if (effect == null || effect.isGarbage()
					|| !("ConsumeToken" in effect.m) || effect.m.ConsumeToken != _tag.ConsumeToken
					|| ("Consumed" in effect.m && effect.m.Consumed))
				{
					return;
				}
				effect.removeSelf();
			}
			catch (e)
			{
			}
		}, tag);
	}

	function onCombatFinished()
	{
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
