-- note to reader: this file is best read from the bottom up

------------------------------------------------------------------------
-- infoFunctions table
-- These power the properties of the slot objects
-- (I could have just included these as a series of 'elseif' statements in the SlotIndexHandler function, but I figured a table lookup would be faster)
local infoFunctions = {}
function infoFunctions.count(self)
    return GetSlotStackSize(self.bagId, self.slotIndex)
end
infoFunctions.stackCount = infoFunctions.count
function infoFunctions.notEmpty(self)
    return self.stackCount > 0
end
function infoFunctions.empty(self)
    return self.stackCount == 0
end
function infoFunctions.link(self)
    if self.empty then return nil end
    return GetItemLink(self.bagId, self.slotIndex)
end
infoFunctions.itemLink = infoFunctions.link
function infoFunctions.rawName(self)
    if self.empty then return nil end
    return GetItemName(self.bagId, self.slotIndex)
end
infoFunctions.itemRawName = infoFunctions.rawName
function infoFunctions.name(self)
    if self.empty then return nil end
    return zo_strformat(SI_TOOLTIP_ITEM_NAME, self.rawName)
end
infoFunctions.itemName = infoFunctions.name
function infoFunctions.type(self)
    if self.empty then return nil end
    return GetItemType(self.bagId, self.slotIndex)
end
infoFunctions.itemType = infoFunctions.type
function infoFunctions.quality(self)
    if self.empty then return nil end
    return GetItemDisplayQuality(self.bagId, self.slotIndex)
end
infoFunctions.itemQuality = infoFunctions.quality
function infoFunctions.qualityIsGoldOrBetter(self)
    if self.empty then return nil end
    return self.quality >= ITEM_DISPLAY_QUALITY_LEGENDARY
end
function infoFunctions.qualityIsPurpleOrBetter(self)
    if self.empty then return nil end
    return self.quality >= ITEM_DISPLAY_QUALITY_ARTIFACT
end
function infoFunctions.qualityIsBlueOrBetter(self)
    if self.empty then return nil end
    return self.quality >= ITEM_DISPLAY_QUALITY_SUPERIOR
end
function infoFunctions.qualityIsGreenOrBetter(self)
    if self.empty then return nil end
    return self.quality >= ITEM_DISPLAY_QUALITY_MAGIC
end
function infoFunctions.qualityIsWhiteOrBetter(self)
    if self.empty then return nil end
    return self.quality >= ITEM_DISPLAY_QUALITY_NORMAL
end
function infoFunctions.qualityIsTrash(self)
    if self.empty then return nil end
    return self.quality == ITEM_DISPLAY_QUALITY_TRASH
end
function infoFunctions.uniqueId(self)
    if self.empty then return nil end
    return GetItemUniqueId(self.bagId, self.slotIndex)
end
function infoFunctions.instanceId(self)
    if self.empty then return nil end
    return GetItemInstanceId(self.bagId, self.slotIndex)
end
function infoFunctions.baseId(self)
    if self.empty then return nil end
    return GetItemLinkItemId(self.link)
end
function infoFunctions.collectibleId(self)
    if self.empty then return nil end
    local collectibleId = GetCollectibleIdFromLink(self.link)
    if not collectibleId then
        collectibleId = GetItemLinkContainerCollectibleId(self.link)
    end
    if collectibleId == 0 then
        collectibleId = nil
    end
    return collectibleId
end
function infoFunctions.setId(self)
    if self.empty then return nil end
    return select(6, GetItemLinkSetInfo(self.link))
end
function infoFunctions.setCollectionSlot(self)
    if self.empty then return nil end
    return GetItemLinkItemSetCollectionSlot(self.link)
end
function infoFunctions.setPieceUnlocked(self)
    if self.empty then return nil end
    return IsItemSetCollectionPieceUnlocked(self.baseId)
end
function infoFunctions.recipe(self) -- includes furnishing designs
    if self.empty then return nil end
    return self.type == ITEMTYPE_RECIPE
end
infoFunctions.isRecipe = infoFunctions.recipe
function infoFunctions.recipeKnown(self)
    if self.empty then return nil end
    return IsItemLinkRecipeKnown(self.link)
end
function infoFunctions.motif(self)
    if self.empty then return nil end
    return self.type == ITEMTYPE_RACIAL_STYLE_MOTIF
end
infoFunctions.isMotif = infoFunctions.motif
function infoFunctions.motifKnown(self)
    if self.empty then return nil end
    return IsItemLinkBookKnown(self.link)
end
function infoFunctions.condition(self)
    if self.empty then return nil end
    return GetItemCondition(self.bagId, self.slotIndex)
end
function infoFunctions.stolen(self)
    if self.empty then return nil end
    return IsItemStolen(self.bagId, self.slotIndex)
end
infoFunctions.isStolen = infoFunctions.stolen
function infoFunctions.bound(self)
    if self.empty then return nil end
    return IsItemBound(self.bagId, self.slotIndex)
