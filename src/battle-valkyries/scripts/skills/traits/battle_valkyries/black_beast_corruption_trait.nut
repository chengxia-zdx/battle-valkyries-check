// The stable per-character subclasses fix RoleID. The existing schema is reused unchanged.
this.black_beast_corruption_trait <- this.inherit("scripts/skills/traits/battle_valkyries/olga_corruption_trait", {
    m = { RoleID = "" },
    function create()
    {
        this.olga_corruption_trait.create();
        this.m.ID = "$bvvar{modId}.trait." + this.m.RoleID + "_corruption";
        this.m.Name = "$bv{black_beast.corruption.name}";
        this.m.Description = "$bv{black_beast.corruption.description}";
        this.m.Icon = "ui/traits/$bvvar{iconPrefix}/" + this.m.RoleID + "_trait_icon.png";
    }
    function getTooltip()
    {
        local ret = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() },
            { id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{olga.corruption.value}" + this.getCorruption() + " / 100" }];
        foreach (stage in ::$bvvar{namespace}.BlackBeastCorruptionStages[this.m.RoleID])
        {
            local state = this.hasTriggeredStage(stage.Value) ? (this.hasClaimedStage(stage.Value) ? "$bv{olga.corruption.done}" : "$bv{olga.corruption.unclaimed}")
                : (this.hasChallengeSpawnedStage(stage.Value) ? "$bv{olga.corruption.challenge}" : (this.hasPendingStageValue(stage.Value) ? "$bv{olga.corruption.pending}" : "$bv{olga.corruption.locked}"));
            ret.push({ id = 10 + stage.Value, type = "text", icon = "ui/icons/special.png", text = stage.Value + "  " + stage.Name + " — " + state });
        }
        return ret;
    }
});
