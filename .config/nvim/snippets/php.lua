local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
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

-- also matches leading $ sign and property accees ->
local php_variable_pattern = [[[%w%.%_%-%"%'%$%->]+$]]
local postfix_iferr = postfix({
  trig = ".iferr",
  match_pattern = php_variable_pattern, 
}, {
  d(1, function(_, parent)
    local var = parent.env.POSTFIX_MATCH
    return sn(nil, {
      t({ "if (isErr(" .. var .. ")) {", "" }),
      t("    return " .. var .. ";"),
      t({ "", "}", "" }),
      i(1),
    })
  end, {}),
})

local postfix_unwrap = postfix({
  trig = ".unwrap",
  match_pattern = php_variable_pattern,
}, {
  d(1, function(_, parent)
    local var = parent.env.POSTFIX_MATCH
    return sn(nil, {
      t({ "if (isErr(" .. var .. ")) {", "" }),
      t("    return " .. var .. ";"),
      t({ "", "}" }),
      t({ "", var .. " = " .. var .. "->ok();", "" }),
      i(1),
    })
  end, {}),
})

local doc_comment = s("doccomment", {
  t({"/**", " * "}), i(1), t({"", " */"})
})

ls.add_snippets("php", {
  iferr,
  errguard,
  postfix_iferr,
  postfix_unwrap,
  doc_comment,
})