end
infoFunctions.isBound = infoFunctions.bound
function infoFunctions.bindType(self)
    if self.empty then return nil end
    return GetItemBindType(self.bagId, self.slotIndex)
end
function infoFunctions.temporarilyTradable(self)
    if self.empty then return nil end
    return IsItemBoPAndTradeable(self.bagId, self.slotIndex)
end
function infoFunctions.crafted(self)
    if self.empty then return nil end
    return IsItemLinkCrafted(self.link)
end
infoFunctions.isCrafted = infoFunctions.crafted
function infoFunctions.notCrafted(self)
    if self.empty then return nil end
    return not self.crafted
end
infoFunctions.isNotCrafted = infoFunctions.notCrafted
function infoFunctions.sellInformation(self)
    if self.empty then return nil end
    return GetItemSellInformation(self.bagId, self.slotIndex)
end
function infoFunctions.sellable(self)
    if self.empty then return nil end
    return self.sellInformation ~= ITEM_SELL_INFORMATION_CANNOT_SELL
end
infoFunctions.isSellable = infoFunctions.sellable
infoFunctions.canSell = infoFunctions.sellable
function infoFunctions.sellPricePerUnit(self)
    if self.empty then return nil end
    return GetItemSellValueWithBonuses(self.bagId, self.slotIndex)
end
infoFunctions.price = infoFunctions.sellPricePerUnit
infoFunctions.sellPrice = infoFunctions.sellPricePerUnit
infoFunctions.unitSellPrice = infoFunctions.sellPricePerUnit
infoFunctions.unitPrice = infoFunctions.sellPricePerUnit
infoFunctions.pricePerUnit = infoFunctions.sellPricePerUnit
function infoFunctions.sellPriceTotal(self)
    if self.empty then return nil end
    return self.sellPricePerUnit * self.stackCount
end
infoFunctions.totalSellPrice = infoFunctions.sellPriceTotal
infoFunctions.totalPrice = infoFunctions.sellPriceTotal
infoFunctions.stackPrice = infoFunctions.sellPriceTotal
infoFunctions.stackSellPrice = infoFunctions.sellPriceTotal
infoFunctions.stackTotalPrice = infoFunctions.sellPriceTotal
infoFunctions.stackTotalSellPrice = infoFunctions.sellPriceTotal
function infoFunctions.traitInformation(self)
    if self.empty then return nil end
    return GetItemTraitInformation(self.bagId, self.slotIndex)
end
function infoFunctions.ornate(self)
    if self.empty then return nil end
    return self.traitInformation == ITEM_TRAIT_INFORMATION_ORNATE
end
function infoFunctions.intricate(self)
    if self.empty then return nil end
    return self.traitInformation == ITEM_TRAIT_INFORMATION_INTRICATE
end
function infoFunctions.isTraitResearchable(self)
    if self.empty then return nil end
    return self.traitInformation == ITEM_TRAIT_INFORMATION_RESEARCHABLE
end
function infoFunctions.companion(self)
    if self.empty then return nil end
    return GetItemActorCategory(self.bagId, self.slotIndex) == GAMEPLAY_ACTOR_CATEGORY_COMPANION
end
infoFunctions.isCompanion = infoFunctions.companion
infoFunctions.isCompanionEquipment = infoFunctions.companion
function infoFunctions.armory(self)
    if self.empty then return nil end
    if bagId == BAG_GUILDBANK or bagId == BAG_BUYBACK or bagId == BAG_VIRTUAL or bagId == BAG_COMPANION_WORN then
        return false
    else
        return IsItemInArmory(bagId, slotIndex)
    end
end
infoFunctions.inArmory = infoFunctions.armory
function infoFunctions.locked(self)
    if self.empty then return nil end
    return IsItemPlayerLocked(self.bagId, self.slotIndex)
end
infoFunctions.isLocked = infoFunctions.locked
function infoFunctions.equipType(self)
    if self.empty then return nil end
    return GetItemEquipType(self.bagId, self.slotIndex)
end
function infoFunctions.jewelry(self)
    if self.empty then return nil end
    return self.equipType == EQUIP_TYPE_RING or self.equipType == EQUIP_TYPE_NECK
end
infoFunctions.isJewelry = infoFunctions.jewelry
function infoFunctions.weapon(self)
    if self.empty then return nil end
    return self.equipType == EQUIP_TYPE_ONE_HAND or self.equipType == EQUIP_TYPE_TWO_HAND or self.equipType == EQUIP_TYPE_OFF_HAND
end
infoFunctions.isWeapon = infoFunctions.weapon
function infoFunctions.armor(self)
    if self.empty then return nil end
    return self.equipType == EQUIP_TYPE_CHEST or self.equipType == EQUIP_TYPE_FEET or self.equipType == EQUIP_TYPE_HAND or self.equipType == EQUIP_TYPE_HEAD or self.equipType == EQUIP_TYPE_LEGS or self.equipType == EQUIP_TYPE_SHOULDERS or self.equipType == EQUIP_TYPE_WAIST
