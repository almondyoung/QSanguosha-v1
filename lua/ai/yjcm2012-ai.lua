sgs.ai_skill_invoke.zishou = function(self, data)
	return self.player:getHandcardNum() < 2
end

sgs.ai_skill_invoke.qianxi = function(self, data)
	local effect = data:toSlashEffect()
	local target = effect.to
	return target:getLostHp() == 0 or self:hasSkills(sgs.masochism_skill,target)
end
sgs.ai_skill_invoke.fuhun = function(self, data)
	local target = 0
	for _,enemy in ipairs(self.enemies) do
		if (self.player:distanceTo(enemy) <= self.player:getAttackRange())  then target = target + 1 end
	end
	return target > 0 and not self.player:isSkipped(sgs.Player_Play)
end

sgs.ai_skill_choice.jiangchi = function(self, choices)
	local target = 0
	local slashnum = 0
	local needburst = 0
	for _,enemy in ipairs(self.enemies) do
		for _, slash in ipairs(self:getCards("Slash")) do
			if self:slashIsEffective(slash, enemy) then 
				slashnum = slashnum + 1  -- for chi
			end 
			if self:slashIsEffective(slash, enemy) and (self.player:distanceTo(enemy) <= self.player:getAttackRange())  then 
				target = target + 1  -- for jiang
			end
		end
	end
	if slashnum > 1 or (slashnum > 0 and target == 0) then needburst = 1 end
	self:sort(self.enemies,"defense")
	
	for _,enemy in ipairs(self.enemies) do
		local def=sgs.getDefense(enemy)
		local amr=enemy:getArmor()
		local eff=(not amr) or self.player:hasWeapon("qinggang_sword") or not
			((amr:inherits("Vine") and not self.player:hasWeapon("fan"))
			or (amr:objectName()=="eight_diagram"))
			
		if enemy:hasSkill("kongcheng") and enemy:isKongcheng() then
		elseif self:slashProhibit(nil, enemy) then
		elseif def<6 and eff and needburst > 0 then return "chi"
		end	
	end
	
	for _,enemy in ipairs(self.enemies) do
		local def=sgs.getDefense(enemy)
		local amr=enemy:getArmor()
		local eff=(not amr) or self.player:hasWeapon("qinggang_sword") or not
			((amr:inherits("Vine") and not self.player:hasWeapon("fan"))
			or (amr:objectName()=="eight_diagram"))

		if enemy:hasSkill("kongcheng") and enemy:isKongcheng() then
		elseif self:slashProhibit(nil, enemy) then
		elseif eff and def<8 and needburst > 0 then return "chi"
		end
	end
	if target == 0 then return "jiang" end
	return "cancel"
end

--[[local lihuo_skill={}
lihuo_skill.name="lihuo"
table.insert(sgs.ai_skills,lihuo_skill)
lihuo_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("h")	
	cards=sgs.QList2Table(cards)
	local target = 0
	local slash_card
	for _,enemy in ipairs(self.enemies) do
		if (self.player:distanceTo(enemy) <= self.player:getAttackRange()) and enemy:getHandcardNum() < 3 then target = target + 1 end
	end
	self:sortByUseValue(cards,true)

	
	for _,card in ipairs(cards)  do
		if card:inherits("Slash") then
			slash_card = card
			break
		end
	end
	
	if not slash_card or target < 2 then return nil end
	local suit = slash_card:getSuitString()
	local number = slash_card:getNumberString()
	local card_id = slash_card:getEffectiveId()
	local card_str = ("slash:lihuo[%s:%s]=%d"):format(suit, number, card_id)
	local fireslash = sgs.Card_Parse(card_str)
	assert(fireslash)
	
	return fireslash
		
end

function sgs.ai_skill_invoke.chunlao(self, data)
	local slash_num
	local weak = 0
	local slash_card
	local cards = self.player:getCards("h")	
	cards=sgs.QList2Table(cards)
	for _,card in ipairs(cards)  do
		if card:inherits("Slash") then
			slash_num = slash_num + 1
		end
	end
	for _,friend in ipairs(self.friends) do
		if self:isWeak(friend) then weak = weak + 1 end
	end
	self:sortByUseValue(cards,true)
	for _,card in ipairs(cards)  do
		if card:inherits("Slash") then
			slash_card = card
			break
		end
	end
	if slash_num > 1 or (slash_num > 0 and weak > 0) then return slash_card end
	return false
end

sgs.ai_skill_cardask.ChunlaoCard = function(self, data)
	local dying = data:toDying()
	return self:isFriend(dying.who)
end]]