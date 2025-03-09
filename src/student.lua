-- Implementation of Student cards

local _G_UIDEF_use_and_sell_buttons
f = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local t = _G_UIDEF_use_and_sell_buttons(card)
    if t and t.nodes[1] and t.nodes[1].nodes[2] and card.config.center.ex_skill then
        table.insert(
            t.nodes[1].nodes[2].nodes,
            {
                n = G.UIT.C,
                config = {align = "cr"},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            ref_table = card,
                            align = "cr",
                            maxw = 1.25,
                            padding = 0.1,
                            r = 0.08,
                            minw = 1.25,
                            minh = 1,
                            hover = true,
                            shadow = true,
                            colour = G.C.UI.BACKGROUND_INACTIVE,
                            one_press = true,
                            button = "BA_ex_use",
                            func = "BA_ex_ready"
                        },
                        nodes = {
                            {n = G.UIT.B, config = {w = 0.1, h = 0.6}},
                            {
                                n = G.UIT.T,
                                config = {
                                    text = localize("b_use"),
                                    colour = G.C.UI.TEXT_LIGHT,
                                    scale = 0.55,
                                    shadow = true
                                }
                            }
                        }
                    }
                }
            }
        )
    end
    return t
end

G.FUNCS.BA_ex_ready = function(e)
    local card = e.config.ref_table
    local can_use =
        not (not skip_check and
        ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))) and
        G.STATE ~= G.STATES.HAND_PLAYED and
        G.STATE ~= G.STATES.DRAW_TO_HAND and
        G.STATE ~= G.STATES.PLAY_TAROT and
        card.area == G.jokers and
        not card.debuff and
        card.config.center.BA_ex_use and
        card.config.center.BA_ex_cost >= G.GAME.current_round.blueatro.cost_meter.cur
        card.config.center:BA_ex_ready(card))
    if can_use then
        e.config.colour = G.C.RED
        e.config.button = "BA_ex_use"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.BA_ex_use = function(e, mute)
    local card = e.config.ref_table

    G.E_MANAGER:add_event(
        Event(
            {
                func = function()
                    e.disable_button = nil
                    e.config.button = "BA_ex_use"
                    return true
                end
            }
        )
    )

    if card.children.use_button then
        card.children.use_button:remove()
        card.children.use_button = nil
    end
    if card.children.sell_button then
        card.children.sell_button:remove()
        card.children.sell_button = nil
    end
    local meter = G.GAME.current_round.blueatro.cost_meter
    -- It's not the job of this function to check if this will go negative.
    -- That responsibility is on `G.FUNCS.BA_ex_ready`.
    meter.cur = meter.cur - card.config.center.BA_ex_cost
    card.config.center:BA_ex_use(card)
    card.area:remove_from_highlighted(card)
end