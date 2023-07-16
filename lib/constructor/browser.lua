--- Browser Lib
--- 0.1
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
--- browser.browse_item(menu.my_root(), vehicles_items, {
---    add_item_menu=function(root_menu, item)
---        root_menu:action(item.name, {}, "", function()
---          util.toast(item.name)
---        end)
---    end
--- })

--local inspect = require("inspect")

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
    for i = (search_params.page_size*search_params.page_number)+1, search_params.page_size*(search_params.page_number+1) do
        if results[i] then
            local search_result_menu = search_params.add_item_menu_function(search_params, results[i])
            table.insert(search_params.results, search_result_menu)
        end
    end
    if search_params.menus.search_add_more ~= nil and search_params.menus.search_add_more:isValid() then
        menu.delete(search_params.menus.search_add_more)
    end
    search_params.menus.search_add_more = menu.action(search_params.menus.root, "Load More", {}, "", function()
        local more_search_params = search_params
        more_search_params.page_number = more_search_params.page_number + 1
        browser.search(more_search_params)
    end)
    table.insert(search_params.results, search_params.menus.search_add_more)
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
            if string.match(item.name:lower(), query:lower()) then
                table.insert(results, item)
            end
        end
    end
    return results
end

browser.browse_item = function(root_menu, root_item, browse_params)
    if root_item.items ~= nil then
        local menu_list = root_menu:list(root_item.name)
        state.search_menu_counter = state.search_menu_counter + 1
        local search_command = "search"..state.search_menu_counter
        local search_menu = menu_list:list("Search", {}, "", function() menu.show_command_box(search_command.." ") end)
        search_menu:text_input("Search", {search_command}, "", function(query)
            delete_menus(state.search_results_menus)
            state.search_results_menus = {}
            browser.search({
                root_item=root_item,
                query=query,
                results=state.search_results_menus,
                menus={
                    root=search_menu,
                },
                query_function=function(search_params)
                    if browse_params.query_function ~= nil then
                        return browse_params.query_function(search_params)
                    else
                        return browser.search_items(search_params.root_item, search_params.query)
                    end
                end,
                add_item_menu_function=function(search_params, item)
                    if browse_params.add_item_menu_function ~= nil then
                        return browse_params.add_item_menu_function(search_params.menus.root, item)
                    end
                end,
            })
        end)
        if browse_params.additional_page_menus ~= nil then
            browse_params.additional_page_menus(browse_params, root_menu)
        end
        menu_list:divider("Browse")
        for _, item in pairs(root_item.items) do
            if type(item) == "table" then
                if item.items ~= nil then
                    browser.browse_item(menu_list, item, browse_params)
                else
                    if browse_params.add_item_menu_function ~= nil then
                        browse_params.add_item_menu_function(menu_list, item)
                    end
                end
            end
        end
        return menu_list
    end
end

return browser
