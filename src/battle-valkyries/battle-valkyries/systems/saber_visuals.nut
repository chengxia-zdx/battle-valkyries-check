// Dedicated artwork; the shared renderer remains responsible for actor validity and failure isolation.
foreach (key, theme in {
 saber_mana_ready = {Effect="effect_bv_saber_oath_ring",Color="#ffffff",Scale=0.35,EndScale=0.85,Duration=650,Layers=1,Offsets=[{X=0,Y=-30}]},
 saber_excalibur_cast = {Effect="effect_bv_saber_oath_release",Color="#ffffff",Scale=0.35,EndScale=0.8,Duration=850,Layers=1,Offsets=[{X=0,Y=36}]},
 saber_mana_release_ring = {Effect="effect_bv_saber_oath_ring",Color="#ffffff",Scale=0.35,EndScale=1.05,Duration=1000,Layers=2,DelayStep=120,Offsets=[{X=0,Y=-30}]},
 saber_mana_release_burst = {Effect="effect_bv_saber_oath_release",Color="#ffffff",Scale=0.4,EndScale=0.95,Duration=900,Layers=1,Offsets=[{X=0,Y=36}]}
}) ::$bvvar{namespace}.ValkyrieVisualThemes[key] <- theme;

::$bvvar{namespace}.playSaberLineVisual <- function(context, user, targetTile, ultimate)
{
 // Snapshot the actual trajectory before damage, knockback or removal of a lethal target.
 // Six pre-rotated brushes avoid relying on an unsupported runtime rotation parameter.
 try
 {
  if (context==null || user==null || targetTile==null || ::$bvvar{namespace}.isActorDeadOrDying(user) || !user.isPlacedOnMap()) return false;
  local origin=user.getTile();
  local tiles=::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(origin,targetTile);
  if (tiles.len()==0) return false;
  local direction=origin.getDirectionTo(tiles[0]);
  if (direction<0 || direction>5) return false;
  local tactical=null, color=null;
  try { tactical=context.Tactical; } catch(e) { tactical=::Tactical; }
  try { color=context.createColor("#ffffff"); } catch(e) { color=::createColor("#ffffff"); }
  if (tactical==null) return false;
  local brush="effect_bv_saber_oath_"+(ultimate?"beam":"wind")+"_"+direction;
  if (!ultimate) ::$bvvar{namespace}.playValkyrieVisual(context,user,"saber_mana_ready",{Scale=0.25,EndScale=0.6,Duration=350});
  local index=0;
  foreach(tile in tiles)
  {
   if(tile==null)continue;
   tactical.spawnSpriteEffect(brush,color,tile,0,24,ultimate?0.55:0.45,ultimate?0.95:0.8,
    (ultimate?180:0)+index*45,ultimate?650:420,200);
   index++;
  }
  return true;
 }
 catch(e) { ::logWarning("[Battle Valkyries] Saber visual skipped: "+e); return false; }
};
