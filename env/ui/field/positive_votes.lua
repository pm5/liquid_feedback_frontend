function ui.field.positive_votes(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value = args.value
    ui.container{
      attr = { class = "positive_votes" },
      content = function()
        ui.tag{
          attr = { class = "value" },
          content = function()
            slot.put(tostring(value) .. '&nbsp;')
            ui.image{
              static = "icons/16/add.png"
            }
          end
        }
      end
    }
  end)
end