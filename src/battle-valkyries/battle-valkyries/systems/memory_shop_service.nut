::$bvvar{namespace}.getMemoryShopCostDTO <- function( _product )
{
	local result = [];
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		local required = resource.Key in _product.Cost ? _product.Cost[resource.Key] : 0;
		if (required <= 0) continue;
		local owned = ::$bvvar{namespace}.getMemoryWorldInt("balance." + resource.Key, 0);
		result.push({
			Key = resource.Key,
			Label = resource.Label,
			Required = required,
			Owned = owned,
			IsMet = owned >= required
		});
	}
	return result;
};

::$bvvar{namespace}.canAffordMemoryShopProduct <- function( _product )
{
	if (_product == null) return false;
	foreach (cost in ::$bvvar{namespace}.getMemoryShopCostDTO(_product))
	{
		if (!cost.IsMet) return false;
	}
	return true;
};

::$bvvar{namespace}.hasMemoryShopStashSpace <- function()
{
	if (::World == null || ::World.Assets == null || ::World.Assets.getStash() == null) return false;
	local stash = ::World.Assets.getStash();
	return stash.isResizable() || stash.getNumberOfEmptySlots() > 0;
};

::$bvvar{namespace}.getMemoryShopProductDTO <- function( _product )
{
	local canAfford = ::$bvvar{namespace}.canAffordMemoryShopProduct(_product);
	local hasSpace = ::$bvvar{namespace}.hasMemoryShopStashSpace();
	return {
		ID = _product.ID,
		Name = _product.Name,
		Description = _product.Description,
		EffectLabel = _product.EffectLabel,
		Icon = _product.Icon,
		Cost = ::$bvvar{namespace}.getMemoryShopCostDTO(_product),
		CanAfford = canAfford,
		CanBuy = canAfford && hasSpace,
		Status = !hasSpace ? "$bv{memory.shop.status.stash_full}" : (canAfford ? "$bv{memory.shop.status.available}" : "$bv{memory.shop.status.insufficient}")
	};
};

::$bvvar{namespace}.getMemoryShopHubDTO <- function()
{
	local products = [];
	foreach (product in ::$bvvar{namespace}.MemoryShopProducts)
	{
		products.push(::$bvvar{namespace}.getMemoryShopProductDTO(product));
	}
	return {
		Resources = ::$bvvar{namespace}.getMemoryArchiveBalancesDTO(),
		Products = products
	};
};

::$bvvar{namespace}.getMemoryShopErrorText <- function( _code )
{
	local texts = {
		world_unavailable = "$bv{memory.shop.error.world_unavailable}",
		invalid_product = "$bv{memory.shop.error.invalid_product}",
		insufficient_resources = "$bv{memory.shop.error.insufficient_resources}",
		stash_full = "$bv{memory.shop.error.stash_full}",
		item_create_failed = "$bv{memory.shop.error.item_create_failed}",
		purchase_failed = "$bv{memory.shop.error.purchase_failed}"
	};
	return _code in texts ? texts[_code] : texts.purchase_failed;
};

::$bvvar{namespace}.purchaseMemoryShopProduct <- function( _productID )
{
	if (::World == null || ::World.Flags == null || ::World.Assets == null || ::World.Assets.getStash() == null)
	{
		return { Success = false, Code = "world_unavailable", Message = ::$bvvar{namespace}.getMemoryShopErrorText("world_unavailable") };
	}
	local product = ::$bvvar{namespace}.getMemoryShopProductByID(_productID);
	if (product == null)
	{
		return { Success = false, Code = "invalid_product", Message = ::$bvvar{namespace}.getMemoryShopErrorText("invalid_product") };
	}
	if (!::$bvvar{namespace}.canAffordMemoryShopProduct(product))
	{
		return { Success = false, Code = "insufficient_resources", Message = ::$bvvar{namespace}.getMemoryShopErrorText("insufficient_resources") };
	}
	if (!::$bvvar{namespace}.hasMemoryShopStashSpace())
	{
		return { Success = false, Code = "stash_full", Message = ::$bvvar{namespace}.getMemoryShopErrorText("stash_full") };
	}

	local item = null;
	try { item = ::new(product.ItemScript); } catch (e)
	{
		try { ::logError("[Battle Valkyries] Memory shop item creation failed for " + product.ID + ": " + e); } catch (ignored) {}
	}
	if (item == null)
	{
		return { Success = false, Code = "item_create_failed", Message = ::$bvvar{namespace}.getMemoryShopErrorText("item_create_failed") };
	}

	local stash = ::World.Assets.getStash();
	local slot = null;
	try { slot = stash.add(item); } catch (e) {}
	if (slot == null)
	{
		return { Success = false, Code = "stash_full", Message = ::$bvvar{namespace}.getMemoryShopErrorText("stash_full") };
	}

	local oldBalances = {};
	try
	{
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			local oldAmount = ::$bvvar{namespace}.getMemoryWorldInt("balance." + resource.Key, 0);
			oldBalances[resource.Key] <- oldAmount;
			local required = resource.Key in product.Cost ? product.Cost[resource.Key] : 0;
			if (oldAmount < required) throw "resource balance changed";
		}
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			local required = resource.Key in product.Cost ? product.Cost[resource.Key] : 0;
			if (required > 0) ::$bvvar{namespace}.setMemoryWorldValue("balance." + resource.Key, oldBalances[resource.Key] - required);
		}
	}
	catch (e)
	{
		try { stash.remove(item); } catch (ignored) {}
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			if (resource.Key in oldBalances) ::$bvvar{namespace}.setMemoryWorldValue("balance." + resource.Key, oldBalances[resource.Key]);
		}
		try { ::logError("[Battle Valkyries] Memory shop purchase failed for " + product.ID + ": " + e); } catch (ignored) {}
		return { Success = false, Code = "purchase_failed", Message = ::$bvvar{namespace}.getMemoryShopErrorText("purchase_failed") };
	}

	try { if (::World.State != null) ::World.State.updateTopbarAssets(); } catch (e) {}
	return {
		Success = true,
		Code = "success",
		Message = "$bv{memory.shop.result.success}",
		ProductID = product.ID,
		ProductName = product.Name
	};
};
