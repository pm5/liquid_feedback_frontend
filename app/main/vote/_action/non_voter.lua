local issue = Issue:new_selector():add_where{ "id = ?", param.get("issue_id", atom.integer) }:for_share():single_object_mode():exec()

local direct_voter = DirectVoter:by_pk(issue.id, app.session.member_id)

if direct_voter then
  slot.select("error", function()
    ui.tag{ content = _"You already voted this issue" }
  end )
  return false
end

local non_voter = NonVoter:by_pk(issue.id, app.session.member_id)

if non_voter and param.get("delete", atom.boolean) then
  non_voter:destroy()
elseif not non_voter then
  non_voter = NonVoter:new()
  non_voter.issue_id = issue.id
  non_voter.member_id = app.session.member_id
  non_voter:save()
end