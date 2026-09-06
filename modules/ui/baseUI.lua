local CodewareVersion = "1.15.0"
local ArchiveXLVersion = "1.22.0"
local ModVersion = "1.1.3"
local ModName = "Native Interactions"

local style = require("modules/ui/style")
local localization = require("modules/localization")

---@class baseUI
---@field public savedUI savedUI
---@field public editUI editUI
---@field public interactionUI interactionUI
---@field public requirementsIssues string[]
---@field public switchToEdit boolean
---@field public switchToInteraction boolean
local baseUI = {
    savedUI = require("modules/ui/savedUI"),
    editUI = require("modules/ui/editUI"),
    interactionUI = require("modules/ui/interactionUI"),
    removalsUI = require("modules/ui/removalsUI"),
    requirementsIssues = {},
    switchToEdit = false,
    switchToInteraction = false
}

function baseUI.init()
    if not ArchiveXL then
        table.insert(baseUI.requirementsIssues, "ArchiveXL is not installed")
    elseif not ArchiveXL.Require(ArchiveXLVersion) then
        table.insert(baseUI.requirementsIssues, "ArchiveXL version is outdated, please update to at least " .. ArchiveXLVersion)
    end

    if not Codeware then
        table.insert(baseUI.requirementsIssues, "Codeware is not installed")
    elseif not Codeware.Require(CodewareVersion) then
        table.insert(baseUI.requirementsIssues, "Codeware version is outdated, please update to at least " .. CodewareVersion)
    end

    if not Game.GetScriptableServiceContainer():GetService("NativeInteractions") then
        table.insert(baseUI.requirementsIssues, "Redscript part of the mod is not installed")
    end

    if not ModArchiveExists("nativeInteractions.archive") then
        table.insert(baseUI.requirementsIssues, "Native Interactions archive is not installed")
    end
end

local function getWindowName()
    return ModName .. " " .. ModVersion .. "###Native Interactions 1.1.1" -- use fixed ID, pin it at 1.1.1 to avoid another window reset
end

function baseUI.draw(debug)
    if #baseUI.requirementsIssues > 0 then
        if ImGui.Begin(getWindowName(), ImGuiWindowFlags.AlwaysAutoResize) then
            style.mutedText("The following issues are preventing Native Interactions from running:")

            for _, issue in pairs(baseUI.requirementsIssues) do
                ImGui.Text(issue)
            end

            ImGui.End()
        end
        return
    end

    if ImGui.Begin(getWindowName(), ImGuiWindowFlags.AlwaysAutoResize) then
        if ImGui.BeginTabBar("Tabbar", ImGuiTabItemFlags.NoTooltip) then
            if ImGui.BeginTabItem(localization.get("projects")) then
                ImGui.Spacing()
                baseUI.savedUI.draw(debug)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem(localization.get("editProject"), baseUI.switchToEdit and ImGuiTabItemFlags.SetSelected or ImGuiTabItemFlags.None) then
                baseUI.switchToEdit = false
                ImGui.Spacing()
                baseUI.editUI.draw(debug)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem(localization.get("editInteraction"), baseUI.switchToInteraction and ImGuiTabItemFlags.SetSelected or ImGuiTabItemFlags.None) then
                baseUI.switchToInteraction = false
                ImGui.Spacing()
                baseUI.interactionUI.draw(debug)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem(localization.get("editRemovals")) then
                ImGui.Spacing()
                baseUI.removalsUI.draw(debug)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem(localization.get("settings")) then
                ImGui.Spacing()
                style.mutedText(localization.get("language") .. ":")
                ImGui.SameLine()
                ImGui.SetNextItemWidth(220 * style.viewSize)

                local selected = localization.getSelected()
                local preview = localization.get("follow")
                for _, language in ipairs(localization.getLanguages()) do
                    if language.code == selected and selected ~= "auto" then preview = language.name end
                end

                if ImGui.BeginCombo("##language", preview) then
                    for _, language in ipairs(localization.getLanguages()) do
                        local label = language.code == "auto" and localization.get("follow") or language.name
                        if ImGui.Selectable(label, language.code == selected) then
                            localization.setLanguage(language.code)
                        end
                    end
                    ImGui.EndCombo()
                end
                ImGui.EndTabItem()
            end

            ImGui.EndTabBar()
        end

        ImGui.End()
    end
end

return baseUI
