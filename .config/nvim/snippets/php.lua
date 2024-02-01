local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix

local iferr = s("iferr", {
  t("if (isErr("), i(1), t({ ")) {", "" }),
  t("    "), i(2),
  t({ "", "}" })
})

local errguard = s("errguard", {
  t("if (isErr("), i(1), t({ ")) {", "" }),
  t("    return "), rep(1), t(";"),
  t({ "", "}" })
})

local postfix_iferr = postfix({
  trig = ".iferr",
  match_pattern = [[[%w%.%_%-%"%'%$]+$]], -- also match leading $ sign
}, {
  d(1, function(_, parent)
    local var = parent.env.POSTFIX_MATCH
    return sn(nil, {
      t({ "if (isErr(" .. var .. ")) {", "" }),
      t("    "), i(1),
      t({ "", "}", "" }),
      rep(1), t(" = "), rep(1), t("->ok();"),
    })
  end, {}),
})

local postfix_errguard = postfix({
  trig = ".errguard",
  match_pattern = [[[%w%.%_%-%"%'%$]+$]], -- also match leading $ sign
}, {
  d(1, function(_, parent)
    local var = parent.env.POSTFIX_MATCH
    return sn(nil, {
      t({ "if (isErr(" .. var .. ")) {", "" }),
      t("    "), i(1, "return " .. var .. ";"),
      t({ "", "}" }),
      t({ "", var .. " = " .. var .. "->ok();", "" }),
      i(0),
    })
  end, {}),
})

ls.add_snippets("php", {
  iferr,
  errguard,
  postfix_iferr,
  postfix_errguard,
})
