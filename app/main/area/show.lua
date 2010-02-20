local area = Area:new_selector():add_where{ "id = ?", param.get_id() }:single_object_mode():exec()

slot.put_into("title", encode.html(_"Area '#{name}'":gsub("#{name}", area.name)))

ui.container{
  attr = { class = "vertical"},
  content = function()
    ui.field.text{ value = area.description }
  end
}


slot.select("actions", function()
  ui.link{
    content = function()
      ui.image{ static = "icons/16/folder_add.png" }
      slot.put(_"Create new issue")
    end,
    module = "initiative",
    view = "new",
    params = { area_id = area.id }
  }
end)

util.help("area.show")

execute.view{
  module = "membership",
  view = "_show_box",
  params = { area = area }
}

execute.view{
  module = "delegation",
  view = "_show_box",
  params = { area_id = area.id }
}

--[[
for i, issue in ipairs(area.issues) do
  local head_name = "issue_head_content_" .. tostring(issue.id)
  local name = "issue_content_" .. tostring(issue.id)
  local icon_name = "issue_icon_" .. tostring(issue.id)
  ui.container{
    attr = { class = "ui_tabs" },
    content = function()
      local onclick = 
        'if (ui_tabs_active["' .. name .. '"]) {' ..
          'el=document.getElementById("' .. name .. '");' ..
          'el.innerHTML="";' ..
          'el.style.display="none";' ..
          'ui_tabs_active["' .. name .. '"]=false' ..
        '} else {' ..
          'ui_tabs_active["' .. name .. '"]=true;' ..
          'document.getElementById("' .. name .. '").style.display="block"; ' ..
          'var hourglass_el = document.getElementById("' .. icon_name .. '");' ..
          'var hourglass_src = hourglass_el.src;' ..
          'hourglass_el.src = "' .. encode.url{ static = "icons/16/connect.png" } .. '";' ..
          'partialMultiLoad(' ..
            '{ trace: "trace", system_error: "system_error", ' .. name .. '_title: "title", ' .. name .. '_actions: "actions", ' .. name .. '_content: "default" },' ..
            '{},' ..
            '"error",' ..
            '"' .. request.get_relative_baseurl() .. 'issue/show/' .. tostring(issue.id) .. '.html?&_webmcp_json_slots[]=title&_webmcp_json_slots[]=actions&_webmcp_json_slots[]=default&_webmcp_json_slots[]=trace&_webmcp_json_slots[]=system_error&dyn=1",' ..
            '{},' ..
            '{},' ..
            'function() {' ..
              'hourglass_el.src = hourglass_src;' ..
            '},' ..
            'function() {' ..
              'hourglass_el.src = hourglass_src;' ..
            '}' ..
          '); ' ..
        '}' ..
        'return(false);'
      ui.link{
        attr = {
          name = name,
          class = "ui_tabs_accordeon_head",
          id = head_name,
          onclick = onclick,
        },
        module  = "issue",
        view    = "show",
        id      = issue.id,
        params  = params,
        anchor  = name,
        content = function()
          ui.image{
            attr = { id = icon_name },
            static = "icons/16/script.png"
          }
          ui.container{
            attr = { style = "float: right;" },
            content = function()
              
            end
          }
          slot.put(tostring(issue.id))
        end
      }
    end
  }

  ui.container{
    attr = {
      id = name,
      class = "ui_tabs_accordeon_content",
    },
    content = function()
      ui.container{ attr = { id = name .. "_title",   }, content = function() slot.put("&nbsp;") end }
      ui.container{ attr = { id = name .. "_actions", }, content = function() slot.put("&nbsp;") end }
      ui.container{ attr = { id = name .. "_content", }, content = function() 
        execute.view{
          module = "initiative",
          view = "_list",
          params = {
            issue = issue,
            initiatives_selector = issue:get_reference_selector("initiatives"),
            limit = 3,
            per_page = 3,
            no_sort = true,
          }
        }
      end }
    end
  }

  if config.user_tab_mode == "accordeon_all_expanded" then
    ui.script{ script = 'document.getElementById("' .. head_name .. '").onclick();' }
  end
end
--]]

execute.view{
  module = "area",
  view = "show_tab",
  params = { area = area }
}
