local value
if app.session.member then
  local setting_key = "liquidfeedback_frontend_stylesheet_url"
  local setting = Setting:by_pk(app.session.member.id, setting_key)
  value = setting and setting.value
end

if value then
  slot.put_into("stylesheet_url", value)
else
  slot.put_into("stylesheet_url", config.absolute_base_url .. "static/style.css")
end

if os.getenv("HTTP_USER_AGENT"):find("Android.*AppleWebKit.*Mobile Safari") then
  slot.select("html_head", function()
    ui.tag{
      tag = "style",
      content = "body, td, th { font-size: 16px; };"
    }
  end)
end

if app.session.member then
  local tab_mode = app.session.member:get_setting_value("tab_mode")
  if tab_mode then
    config.user_tab_mode = tab_mode
  end
end

local web20 = config.user_tab_mode == "accordeon"
  or config.user_tab_mode == "accordeon_first_expanded"
  or config.user_tab_mode == "accordeon_all_expanded"

if web20 then
  ui.enable_partial_loading()
end

if request.get_json_request_slots() then
  slot.set_layout("blank")
end


ui.container{
  attr = {
    class = web20 and "web20" or "web10"
  },
  content = function()
    execute.inner()
  end
}