--- Browser Lib
--- 0.3
--- by Hexarobi
---
--- Add browsable and searchable hierarchical menu structures to Stand
--- Usage:
--- local vehicles_items = {
---   name="Vehicles",
---   items={
---     {
---       name="Sports",
---       items={
---         {name="Alpha", ...},
---         {name="Banshee", ...},
---         ...
---       }
---     },
---     {
---       name="Super",
---       items={
---         {name="Adder", ...},
---         {name="Bullet", ...},
---         ...
---       }
---     }
---   },
---   ...
--- }
--- browser.browse_item(menu.my_root(), vehicles_items, function(parent_menu, item)
---     parent_menu:action(item.name, {}, "", function()
---       util.toast(item.name)
---     end)
--- end)

local inspect = require("inspect")

local browser = {}
local config = {
    max_search_results = 30,
}
local state = {
    search_menu_counter = 1
}

browser.table_copy = function(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[browser.table_copy(k)] = browser.table_copy(v) end
    return res
end

browser.search = function(search_params)
    if search_params.page_size == nil then search_params.page_size = config.max_search_results end
    if search_params.page_number == nil then search_params.page_number = 0 end
    if search_params.menus == nil then search_params.menus = {} end
    if search_params.results == nil then search_params.results = {} end
    local results = search_params.query_function(search_params)
    local more_results_available = false
    local first_result_index = (search_params.page_size*search_params.page_number)+1
    local last_result_index = search_params.page_size*(search_params.page_number+1)
    for i = first_result_index, last_result_index do
        if results[i] then
            local search_result_menu = search_params.add_item_menu_function(search_params, results[i])
            table.insert(search_params.results, search_result_menu)
        end
        more_results_available = (results[i+1] ~= nil)
    end
    if search_params.menus.search_add_more ~= nil and search_params.menus.search_add_more:isValid() then
        menu.delete(search_params.menus.search_add_more)
    end
    if more_results_available then
        search_params.menus.search_add_more = menu.action(search_params.menus.root, "[More]", {}, "", function()
            local more_search_params = search_params
            more_search_params.page_number = more_search_params.page_number + 1
            browser.search(more_search_params)
        end)
        table.insert(search_params.results, search_params.menus.search_add_more)
    end
end

local function delete_menus(menus)
    if type(state.search_results_menus) == "table" then
        for _, menu_ref in menus do
            if menu_ref:isValid() then menu.delete(menu_ref) end
        end
    end
end

browser.search_items = function(folder, query, results)
    if results == nil then results = {} end
    if #results > config.max_search_results then return results end
    for _, item in folder.items do
        if item.items ~= nil then
            browser.search_items(item, query, results)
        else
            if type(item.name) == "string" then
                if string.match(item.name:lower(), query:lower()) then
                    table.insert(results, item)
                end
            else
                util.log("Warning: Item skipped from search due to invalid name field "..inspect(item))
            end
        end
    end
    return results
end

browser.browse_item = function(parent_menu, this_item, add_item_menu_function, browse_params)
    if browse_params == nil then browse_params = {} end
    if this_item.items ~= nil then
        local menu_list = parent_menu:list(this_item.name)
        state.search_menu_counter = state.search_menu_counter + 1
        local search_command = "search"..state.search_menu_counter
        local search_menu = menu_list:list("Search", {}, "", function() menu.show_command_box(search_command.." ") end)
        search_menu:text_input("Search", {search_command}, "", function(query)
            delete_menus(state.search_results_menus)
            state.search_results_menus = {}
            browser.search({
                this_item=this_item,
                query=query,
                results=state.search_results_menus,
                menus={
                    root=search_menu,
                },
                query_function=function(search_params)
                    if browse_params.query_function ~= nil then
                        return browse_params.query_function(search_params)
                    else
                        return browser.search_items(search_params.this_item, search_params.query)
                    end
                end,
                add_item_menu_function=function(search_params, item)
                    if add_item_menu_function ~= nil then
                        return add_item_menu_function(search_params.menus.root, item)
                    end
                end,
            })
        end)
        --if browse_params.additional_page_menus ~= nil then
        --    browse_params.additional_page_menus(browse_params, parent_menu)
        --end
        menu_list:divider("Browse")
        for _, item in pairs(this_item.items) do
            if type(item) == "table" then
                if item.items ~= nil then
                    browser.browse_item(menu_list, item, add_item_menu_function)
                else
                    if add_item_menu_function ~= nil then
                        add_item_menu_function(menu_list, item)
                    end
                end
            end
        end
        return menu_list
    end
end

return browser
