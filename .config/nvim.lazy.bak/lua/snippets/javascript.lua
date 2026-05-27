local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets({ "javascript", "javascriptreact" }, {
  s("cl", { t("console.log("), i(1, ""), t(");") }),
  s("cltest", { t("console.log("), i(1, ""), t(");") }),
  s("fn", { t("function "), i(1, "name"), t("() {"), i(2, ""), t("}") }),
  s("storyOutline", {
    t({
      "const meta = {",
      "  title: 'Components/",
    }),
    i(1, "ComponentName"),
    t({ "',", "  tags: ['autodocs']," }),
    t({ "  component: " }),
    i(2, "Component"),
    t({ ",", "  argTypes: {", "    " }),
    i(3, "// Add argTypes here"),
    t({
      "",
      "  }",
      "};",
      "",
      "export default meta;",
      "",
      "const ConstructStory = story => {",
      "  return {",
      "    ...story,",
      "    args: {",
      "      ...story?.args",
      "    }",
      "  };",
      "};",
      "",
      "export const Default = ConstructStory();",
    }),
  }),
})
