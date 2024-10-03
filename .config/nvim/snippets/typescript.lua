local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep

local doc_comment = s("doccomment", {
	t({ "/**", " * " }),
	i(1),
	t({ "", " */" }),
})

-- stylua: ignore
--
-- type Props = {
-- }
--
-- function <Component>({ }: Props) {
--    return <div></div>
-- }
--
-- export default <Component>;
local react_component = s("react.component", {
	t({ "type Props = {", "", "}", "", "" }),
	t("function "), i(1), t({ "({ }: Props) {", "" }),
	t("  return <div>"), i(2), t("</div>;"),
	t({ "", "}", "", "" }),
  t("export default "), rep(1), t(";"),
})

-- stylua: ignore
--
-- type <Component>Props = {
-- }
--
-- function <Component>({ }: <Component>Props) {
--    return <div></div>
-- }
local react_local_component = s("react.localcomponent", {
	t({ "type "}), rep(1), t({ "Props = {", "", "}", "", "" }),
	t("function "), i(1), t("({ }: "), rep(1), t({ "Props) {", "" }),
	t("  return <div>"), i(2), t("</div>;"),
	t({ "", "}" }),
})

ls.add_snippets("javascript", { doc_comment })
ls.add_snippets("typescript", { doc_comment, react_component, react_local_component })
ls.add_snippets("javascriptreact", { doc_comment })
ls.add_snippets("typescriptreact", { doc_comment, react_component, react_local_component })
