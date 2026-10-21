(function(){
 "use strict";
 var namespace="$bvvar{namespace}",copy={failed:"$bv{ryza.alchemy.failed}"};
 function el(tag,cls,text){var n=$("<"+tag+">").addClass(cls||"");if(text!==undefined)n.text(text);return n;}
 // Native buttons do not inherit the translated game font from the detail root.
 function button(cls,label,fn){return el("button",cls+" text-font-normal",label).attr("type","button").on("click",fn);}
 function disabled(node,value){node.prop("disabled",!!value);}
 function Workshop(owner){
  this.owner=owner;this.hub=owner.hub;this.slot={Detail:{Alchemy:owner.slot.Detail.Alchemy}};this.busy=false;this.disposed=false;this.tabID="alchemy";
  this.previousFocus=document.activeElement;this.root=el("div","bv-ryza-overlay").attr({role:"dialog","aria-modal":"true","aria-label":"$bv{ryza.alchemy.title}"});
  var self=this,windowPanel=el("div","bv-ryza-window"),bar=el("div","bv-ryza-topbar");
  this.back=button("bv-detail-button","$bv{ryza.ext.close}",function(){self.close();});
  this.refreshButton=button("bv-detail-button","$bv{ryza.ext.reload}",function(){self.reload();});bar.append(this.back).append(this.refreshButton);
  this.content=el("div","bv-ryza-content");windowPanel.append(bar).append(this.content);this.root.append(windowPanel);owner.root.append(this.root);
  this.root.on("click",function(e){if(e.target===self.root[0])self.close();});
  this.content.on("wheel mousewheel DOMMouseScroll",function(e){self.hub.handleBodyWheel(e,self.content);});
  this.renderRyzaAlchemy();this.back[0].focus();this.reload();
 }
 Workshop.prototype.messages=function(){return this.owner.messages();};
 Workshop.prototype.close=function(focus){if(this.busy&&focus!==false)return;if(this.confirm&&focus!==false){this.confirm.remove();this.confirm=null;this.back[0].focus();return;}if(focus!==false&&this.closePicker(true))return;this.closePicker(false);this.disposed=true;this.root.remove();if(this.owner.ryzaWorkshop===this)this.owner.ryzaWorkshop=null;if(focus!==false&&this.previousFocus&&document.documentElement.contains(this.previousFocus))this.previousFocus.focus();};
 Workshop.prototype.closePicker=function(focus){if(!this.openPicker)return false;var picker=this.openPicker;this.openPicker=null;picker.List.hide();picker.Trigger.attr('aria-expanded','false');if(focus)picker.Trigger[0].focus();return true;};
 // Coherent's native select popup is unreliable. Keep every choice in the page.
 Workshop.prototype.choicePicker=function(id,label,placeholder,options,value,onChange,blocked){
  var self=this,box=el('div','bv-ryza-picker'),list=el('div','bv-ryza-choices').attr({id:id+'-choices',role:'group','aria-label':label}).hide(),caption=placeholder;
  for(var i=0;i<options.length;i++)if(String(options[i].ID)===String(value))caption=options[i].Name;
  var trigger=button('bv-ryza-select bv-ryza-picker-trigger',caption+' ▾',function(){
   if(self.openPicker&&self.openPicker.Trigger[0]===trigger[0]){self.closePicker(true);return;}
   self.closePicker(false);self.openPicker={Trigger:trigger,List:list};list.show();trigger.attr('aria-expanded','true');
  }).attr({id:id,'aria-label':label,'aria-expanded':'false','aria-controls':id+'-choices'});
  disabled(trigger,blocked);
  for(var n=0;n<options.length;n++)(function(option){
   var choice=button('bv-ryza-choice'+(String(option.ID)===String(value)?' is-selected':''),option.Name,function(){
    if(blocked||option.Disabled||self.busy||self.disposed)return;
    self.closePicker(false);onChange(option.ID);var next=self.content.find('#'+id);if(next.length)next[0].focus();
   }).attr({'data-choice-id':String(option.ID),'aria-pressed':String(option.ID)===String(value)?'true':'false'});
   disabled(choice,blocked||option.Disabled);list.append(choice);
  })(options[n]);
  if(!options.length)list.append(el('div','bv-ryza-choice-empty',"$bv{ryza.ext.no_candidates}"));
  list.on('wheel mousewheel DOMMouseScroll',function(e){self.hub.handleBodyWheel(e,list);});
  return box.append(trigger).append(list);
 };
 Workshop.prototype.reload=function(){var self=this;if(this.busy||this.disposed)return;this.busy=true;this.renderRyzaAlchemy();this.call("getRyzaAlchemyState",null,function(data){self.busy=false;if(data&&data.Recipes)self.slot.Detail.Alchemy=data;else self.slot.Detail.Alchemy.Editable=false;self.renderRyzaAlchemy();if(!data||!data.Recipes)self.hub.showMessage(data&&data.Message?data.Message:copy.failed,"$bv{ryza.alchemy.title}");});};
 Workshop.prototype.call=function(method,request,callback){
  var self=this,done=false,timer=setTimeout(function(){if(done||self.disposed)return;done=true;self.busy=false;self.slot.Detail.Alchemy.Editable=false;self.renderRyzaAlchemy();self.hub.showMessage("$bv{ryza.ext.timeout}","$bv{ryza.alchemy.title}");},20000);
  try{SQ.call(this.hub.mBackendHandle,method,request,function(result){if(done||self.disposed)return;done=true;clearTimeout(timer);callback(result);});}catch(e){clearTimeout(timer);self.busy=false;self.renderRyzaAlchemy();self.hub.showMessage(copy.failed,"$bv{ryza.alchemy.title}");}
 };
	Workshop.prototype.ryzaLabels = function()
	{
		return {single:"$bv{ryza.route.single}",triple:"$bv{ryza.route.triple}",fusion:"$bv{ryza.route.fusion}",upgrade:"$bv{ryza.route.upgrade}",brother:"$bv{ryza.ext.fusion}",augment:"$bv{ryza.ext.augments}"};
	};
	Workshop.prototype.ryzaStats = function(s)
	{
		var row = el("div", "bv-ryza-stats");
		if (!s) return row;
		var fields = [["$bv{ryza.pet.hp}",s.HP],["$bv{ryza.pet.armor}",s.Body+" / "+s.Head],["$bv{ryza.pet.damage}",s.Min+"–"+s.Max+" / "+s.Armor+"% $bv{ryza.pet.armor_damage}"],["$bv{ryza.pet.accuracy}",s.Attack],["$bv{ryza.pet.defense}",s.MeleeDefense+" / "+s.RangedDefense],["$bv{ryza.pet.range}",s.Range],["$bv{ryza.ext.stat.Stamina}",s.Stamina],["$bv{ryza.ext.stat.Bravery}",s.Bravery],["$bv{ryza.ext.stat.Initiative}",s.Initiative]];
		for (var i=0;i<fields.length;i++) row.append(el("div", "").append(el("small","",fields[i][0])).append(el("strong","",fields[i][1])));
		return row;
	};
	Workshop.prototype.renderRyzaAlchemy = function()
	{
		var self=this, data=this.slot.Detail.Alchemy;disabled(this.back,this.busy);disabled(this.refreshButton,this.busy);
		if (!data) return;
		var catalogScroll=this.content.find(".bv-ryza-catalog").scrollTop()||0, contentScroll=this.content.scrollTop();
		this.closePicker(false);
		this.content.empty();
		var panel=el("div","bv-ryza"), title=el("div","bv-ryza-heading");
		title.append(el("div","").append(el("div","bv-detail-eyebrow","$bv{ryza.alchemy.eyebrow}")).append(el("h2","","$bv{ryza.alchemy.title}")));
		title.append(el("div","bv-ryza-money","$bv{ryza.alchemy.balance}"+data.Money));panel.append(title);
		panel.append(el("p","bv-ryza-intro",data.Description));
		if (!data.Editable) panel.append(el("p","bv-ryza-warning","$bv{ryza.alchemy.locked}"));
		var modes=el("div","bv-ryza-modes");
		function mode(id,label) { var b=button("bv-detail-button"+(self.ryzaMode===id?" is-selected":""),label,function(){self.ryzaMode=id;self.ryzaDraft=null;self.ryzaFilter="all";self.ryzaTier=id==="fusion"?3:1;self.renderRyzaAlchemy();});b.attr("aria-pressed",self.ryzaMode===id?"true":"false");disabled(b,self.busy);modes.append(b); }
		this.ryzaMode=this.ryzaMode||"recipes";mode("recipes","$bv{ryza.alchemy.recipes}");mode("fusion","$bv{ryza.ext.fusion}");mode("augments","$bv{ryza.ext.augments}");mode("pets","$bv{ryza.alchemy.my_pets}");panel.append(modes);
		this.content.append(panel);
		if(this.ryzaMode==="pets") { this.renderRyzaPets(panel,data);return; }
		this.ryzaTier=this.ryzaTier||1;
		var tools=el("div","bv-ryza-filters"), tiers=el("div","bv-ryza-tiers");
		for(var t=this.ryzaMode==="fusion"?3:1;t<=4;t++)(function(tier){var b=button("bv-detail-button"+(self.ryzaTier===tier?" is-selected":""),"T"+tier,function(){self.ryzaTier=tier;self.ryzaDraft=null;self.renderRyzaAlchemy();});b.attr("aria-pressed",self.ryzaTier===tier?"true":"false");disabled(b,self.busy);tiers.append(b);})(t);
		if(this.ryzaMode!=="augments")tools.append(tiers);
		var filters=[["all","$bv{ryza.alchemy.all}"],["ready","$bv{ryza.alchemy.ready_only}"],["defense","$bv{ryza.role.defense}"],["warrior","$bv{ryza.role.warrior}"],["pursuit","$bv{ryza.role.pursuit}"],["ranged","$bv{ryza.role.ranged}"],["support","$bv{ryza.role.support}"]];
		var filterOptions=[];for(var f=0;f<filters.length;f++)filterOptions.push({ID:filters[f][0],Name:filters[f][1]});
		var select=this.choicePicker('bv-ryza-filter',"$bv{ryza.alchemy.filter}","$bv{ryza.alchemy.all}",filterOptions,this.ryzaFilter||'all',function(value){self.ryzaFilter=value;self.renderRyzaAlchemy();},this.busy);if(this.ryzaMode!=="augments")tools.append(select);panel.append(tools);
		var recipes=[], chosen=null;
		var source=this.ryzaMode==="augments"?(data.TraitRecipes||[]):data.Recipes;
		for(var n=0;n<source.length;n++) { var r=source[n];if(this.ryzaMode!=="augments"&&r.Tier!==this.ryzaTier)continue;if(this.ryzaMode==="fusion"&&!r.Fusion)continue;if(this.ryzaMode==="recipes"&&r.Fusion)continue;if(this.ryzaFilter==="ready"&&!r.Ready)continue;if(this.ryzaFilter&&this.ryzaFilter!=="all"&&this.ryzaFilter!=="ready"&&r.Role!==this.ryzaFilter)continue;recipes.push(r);if(r.ID===this.ryzaSpecies)chosen=r; }
		if(!recipes.length){panel.append(el("div","bv-ryza-empty","$bv{ryza.alchemy.empty_filter}"));return;}
		chosen=chosen||recipes[0];this.ryzaSpecies=chosen.ID;
		var workspace=el("div","bv-ryza-workspace"), list=el("div","bv-ryza-catalog").attr({role:"group","aria-label":"$bv{ryza.alchemy.recipes}"});
		var wheelType="onwheel" in document?"wheel":("onmousewheel" in document?"mousewheel":"DOMMouseScroll");
		list.on(wheelType,function(event){self.hub.handleBodyWheel(event,list);});
		for(var j=0;j<recipes.length;j++)(function(r){
			var card=button("bv-ryza-recipe"+(r.ID===chosen.ID?" is-selected":""),"",function(){self.ryzaSpecies=r.ID;self.ryzaDraft=null;self.renderRyzaAlchemy();});
			card.attr({"aria-pressed":r.ID===chosen.ID?"true":"false",title:r.Description});
			card.append(el("img","").attr({src:Path.GFX+r.Icon,alt:""}));
			card.append(el("span","bv-ryza-recipe-copy").append(el("strong","",r.Name)).append(el("small","",r.RoleName+(r.Kind==="augment"?"":" / T"+r.Tier))).append(el("small",r.Ready?"is-ready":"",r.Ready?"$bv{ryza.alchemy.available}":"$bv{ryza.alchemy.view_recipe}")));
			disabled(card,self.busy);list.append(card);
		})(recipes[j]);
		workspace.append(list);var plan=el("div","bv-ryza-plan");this.renderRyzaRecipe(plan,data,chosen);workspace.append(plan);panel.append(workspace);
		list.scrollTop(catalogScroll);this.content.scrollTop(contentScroll);
	};
	Workshop.prototype.renderRyzaRecipe = function(plan,data,r)
	{
		var self=this, hero=el("div","bv-ryza-hero");
		hero.append(el("img","").attr({src:Path.GFX+r.Icon,alt:r.Name})).append(el("div","").append(el("div","bv-detail-eyebrow",this.ryzaLabels()[r.Route]+" / "+r.RoleName)).append(el("h3","",r.Name+(r.Kind==="augment"?"":" T"+r.Tier))).append(el("p","",r.Description)));
		plan.append(hero);if(r.Kind!=="augment")plan.append(el("p","bv-ryza-note","$bv{ryza.alchemy.base_stats}")).append(this.ryzaStats(r.Stats));else plan.append(el("p","bv-ryza-note","$bv{ryza.ext.limit}")).append(el("p","bv-ryza-note","$bv{ryza.ext.adaptation}"));
		var path=[];for(var t=1;t<=4;t++)path.push("T"+t);if(r.Kind!=="augment")plan.append(el("div","bv-ryza-path",r.Fusion?"$bv{ryza.ext.fusion_path}":r.Name+"  "+path.join(" → ")+"  | $bv{ryza.alchemy.unique}"));
		plan.append(el("h4","","$bv{ryza.alchemy.ingredients}"));
		if(!this.ryzaDraft||this.ryzaDraft.Recipe!==r.ID)this.ryzaDraft={Recipe:r.ID,Pets:[],Kind:r.Kind||"pet",Actor:null};
		var draft=this.ryzaDraft, selected={}, valid=true;
		if(r.Brother||r.Kind==="augment")valid=this.renderBrother(plan,data,r,draft);
		for(var n=0;n<r.Slots.length;n++)(function(index){
			var slot=r.Slots[index], current=null, options=[];
			for(var j=0;j<data.Items.length;j++){var i=data.Items[j];if(i.Species===slot.Species&&i.Tier===slot.Tier){options.push(i);if(i.ID===draft.Pets[index]&&i.Available&&!selected[i.ID])current=i;}}
			if(!current)for(var q=0;q<options.length;q++)if(options[q].Available&&!selected[options[q].ID]){current=options[q];break;}
			draft.Pets[index]=current?current.ID:null;if(current)selected[current.ID]=true;else valid=false;
			var row=el("div","bv-ryza-ingredient"+(!current?" is-missing":"")),label=el("label","",(r.Kind==="augment"?"$bv{ryza.ext.consumed_pet}":index===0?"$bv{ryza.alchemy.primary}":"$bv{ryza.alchemy.donor}")+" — "+slot.Name);
			var choices=[];label.attr("for","bv-ryza-pet-"+index);
			for(var k=0;k<options.length;k++){var pet=options[k],taken=selected[pet.ID]&&(!current||pet.ID!==current.ID);choices.push({ID:pet.ID,Name:pet.Name+" (#"+pet.ID+")"+(pet.Available?"":" — "+pet.Reason)+(taken?" — $bv{ryza.ext.pet_selected}":""),Disabled:!pet.Available||taken});}
			var picker=self.choicePicker("bv-ryza-pet-"+index,label.text(),"$bv{ryza.alchemy.choose}",choices,current?current.ID:null,function(value){draft.Pets[index]=value;self.renderRyzaAlchemy();},self.busy||!data.Editable);row.append(label).append(picker);
			if(!current)row.append(el("small","","$bv{ryza.alchemy.need_pet}"));plan.append(row);
		})(n);
		var mats=el("div","bv-ryza-materials");
		for(var m=0;m<r.Materials.length;m++){var material=r.Materials[m],missing=material.Have<material.Count;if(missing)valid=false;var row=el("div","bv-ryza-material"+(missing?" is-missing":" is-ready"));row.append(el("img","").attr({src:Path.GFX+material.Icon,alt:""})).append(el("span","",material.Name)).append(el("strong","",material.Have+" / "+material.Count));if(missing)row.append(el("small","","$bv{ryza.alchemy.deficit}"+(material.Count-material.Have)));mats.append(row);}
		plan.append(mats);if(r.Kind!=="augment")plan.append(el("p","bv-ryza-note","$bv{ryza.ext.retained_note}"));
		var footer=el("div","bv-ryza-footer"),cost=el("strong",data.Money<r.Cost?"is-missing":"","$bv{ryza.alchemy.price}"+r.Cost);
		footer.append(cost);var craft=button("bv-detail-button bv-ryza-craft",self.busy?"$bv{ryza.alchemy.working}":"$bv{ryza.alchemy.preview}",function(){self.previewRyzaRecipe();});
		disabled(craft,self.busy||!data.Editable||!valid||data.Money<r.Cost);footer.append(craft);plan.append(footer);
		if(!valid||data.Money<r.Cost)plan.append(el("p","bv-ryza-warning","$bv{ryza.alchemy.requirements}"));
	};
 Workshop.prototype.previewRyzaRecipe=function(){
  var self=this;if(this.busy||!this.ryzaDraft)return;var request=$.extend(true,{},this.ryzaDraft);this.busy=true;this.renderRyzaAlchemy();
  this.call("previewRyzaSynthesis",request,function(result){self.busy=false;self.renderRyzaAlchemy();if(!result||!result.Success){self.hub.showMessage(result&&result.Message?result.Message:copy.failed,"$bv{ryza.alchemy.title}");return;}request.Token=result.Token;self.showConfirmation(result,request);});
 };
 Workshop.prototype.performRyzaAction=function(method,request){
  var self=this;if(this.busy||this.disposed)return;this.busy=true;this.renderRyzaAlchemy();
  this.call(method,request,function(result){self.call("getRyzaAlchemyState",null,function(data){self.busy=false;self.ryzaDraft=null;if(data&&data.Recipes)self.slot.Detail.Alchemy=data;else self.slot.Detail.Alchemy.Editable=false;self.renderRyzaAlchemy();self.hub.showMessage((result&&result.Message?result.Message:copy.failed)+(!data||!data.Recipes?"\n$bv{ryza.ext.timeout}":""),"$bv{ryza.alchemy.title}");});});
 };
	Workshop.prototype.renderRyzaPets = function(panel,data)
	{
		var self=this,grid=el("div","bv-ryza-pet-grid"),count=0;
		panel.append(el("p","bv-ryza-note","$bv{ryza.alchemy.training_hint}"));
		for(var n=0;n<data.Items.length;n++)(function(pet){
			if(pet.Tier===0)return;count++;var card=el("div","bv-ryza-owned"),header=el("div","bv-ryza-hero");
			header.append(el("img","").attr({src:Path.GFX+pet.Icon,alt:""})).append(el("div","").append(el("h3","",pet.Name)).append(el("p","","$bv{ryza.pet.training}"+pet.Rank+" / 2")));
			card.append(header).append(self.ryzaStats(pet.Stats));if(pet.DonorName)card.append(el("p","bv-ryza-note","$bv{ryza.ext.inherited_from}"+pet.DonorName));
			card.append(el("p","","$bv{ryza.pet.hp}"+pet.Health+"% | $bv{ryza.pet.armor}"+pet.Body+"% / "+pet.Head+"%"));
			if(!pet.Available)card.append(el("p","bv-ryza-warning",pet.Reason+(pet.Days>0?" "+pet.Days+" $bv{ryza.alchemy.days}":"")));
			var actions=el("div","bv-ryza-maintenance");
			function action(key,label,cost,blocked){var b=button("bv-detail-button",label+" — "+cost,function(){hubConfirm();});function hubConfirm(){self.hub.showPopup("$bv{ryza.alchemy.confirm_title}",pet.Name+"\n"+label+"\n$bv{ryza.alchemy.price}"+cost,[{Label:"$bv{ryza.alchemy.confirm_care}",Callback:function(){self.performRyzaAction("maintainRyzaPet",{ID:pet.ID,Action:key,Rank:pet.Rank});}},{Label:self.messages().Cancel,Callback:null}]);}disabled(b,self.busy||!data.Editable||!pet.Available||data.Money<cost||blocked);actions.append(b);}
			action("repair","$bv{ryza.alchemy.repair}",pet.RepairCost,pet.Health>=100&&pet.Body>=100&&pet.Head>=100);
			action("vitality","$bv{ryza.alchemy.vitality}",pet.TrainingCost,pet.Rank>=2||(pet.Focus&&pet.Focus!=="vitality"));
			action("precision","$bv{ryza.alchemy.precision}",pet.TrainingCost,pet.Rank>=2||(pet.Focus&&pet.Focus!=="precision"));
			action("reset","$bv{ryza.alchemy.reset}",pet.ResetCost,pet.Rank===0);card.append(actions);grid.append(card);
		})(data.Items[n]);
		if(!count)grid.append(el("div","bv-ryza-empty","$bv{ryza.alchemy.no_pets}"));panel.append(grid);
	};


 Workshop.prototype.renderBrother=function(plan,data,r,draft){
  var self=this,trait=r.Kind==="augment",label=trait?"$bv{ryza.ext.recipient}":"$bv{ryza.ext.donor}",row=el("div","bv-ryza-ingredient"),chosen=null,choices=[];
  row.append(el("label","",label).attr("for","bv-ryza-brother"));
  var brothers=(data.Brothers||[]).slice(0);
  if(!trait)brothers.sort(function(a,b){function score(c){var rows=c.Inheritance&&c.Inheritance[r.Species]?c.Inheritance[r.Species].Rows:[],n=0;for(var i=0;i<rows.length;i++)n+=rows[i].Bonus;return n;}return score(b)-score(a)||a.ID-b.ID;});
  for(var i=0;i<brothers.length;i++){var a=brothers[i],reason=trait?(a.Choices[r.ID]||a.Reason):a.DonorReason;if(a.ID===draft.Actor)chosen=a;choices.push({ID:a.ID,Name:a.Name+" / $bv{ryza.ext.level}"+a.Level+(reason?" — "+reason:""),Disabled:trait?!a.Available:!!reason});}
  var pick=this.choicePicker('bv-ryza-brother',label,"$bv{ryza.ext.select_actor}",choices,chosen?chosen.ID:null,function(value){draft.Actor=value;self.renderRyzaAlchemy();},this.busy||!data.Editable);row.append(pick);plan.append(row);
  if(!trait)plan.append(el("p","bv-ryza-warning","$bv{ryza.ext.irreversible}")).append(el("p","bv-ryza-note","$bv{ryza.ext.intrinsic}"));
  if(!chosen){row.addClass("is-missing");plan.append(el("p","bv-ryza-warning","$bv{ryza.ext.select_actor}"));return false;}
  if(chosen.Portrait)plan.append(el("img","bv-ryza-brother-portrait").attr({src:Path.PROCEDURAL+chosen.Portrait,alt:chosen.Name}));
  if(trait&&chosen.Choices[r.ID]&&chosen.RemainingHours<=0)plan.append(el("p","bv-ryza-warning",chosen.Choices[r.ID]));
  if(trait){plan.append(el("p","bv-ryza-path","$bv{ryza.ext.slots}"+chosen.Traits.length+" / 6"));var owned=el("div","bv-ryza-owned-traits");for(var j=0;j<chosen.Traits.length;j++){var tr=chosen.Traits[j];owned.append(el("div","",tr.Name).attr("title",tr.Description));}if(!chosen.Traits.length)owned.append(el("p","bv-ryza-note","$bv{ryza.ext.no_traits}"));plan.append(owned);if(chosen.RemainingHours>0)plan.append(el("p","bv-ryza-warning","$bv{ryza.ext.cooldown}"+chosen.RemainingHours+" $bv{ryza.ext.hours}"));plan.append(el("p","bv-ryza-note","$bv{ryza.ext.cooldown_preview}"+r.Days+" $bv{ryza.alchemy.days}"));return !chosen.Choices[r.ID];}
  var inherit=chosen.Inheritance[r.Species];if(!inherit)return false;this.renderInheritance(plan,inherit.Rows);plan.append(el("p","bv-ryza-note","$bv{ryza.ext.return_items}"+(chosen.Gear.length?chosen.Gear.join(" / "):"$bv{ryza.ext.no_gear}")));return chosen.DonorAvailable;
 };
 Workshop.prototype.renderInheritance=function(plan,rows){var box=el("div","bv-ryza-inheritance");box.append(el("h4","","$bv{ryza.ext.inheritance}"));for(var i=0;i<rows.length;i++){var r=rows[i];box.append(el("div","").append(el("strong","",r.Name+" "+r.Value+" → +"+r.Bonus)).append(el("small","",r.Next===null?"$bv{ryza.ext.cap}":"$bv{ryza.ext.next}"+r.Next+" → +"+r.NextBonus)));}plan.append(box);};
 Workshop.prototype.showConfirmation=function(result,request){
  var self=this,overlay=el("div","bv-ryza-confirm").attr({role:"dialog","aria-modal":"true","aria-label":"$bv{ryza.alchemy.confirm_title}"}),box=el("div","bv-ryza-confirm-box"),body=el("div","bv-ryza-confirm-body");
  box.append(el("h2","","$bv{ryza.alchemy.confirm_title}"));body.append(el("h3","",result.Name)).append(el("p","",result.Message));
  if(result.ActorName)body.append(el("div",result.ConsumeBrother?"bv-ryza-warning":"bv-ryza-path",(result.ConsumeBrother?"$bv{ryza.ext.consumed_brother}":"$bv{ryza.ext.recipient}")+" "+result.ActorName+" / $bv{ryza.ext.level}"+result.ActorLevel));
  if(result.ActorPortrait)body.append(el("img","bv-ryza-brother-portrait").attr({src:Path.PROCEDURAL+result.ActorPortrait,alt:result.ActorName}));
  if(result.ConsumeBrother)body.append(el("p","bv-ryza-warning","$bv{ryza.ext.irreversible}"));
  var ingredients=el("ul","bv-ryza-confirm-costs");(result.Names||[]).concat(result.Materials||[]).forEach(function(v){ingredients.append(el("li","",v));});body.append(ingredients);
  if(result.ReturnedGear&&result.ReturnedGear.length)body.append(el("p","","$bv{ryza.ext.return_items}"+result.ReturnedGear.join(" / ")));
  if(result.Inheritance&&result.Inheritance.length)this.renderInheritance(body,result.Inheritance);
  if(result.Stats)body.append(el("h4","","$bv{ryza.ext.final}")).append(this.ryzaStats(result.Stats));else body.append(el("p","",result.Description)).append(el("p","bv-ryza-path","$bv{ryza.ext.cooldown_preview}"+result.Days+" $bv{ryza.alchemy.days}"));
  body.append(el("strong","","$bv{ryza.alchemy.price}"+result.Cost));box.append(body);
  var actions=el("div","bv-ryza-confirm-actions"),confirm=button("bv-detail-button bv-ryza-craft","$bv{ryza.alchemy.confirm_button}",function(){if(confirm.prop("disabled"))return;request.Acknowledge=!!result.ConsumeBrother;overlay.remove();self.confirm=null;self.performRyzaAction("performRyzaSynthesis",request);});
  if(result.ConsumeBrother){var ack=el("input","").attr({type:"checkbox",id:"bv-ryza-consume-ack"});disabled(confirm,true);ack.on("change",function(){disabled(confirm,!ack.prop("checked"));});actions.append(el("label","bv-ryza-ack").append(ack).append(el("span","","$bv{ryza.ext.ack}")));}
  actions.append(button("bv-detail-button",this.messages().Cancel,function(){overlay.remove();self.confirm=null;self.back[0].focus();})).append(confirm);box.append(actions);overlay.append(box);this.root.append(overlay);this.confirm=overlay;actions.find("button").first()[0].focus();
 };
 window[namespace+"RyzaWorkshop"]=Workshop;
})();