end
infoFunctions.isArmor = infoFunctions.armor
function infoFunctions.armorType(self)
    if self.empty then return nil end
    return GetItemArmorType(self.bagId, self.slotIndex)
end
function infoFunctions.glyph(self)
    if self.empty then return nil end
    return self.type == ITEMTYPE_GLYPH_ARMOR or self.type == ITEMTYPE_GLYPH_JEWELRY or self.type == ITEMTYPE_GLYPH_WEAPON
end
infoFunctions.isGlyph = infoFunctions.glyph

--------------------------------------------------------------
-- actionFunctions table
-- These power the methods of the slot objects
-- (I could have just included these as a series of 'elseif' statements in the SlotIndexHandler function, but I wanted to be consistent with the infoFunctions table)
local actionFunctions = {}
function actionFunctions.Sell(self, count)
    if self.empty then return end
    SellInventoryItem(self.bagId, self.slotIndex, count or self.stackCount)
end
function actionFunctions.Destroy(self)
    if self.empty then return end
    DestroyItem(self.bagId, self.slotIndex)
end

--------------------------------------------------------------

-- By the magic of "setmetatable", this function gets called when someone tries to access a nil property/method on a slot object
local function SlotIndexHandler (self, key)
    if infoFunctions[key] then
        local value = infoFunctions[key](self)
        self[key] = value -- cache the value in the object itself, so this function doesn't get called again for the same key
        -- no cache invalidation is implemented because slot objects are intended to be short-lived
        return value
    elseif actionFunctions[key] then
        return actionFunctions[key] -- no caching is done here, because you shouldn't be selling the same slot twice in a row anyway
    else
        error("LibInventory: SlotInfoHandler: No handler for key: " .. key)
        -- if this occurs because someone guessed about property name that turned out to not exist, we might want to add an alias for the key to support user-friendlyness
    end
end

-- Used directly by setmetatable; a metatable is basically a table of configuration options that can be applied to other tables
-- in this case, we are using the "__index" option to tell Lua to call the SlotIndexHandler function when someone tries to access a nil property/method on a slot object
-- (note that __index can can also be set to a table, in which case it will be used as a fallback for missing keys, that's a much more common use of __index)
local metatableForSlotObjects = { -- normally, for readability, I would just inline this in the setmetatable call, but we are going to be creating a lot of these objects, so reusing the same metatable is worth it for the performance
    __index = SlotIndexHandler,
}

--------------------------------------------------------------
-- Public API
LibInventory = LibInventory or {}

-- Returns a slot object for the given bagId and slotIndex.
-- The slot object is a point-in-time, lazy-evaluated, auto-caching snapshot that should NOT be stored for later use.
function LibInventory.Slot(bagId, slotIndex)
    assert(type(bagId) == "number", "bagId must be a number")
    assert(type(slotIndex) == "number", "slotIndex must be a number")
    return setmetatable({ -- usually, developers would create a local table variable and call setmetatable on that, but you can also just call setmetatable directly on the table literal and it will return the resulting table (and Intellisense seems to like it better this way)
        bagId = bagId,
        slotIndex = slotIndex,
        count = nil, -- these remaining nils are only here to give IntelliSense a hint about what properties are available
        notEmpty = nil,
        empty = nil,
        link = nil,
        rawName = nil,
        name = nil,
        type = nil,
        quality = nil,
        qualityIsGoldOrBetter = nil,
        qualityIsPurpleOrBetter = nil,
        qualityIsBlueOrBetter = nil,
        qualityIsGreenOrBetter = nil,
        qualityIsWhiteOrBetter = nil,
        qualityIsTrash = nil,
        uniqueId = nil,
        instanceId = nil,
        baseId = nil,
        collectibleId = nil,
        setId = nil,
        setCollectionSlot = nil,
        setPieceUnlocked = nil,
        recipe = nil,
        recipeKnown = nil,
        motif = nil,
        motifKnown = nil,
        condition = nil,
        stolen = nil,
        bound = nil,
        bindType = nil,
        temporarilyTradable = nil,
        crafted = nil,
        sellInformation = nil,
        sellable = nil,
        sellPricePerUnit = nil,
        sellPriceTotal = nil,
        traitInformation = nil,
        ornate = nil,
        intricate = nil,
        isTraitResearchable = nil,
        companion = nil,
        armory = nil,
        locked = nil,
        equipType = nil,
        jewelry = nil,
        weapon = nil,
        armor = nil,
        armorType = nil,
        glyph = nil,
    }, metatableForSlotObjects) -- see comments on metatableForSlotObjects
end
LibInventory.GetSlot = LibInventory.Slot -- alias
