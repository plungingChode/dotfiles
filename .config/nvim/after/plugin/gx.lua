require("gx").setup({
  handlers = {
    jira = {
      name = "jira",
      handle = function(mode, line, _)
        local ticket = require("gx.helper").find(line, mode, "(%u+%-%d+)")
        if ticket then
          return "https://adiumsoft.atlassian.net/browse/" .. ticket
        end
      end
    }
  }
})
