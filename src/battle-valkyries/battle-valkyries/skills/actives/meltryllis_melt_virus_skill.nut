this.meltryllis_melt_virus_skill <- this.inherit("$bvvar{privateFolder}/skills/actives/meltryllis_active_skill", {
	m = {},
	function create() { this.meltryllis_active_skill.create(); }
	function onUse(_user, _targetTile)
	{
		if (!this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local skills = _targetTile.getEntity().getSkills();
		local effect = skills.getSkillByID("$bvvar{modId}.effects.meltryllis_virus");
		if (effect == null) skills.add(this.new("$bvvar{privateFolder}/skills/effects/meltryllis_virus_effect")); else effect.onRefresh();
		local absorption = this.getContainer().getSkillByID("$bvvar{modId}.effects.meltryllis_absorption");
		if (absorption == null) this.getContainer().add(this.new("$bvvar{privateFolder}/skills/effects/meltryllis_absorption_effect")); else absorption.onRefresh();
		_user.setFatigue(this.Math.max(0, _user.getFatigue() - 15));
		this.startCooldown();
		if (skills.getSkillByID("$bvvar{modId}.effects.meltryllis_virus") != null
			&& this.getContainer().getSkillByID("$bvvar{modId}.effects.meltryllis_absorption") != null
			&& "playValkyrieSkillAudio" in ::$bvvar{namespace})
		{
			local position = ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(_targetTile.getEntity());
			if (position != null) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "meltryllis_melt_virus_apply", position);
		}
		return true;
	}
});
