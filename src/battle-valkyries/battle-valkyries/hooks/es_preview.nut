::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/tactical_screen",function(q){q.onEsPreview <- function(data){return ::$bvvar{namespace}.EsPreview.request(this,data);};});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.executeEntitySkill=@(__original) function(actor,tile)
 {
  local p=::$bvvar{namespace}.EsPreview;
  if(!p.Confirming&&p.open(this,actor,actor.getSkills().getSkillByID(this.m.SelectedSkillID),tile))return;
  return __original(actor,tile);
 };
 q.updateCursorAndTooltip=@(__original) function(selected=false){if(::$bvvar{namespace}.EsPreview.Current!=null)return;return __original(selected);};
 q.cancelEntitySkill=@(__original) function(actor){local p=::$bvvar{namespace}.EsPreview;p.close(false);return __original(actor);};
 q.onKeyInput=@(__original) function(key){local p=::$bvvar{namespace}.EsPreview;if(p.Current!=null&&key.getKey()==41){if(key.getState()==0)p.close();return true;}
 return __original(key);};
 q.onUpdate=@(__original) function(){local ret=__original();::$bvvar{namespace}.EsPreview.refresh(this);return ret;};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.EsPreview.close();return __original();};
 q.onFinish=@(__original) function(){::$bvvar{namespace}.EsPreview.close();return __original();};
});
