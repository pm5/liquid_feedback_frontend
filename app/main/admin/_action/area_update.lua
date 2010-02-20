if not app.session.member.admin then
  error()
end

local id = param.get_id()

local area
if id then
  area = Area:new_selector():add_where{ "id = ?", id }:single_object_mode():exec()
else
  area = Area:new()
end


param.update(area, "name", "description", "active")

area:save()

slot.put_into("notice", _"Area successfully updated")