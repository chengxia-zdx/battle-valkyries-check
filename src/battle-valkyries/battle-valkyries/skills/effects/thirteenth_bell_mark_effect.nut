this.thirteenth_bell_mark_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owners = null },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effect.thirteenth_bell_mark";
		this.m.Name = "$bv{chapter.thirteenth_bell.mark.name}"; this.m.Description = "$bv{chapter.thirteenth_bell.mark.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/thirteenth_bell_promise.png"; this.m.IconMini = "status_effect_54_mini"; this.m.Owners = [];
	},
	function addOwner(a, epoch, turn)
	{
		local bv = ::$bvvar{namespace};
		foreach (row in this.m.Owners) if (row.ID == a.getID()) { row.Epoch = epoch; row.Turn = turn; return; }
		this.m.Owners.push({ ID = a.getID(), Ref = bv.makeValkyrieCombatWeakRef(a), Epoch = epoch, Turn = turn });
	},
	function valid(row)
	{
		local bv = ::$bvvar{namespace}, f = bv.ThirteenthBell, a = bv.readValkyrieCombatWeakRef(row.Ref);
		if (!f.owns(a, "rachel_alucard") || !f.entitled(a, "promise")) return null;
		local s = f.state(a); return s.Epoch == row.Epoch && s.Turn == row.Turn ? a : null;
	},
	function takeOwner()
	{
		local f = ::$bvvar{namespace}.ThirteenthBell;
		for (local i = 0; i < this.m.Owners.len(); ++i)
		{
			local a = this.valid(this.m.Owners[i]); if (a == null || f.state(a).UsedRound == ::Time.getRound()) continue;
			f.state(a).UsedRound = ::Time.getRound(); this.m.Owners.remove(i); if (this.m.Owners.len() == 0) this.removeSelf(); return a;
		}
		return null;
	},
	function onUpdate(p)
	{
		for (local i = this.m.Owners.len() - 1; i >= 0; --i) if (this.valid(this.m.Owners[i]) == null) this.m.Owners.remove(i);
		this.m.IsHidden = this.m.Owners.len() == 0;
	},
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; },
	function onCombatFinished() { this.m.Owners = []; this.removeSelf(); }
});
