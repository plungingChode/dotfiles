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
--
-- /** @var <1> */ >
local variable_type_annotation = s("vardoc", {
  t("/** @var "), i(1), t(" */ "), i(0)
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

local function make_function_decl(shorthand, modifiers)
  -- stylua: ignore
  return s(shorthand, {
    t(modifiers .. " function "), i(1), t("("), i(2), t({ "): void", "" }),
    t({ "{", "" }),
    t("    "), i(0), t({ "", "" }),
    t({ "}", "" }),
  })
end

local function make_log_call(log_level)
  -- stylua: ignore
  return s("log" .. log_level, {
    t("$this->logger->" .. log_level .. "(\""), i(0), t("\");"),
  })
end

-- stylua: ignore
local endpoint_definition = s("endpoint", {
  t("public function "), i(1), t({"(Request $request): ResponseInterface", "" }),
  t({ "{", "" }),
  t("    "), i(0), t({ "", "" }),
  t({ "}", "" }),
})

-- stylua: ignore
local test_definition = s("unittest", {
  t({ "#[Test]", "" }),
  t("public function "), i(1), t({"(): void", "" }),
  t({ "{", "" }),
  t("    "), i(0), t({ "", "" }),
  t({ "}", "" }),
})

-- stylua: ignore
local try_catch = s("try .. catch", {
  t({ "try {", "" }),
  t("    "), i(1), t({"", "" }),
  t({ "} catch () {", "", "" }),
  t({ "}", "" }),
})

ls.add_snippets("php", {
	iferr,
	errguard,
	postfix_iferr,
	postfix_unwrap,
	doc_comment,
	variable_type_annotation,
	classdef,
	endpoint_definition,
	test_definition,
	try_catch,

	make_function_decl("pubfn", "public"),
	make_function_decl("profn", "protected"),
	make_function_decl("prifn", "private"),
	make_function_decl("stpubfn", "public static"),
	make_function_decl("stprofn", "protected static"),
	make_function_decl("stprifn", "private static"),

	make_log_call("info"),
	make_log_call("debug"),
	make_log_call("warn"),
	make_log_call("error"),
})

-- vim: sw=2 ts=2
