::$bvvar{namespace}.MH.hook("scripts/ui/screens/tactical/tactical_screen",function(q){
 q.onKanadeRotationPreview <- function(data){return ::$bvvar{namespace}.KanadeRotationPreview.request(this,data);};
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state",function(q){
 q.setActionStateBySkillId=@(__original) function(id)
 {
  local p=::$bvvar{namespace}.KanadeRotationPreview,a=::Tactical.TurnSequenceBar.getActiveEntity();
  if(a!=null&&p.open(this,a,a.getSkills().getSkillByID(id)))return;
  p.close();return __original(id);
 };
 q.setActionStateBySkillIndex=@(__original) function(index)
 {
  local p=::$bvvar{namespace}.KanadeRotationPreview,a=::Tactical.TurnSequenceBar.getActiveEntity();
  if(a!=null){local skills=a.getSkills().queryActives();if(index>=0&&index<skills.len()&&p.open(this,a,skills[index]))return;}
  p.close();return __original(index);
 };
 q.setActionStateBySkill=@(__original) function(actor,skill)
 {
  local p=::$bvvar{namespace}.KanadeRotationPreview;if(p.open(this,actor,skill))return;
  p.close();return __original(actor,skill);
 };
 q.executeEntitySkill=@(__original) function(actor,tile)
 {
  local p=::$bvvar{namespace}.KanadeRotationPreview;
  if(p.matches(actor.getSkills().getSkillByID(this.m.SelectedSkillID))&&!p.Confirming)return;
  return __original(actor,tile);
 };
 q.updateCursorAndTooltip=@(__original) function(selected=false)
 {
  // Hovering or clicking the battlefield must not move the fixed preview or submit it.
  if(::$bvvar{namespace}.KanadeRotationPreview.Current!=null)return;
  return __original(selected);
 };
 q.cancelEntitySkill=@(__original) function(actor)
 {
  ::$bvvar{namespace}.KanadeRotationPreview.close(false);return __original(actor);
 };
 q.onKeyInput=@(__original) function(key)
 {
  local p=::$bvvar{namespace}.KanadeRotationPreview;
  if(p.Current!=null&&key.getKey()==41){if(key.getState()==0)p.close();return true;}
  return __original(key);
 };
 q.onUpdate=@(__original) function(){local result=__original();::$bvvar{namespace}.KanadeRotationPreview.refresh(this);return result;};
 q.onBattleEnded=@(__original) function(){::$bvvar{namespace}.KanadeRotationPreview.close();return __original();};
 q.onFinish=@(__original) function(){::$bvvar{namespace}.KanadeRotationPreview.close();return __original();};
});
