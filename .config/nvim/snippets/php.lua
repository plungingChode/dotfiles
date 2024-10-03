local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local isn = ls.indent_snippet_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix

-- stylua: ignore
--
-- if (isErr(<var>)) {
--    >
-- }
--
local iferr = s("iferr", {
  t("if (isErr("), i(1), t({ ")) {", "" }),
  t("    "), i(2),
  t({ "", "}" })
})

-- stylua: ignore
--
-- if (isErr(<var>)) {
--    return <var>;
-- }
--
local errguard = s("errguard", {
  t("if (isErr("), i(1), t({ ")) {", "" }),
  t("    return "), rep(1), t(";"),
  t({ "", "}" })
})

-- stylua: ignore
-- also matches leading $ sign and property accees ->
-- $var.unwrap ->
--
-- if (isErr($var)) {
--    return $var;
-- }
--
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

-- stylua: ignore
-- $var.unwrap ->
--
-- if (isErr($var)) {
--    return $var;
-- }
-- $var = $var->ok();
--
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

-- stylua: ignore
--
-- /**
--  *
--  */
local doc_comment = s("doccomment", {
  t({ "/**", " * " }), i(1), t({ "", " */" })
})

-- stylua: ignore
local classdef = s("classdef", {
  t({ "<?php", "", "" }),
  t({ "declare(strict_types=1);", "", "" }),
  t({ "namespace " }), i(1), t({";", "", "" }),
  t({ "class " }), i(2), t({ "", "{", "" }),
  t({ "    public function __construct(", "" }),
  t({ "        " }), i(0), t({ "", "" }),
  t({ "    ) {", "" }),
  t({ "    }", "", }),
  t({ "}" }),
})

ls.add_snippets("php", {
	iferr,
	errguard,
	postfix_iferr,
	postfix_unwrap,
	doc_comment,
	classdef,
})
